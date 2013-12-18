Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3LRD3g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 22:29:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vt7pF-00044s-WF
	for linux-btrfs@vger.kernel.org; Wed, 18 Dec 2013 04:29:34 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 04:29:33 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 04:29:33 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
Date: Tue, 17 Dec 2013 22:29:23 -0500
Message-ID: <8761qmsup8.fsf@maru2.md5i.com>
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131217150919.GP6498@twin.jikos.cz>
	<tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
	<52B10EBE.4030508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao Xie <miaox@cn.fujitsu.com> writes:

> On Tue, 17 Dec 2013 10:40:41 -0500, Michael Welsh Duggan wrote:
>> David Sterba <dsterba@suse.cz> writes:
>> 
>>> On Tue, Dec 17, 2013 at 05:13:49PM +0800, Wang Shilong wrote:
>>>> If we change our default subvolume, btrfs receive will fail to find
>>>> subvolume. To fix this problem, i have two ideas.
>>>>
>>>> 1.make btrfs snapshot ioctl support passing source subvolume's
>>>> objectid
>>>
>>>> 2.when we want to using interval subvolume path, we mount it other
>>>> place
>>>> that use subvolume 5 as its default subvolume.
>>>
>>> 3. Tell the user to mount the toplevel subvol by himself and run
>>> receive
>>>    again
>> 
>> Ugh.  I hope that would be considered a short-term hack waiting for a
>> better solution, perhaps requiring a kernel upgrade.  From a user's
>> perspective there is no reason this should be necessary, and requiring
>> this would be extraordinarily surprising.  "Why is btrfs unable to find
>> my snapshot?  It's right there!"  Moreover, this used to work just fine
>> in previous versions of btrfs-progs.
>
> Though the snapshot is still in the fs, it is inaccessible because you
> mount
> some subvolume as the root, and you can not find the path to the snapshot.
>
> For example:
> There are two subvolumes in the fs, and they are in the root directory
> of the
> fs, just like
> 	real root directory
> 	 |->subv0
> 	 |->subv1
>
> Then if you mount the subv1 as the root directory, the real root
> directory of
> the fs and subv0 will be shielded,
> 	+-------------------+
> 	|real root directory|
> 	| |->subv0          |
> 	+-------------------+
> 	  |->subv1
> you can only access the files, directories, subvolumes... in the subv1. So the tool
> will report "can not find ...."
>
> BTW, it is impossible that the previous version of btrfs-progs can work well in
> this case.

In that case I either misunderstand completely, or my problem is almost
decidedly different.  To recap, this is the command that failed:

    # ./btrfs send -p /snapshots/bo /snapshots/bp | ./btrfs receive /backup/snapshots/root/
    At subvol /snapshots/bp
    At snapshot bp
    ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key 48f0ebae83fd32f1, UUID_KEY, 90139d8200afeaab) ret=-1, error: No such file or directory
    ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key 48f0ebae83fd32f1, UUID_KEY, 90139d8200afeaab) ret=-1, error: No such file or directory
    ERROR: could not find parent subvolume

Now, I believe you are saying that this means that it can't find the
"bo" snapshot in the backup volume.  But it is mounted in the expected
location:

    # ls -ld /backup/snapshots/root/bo/
    drwxr-xr-x 1 root root 280 Dec 13 17:54 /backup/snapshots/root/bo/

and 

    # ./btrfs sub list -p /backup/ | grep root/bo
    ID 1030 gen 1046 parent 5 top level 5 path snapshots/root/bo

    # btrfs sub show /backup/snapshots/root/bo/
    /backup/snapshots/root/bo
            Name:                   bo
            uuid:                   5e15ef24-f2d0-194f-886d-3f7afc7413a4
            Parent uuid:            9a226af3-8497-744b-90f7-d7e54d58946d
            Creation time:          2013-12-13 17:51:57
            Object ID:              1030
            Generation (Gen):       1046
            Gen at creation:        1042
            Parent:                 5
            Top Level:              5
            Flags:                  readonly
            Snapshot(s):

Maybe I am missing some terminology here?  Is there some output I can
send to make the problem clearer?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

