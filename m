From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0
 [btrfs]()
Date: Mon, 14 May 2012 18:16:33 +0200
Message-ID: <4FB12FE1.2070909@arndnet.de>
References: <4FB10636.2010003@arndnet.de> <20120514150509.GJ25501@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120514150509.GJ25501@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hello David,

Am 14.05.2012 17:05, schrieb David Sterba:
> On Mon, May 14, 2012 at 03:18:46PM +0200, Arnd Hannemann wrote:
>> I just got the following warning on a compressed btrfs filesystem, while writing on it
>> until no remaining space was available.
>> Looks like a bit verbose "disk full" message, is it expected behavior?
> 
> Shouldn't be the case for regular ENOSPC (ie. when the space is reserved
> in advance and with the possibility to fail early). If the transaction
> is aborted, it means it's too late and there was some logic error.
> 
> Can you please describe more the fs and how did you fill it? Like single
> process or multiple, dd or whatever.

the particular filesystem is used for chroots (/opt/chroots). It got full while
installing texlive-extra on a debian squeeze (i386) chroot.
It was probably a single process, but it involed a lot of small files.

Best regards
Arnd
