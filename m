Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33757 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbcEQDm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 23:42:58 -0400
Received: by mail-oi0-f68.google.com with SMTP id t140so804303oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 20:42:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463442292.3278.61.camel@clone1.com>
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
	<1463442292.3278.61.camel@clone1.com>
Date: Mon, 16 May 2016 21:42:57 -0600
Message-ID: <CAJCQCtQE4apgSw+5mX+4h050opH1Jw3MYXk5jUfab1DzS1f-+Q@mail.gmail.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: Chris Murphy <lists@colorremedies.com>
To: "Richard A. Lochner" <lochner@clone1.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 16, 2016 at 5:44 PM, Richard A. Lochner <lochner@clone1.com> wrote:
> Chris,
>
> It has actually happened to me three times that I know of in ~7mos.,
> but your point about the "larger footprint" for data corruption is a
> good one.  No doubt I have silently experienced that too.

I dunno three is a lot to have the exact same corruption only in
memory then written out into two copies with valid node checksums; and
yet not have other problems, like a node item, or uuid, or xattr or
any number of other item or object types all of which get checksummed.
I suppose if the file system contains large files, the % of metadata
that's csums could be the 2nd largest footprint. But still.

Three times in 7 months, if it's really the same vector, is just short
of almost reproducible. Ha. It seems like if you merely balanced this
file system a few times, you'd eventually stumble on this. And if
that's true, then it's time for debug options and see if it can be
caught in action, and whether there's a hardware or software
explanation for it.


> And, as you
> suggest, there is no way to prevent those errors.  If the memory to be
> written to disk gets corrupted before its checksum is calculated, the
> data will be silently corrupted, period.

Well, no way in the present design, maybe.



>
> Clearly, I won't rely on this machine to produce any data directly that
> I would consider important at this point.
>
> One odd thing to me is that if this is really due to undetected memory
> errors, I'd think this system would crash fairly often due to detected
> "parity errors."  This system rarely crashes.  It often runs for
> several months without an indication of problems.

I think you'd have other problems. Only data csums are being corrupt
after they're read in, but before the node csum is computed? Three
times?  Pretty wonky.




-- 
Chris Murphy
