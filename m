Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaELQRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 12:17:54 -0400
Date: Mon, 12 May 2014 18:17:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: -musage=>0 means always reporting relocation
Message-ID: <20140512161751.GE6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201405111943.16913.russell@coker.com.au>
 <201405111952.43458.russell@coker.com.au>
 <536F852C.3000100@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536F852C.3000100@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 11, 2014 at 04:11:56PM +0200, Brendan Hide wrote:
> On 2014/05/11 11:52 AM, Russell Coker wrote:
> >On Sun, 11 May 2014, Russell Coker <russell@coker.com.au> wrote:
> >>Below is the output of running a balance a few times on a 120G SSD.
> >Sorry forgot to mention that's kernel 3.14.1 Debian package.
> >
> Please send the output of the two following command:
> btrfs fi df /
> 
> This will give more information on your current chunk situation. I suspect
> this is a case where a system chunk (which is included when specifying
> metadata) that is not actually being relocated. This is a bug that I believe
> was already fixed, though I'm not sure in which version.
> 
> The pathological case is where you have a chunk that is 1% full and *every*
> other in-use chunk on the device is 100% full. In that situation, a balance
> will simply move that data into a new chunk (which will only ever reach 1%
> full). Thus, all subsequent balances will relocate that same data again to
> another new chunk.

You're right about the system chunk, the message says it's blockgroup
type '34', which matches SYSTEM (2) and DUP (32).

Seems that the usage value does not propagate to the system group filter
and just processes all its chunks each time, though all the metadata
chunks are correctly filtered.
