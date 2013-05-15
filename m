Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3EONMZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 09:12:25 -0400
Date: Wed, 15 May 2013 15:12:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Btrfs: introduce a tree for UUID to subvol ID
 mapping
Message-ID: <20130515131223.GX16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
 <20130514105523.GD15127@liubo.jp.oracle.com>
 <5192705A.6030708@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5192705A.6030708@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 14, 2013 at 07:11:54PM +0200, Stefan Behrens wrote:
> # of subvols  | without    | with
> in filesystem | UUID tree  | UUID tree
> --------------+------------+----------
>             2 |  0m00.004s | 0m00.003s
>          1000 |  0m07.010s | 0m00.004s
>          2000 |  0m28.210s | 0m00.004s
>          3000 |  1m04.872s | 0m00.004s
>          4000 |  1m56.059s | 0m00.004s
>          5000 |  3m00.489s | 0m00.004s
>          6000 |  4m27.376s | 0m00.004s
>          7000 |  6m08.938s | 0m00.004s
>          8000 |  7m54.020s | 0m00.004s
>          9000 | 10m05.108s | 0m00.004s
>         10000 | 12m47.406s | 0m00.004s

It looks like a copy paste error in the 3rd column. No really, this
is a great improvement!

david
