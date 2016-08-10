Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33077 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbcHJVPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 17:15:40 -0400
Received: by mail-oi0-f50.google.com with SMTP id c15so76632275oig.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 14:15:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Aug 2016 15:15:24 -0600
Message-ID: <CAJCQCtSybRPdoe1FD1bXnqto7ovhrr=N8Zvwkz_4UWO0-0qJTg@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Dave T <davestechshop@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2016 at 9:27 PM, Dave T <davestechshop@gmail.com> wrote:
> btrfs scrub returned with uncorrectable errors. Searching in dmesg
> returns the following information:
>
> BTRFS warning (device dm-0): checksum error at logical NNNNN on
> /dev/mapper/[crypto] sector: yyyyy metadata node (level 2) in tree 250
>
> it also says:
>
> unable to fixup (regular) error at logical NNNNNN on /dev/mapper/[crypto]
>
>
> I assume I have a bad block device. Does that seem correct? The
> important data is backed up.

If it were persistently, blatantly bad, then the drive firmware would
know about it, and would report a read error. If you're not seeing
libata UNC errors, or the other way it manifests is with hard link
resets due to inappropriate SCSI command timer default in the kernel,
then it's probably some kind of SDC, torn or misdirected write, etc.
If metadata is profile DUP, then scrub should fix it. If it's not,
there's something else going on (or really bad luck).

I'd like to believe that btrfs check can, or someday will, be able to
do some kind of sanity check on a node that fails checksum, and fix
it. If the node can be read but merely fails checksum isn't a really
good reason for a file system to not give you access to its data, but
yeah it kinda depends on what's in the node. It could contain up to a
couple hundred items each of which point elsewhere.

btrfs-debug-tree -b <block number reported by error at logical> <dev>
might give some hint what's going on. I'd like to believe it'll be
noisy and warn the checksum fails but still show the contents assuming
the drive hands over the data on those sectors.


> If I can copy this entire root filesystem, what is the best way to do
> it? The btrfs restore tool? cp? rsync? Some cloning tool? Other
> options?

0. Backup, that's done.
1. Report 'btrfs check' without --repair, let's see what it complains
about and if it might be able to plausibly fix this.

Since you can scrub, it means the file system mounts. Since the file
system mounts, I would not look at restore to start out because it's
tedious. I'd say you toss a coin over using btrfs send/receive, or
btrfs check --repair to see if it fixes the node. These days it should
be safe with relatively recent btrfs-progs so I'd say use a 4.6.x or
4.7 progs for this. And then the send/receive should be done with -v
or maybe even -vv for both send and receive, along with --max-errors
0, which will permit unlimited errors but will report them rather than
failing midstream. This will get you the bulk of the OS.

If you're lucky, the node contains only a handful of relatively
unimportant items, especially if they're files small enough to be
stored inline the node, which will substantially reduce the number of
errors as a result of a single node loss.

The calculus on btrfs check --repair first then send receive, vs
send/receive then if that fails fallback to btrfs check --repair, is
mainly time. Maybe repair can fix it, maybe it makes things worse.
Where send/receive might fail midstream without the node being fixed
first, but it causes no additional problems. The 2nd is more
conservative but takes more time if it turns out the send/receive
fails, you then do repair, and then have to start the send/receive
over from scratch again. (If it fails, you should delete or rename the
bad subvolume on the receive side before starting another send).


> If I use the btrfs restore tool, should I use options x, m and S? In
> particular I wonder exactly what the S option does. If I leave S out,
> are all symlinks ignored?

I would only use restore for the files that are reported by
send/receive as failed due to errors - assuming that even happens. Or
since this is OS stuff, just reinstall the packages for the files
affected by the bad node.


-- 
Chris Murphy
