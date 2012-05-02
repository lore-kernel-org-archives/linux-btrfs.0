From: David Sterba <dave@jikos.cz>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Wed, 2 May 2012 16:54:08 +0200
Message-ID: <20120502145408.GE6740@twin.jikos.cz>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz>
 <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
 <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2012 at 05:42:05PM +0200, Marco L. Crociani wrote:
> Apr 19 17:38:41 evo kernel: [  347.661915] Call Trace:
> Apr 19 17:38:41 evo kernel: [  347.661964]  [<ffffffffa00b76ac>] > btrfs_ioctl_dev_info+0x15c/0x1a0 [btrfs]
> Apr 19 17:38:41 evo kernel: [  347.662013]  [<ffffffffa00ba9b1>] > btrfs_ioctl+0x571/0x6c0 [btrfs]
> Apr 19 17:38:41 evo kernel: [  347.662024]  [<ffffffff81193839>] > do_vfs_ioctl+0x99/0x330
> Apr 19 17:38:41 evo kernel: [  347.662032]  [<ffffffff8118d345>] ?  > putname+0x35/0x50
> Apr 19 17:38:41 evo kernel: [  347.662040]  [<ffffffff81193b71>] > sys_ioctl+0xa1/0xb0
> Apr 19 17:38:41 evo kernel: [  347.662049]  [<ffffffff816691a9>] > system_call_fastpath+0x16/0x1b

Fixed by
http://comments.gmane.org/gmane.comp.file-systems.btrfs/16302

reported earlier
http://article.gmane.org/gmane.comp.file-systems.btrfs/16796

and it's part of 3.4-rc5.


david
