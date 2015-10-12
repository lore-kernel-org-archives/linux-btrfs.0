Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbbJLOLP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 10:11:15 -0400
Date: Mon, 12 Oct 2015 16:10:05 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Add stripes filter
Message-ID: <20151012141005.GG27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1443463025.16163.6.camel@system.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1443463025.16163.6.camel@system.is>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2015 at 05:57:05PM +0000, Gabríel Arthúr Pétursson wrote:
> The attached patches to linux and btrfs-progs add support for filtering
> based on the number of strips in a block when balancing.

FYI, I'm going to make the fixups myself as they're mostly cosmetic and
prepare this patch for 4.4 merge window, together with the extension to
the 'limit' filter I mentioned.
