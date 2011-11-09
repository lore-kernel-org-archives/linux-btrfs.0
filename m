From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] Btrfs: runtime integrity check tool
Date: Wed, 9 Nov 2011 12:50:10 -0500
Message-ID: <20111109175010.GQ9368@shiny>
References: <cover.1320849129.git.sbehrens@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1320849129.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2011 at 04:17:57PM +0100, Stefan Behrens wrote:
> This patch series adds a new module to the btrfs kernel mode
> code. This new module can be used to catch cases when the
> btrfs kernel code executes write requests to the disk that
> bring the file system in an inconsistent state. In such a
> state, a power-loss or kernel panic event would cause that
> the data on disk is lost or at least damaged.
> 
> Code is added that examines all block write requests during
> runtime (including writes of the super block). Three rules
> are verified and an error is printed on violation of the
> rules:

This patch is clearly useful because it has already found two big bugs.

I'll definitely review it in detail and somehow or another I'd love to
include this functionality in 3.3.

Thanks again!

-chris
