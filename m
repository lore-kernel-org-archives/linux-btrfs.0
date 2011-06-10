From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Fri, 10 Jun 2011 14:55:51 -0400
Message-ID: <BANLkTinUDt4vCBF=z=2+3cdY7FS6evBPCQ@mail.gmail.com>
References: <201106061220.05696.markotahal@gmail.com> <BANLkTi=-xRoNBQHT+qS9eA_vHQnYOBGGjQ@mail.gmail.com>
 <4DF21D20.8010304@redhat.com> <201106102043.19025.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Marek Otahal <markotahal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106102043.19025.markotahal@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2011 at 2:43 PM, Marek Otahal <markotahal@gmail.com> wrote:
>
> The test-case is quite easy,
> 1. mount the FS, just with compress-force=lzo option // I didn't try without, but on my other btrfs partition that doesn't use compression the err never happened ...so, can the others who experience the bug confirm compress=lzo used?

Yes, I use compress=lzo.

--Andy
