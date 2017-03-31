Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:35436 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934584AbdCaBBF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 21:01:05 -0400
Received: by mail-wr0-f179.google.com with SMTP id k6so78302471wre.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 18:01:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk> <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu> <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk> <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
 <22749.11946.474065.536986@tree.ty.sabi.co.uk> <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
From: GWB <gwb@2realms.com>
Date: Thu, 30 Mar 2017 20:00:22 -0500
Message-ID: <CAP8EXU2ufgLWL+kgKtaLjqHDBGV1OB8GWy+efCJf4Knb0DaEPQ@mail.gmail.com>
Subject: Re: Shrinking a device - performance?
To: ct@flyingcircus.io, Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Christiane,

I very much enjoyed the discussion you sparked with your original
post.  My ability in btrfs is very limited, much less than the others
who have replied here, so this may not be much help.

Let us assume that you have been able to shrink the device to the size
you need, and you are now merrily on your way to moving the data to
XFS.  If so, ignore this email, delete, whatever, and read no further.

If that is not the case, perhaps try something like the following.

Can you try to first dedup the btrfs volume?  This is probably out of
date, but you could try one of these:

https://btrfs.wiki.kernel.org/index.php/Deduplication

If that does not work, this is a longer shot, but you might consider
adding an intermediate step of creating yet another btrfs volume on
the underlying lvm2 device mapper, turning on dedup, compression, and
whatever else can squeeze some extra space out of the current btrfs
volume.  You could then try to copy over files and see if you get the
results you need (or try sending the current btrfs volume as a
snapshot, but I'm guessing 20TB is too much).

Once the new btrfs volume on top of lvm2 is complete, you could just
delete the old one, and then transfer the (hopefully compressed and
deduped) data to XFS.

Yep, that's probably a lot of work.

I use both btrfs (on root on Ubuntu) and zfs (for data, home), and I
try to do as little as possible with live mounted file systems other
than snapshots.  I avoid sending and receive snapshots from the live
system (mostly zfs, but sometimes btrfs) but instead write increment
snapshots as a file on the backup disks, and then import the
incremental snaps into a backup pool at night.

My recollection is that btrfs handles deduplication differently than
zfs, but both of them can be very, very slow (from the human
perspective; call that what you will; a sub optimal relationship of
the parameters of performance and speed).

The advantage you have is that with lvm you can create a number of
different file systems.  And lvm can also create snapshots.  I think
both zfs and btrfs both have a more "elegant" way of dealing with
snapshots, but lvm allows a file system without that feature to have
it.  Others on the list can tell you about the disadvantages.

I would be curious how it turns out for you.  If you are able to move
the data to XFS running on top of lvm, what is your plan for snapshots
in lvm?

Again, I'm not an expert in btrfs, but in most cases a full balance
and scrub takes care of any problems on the root partition, but that
is a relatively small partition.  A full balance (without the options)
and scrub on 20 TiB must take a very long time even with robust
hardware, would it not?

CentOS, Redhat, and Oracle seem to take the position that very large
data subvolumes using btrfs should work fine.  But I would be curious
what the rest of the list thinks about 20 TiB in one volume/subvolume.

Gordon



On Thu, Mar 30, 2017 at 5:13 PM, Piotr Pawłow <pp@siedziba.pl> wrote:
>> The proposed "move whole chunks" implementation helps only if
>> there are enough unallocated chunks "below the line". If regular
>> 'balance' is done on the filesystem there will be some, but that
>> just spreads the cost of the 'balance' across time, it does not
>> by itself make a «risky, difficult, slow operation» any less so,
>> just spreads the risk, difficulty, slowness across time.
>
> Isn't that too pessimistic? Most of my filesystems have 90+% of free
> space unallocated, even those I never run balance on. For me it wouldn't
> just spread the cost, it would reduce it considerably.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
