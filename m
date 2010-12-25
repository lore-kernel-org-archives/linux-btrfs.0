From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: Re: [PATCH] BTRFS: Don't leak memory in btrfs_get_acl()
Date: Sat, 25 Dec 2010 16:02:40 +0100
Message-ID: <20101225150240.GA7938@mako-laptop>
References: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 24, 2010 at 11:45:21PM +0100, Jesper Juhl wrote:
> Hi,
> 
> Currrently we leak memory in btrfs_get_acl::btrfs_get_acl() if 
> posix_acl_from_xattr() fails. With this patch we do not.

I sent similar patch some time ago but no reply from Chris so far.

http://marc.info/?l=linux-kernel&m=129247984126414

-- 
Mariusz Kozlowski
