Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaGBKwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 06:52:39 -0400
Message-ID: <53B3E471.2010101@redhat.com>
Date: Wed, 02 Jul 2014 12:52:33 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
MIME-Version: 1.0
To: Gionatan Danti <g.danti@assyoma.it>, linux-btrfs@vger.kernel.org
CC: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question about fallocate
References: <20140702014130.47a5ba75@ws> <53B3E0C6.3030803@assyoma.it>
In-Reply-To: <53B3E0C6.3030803@assyoma.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/02/2014 12:36 PM, Gionatan Danti wrote:
> Hi,
> 
>> But how did you disable COW?  The nodatacow mount option?  Setting the
>> NOCOW attribute on the file or parent-dir (chattr +C)?  Something else?
>>
>> Because there are caveats to both the mount option and the file
>> attribute methods.
>>
> 
> I used the nodatacow mount point. When doing the test, I had no other subvolume or snapshot.
> 
>> Other than that, I don't know, but it'd be interesting to see if the
>> behavior replicates on a current kernel.
>>
> 
> Yes, I'll try to replicate it on a 3.14.x based Fedora 20.


I am unable to reproduce the problem on kernel version 3.16.0-rc2
using nodatacow.

$ mkfs.btrfs testdisk

WARNING! - Btrfs v3.14.1 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Performing full device TRIM (20.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
fs created label (null) on testdisk

$ sudo mount -o nodatacow testdisk mnt/
$ mount
/mnt/iscsi-disk/test/testdisk on /mnt/iscsi-disk/test/mnt type btrfs (rw,relatime,seclabel,nodatasum,nodatacow,space_cache)

$ cd mnt
$ fallocate test.img -l 1G
$ sync
$ filefrag -v test.img
Filesystem type is: 9123683e
File size of test.img is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   65535:     269312..    334847:  65536:
   1:    65536..  131071:     334848..    400383:  65536:
   2:   131072..  196607:     400384..    465919:  65536:
   3:   196608..  262143:     465920..    531455:  65536:             eof
test.img: 1 extent found

$ for id in `seq 1 32`; do dd if=/dev/zero of=test.img bs=4k count=1 seek=$id conv=notrunc,nocreat oflag=direct,sync; done
$ filefrag -v test.img
Filesystem type is: 9123683e
File size of test.img is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:     269312..    269312:      1:
   1:        1..      32:     269313..    269344:     32:
   2:       33..  262143:     269345..    531455: 262111:             eof
test.img: 1 extent found

$ uname -a
Linux dhcp-27-189.brq.redhat.com 3.16.0-rc2-mainline #17 SMP Mon Jun 23 12:28:11 CEST 2014 x86_64 x86_64 x86_64 GNU/Linux


Regards,
Maurizio Lombardi
