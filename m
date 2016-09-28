Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33599 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934445AbcI1BbC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 21:31:02 -0400
Received: by mail-oi0-f42.google.com with SMTP id r126so36288679oib.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Sep 2016 18:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160927225715.GQ21290@hungrycats.org>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
 <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com> <20160927225715.GQ21290@hungrycats.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 27 Sep 2016 19:31:00 -0600
Message-ID: <CAJCQCtTu2XRnmsVULrvOHhU2pwcckMABsXKET+we6KwduNy6Ew@mail.gmail.com>
Subject: Re: OS X Time Machine and BTRFS
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 27, 2016 at 4:57 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Mon, Sep 26, 2016 at 03:06:39PM -0600, Chris Murphy wrote:
>> On Mon, Sep 26, 2016 at 2:15 PM, Ruben Salzgeber
>> <ruben.salzgeber@gmail.com> wrote:
>> > Hi everyone
>> >
>> > I'm reaching out to you because I experience unusually slow read and
>> > write speeds on my Arch Linux server in combination with OS X time
>> > machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
>> > for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
>> > version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
>> > connection I reach 120MB/s for normal filetransfers from OS X to the
>> > Server. When using Time Machine I measure peak network trafic around
>> > 1-2MB/s and long durations of almost no trafic. Could this be in any
>> > relation to BTRFS? Is there a special configuration necessary for
>> > folders containing the Time Machine sparsebundle file?
>
> Ruben, if nobody has told you before now:  don't use btrfs raid5 in
> production.


I spaced this out, it might be a factor in the performance problem. More below.


>
>> For the likely majority who have no idea what this means: this creates
>> a file on the server, on which an HFS+ volume is created and then
>> remotely mounted on the client. Client sees an HFS+ volume. Server
>> side, this file isn't really just one file, it's actually a directory
>> containing a bunch of 8MiB files. So it's like a qcow2 file, in that
>> it grows dynamically, but is made up of 8MiB "extents" that appear as
>> files.
>>
>> First question is if the directory containing the sparsebundle file
>> has xattr +C set on it? If not, individual bundle files won't inherit
>> nodatacow as they're created. You'll have literally hundreds if not
>> thousands of these files, many of which are being CoW'd constantly and
>> simultaneously as they're being modified. Even a tiny metadata "touch"
>> for an area of the HFS+ file system will result in an 8MiB file being
>> affected. What I don't know, but suspect, is that each change to one
>> of these 8MiB files is causing the whole 8MiB to be CoW'd. I have no
>> idea what kind of optimization is possible here. If Netatalk is
>> updating one of these 8MiB files, what does that write pattern look
>> like? If it's making half a dozen small changes, is that half a dozen
>> CoW of that entire 8MiB file? Or is it just CoW'ing what's changed?
>> And then to what degree is Netatalk doing fsync at all? It could be a
>> worse case scenario where it's CoWing 8MiB increments each time and
>> with lots of fsyncs, which would just obliterate the performance.
>
> Btrfs will CoW just the parts that are changed, leaving the original 8MB
> extent on disk until the last original block is overwritten.

If the parts that are changed are less than the full data stripe size,
in this case 448KiB, then my understanding is it's not CoW, it's RMW
for that stripe.

In this use case, I mostly expect the backup is producing new writes
on HFS+, and thus new writes on Btrfs. But two things could cause a
lot of RMW: the HFS+ journal is ~16MiB, and maybe it's getting hit
with lots of changes during backups, I'm not sure. And there could be
a lot of small block writes for HFS+ metadata, also causing RMW.


-- 
Chris Murphy
