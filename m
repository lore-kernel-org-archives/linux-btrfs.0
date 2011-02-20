From: Tomas Zvala <tomas@zvala.cz>
Subject: Re: [Bugme-new] [Bug 29302] New: Null pointer dereference with large
 max_sectors_kb
Date: Sun, 20 Feb 2011 12:06:42 +0100
Message-ID: <4D60F5C2.2040907@zvala.cz>
References: <bug-29302-10286@https.bugzilla.kernel.org/> <20110217153719.9ecc67df.akpm@linux-foundation.org> <20110218174315.GD5615@twin.jikos.cz> <1298056463-sup-4453@think> <20110218115603.5f235b07.akpm@linux-foundation.org> <1298059754-sup-2258@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	bugzilla-daemon <bugzilla-daemon@bugzilla.kernel.org>,
	bugme-daemon <bugme-daemon@bugzilla.kernel.org>,
	fox <fox@murder.cz>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298059754-sup-2258@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.2.2011 21:18, Chris Mason wrote:
> Ok, so it isn't part of the open devices code that prints errors, my
> guess is we're failing to read a good super.
>
> Could you please mkfs.btrfs /dev/xxx, sync, then btrfsck /dev/xxx, I want
> to make sure things are really getting written.
>
> Here's a patch that makes sure we have a good bdev after scanning,
> hopefully it will let us debug things without your box going boom.
>
> -chris
>
>
Hello Chris,
I patched the kernel, recompiled and installed, but I don't see the 
message in the kernel log.  I forgot to mention before, that 
max_hw_sectors_kb and thus max_sectors_kb is 4096.

Linux stg-top 2.6.37stg #7 SMP Sun Feb 20 10:48:57 CET 2011 x86_64 
Intel(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux


With default max_sectors_kb = 512
mkfs, sync, btrfsck going through fine
first mount is fine

[112005]stg-top ~ # cat /sys/block/sdb/queue/max_sectors_kb
512
[112012]stg-top ~ # mkfs.btrfs /dev/sdb

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb
         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
Btrfs Btrfs v0.19
[112045]stg-top ~ # sync
[112046]stg-top ~ # btrfsck /dev/sdb
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 23875
file data blocks allocated: 0
  referenced 0
Btrfs Btrfs v0.19
[112050]stg-top ~ # mount /dev/sdb /mnt/
[112054]stg-top ~ # df /mnt/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb             2929685760        56 2927559936   1% /mnt
[112057]stg-top ~ # umount /mnt


With max_sectors_kb = 4096
mkfs, sync, btrfsck is fine
second mount  BUGs out

[112100]stg-top ~ # echo 4096 > /sys/block/sdb/queue/max_sectors_kb
[112107]stg-top ~ # mkfs.btrfs /dev/sdb

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb
         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
Btrfs Btrfs v0.19
[112113]stg-top ~ # sync
[112117]stg-top ~ # btrfsck /dev/sdb
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 23875
file data blocks allocated: 0
  referenced 0
Btrfs Btrfs v0.19
[112123]stg-top ~ # mount /dev/sdb /mnt/
Killed

Back to max_sectors_kb = 512
mkfs, can't sync, because that'd block, btrfsck is fine
third mount fails

[112126]stg-top ~ # echo 512 > /sys/block/sdb/queue/max_sectors_kb
[112141]stg-top ~ # mkfs.btrfs /dev/sdb

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb
         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
Btrfs Btrfs v0.19
[112144]stg-top ~ # btrfs
btrfs          btrfs-bcp      btrfs-convert  btrfs-image    
btrfs-show     btrfs-vol      btrfsck        btrfsctl       btrfstune
[112144]stg-top ~ # btrfsck /dev/sdb
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 23875
file data blocks allocated: 0
  referenced 0
Btrfs Btrfs v0.19
[112150]stg-top ~ # mount /dev/sdb /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

Run sync in background (it just sits there) and try to mount again (no 
other commands in meantime)

[112155]stg-top ~ # sync &
[1] 15800
[112202]stg-top ~ # mount /dev/sdb /mnt
[112411]stg-top ~ # df /mnt/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb             2929685760        56 2927559936   1% /mnt
[112456]stg-top ~ #

(dmesg after 1st mount)
[  122.085837] device fsid 8d440bbadcd5b357-9e8f05f44e926498 devid 1 
transid 7 /dev/sdb

(dmesg after 2nd mount is pretty much the same as before - no mention of 
the patch)

(dmesg after 3rd mount)
[  183.535484] device fsid 945db83dbf98e60-a27fadce8932f892 devid 1 
transid 7 /dev/sdb
[  183.536785] btrfs bad fsid on block 20971520
[  183.537041] btrfs bad fsid on block 20971520
[  183.537268] btrfs bad fsid on block 20971520
[  183.537469] btrfs: failed to read chunk root on sdb
[  183.545654] btrfs: open_ctree failed

(dmesg after 4th mount)
[  192.481985] device fsid 945db83dbf98e60-a27fadce8932f892 devid 1 
transid 7 /dev/sdb


Tomas

