Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29301 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbbE0D2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 23:28:02 -0400
Message-ID: <556539BF.4040300@cn.fujitsu.com>
Date: Wed, 27 May 2015 11:27:59 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Ian Hinder <ian.hinder@aei.mpg.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: du vs qgroup
References: <FE5E411A-18A0-4D69-9997-050C05275019@aei.mpg.de>
In-Reply-To: <FE5E411A-18A0-4D69-9997-050C05275019@aei.mpg.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: du vs qgroup
From: Ian Hinder <ian.hinder@aei.mpg.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年05月27日 07:04

> Hi,
>
> I have a 350 GB btrfs filesystem in which I am storing backups of virtual machine disk images.  These are rsynced periodically from the VM host to a "current" subvolume, followed by a snapshot operation to a dated subvolume.  One disk image is about 50 GB in size, as reported by ls -l and du.  However, the qgroup assigned to the "current" subvolume reports a "refr" size of 75 GB.  I have performed a "btrfs quota rescan" to make sure the quota is up-to-date.  I have tried defragmenting the file, but this did not significantly help.
Snapshot aware defrag is not implemented yet.
Even in lastest kernel.

And in fact, fragments may be the cause of your problem.
50G original extents + 25G fragments.
Wow, quite a lot fragments.

As you mentioned, the file is rsynced, which means it's only partially 
updated, and COW happens.
Let's take a 16K file as an example.
The 16K file is write as a whole, and on disk it is continuous as one 
extent.
|------16K-------|

Then update the second 4K and sync. Which will make btrfs to COW the 4K.
|--old 16K-------| |-new 4K-|

The old 16K is still there, and new 4K is some place else.
It takes 20K now, even the second 4K in the 16K extent is not used by 
any one.

And quota only cares the space of all extents takes up, even there is 
some hole in the extent, which is not used by anyone.
So quota will report you 20K, not 16K as other overwriting filesystem.

Normally, defrag should work and makes the case back to one 16K extent.
But as snapshot aware defrag not implemented in kernel, defrag just 
doesn't work.

If you really want to make the value goes back to 50G in your case.
Don't rsync, just scp and that should makes it back to 50G.

BTW, you can also try nocow for the VM image, but I'm not sure whether 
it's good or not.

Thanks,
Qu
>
> Is there an explanation for the discrepancy between the logical file size and the data used in btrfs to store it?
>
> I have one theory, which is that when the updated VM image is synced into the current subvolume, the changes affect only a small part of each data storage node (I'm not sure if I'm using the terminology "node" correctly here), but each node needs to be duplicated due to the COW nature of the filesystem, and the fact that the nodes are shared with the existing snapshots, so they cannot be rewritten to be more efficient.  This means that most of the data in such a node is actually duplicated, even though it only counts once toward the logical size of the file.  I do not know how to determine the node size of my filesystem, but as far as I can tell from searching, the node size is never more than 65 K.  It seems to me unlikely that such a small node size could cause the problems I am seeing, but I suppose it's not impossible, especially because this virtual machine disk image hosts a number of git repositories, typically containing large numbers of small files, which have under!
>   gone significant churn in the past.  If this were the problem, would deduplication help, or does it operate only at the level of nodes?
>
> I am using Linux version 3.16.0-38-generic, Ubuntu 14.04.2 LTS.  This is from August 2014.  I know that it is preferable to use the latest kernel for btrfs; Ubuntu provides up to 3.19.0-18, and I would consider upgrading if this is likely to help the problem.
>
> What is the most up-to-date description of how btrfs stores data? I have found this, https://oss.oracle.com/~mason/btrfs/btrfs-design.html, for example.
>
