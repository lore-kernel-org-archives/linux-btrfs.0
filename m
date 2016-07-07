Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55485 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbcGGOzU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 10:55:20 -0400
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <87efcca5-6871-2dde-e2df-40602f1a24c2@gmail.com>
From: Francesco Turco <fturco@fastmail.fm>
Message-ID: <eefaeb0f-9eb0-bd2c-3ce5-5eb28bb43c68@fastmail.fm>
Date: Thu, 7 Jul 2016 16:55:18 +0200
MIME-Version: 1.0
In-Reply-To: <87efcca5-6871-2dde-e2df-40602f1a24c2@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 16:27, Austin S. Hemmelgarn wrote:
> This seems odd, are you trying to access anything over NFS or some other
> network filesystem protocol here?  If not, then I believe you've found a
> bug, because I'm pretty certain we shouldn't be returning -ESTALE for
> anything.

No, I don't use NFS or any other network filesystem.

> The question here is: Do you get any data corruption when using ext4?
> Quite often when there's a hardware issue, you won't see _any_
> indication of it other than corrupted files when using something like
> ext4 or XFS, but it will show up almost immediately with BTRFS because
> we validate checksums on almost everything.  There have been at least a
> couple of times I've found disk issues while converting from ext4 to
> BTRFS that I didn't know existed before, and then going back was able to
> reliable reproduce using other tools.
> 
> Also, FWIW, badblocks is not necessarily a reliable test method for
> flash drives, they often handle serialized reads like badblocks does
> very well even when failing.

I'm not sure. Commands don't fail explicitely when I use ext4, but I
agree with you that I may get corruption silently nonetheless. Perhaps I
should try to rule out an hardware problem by filling my USB flash drive
with a large random file and then checking if its SHA-1 checksum
corresponds to the original copy on the hard disk. But first I probably
should backup the current Btrfs filesystem with the dd command. Can I
proceed?

> Just to clarify, you're using BTRFS on top of disk encryption (LUKS? Or
> is it just raw encryption, or even something completely different?), on
> a USB flash drive (not a USB to SATA adapter with an SSD or HDD in it),
> correct?

I'm using a btrfs filesystem on a GUID partition encrypted with LUKS.
It's a Kingston USB flash drive connected directly to my desktop machine
via USB. It's definitively not a SSD or a HDD, and I'm not using any
adapter.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
