From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Tue, 24 May 2011 07:34:30 -0400
Message-ID: <1306235183-sup-2539@shiny>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com> <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com> <1305850961-sup-454@shiny> <1306161195-sup-8189@shiny> <4DDC7E08.4020207@cn.fujitsu.com> <4DDCD810.7090904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, josef <josef@redhat.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DDCD810.7090904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-05-25 06:21:04 -0400:
> On 05/24/2011 11:56 PM, liubo wrote:
> >> > The problems I hit:
> >> > 
> >> > When an inode is dropped from cache (just via iput) and then read in
> >> > again, the BTRFS_I(inode)->logged_trans goes back to zero.  When this
> >> > happens the logging code assumes the inode isn't in the log and hits
> >> > -EEXIST if it finds inode items.
> >> > 
> > 
> > ok, I just find where the problem addresses.  This is because I've put
> > a check between logged_trans and transaction_id, which is inclined to
> > filter those that are first logged, and I'm sorry for not taking the
> > 'iput' stuff into consideration.  And it's easy to fix this, as we
> > can just kick this check off and put another check while searching
> > 'BTRFS_INODE_ITEM_KEY', since if we cannot find a inode item in a tree,
> > it proves that this inode is definitely not in the tree.
> > 
> > So I'd like to make some changes like this patch(_UNTEST_):
> 
> I've thought of this problem more and came up with a _better and more efficient_ patch.
> It will always get BTRFS_I(inode)->logged_trans correct value.

Thanks, this makes sense.

> 
> But I'm still trying to test it somehow... :P

http://oss.oracle.com/~mason/synctest/synctest.c

I used synctest -F -f -u -n 100 -t 32 .

-chris
