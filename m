Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:44786 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab2ERHJX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 03:09:23 -0400
Date: Fri, 18 May 2012 09:02:52 +0200
From: Sander <btrfs@humilis.net>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: SSD format/mount parameters questions
Message-ID: <20120518070251.GA32766@panda>
References: <jp32u7$vlc$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <jp32u7$vlc$1@dough.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin wrote (ao):
> Are there any format/mount parameters that should be set for using
> btrfs on SSDs (other than the "ssd" mount option)?

If possible, format the whole device, do not partition the ssd. This
will guarantee proper allignment.

The kernel will detect the ssd, and apply the ssd mount option
automatically.

> I've got a mix of various 120/128GB SSDs to newly set up. I will be
> using ext4 on the critical ones, but also wish to compare with
> btrfs...

I would use btrfs on the critical ones, as btrfs has checksums to detect
datacorruption.

> The mix includes some SSDs with the Sandforce controller that implements
> its own data compression and data deduplication. How well does btrfs fit
> with those compared to other non-data-compression controllers?

Since you have them both, you might want to find out yourself, and let
us know ;-)

FWIW (not much, as you already have them), I would not buy anything else
than intel. I have about 26 of them for years now (both in servers and
workstations, several series), and never had an issue. Two of my
colleagues have OCZ, and both had to RMA them.

	Sander
