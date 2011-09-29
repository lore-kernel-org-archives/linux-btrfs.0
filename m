From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix tree corruption after multi-thread snapshots and inode cache flush
Date: Thu, 29 Sep 2011 10:59:46 -0400
Message-ID: <1317308349-sup-2231@shiny>
References: <1317261627-17265-1-git-send-email-liubo2009@cn.fujitsu.com> <4E83F354.3030102@linux.intel.com> <4E8429DE.1030501@cn.fujitsu.com> <4E842E0A.60808@linux.intel.com> <4E842EFE.40205@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	josef <josef@redhat.com>, lizf <lizf@cn.fujitsu.com>,
	miaox <miaox@cn.fujitsu.com>, dave <dave@jikos.cz>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E842EFE.40205@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2011-09-29 04:40:30 -0400:
> On 29.09.2011 10:36, Yan, Zheng wrote:
> > On 09/29/2011 04:18 PM, Liu Bo wrote:
> >> On 09/29/2011 12:25 PM, Yan, Zheng wrote:
> >>> On 09/29/2011 10:00 AM, Liu Bo wrote:
> >>>> The btrfs snapshotting code requires that once a root has been
> >>>> snapshotted, we don't change it during a commit.
> >>>>
> >>>> But there are two cases to lead to tree corruptions:
> >>>>
> >>>> 1) multi-thread snapshots can commit serveral snapshots in a transaction,
> >>>>    and this may change the src root when processing the following pending
> >>>>    snapshots, which lead to the former snapshots corruptions;
> >>>>
> >>>> 2) the free inode cache was changing the roots when it root the cache,
> >>>>    which lead to corruptions.
> >>>>
> >>> For the case 2, the free inode cache of newly created snapshot is invalid.
> >>> So it's better to avoid modifying snapshotted trees.
> >>>
> >>
> >> For case 2, with flushing dirty inode cache during create_pending_snapshot,
> >> we can avoid modifying snapshotted trees as your advice.
> >>
> >> But for case 1, I have no idea how to do the same thing, since we are not
> >> allowed to commit per snapshot, which will make the performance terrible.
> 
> One snapshot per subvol per transaction is ok, but it must be possible to create
> hundreds or thousands of snapshots for different subvols within one transaction.
> Imagine a setup with 10000 subvols and creating one snapshot per hour.

Agreed, we need to be able to do more than one snapshot per commit.  Our
current commits are pretty heavy, we do need to be able to batch them.

-chris
