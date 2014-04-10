Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:48070 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaDJWkY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 18:40:24 -0400
Received: by mail-we0-f169.google.com with SMTP id w62so4635380wes.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 15:40:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140410203439.GB20307@carfax.org.uk>
References: <CAH3EO-o-S7WveO7V++zB1+Zd3kfrxk4YyMZ6P+GrcNWfALgrfA@mail.gmail.com>
	<20140410203439.GB20307@carfax.org.uk>
Date: Thu, 10 Apr 2014 15:40:22 -0700
Message-ID: <CAH3EO-oSzYTd2Q3H3wfg9eV9ii-phuquvtzU2mT5KGKF1_x5iw@mail.gmail.com>
Subject: Re: Filesystem unable to recover from ENOSPC
From: Chip Turner <cturner@pattern.net>
To: Hugo Mills <hugo@carfax.org.uk>, Chip Turner <cturner@pattern.net>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 10, 2014 at 1:34 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Apr 10, 2014 at 01:00:35PM -0700, Chip Turner wrote:
>> btrfs show:
>> Label: none  uuid: 04283a32-b388-480b-9949-686675fad7df
>> Total devices 1 FS bytes used 135.58GiB
>> devid    1 size 238.22GiB used 238.22GiB path /dev/sdb2
>>
>> btrfs fi df:
>> Data, single: total=234.21GiB, used=131.82GiB
>> System, single: total=4.00MiB, used=48.00KiB
>> Metadata, single: total=4.01GiB, used=3.76GiB
>
>    I'm surprised it's managed to use that much of the metadata
> allocation. The FS usually hits this problem with a much smaller
> used-to-total ratio.

It perhaps was related to how I build it -- basically I dumped many
files (around 8.5 million, 95% of which are hardlinks rather than
actual files) onto it at once, created a snapshot, and then began
deleting files.  The btrfs filesystem they were coming from was fine
with the files and its own original load, but something about the
snapshotting and deleting seemed to push it over the edge.

The issue happened over a couple of days so I don't recall exactly,
but I may also have run out of space and had to delete a lot of files
(basically, I left off the '-H' to rsync, so, when I copied to the
system, it made copies rather than hard links).  This occurred before
the original full copy and hence before the snapshot and deletion.

>    One thing you could do is btrfs dev add a small new device to the
> filesystem (say, a USB stick, or a 4 GiB loopback file mounted over
> NBD or something). Then run the filtered balance. Then btrfs dev del
> the spare device.

Ah, this worked great.  It fixed it in about ten seconds.

I'm curious about the space report; why doesn't Data+System+Metadata
add up to the total space used on the device?  Was the fs stuck in a
state where it couldn't clean up because it couldn't write more
metadata (and hence adding a few gb allowed it to balance)?  After the
balance, the used space dropped to around 150GB, roughly what I'd
expect.

>    The fact that this FS has ended up in this state should be
> considered a bug. It used to be quite common, then josef fixed a load
> of problems, and it's been rare for about a year. Only recently we've
> been seeing more of this kind of problem, and I think there's been a
> bit of a regression somewhere.

Is there any other data I can provide to help fix this?  I can see if
it's reproducible (I'm migrating disks so I can just keep doing it and
see if it happens again).

Chip

-- 
Chip Turner - cturner@pattern.net
