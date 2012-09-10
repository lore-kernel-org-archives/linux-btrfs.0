Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43426 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab2IJSOI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 14:14:08 -0400
Received: by eekc1 with SMTP id c1so1391532eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 11:14:07 -0700 (PDT)
Message-ID: <504E2DE1.8060405@gmail.com>
Date: Mon, 10 Sep 2012 20:13:53 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Cannot create subvolume with quota enabled
References: <504A4CBF.7000605@gmail.com> <504A6F67.3060506@gmx.net>
In-Reply-To: <504A6F67.3060506@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Arne,

On 08.09.2012 00:04, Arne Jansen wrote:
> Hi Andreas,
>
> On 09/07/2012 09:36 PM, Andreas Philipp wrote:
>> Hi,
>>
>> The following steps reproduce the error. My kernel is 3.6-rc4 and 
>> btrfs-progs are at commit 89fe5b5f666c247aa3173745fb87c710f3a71a4a
>> from 
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>>
>>
> master.
>> thor ~ # mkfs.btrfs -L test /dev/vg1/test
>>
>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL WARNING! - see
>> http://btrfs.wiki.kernel.org before using
>>
>> fs created label test on /dev/vg1/test nodesize 4096 leafsize 4096
>> sectorsize 4096 size 20.00GB Btrfs Btrfs v0.19 thor ~ # mount
>> /dev/vg1/test /mnt/tmp thor ~ # btrfs quota enable /mnt/tmp thor ~
>> # btrfs subvolume create /mnt/tmp/test Create subvolume
>> '/mnt/tmp/test' ERROR: cannot create subvolume - Invalid argument
> Thanks for giving quota a try. I sent a fix separately with
> the subject
>
> [PATCH] Btrfs: btrfs_qgroup_inherit wrongly returns an error
>
> Could you please see if it fixes the problem?
With the patch applied (on top of either 3.6-rc4 or 3.6-rc5) I can
create subvolumes as you see below.

root@debian:~# mkfs.btrfs /dev/sdb

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb
        nodesize 4096 leafsize 4096 sectorsize 4096 size 3.00GB
Btrfs Btrfs v0.19
root@debian:~# mount /dev/sdb /mnt/test
root@debian:~# btrfs quota enable /mnt/test
root@debian:~# btrfs subvolume create /mnt/test/subvolume
Create subvolume '/mnt/test/subvolume'
root@debian:~# btrfs qgroup show /mnt/test
0/257 4096 4096
root@debian:~# dd if=/dev/urandom of=/mnt/test/subvolume/testfile
bs=1024k count=25
25+0 records in
25+0 records out
26214400 bytes (26 MB) copied, 2.95321 s, 8.9 MB/s
root@debian:~# btrfs qgroup show /mnt/test
0/257 4096 4096
root@debian:~# du -hs /mnt/test/*
25M     /mnt/test/subvolume

At least I expected that the output of ' btrfs qgroup show' changes
after some data got written to a subvolume which is assigned to a
qgroup. (Hope, I got it right.)

Thanks,
Andreas

>
> Thanks,
> Arne
>> Please, do not hesitate to contact me for any further information
>> etc.
>>
>> Thanks, Andreas -- To unsubscribe from this list: send the line
>> "unsubscribe linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>>

