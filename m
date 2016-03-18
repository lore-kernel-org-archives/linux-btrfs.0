Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbcCRQNa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 12:13:30 -0400
Date: Fri, 18 Mar 2016 17:13:02 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: linux-btrfs@vger.kernel.org, lakshmipathi.g@giis.co.in
Subject: Re: [PATCH][btrfs-progs] populate fs with small dataset for
 convert-tests
Message-ID: <20160318161302.GC21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56dee8fb.9712620a.c80b2.ffffbce5@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56dee8fb.9712620a.c80b2.ffffbce5@mx.google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 08, 2016 at 08:30:06PM +0530, Lakshmipathi.G wrote:
> +		perm)
> +			for modes in $(seq 1 7777);do

This generates way too many files, and is the longest part of image
pupulation, given the number of option combinations of ext4 and btrfs,
we need to keep the runtime reasonable.

I don't think we need to iterate over all RWX values, I'll enumerate a
list of common ones for now.

Patch applied.
