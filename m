Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:32849 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbeERJhu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 05:37:50 -0400
Received: by mail-ot0-f177.google.com with SMTP id l22-v6so8396718otj.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 02:37:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
References: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Fri, 18 May 2018 05:37:48 -0400
Message-ID: <CA+X5Wn4=fhaSSaYYbf6_EgFYrZyrndqvoBnBmqtq0hfX_1My+g@mail.gmail.com>
Subject: Re: btrfs device replace can cause silent or noisy corruption on
 compressed NOCOW/NODATASUM
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 5:46 AM, james harvey <jamespharvey20@gmail.com> wrote:
> ...
> I of course don't know the extent of this.  I don't know all of the
> situations where NOCOW/NODATASUM extents are compressed anyway.  In my
> real world case, it was journald logs.  We know journald/systemd
> submits those for defragmentation.  I haven't verified if it submits
> the defragmentation asking for compression.  In my reproducing example
> linked above, I had to defragment the file asking for compression to
> cause the file to be compressed.  If that's the extent of the bug,
> probably lots of journald logs out there that have been through a
> replace have corruption, but hopefully no databases.  I don't think
> any databases, and not many database administrators, are going to
> submit the files for defragmentation with compression.  But, if
> compression can be triggered in more situations than this, it's
> possible there's a lot of corruption (sometimes silent) out there on
> important things like databases.
> ...

I hoped to show systemd asked for its journal files to be compressed
when it asked them to be defragmented.  That would limit the exposure
to programs that asked for compressed NOCOW, which hopefully would not
be many.

But, systemd doesn't do this.

The most it does is try turning *off* NOCOW when it's rotating a file
and won't write to it ever again, but it fails doing that without
realizing it, since the file isn't empty.

I'm confused on why its journal files get compressed while still being NOCOW.

systemd sets NOCOW for new journal files.  [1]

There's only 2 places I can see where systemd changes the NOCOW
attribute or asks for defragmentation.  It doesn't do anything with
the lowercase 'c' attribute explicitly asking for compression (ioctl
FS_COMPR_FL.)

src/journal/journal-file.c::journal_file_open_reliably()::3555 - When
opening a journal file, if its journal format is corrupted, set NOCOW
and defrag it before trying one more time.

src/journal/journal-file.c::journal_file_close()::378 - When closing a
journal file marked defrag on close: turn *off* NOCOW and defrag it.
The only time a journal file is marked defrag on close is at
journal_file_rotate()::3484, for the old file being rotated out.  When
rotating out, it's done by renaming the file at :3466, not by copying
the contents to a new file and blanking the existing one.

These places set or turn off NOCOW by ultimately calling "ioctl(fd,
FS_IOC_SETFLAGS" and appropriately handling FS_NOCOW_FL.

These places defrag by ultimately calling "ioctl(fd, BTRFS_IOC_DEFRAG, NULL)".

To request defragmentation with decompression, I believe
BTRFS_IOC_DEFRAG_RANGE has to be used instead so the range struct can
be used with a compression type.  And, systemd doesn't seem to be
calling the _RANGE variant anywhere, so it's not directly asking for
compression.

It tries to be helpful by thinking it's turning off NOCOW once it's
done forever writing to a file, not understanding that since it's a
non-empty file, you can't do that this way.

The only thing I could come up with was that ioctl might be turning
off NOCOW on a non-empty file where "chattr -C" wasn't, but I wrote a
c program that uses systemd's exact chattr_fd() that in turn uses
"ioctl(fd, FS_IOC_SETFLAGS", and it leaves the NOCOW attribute on as
expected.

Unless I'm missing something, systemd triggers NOCOW compression
without explicitly asking for it in the c program equivalent to
running on a NOCOW file "btrfs fi def -c".

If that's correct, that means the number of programs that cause
compressed NOCOW is probably larger than just systemd.



[1] Started in systemd 219, and as of 220, it's done in a way where
the user can modify tmpfiles.d/journal-nocow.conf to change this
behavior.  See systemd NEWS, and
http://systemd-devel.freedesktop.narkive.com/ii8vxOoW/patch-v3-allow-systemd-tmpfiles-to-set-file-directory-attributes
