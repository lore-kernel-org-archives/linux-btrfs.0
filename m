From: Rieder Michael <mr@student.ethz.ch>
Subject: Re: TRIM discard testing
Date: Thu, 10 Nov 2011 22:11:58 +0000 (UTC)
Message-ID: <loom.20111110T230153-346@post.gmane.org>
References: <1EFA45DCD932BC42AB701E5073CC52D41CE5F1@MBX12.d.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Rieder  Michael <mr <at> student.ethz.ch> writes:

> hdparm -I says the drive supports TRIM and does "Deterministic read after
TRIM" which I interpret to mean
> that if the data was really discarded, the drive should return zeros (or
something else) but not the
> previous data.
> 

OK I found out what's wrong. There's a difference between
"Deterministic read data after TRIM" (word 69 bit 14)
and "Deterministic read ZEROs after TRIM" (bit 5).
My drive (OCZ Agility 3) uses only deterministic read, but
that only means a trimmed block always returns the same
result until the next write command.

So the testing procedure described on many Linux resources
on the web is not valid for all SSD drives actually...

