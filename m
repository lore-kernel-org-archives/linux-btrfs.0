Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbcG2OrD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 10:47:03 -0400
Date: Fri, 29 Jul 2016 16:46:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Justin Maggard <jmaggard@netgear.com>
Subject: Re: [PATCH] btrfs-progs: fix memory leak with missing device
Message-ID: <20160729144640.GC30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160728174411.4998-1-jmaggard@netgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160728174411.4998-1-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 10:44:11AM -0700, Justin Maggard wrote:
> In read_one_chunk(), we may add an empty entry for a missing device.
> However, this entry wasn't being added to the dev_list, and so it never
> got freed.
> 
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>

Applied (to 4.7), thanks.
