Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34881 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbcAXCaF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 21:30:05 -0500
Received: by mail-lb0-f178.google.com with SMTP id bc4so58586763lbc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 18:30:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A230C3.3080100@netcologne.de>
References: <56A230C3.3080100@netcologne.de>
Date: Sun, 24 Jan 2016 03:30:02 +0100
Message-ID: <CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2016 at 2:38 PM, Christian Rohmann
<crohmann@netcologne.de> wrote:
> Hello btrfs-folks,
>
> I am currently doing a big "btrfs balance" to extend a 8 drive RAID6 to
> 12 drives using
>  "btrfs balance start -dstripes 1..11 -mstripes 1..11"

I am not sure why you use/need the stripes filter here; In fact you
want a full balance I think. If you cancel sometime during the ongoing
balance and then later want to continue, it might be needed in order
not to redo the already balanced chunks, maybe that is the case.

> With kernel 4.4 and btrfs progs 4.4 it's running fine for a few days now
> and the new disks are slowing getting more and more extents.
> But somehow the process is VERY slow (3% in 3 days) and there is almost
> no additional disk utilization.
>
> The process doing the balance is doing 100% cpu (one core) so apparently
> the whole thing is very much single threaded and therefore CPU-bound in
> this case.
>
> Is this a known issue or is there anything I can do to speed this up? I
> mean the disks have plenty of iops left to work with and the box has
> many more CPU cores idling away.

I have been using raid5 with kernels 3.11..4.1.6 and several disk
swaps (add command, delete command, dd, but not replace command).

Before raid5 functionally was complete in the kernel, low-level
operations were OK w.r.t speed (like a raid0) as far as I remember.
Later kernels I remember the operations were very slow and very high
cpu load. It has been single core (3.x kernels I believe ), but also
multicore but slow. In fact so slow, that samba gave up and the
filesytem/server was simply unusable for hour/days/weeks.

One reason was I wanted 4x 4TB disk and was halfway (2x 2TB + 2x 4TB)
that upgrade. As balances were crashing and very slow, btrfs was using
4x 2TB for 'normal' raid5 (data0 + data1 +parity), but for the second
half of the 4TB disks just data + parity. The 'normal' raid5 involving
the 2TB disk was very slow, high fragmentation etc.

So my experience is, yes it is or can be slow, very slow. Also scrub
is roughly 10x slower (with 4.3.x kernels at least) than it should be.
A reason is likely that readahead for raid56 is currently not working
(see patches in the list), for some operations, not for all AFAIKU. If
you use iostat you will get an idea of the speed. It might also be
that there are 512 and 4096 sector size effects, but this is just
speculation.

It might be that just a full balance runs faster, so no filters, you
could try that. Otherwise I wouldn't know how to speedup, hopefully
the fs is still usable while balancing.
