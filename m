Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36395 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbcEPXpG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 19:45:06 -0400
Received: by mail-pf0-f170.google.com with SMTP id c189so74778756pfb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 16:45:06 -0700 (PDT)
Message-ID: <1463442292.3278.61.camel@clone1.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: "Richard A. Lochner" <lochner@clone1.com>
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 16 May 2016 18:44:52 -0500
In-Reply-To: <CAJCQCtSmmm-2aCUQvG4QNYvLHCo0LPcYKbSkmcxE1m5JqTL9zQ@mail.gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
	 <1463075341.3636.56.camel@clone1.com>
	 <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
	 <1463114957.3636.140.camel@clone1.com>
	 <CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
	 <1463337834.4626.14.camel@clone1.com>
	 <CAJCQCtSYgfhmNYFE4ffxFy20B=trkh+P=hhdbrq71ysZSm_FEA@mail.gmail.com>
	 <41b097af-d565-6cd7-2ed8-cb66b9ae8ecc@gmail.com>
	 <CAJCQCtSmmm-2aCUQvG4QNYvLHCo0LPcYKbSkmcxE1m5JqTL9zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

It has actually happened to me three times that I know of in ~7mos.,
but your point about the "larger footprint" for data corruption is a
good one.  No doubt I have silently experienced that too.  And, as you
suggest, there is no way to prevent those errors.  If the memory to be
written to disk gets corrupted before its checksum is calculated, the
data will be silently corrupted, period.

Clearly, I won't rely on this machine to produce any data directly that
I would consider important at this point.

One odd thing to me is that if this is really due to undetected memory
errors, I'd think this system would crash fairly often due to detected
"parity errors."  This system rarely crashes.  It often runs for
several months without an indication of problems.  

Rick Lochner


On Mon, 2016-05-16 at 16:43 -0600, Chris Murphy wrote:
> On Mon, May 16, 2016 at 5:33 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
> > 
> > 
> > I would think this would be perfectly possible if some other file
> > that had a
> > checksum in that node changed, thus forcing the node's checksum to
> > be
> > updated.  Theoretical sequence of events:
> > 1. Some file which has a checksum in node A gets written to.
> > 2. Node A is loaded into memory to update the checksum.
> > 3. The new checksum for the changed extent in the file gets updated
> > in the
> > in-memory copy of node A.
> > 4. Node A has it's own checksum recomputed based on the new data,
> > and then
> > gets saved to disk.
> > If something happened after 2 but before 4 that caused one of the
> > other
> > checksums to go bad, then the checksum computed in 4 will have been
> > with the
> > corrupted data.
> > 
> I'm pretty sure Qu had a suggestion that would mitigate this sort of
> problem, where there'd be a CRC32C checksum for each data extent (?)
> something like that anyway. There's enough room to stuff in more than
> just a checksum per 4096 byte block. That way there's three checks,
> and thus there's a way to break a tie.
> 
> But this has now happened to Richard twice. What are the chances of
> this manifesting exactly the same way a second time? If the chance of
> corruption is equal, I'd think the much much larger footprint for
> in-memory corruption is data itself. Problem is, if the corruption
> happens before the checksum is computed, the checksum would say the
> data is valid. So the only way to test this would be passing all file
> from this volume and a reference volume through a hash function and
> comparing hashes, e.g. rsync -c option.
> 
