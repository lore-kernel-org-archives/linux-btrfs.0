Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54198 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbbK3Fqh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 00:46:37 -0500
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com> <565784DE.5080401@oracle.com>
 <5657A757.90909@cn.fujitsu.com> <56581742.9030308@oracle.com>
 <565A5317.8040506@gmx.com> <565BD67B.9090007@oracle.com>
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565BE2A7.8050501@gmx.com>
Date: Mon, 30 Nov 2015 13:46:15 +0800
MIME-Version: 1.0
In-Reply-To: <565BD67B.9090007@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/11/30 12:54 +0800:
>
>
>   (Most of the technical reasoning were already discussed so I won't
>   repeat them here).
>
>   And jolting for new technical reasons finds only these..
>
>> What if the fs is not only for kernel to mount, but also a boot
>> partition for grub?
>> Do you need to check the grub2 version? Check if this is a /boot
>> partition?
>
>
>   In the above context, which is better..
>   this :
>
>     mkfs.btrfs -O ^skinny-metadata,^mixed-bg,^extref,^raid56,^no-holes
>     btrfs-convert -O ^skinny-metadata,^extref,^no-holes
>
>   or this:
>
>     mkfs.btrfs -O comp=<X>
>     btrfs-convert -O comp=<X>
>
>     X = some number below 2.7.37 OR grub2 (planned) (thanks to you,
>     to bring this up).
>
>   ?

Yeah, 2.6.37. What a idiot to use Btrfs on that old kernel?
For stability?

>
>> Recently I just encountered such problem. Latest xfs-progs makes xfs
>> version 5 by default, but grub2 can't handle version 5 yet in latest
>> stable version.
>> Then system can't even boot into grub2.
>
>    Good example. Appears that user didn't know what latest features
>    to disable? so to be compatible with grub2 ? OR they have to read
>    couple of grub documents to fix.

Oh, so we should add btrfs-progs grub2 feature auto align?
And that's what documents is for, I just opened Arch wiki page of xfs, 
and found the solution.

If you don't ever like to read the document, why read the codes and 
enhance it?

>
>    Imagine the pain while using btrfs-convert. That means you need to
>    restore Hope you have not deleted the ext_saved subvol. And then
>    again run btrfs-convert.

Wow, how do you delete the ext_saved subvolume without mounting it?

>
>
>> Did you see Dave trying to add such grub2 version based probe to change
>> mkfs.xfs features?
>> No, just because that's not the way things should be done.
>
>    So what was fix in this case ? Or is there any fix-patch rejected ?

No fix in xfsprogs.
Only support in grub2 is added and already in grub2 git repo.
No stable released at that time.

For xfsprogs, just 4 lines in its announcement:
"There is a notable change in
defaults for mkfs.xfs - it will now make CRC enabled filesystems by
default, and you will need to use "mkfs.xfs -m crc=0" to make
filesystems compatible with production kernels older than 3.15."


Eager to see you to add such feature align patch for xfsprogs and how 
Dave will treat it.



To be honest, how many guys really unhappy with current default features 
behavior *except* you?
Or how many bug report in maillist/bugzilla is about that?

Introducing a new feature matrix only to change the behavior to your flavor?
Isn't this what you called "bloated intelligence"?

Ext2/3/4 and xfs progs are already using such behavior for years and I 
didn't ever see they need anything like btrfs sysfs features interface.
No to mention ext4 and xfs is already used in production environment.

If you are so unhappy with current behavior, why not start from xfs and 
I think Dave will be very "happy" with it.

Thanks,
Qu
>
> Cheers, Anand
