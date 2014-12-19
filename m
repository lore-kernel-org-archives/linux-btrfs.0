Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaLSQtg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:49:36 -0500
Message-ID: <5494571B.70909@redhat.com>
Date: Fri, 19 Dec 2014 10:49:31 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs-progs: corrupt block, add break after option
 U
References: <cover.1419005022.git.dsterba@suse.cz> <e302cda244a100f60584530f2e7cceff408153bc.1419005022.git.dsterba@suse.cz>
In-Reply-To: <e302cda244a100f60584530f2e7cceff408153bc.1419005022.git.dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/14 10:06 AM, David Sterba wrote:
> Resolves-Coverity-CID: 1258793
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  btrfs-corrupt-block.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
> index aeeb1b298f66..b477e878376b 100644
> --- a/btrfs-corrupt-block.c
> +++ b/btrfs-corrupt-block.c
> @@ -1068,6 +1068,7 @@ int main(int ac, char **av)
>  				break;
>  			case 'U':
>  				chunk_tree = 1;
> +				break;
>  			case 'i':
>  				inode = arg_strtou64(optarg);
>  				break;
> 

