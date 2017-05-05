Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:33541 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdEEPkS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 11:40:18 -0400
Received: by mail-yw0-f173.google.com with SMTP id 203so4705053ywe.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 08:40:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGtqt-tVNvbxkdaEB7PshWVpDHsxfHYMujOkAvOP9aiJ6w@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com> <CAPktuGtqt-tVNvbxkdaEB7PshWVpDHsxfHYMujOkAvOP9aiJ6w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 5 May 2017 09:40:17 -0600
Message-ID: <CAJCQCtRNEYcJ5duGNYoTFKX-nBbK15FV_2jZ0UrZrhiDo5rkDw@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Alexandru Guzu <alexguzu@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 5, 2017 at 8:56 AM, Alexandru Guzu <alexguzu@gmail.com> wrote:
> btrfs-progs is 4.4

That's before the rewrite of convert.


> I upgraded the kernel to 4.8.0-51 and the issue persists.
> However, I noticed that the issue is triggered when I start Firefox. I
> think Firefox starts writing something to some specific files and that
> triggers the issue because I was able to upgrade the kernel without
> getting the disk in RO mode.

When Btrfs becomes aware of its confusion, it'll go readonly to
prevent corrupting the file system. It might already have some
isolated corruption. It doesn't really tell us more than that.

>
> I can try to get a newer version of btrfs-progs, but what should I do
> with it? Should I check/scrub? I don't see how simply having a newer
> version of the btrfs-progs would prevent the kernel from throwing the
> error and putting the disk in read-only mode.

It won't change anything now. The version question is to establish
whether you have old or new style converted ext4. The call traces you
have come up in the list only with new style convert. But you have old
style. That's why I included Qu in the cc, I have no idea what the
problem is and if it's fixable with btrfs check from a recent
btrfs-progs or if it needs an even newer kernel, or if it's an unfixed
bug still.

In the meantime I would do this:

1. Backup what you care about. Decent chance the only way forward is
to create a new file system, so you might as well take advantage of
the fact at least you can mount it read only right now.

2. Boot some live media and use btrfs-image to capture an image of the
file system as it it. The newer progs the better, as they get a bit
more tolerant of file system errors and hopefully you can capture a
complete image. btrfs-image -c9 -t4 -s /dev/sdX filename.bin  \\ This
is metadata only, and will sanitize filenames.

3. Output from both of these
btrfs check <device>
btrfs check --mode=lowmem <device>   ##this will spit out more
problems if it's older than 4.10.2

Do this without --repair.

What seems safe to me, is while booted with live media, mount the
problem Btrfs file system, and find the Firefox cache,
~/.cache/mozilla/firefox/*.default and delete that whole default
directory. Now you can reboot the installed system, and see if the
problem still happens. If it does, you can try to reinstall Firefox.

If that doesn't help, it's a coin toss if it's worth trying btrfs
check --repair, or if you're better off taking a read-only snapshot
and using btrfs send/receive to a new Btrfs filesystem. The send
receive process is easier to use than rsync -a or cp -a, but things
get allocated natively rather than however convert did it.



-- 
Chris Murphy
