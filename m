Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35564 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034958AbcIZVGl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 17:06:41 -0400
Received: by mail-oi0-f50.google.com with SMTP id w11so222470161oia.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 14:06:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 26 Sep 2016 15:06:39 -0600
Message-ID: <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com>
Subject: Re: OS X Time Machine and BTRFS
To: Ruben Salzgeber <ruben.salzgeber@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 2:15 PM, Ruben Salzgeber
<ruben.salzgeber@gmail.com> wrote:
> Hi everyone
>
> I'm reaching out to you because I experience unusually slow read and
> write speeds on my Arch Linux server in combination with OS X time
> machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
> for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
> version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
> connection I reach 120MB/s for normal filetransfers from OS X to the
> Server. When using Time Machine I measure peak network trafic around
> 1-2MB/s and long durations of almost no trafic. Could this be in any
> relation to BTRFS? Is there a special configuration necessary for
> folders containing the Time Machine sparsebundle file?

For the likely majority who have no idea what this means: this creates
a file on the server, on which an HFS+ volume is created and then
remotely mounted on the client. Client sees an HFS+ volume. Server
side, this file isn't really just one file, it's actually a directory
containing a bunch of 8MiB files. So it's like a qcow2 file, in that
it grows dynamically, but is made up of 8MiB "extents" that appear as
files.

First question is if the directory containing the sparsebundle file
has xattr +C set on it? If not, individual bundle files won't inherit
nodatacow as they're created. You'll have literally hundreds if not
thousands of these files, many of which are being CoW'd constantly and
simultaneously as they're being modified. Even a tiny metadata "touch"
for an area of the HFS+ file system will result in an 8MiB file being
affected. What I don't know, but suspect, is that each change to one
of these 8MiB files is causing the whole 8MiB to be CoW'd. I have no
idea what kind of optimization is possible here. If Netatalk is
updating one of these 8MiB files, what does that write pattern look
like? If it's making half a dozen small changes, is that half a dozen
CoW of that entire 8MiB file? Or is it just CoW'ing what's changed?
And then to what degree is Netatalk doing fsync at all? It could be a
worse case scenario where it's CoWing 8MiB increments each time and
with lots of fsyncs, which would just obliterate the performance.

xattr +C would probably solve most of this, so long as you're not
taking Btrfs snapshots during a TM backup. Of course if +C is set,
notdatacow implies nodatasum so there's no checksumming of this
sparsebundle.

Maybe someone has an idea how to sample the activity as it happens, to
model the write pattern for this use case? Without knowing more about
the pattern, it's a stab in the dark how to optimize the storage for
it.


-- 
Chris Murphy
