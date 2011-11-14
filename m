From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: compressed btrfs "No space left on device"
Date: Mon, 14 Nov 2011 19:24:27 +0100
Message-ID: <4EC15CDB.90103@arndnet.de>
References: <4EC12C5A.2070304@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC12C5A.2070304@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am 14.11.2011 15:57, schrieb Arnd Hannemann:

> I'm using btrfs for my /usr/share/ partition and keep getting the following error
> while installing a debian package which should take no more than 228 MB:
> 
> Unpacking texlive-fonts-extra (from .../texlive-fonts-extra_2009-10ubuntu1_all.deb) ...
>  dpkg: error processing /var/cache/apt/archives/texlive-fonts-extra_2009-10ubuntu1_all.deb (--unpack):
>  unable to install new version of `/usr/share/texmf-texlive/fonts/type1/public/allrunes/frutlt.pfb': No space left on device
> 
> 
> However df reports plenty of available space:
> 
> /dev/mapper/vg0-usr_share
>                       5.0G  1.5G  2.5G  37% /usr/share
> 
> 
> I already extended /dev/mapper/vg0-usr_share from 4G to 5G and ran defrag and balance on it with no luck.
> I'm using ubuntu 11.10 on amd64 with the ubuntu 3.0.0 kernel.

FYI: The problem is the same with mainline kernel v3.1.1.

Best regards
Arnd
