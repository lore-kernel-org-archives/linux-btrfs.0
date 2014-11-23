Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s24.hotmail.com ([65.55.116.35]:51379 "EHLO
	BLU004-OMC1S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbaKWLAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 06:00:24 -0500
Message-ID: <BLU437-SMTP10930A5E18E8322A8C259AAB750@phx.gbl>
Date: Sun, 23 Nov 2014 11:00:16 +0000
From: Boris Chernov <aqs1024@hotmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Changing label few times killed filesystem?
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl> <20141121093543.6685cbe5@natsu>
In-Reply-To: <20141121093543.6685cbe5@natsu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


 > I suggest upgrading and just posting the results from 'btrfs check 
<device>'
 > without any options and see what you get.
     OK, I have upgraded to 3.17.0 kernel and I also have upgraded 
btrfs-tools:
# btrfs --version
Btrfs v3.17

# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
cmds-check.c:2645: check_owner_ref: Assertion `rec->is_root` failed.
btrfs[0x41a081]
btrfs[0x41a0a5]
btrfs[0x409783]
btrfs[0x40a45e]
btrfs[0x41bfa9]
btrfs[0x40b46a]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7feaf251cb45]
btrfs[0x40b497]

     btrfsck /dev/sdb1 gives exactly the same output. It seems it does 
not even try to check anything but just fails on the assertion. I also 
tried btrfs restore:

# btrfs restore /dev/sdb1 /media/backup/sdb1 # Does nothing and exits 
almost immediately
# echo $?
0

     After I have upgraded to new kernel, when I try to mount the 
partition I get this:

# mount /dev/sdb1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

# dmesg | tail
...
[ 2505.921545] BTRFS info (device sdb1): disk space caching is enabled
[ 2505.925079] parent transid verify failed on 29458432 wanted 5 found 2759
[ 2505.944413] parent transid verify failed on 29458432 wanted 5 found 2759
[ 2505.958450] BTRFS: open_ctree failed

 > However, if you are not now and never did use compression on that 
filesystem,
 > that bug shouldn't affect you, but others might.
     I did not use compression on this partition, but I have used it on 
another btrfs disk (which seems to work fine, at least for now). I think 
I did not use any of special features on the partition I have trouble 
with (I was planning to, but it died before I got a chance).

 > it's quite possible you're seeing the one bug, and the relabeling is 
simply coincidence.
     I suppose it is possible that something else was the cause, but 
only other thing I did with the file system at the time was 
mounting/unmounting it. Also, I did not use it much, just for few weeks, 
before that the disk was unplugged for a few months (with no files on 
it). And only things I did with it (before it stopped working) was 
creating, moving, copying and deleting files.
     Before upgrading btrfs-tools and the kernel I tried to reproduce 
the issue by creating big file with btrfs file system, but I was unable 
to reproduce the problem, but I did not put as much files as on real 
partition, and it was of a smaller size. In other words, the issue I 
have encountered seems to be hard to reproduce, so I cannot tell with 
100% certainty what exactly caused the corruption.


     Is there anything else I can try? If not to restore it then to 
provide more useful debug information (if possible in this case). I 
could try compiling latest development versions of kernel and/or 
btrfs-tools if is there a chance that might help?


     P.S. I received on my mail only shortest reply about "mount" 
command, so I was able to read other replies only after few days when 
they appeared on gmane (I wasn't subscribed at the time because I did 
not expect gmane to be so slow). This time I subscribed to the list so 
hopefully I will be able to read all replies without delay.
