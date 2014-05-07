Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:40820 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEGLII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 07:08:08 -0400
Date: Wed, 7 May 2014 13:08:06 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Btrfs: add xxhash algorithm
Message-ID: <20140507110806.GD26824@mother.pipebreaker.pl>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 06:56:29PM +0800, Liu Bo wrote:
> "xxHash is an extremely fast non-cryptographic Hash algorithm, working at speeds
> close to RAM limits."[1]  And xxhash is 32-bits hash, same as crc32.
> 
> Here is the hash comparsion extracted from the link[1]:
> (single thread, Windows Seven 32 bits, using Open Source's SMHasher on a Core 2
> Duo @3GHz)
> 
> --------------------------------------------
> Name            Speed       Q.Score   Author
> xxHash          5.4 GB/s     10
> CRC32           0.43 GB/s     9
> --------------------------------------------

  Core 2 Duo is awfully old CPU. Since 2008, Intel CPUs have crc32 instruction,
hugely speeding up CRC operations.
 

-- 
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

