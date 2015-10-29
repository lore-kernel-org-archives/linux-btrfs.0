Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbJ2NKA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 09:10:00 -0400
Date: Thu, 29 Oct 2015 14:08:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs-progs: free fslabel for btrfs-convert
Message-ID: <20151029130834.GV13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
 <923885cdd32d06b2bf4446b32b91917618f3be78.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <923885cdd32d06b2bf4446b32b91917618f3be78.1446111097.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2015 at 05:31:45PM +0800, Zhao Lei wrote:
> fslabel need to be freed before exit.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  btrfs-convert.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index 5b9171e..1693d03 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -3027,6 +3027,9 @@ int main(int argc, char *argv[])
>  		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
>  				copylabel, fslabel, progress, features);
>  	}
> +
> +	free(fslabel);

fslabel is on stack:

btrfs-convert.c: In function 'main':
btrfs-convert.c:3031:6: warning: attempt to free a non-heap object 'fslabel' [-Wfree-nonheap-object]
