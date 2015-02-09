Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44594 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbbBIWpn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 17:45:43 -0500
Received: by mail-lb0-f179.google.com with SMTP id w7so8679871lbi.10
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 14:45:42 -0800 (PST)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Mon, 9 Feb 2015 23:45:21 +0100
Message-ID: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com>
Subject: Repair broken btrfs raid6?
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I'm having some trouble with my six-drives btrfs raid6 (each drive
encrypted with LUKS). At first: Yes, I do have backups, but it may
take at least days, maybe weeks or even some month to restore
everything from the (offside) backups. So it is not essential to
recover the data, but would be great ;-)

OS: Ubuntu 14.04
Kernel: 3.19.0
btrfs-progs: 3.19-rc2

When booting my server I am getting this in the syslog:
> [    8.026362] BTRFS: device label tobby-btrfs devid 3 transid 108721 /dev/dm-0
> [    8.118896] BTRFS: device label tobby-btrfs devid 6 transid 108721 /dev/dm-1
> [    8.202477] BTRFS: device label tobby-btrfs devid 1 transid 108721 /dev/dm-2
> [    8.520988] BTRFS: device label tobby-btrfs devid 4 transid 108721 /dev/dm-3
> [    8.555570] BTRFS info (device dm-3): force lzo compression
> [    8.555574] BTRFS info (device dm-3): disk space caching is enabled
> [    8.556310] BTRFS: failed to read the system array on dm-3
> [    8.592135] BTRFS: open_ctree failed
> [    9.039187] BTRFS: device label tobby-btrfs devid 2 transid 108721 /dev/dm-4
> [    9.107779] BTRFS: device label tobby-btrfs devid 5 transid 108721 /dev/dm-5
Looks like there is something wrong on drive 3, giving me "open_ctree
failed". I have to press "S" to skip mounting of the btrfs volume. It
boots and with "sudo mount --all" I can successfully mount the btrfs
volume. Sometimes it takes one or two minutes but it will mount.

After a while I am sometimes/randomly getting this in the syslog:
> [ 1161.283246] BTRFS: dm-5 checksum verify failed on 39099619901440 wanted BB5B0AD5 found 6B6F5040 level 0
Looks like something else is broken on dm-5... But shouldn't this be
repaired with the new raid56-repair-features of kernel 3.19?

After some more time I am getting this:
> [637017.631044] BTRFS (device dm-4): parent transid verify failed on 39099305132032 wanted 108722 found 108719
Then it is not possible to access the mounted volume anymore. I have
to "umount -l" to unmount it and then I can remount it. Until it
happens again (after some time)...

I also tried a balance and a scrub but they "crash". Syslog is full of
messages like the following examples:
> [ 3355.523157] csum_tree_block: 53 callbacks suppressed
> [ 3355.523160] BTRFS: dm-5 checksum verify failed on 39099306917888 wanted F90D8231 found 5981C697 level 0
> [ 4006.935632]  BTRFS (device dm-5): parent transid verify failed on 30525418536960 wanted 108975 found 108767
and "btrfs scrub status /[device]" gives me the following output:
> "scrub status for [UUID]
>        scrub started at Mon Feb  9 18:16:38 2015 and was aborted after 2008 seconds
>        total bytes scrubbed: 113.04GiB with 0 errors"

So a short summary:
- btrfs raid6 on 3.19.0 with btrfs-progs 3.19-rc2
- does not mount at boot up, "open_ctree failed" (disk 3)
- mounts successfully after bootup
- randomly "checksum verify failed" (disk 5)
- balance and scrub crash after some time
- after a while the volume gets unreadable, saying "parent transid
verify failed" (disk 4 or 5)

And it looks like there still is no way to btrfsck a raid6.

Any ideas how to repair this filesystem?

Regards,
Tobias
