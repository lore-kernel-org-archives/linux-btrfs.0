Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964850AbbI2MBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 08:01:30 -0400
Date: Tue, 29 Sep 2015 14:00:29 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Add stripes filter
Message-ID: <20150929120029.GX11442@twin.jikos.cz>
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

What usecase do you want to address? As I understand it, this would help
the raid56 rebalancing to process only blockgroups that are not spread
accross enough devices.
