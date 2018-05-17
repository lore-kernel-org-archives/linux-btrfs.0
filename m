Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:37974 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbeEQJq2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 05:46:28 -0400
Received: by mail-oi0-f45.google.com with SMTP id k17-v6so3416246oih.5
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 02:46:28 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 17 May 2018 05:46:27 -0400
Message-ID: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
Subject: btrfs device replace can cause silent or noisy corruption on
 compressed NOCOW/NODATASUM
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like Qu may have taken care of corrupted compressed data with
NODATASUM from causing causing random kernel memory corruption.

As long as the compressed data was valid and could be uncompressed,
there were no problems, even on data marked NOCOW/NODATASUM.  If the
data being sent to be uncompressed was invalid and failed
decompression, it would sometimes give an I/O error, and sometimes
cause random kernel memory corruption.

I retraced my steps to try to figure out how my data got corrupted in
the first place.  The pattern of corruption didn't make any sense for
this to be hardware related, or a user-caused badly executed dd.

In short, "btrfs device replace" caused it.  When it copies data to a
new drive, and encounters NOCOW/NODATASUM compressed data, it copies
the data in uncompressed form to the new drive, leaving it in
compressed form on the other mirror, leaving it all marked as
compressed.  I don't know how it handles the longer length.  I don't
know if it only writes out the compressed length, if it writes out the
uncompressed length possibly overwriting other data its writing out or
even worse other file extents, etc.

To rule out anything else, I started in a fresh VM with the May 1,
2018, Arch installation ISO.  That's kernel 4.16.5, btrfs-progs 4.16.

Starting with a freshly partitioned disk with (3) 10GB partitions, a
fairly minimal reproducing case with lots of explaining comments can
be read here:

https://pastebin.com/VvNk90Wa

I of course don't know the extent of this.  I don't know all of the
situations where NOCOW/NODATASUM extents are compressed anyway.  In my
real world case, it was journald logs.  We know journald/systemd
submits those for defragmentation.  I haven't verified if it submits
the defragmentation asking for compression.  In my reproducing example
linked above, I had to defragment the file asking for compression to
cause the file to be compressed.  If that's the extent of the bug,
probably lots of journald logs out there that have been through a
replace have corruption, but hopefully no databases.  I don't think
any databases, and not many database administrators, are going to
submit the files for defragmentation with compression.  But, if
compression can be triggered in more situations than this, it's
possible there's a lot of corruption (sometimes silent) out there on
important things like databases.

Obviously, btrfs device replace or something it depends on needs
fixing.  It's above my pay grade on if some type of alert should be
sent out saying not to use replace on btrfs-progs less than a new
version that hasn't come out yet.  Probably depends on how big the
extent of the bug is.

I also submit that even with corrupted compressed data no longer being
submitted for decompression, and even with btrfs device replace soon
being patched, that there should be a way for all NODATASUM data that
is mirrored to have the mirrored copies compared, regardless of if
compression is involved.  I think check or scrub should gain this
functionality.  Obviously, without a checksum, no automatic repair can
happen, but the user can at least be alerted that something is wrong.
As the example will show, if the corruption happens on the mirrored
copy that isn't read, it's silent corruption, unless that good copy
goes bad someday.  Btrfs has a chance to give NODATASUM data extra
protection over other filesystems, somewhere between mirrored copies
just really protecting against a disk failure like most
implementations and like btrfs does with NODATASUM data now, and
between btrfs' checksummed mirrors that guard against bit rot and
one-mirror accidental corruption.

I'd even be interested in writing such an addon to check or scrub, if
it would be accepted, assuming it was written well and worked of
course.  If someone else wants to do it, that's OK too.
