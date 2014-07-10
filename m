Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:55762 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaGJXce (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 19:32:34 -0400
Received: by mail-ig0-f169.google.com with SMTP id r10so3594403igi.4
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:32:33 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 11 Jul 2014 00:32:33 +0100
Message-ID: <CAKinxcW7X=tc8GBBjkGNHKL8wM6dD=a9UkWBpXOsAbLpaOBmYA@mail.gmail.com>
Subject: Btrfs transaction checksum corruption & losing root of the tree &
 bizarre UUID change.
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all !

So it been some time with btrfs, and so far I was very pleased, but
since I've upgraded to ubuntu from 13.10 to 14.04 problems started to
occur (YES I know this might be unrelated).

So in the past I've had problems with btrfs which turned out to be a
problem caused by static from printer generating some corruption in
ram causing checksum failures on the file system - so I'm not going to
assume that there is something wrong with btrfs from the start.

Anyway:
On my server I'm running 6 x 2TB disk in raid 10 for general storage
and 2 x ~0.5 TB raid 1 for system. Might be unrelated, but after
upgrading to 14.04 I've started using Own Cloud which uses Apache &
MySql for backing store - all data stored on storage array, mysql was
on system array.

All started with csum errors showing up in mysql data files and in
some transactions !!!. Generally system imidiatelly was switching to
all btrfs read only mode due to being forced by kernel (don't have
dmesg / syslog now). Removed offending files, problem seemed to go
away and started from scratch. After 5 days problem reapered and now
was located around same mysql files and in files managed by apache as
"cloud". At this point since these files are rather dear to me I've
decided to pull all stops and try to rescue as much as I can.

As a excercise in btrfs managment I've run btrfsck --repair - did not
help. Repeated with --init-csum-tree - turned out that this left me
with blank system array. Nice ! could use some warning here.

I've moved all drives and move those to my main rig which got a nice
16GB of ecc ram, so errors of ram, cpu, controller should be kept
theoretically eliminated. I've used system array drives and spare
drive to extract all "dear to me" files to newly created array (1tb +
500GB + 640GB). Runned a scrub on it and everything seemed OK. At this
point I've deleted "dear to me" files from storage array and ran  a
scrub. Scrub now showed even more csum errors in transactions and one
large file that was not touched FOR VERY LONG TIME (size ~1GB).
Deleted file. Ran scrub - no errors. Copied "dear to me files" back to
storage array. Ran scrub - no issues. Deleted files from my backup
array and decided to call a day. Next day I've decided to run a scrub
once more "just to be sure" this time it discovered a myriad of errors
in files and transactions. Since I've had no time to continue decided
to postpone on next day - next day I've started my rig and noticed
that both backup array and storage array does not mount anymore. I was
attempting to rescue situation without any luck. Power cycled PC and
on next startup both arrays failed to mount, when I tried to mount
backup array mount told me that this specific uuid DOES NOT EXIST
!?!?!

my fstab uuid:
fcf23e83-f165-4af0-8d1c-cd6f8d2788f4
new uuid:
771a4ed0-5859-4e10-b916-07aec4b1a60b


tried to mount by /dev/sdb1 and it did mount. Tried by new uuid and it
did mount as well. Scrub passes with flying colours on backup array
while storage array still fails to mount with:

root@ubuntu-pc:~# mount /dev/sdd1 /arrays/@storage/
mount: wrong fs type, bad option, bad superblock on /dev/sdd1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

for any device in the array.

Honestly this is a question to more senior guys - what should I do now ?

Chris Mason - have you got any updates to your "old friend stress.sh"
? If not I can try using previous version that you provided to stress
test my system - but I this is a second system that exposes this
erratic behaviour.

Anyone - what can I do to rescue my "bellowed files" (no sarcasm with
zfs / ext4 / tapes / DVDs)

ps. needles to say: SMART - no sata CRC errors, no relocated sectors,
no errors what so ever (as much as I can see).
