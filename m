Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaL2QHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 11:07:14 -0500
Date: Mon, 29 Dec 2014 17:07:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, takeuchi_satoru@jp.fujitsu.com
Subject: Re: [PATCH v2] btrfs-progs: Documentation: add T/P/E description for
 resize cmd
Message-ID: <20141229160712.GK6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <54978DFE.6010507@jp.fujitsu.com>
 <1419232973-4623-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419232973-4623-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 03:22:53PM +0800, Gui Hecheng wrote:
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
> changelog
> 	v1->v2: s/\'E\'(EiB)/or \'E\'(EiB)/ as suggested by Satoru, thanks.
> ---
>  Documentation/btrfs-filesystem.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> index a8f2972..138ba6c 100644
> --- a/Documentation/btrfs-filesystem.txt
> +++ b/Documentation/btrfs-filesystem.txt
> @@ -102,8 +102,8 @@ If the prefix + or - is present the size is increased or decreased
>  by the quantity <size>.
>  If no units are specified, the unit of the <size> parameter defaults to
>  bytes. Optionally, the size parameter may be suffixed by one of the following
> -units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
> -respectively.
> +units designators: \'K\'(KiB), \'M\'(MiB), \'G\'(GiB), \'T\'(TiB), \'P\'(PiB)
> +or \'E\'(EiB).

I find this a bit confusing as this would suggest that eg.

  $ btrfs fi resize -1GiB

is valid.
