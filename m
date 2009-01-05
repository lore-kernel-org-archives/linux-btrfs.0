From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix build errors of extent_io.c
Date: Mon, 05 Jan 2009 10:47:39 -0500
Message-ID: <1231170459.4290.90.camel@think.oraclecorp.com>
References: <20081224.175640.119553873.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081224.175640.119553873.ryusuke@osrg.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-24 at 17:56 +0900, Ryusuke Konishi wrote:
> Hi Chris,
> 
> I've started to read and try btrfs, and soon met the following build
> errors.  The attached patch fixes the problem.
> 
> Could you check this?
> 

Strange, I wonder why your gcc complains and mine doesn't ;)  I'll fix
these up thouhg.

-chris


