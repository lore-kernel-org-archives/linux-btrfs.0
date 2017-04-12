Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:34948 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdDLR0B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 13:26:01 -0400
Subject: Re: Btrfs disk layout question
To: Amin Hassani <ahassani@chromium.org>, linux-btrfs@vger.kernel.org
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <03a83bfc-27b9-7cc3-c103-1e5caa858431@mendix.com>
Date: Wed, 12 Apr 2017 19:25:59 +0200
MIME-Version: 1.0
In-Reply-To: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/11/2017 09:15 PM, Amin Hassani wrote:
> 
> I am working on a project with Btrfs and I was wondering if there is
> any way to see the disk layout of the btrfs image. Let's assume I have
> a read-only btrfs image with compression on and only using one disk
> (no raid or anything).

> Is it possible to get a set of offset-lengths
> for each file or metadata parts of the image.

These are two very different things, and it's unclear to me what you
actually want.

Do you want:

1. a layout of physical disk space, and then for each range see if it's
used for data, metadata or not used?

2. a list of files and how they're split up (or not) in one or multiple
extents, and how long those are?

Remember that multiple files can reuse part of each others data in
btrfs. So if you follow the files, and you have reflinked copies or
subvolume snapshots, then you see actual disk usage multiple times.

> I know there is an
> unfinished documentation for On-disk Formant in here:
> https://btrfs.wiki.kernel.org/index.php/On-disk_Format
> But it is not complete and does not show what I am looking for. Is
> there any other documentation on this? Is there any public API that I
> can use to get this information.

...

> For example can I iterate on all
> files starting from the root node and get all offset-lengths? This way
> any part that doesn't come can be assumed as metadata. I don't really
> care what is inside the metadata, I just want to know their
> offset-lengths in the file system.

No, that's not how it works.

To learn more about how btrfs organizes data internally, you need a good
understanding of these concepts:

* how btrfs allocates "chunks" (often 256MiB or 1GiB size) of raw disk
space and dedicate them to either data or metadata.
* how btrfs uses a "virtual address space" and how that maps back from
(dev tree) and forth (chunk tree) to raw physical disk space on either
of the disks that is attached to the filesystem.
* how btrfs stores the administration of exactly with part in that
virtual address space is in use (extent tree).
* how btrfs stores files and directories, and how it does so for
multiple directory trees (subvolumes), (the fs tree and all 256 <= trees
<= -256).
* how files in these file trees reference data from data extents.
* how extents reference back to which (can be multiple!) files they're
used in.

IOW, there are likely multiple levels of indirection that you need to
follow to find things out.

Currently there's no perfect tutorial that explains exactly all those
things in a nice way.

The btrfs wiki can help with this, the btrfs-heatmap tool which was
already meantioned is nice to play around with, and get a better
understanding of all address space and usage.

If you know exactly what the end result would be, then it's probably
possible to build something that uses the SEARCH IOCTL with which you
can search in all metadata (containing info of above mentioned trees) of
a live filesystem. At least for C and for python there's enough example
code around to do so.

-- 
Hans van Kranenburg
