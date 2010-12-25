From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] BTRFS: Don't leak memory in btrfs_get_acl()
Date: Sat, 25 Dec 2010 18:42:15 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1012251838330.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net> <20101225150240.GA7938@mako-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101225150240.GA7938@mako-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 25 Dec 2010, Mariusz Kozlowski wrote:

> On Fri, Dec 24, 2010 at 11:45:21PM +0100, Jesper Juhl wrote:
> > Hi,
> > 
> > Currrently we leak memory in btrfs_get_acl::btrfs_get_acl() if 
> > posix_acl_from_xattr() fails. With this patch we do not.
> 
> I sent similar patch some time ago but no reply from Chris so far.
> 
> http://marc.info/?l=linux-kernel&m=129247984126414
> 
I was not aware of that. The patch looks fine (identical to mine), so I 
think Chris should just merge yours.

Feel free to add:

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
