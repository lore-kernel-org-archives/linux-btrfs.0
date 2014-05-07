Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17445 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaEGUun (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 16:50:43 -0400
Date: Wed, 7 May 2014 13:50:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [RFC PATCH 0/3] Btrfs: add xxhash algorithm
Message-ID: <20140507205035.GA8921@birch.djwong.org>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
 <20140507110806.GD26824@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140507110806.GD26824@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 01:08:06PM +0200, Tomasz Torcz wrote:
> On Wed, May 07, 2014 at 06:56:29PM +0800, Liu Bo wrote:
> > "xxHash is an extremely fast non-cryptographic Hash algorithm, working at speeds
> > close to RAM limits."[1]  And xxhash is 32-bits hash, same as crc32.
> > 
> > Here is the hash comparsion extracted from the link[1]:
> > (single thread, Windows Seven 32 bits, using Open Source's SMHasher on a Core 2
> > Duo @3GHz)
> > 
> > --------------------------------------------
> > Name            Speed       Q.Score   Author
> > xxHash          5.4 GB/s     10
> > CRC32           0.43 GB/s     9
> > --------------------------------------------
> 
>   Core 2 Duo is awfully old CPU. Since 2008, Intel CPUs have crc32 instruction,
> hugely speeding up CRC operations.

Just for kicks I (sloppily) benchmarked a few of the kernel's hash
implementations on a Core i5-3320M CPU @3.3GHz: 

xxhash: 6.0GB/s
crc32c-intel: 11.5GB/s
crc32c (no hw accel): 1.8GB/s

--D
>  
> 
> -- 
> Tomasz Torcz                 "God, root, what's the difference?"
> xmpp: zdzichubg@chrome.pl         "God is more forgiving."
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
