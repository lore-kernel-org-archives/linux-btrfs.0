From: David Sterba <dave@jikos.cz>
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219
 __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
Date: Mon, 14 May 2012 17:05:09 +0200
Message-ID: <20120514150509.GJ25501@twin.jikos.cz>
References: <4FB10636.2010003@arndnet.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FB10636.2010003@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2012 at 03:18:46PM +0200, Arnd Hannemann wrote:
> I just got the following warning on a compressed btrfs filesystem, while writing on it
> until no remaining space was available.
> Looks like a bit verbose "disk full" message, is it expected behavior?

Shouldn't be the case for regular ENOSPC (ie. when the space is reserved
in advance and with the possibility to fail early). If the transaction
is aborted, it means it's too late and there was some logic error.

Can you please describe more the fs and how did you fill it? Like single
process or multiple, dd or whatever.


thanks,
david
