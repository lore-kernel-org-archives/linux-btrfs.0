Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbeDKNjW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 09:39:22 -0400
Date: Wed, 11 Apr 2018 15:36:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs.static: needs libbtrfsutil
Message-ID: <20180411133651.GC21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5023fdf9a4524106ef6fe1d0fdd75ade16dec62c.1523390621.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5023fdf9a4524106ef6fe1d0fdd75ade16dec62c.1523390621.git.baruch@tkos.co.il>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2018 at 11:03:41PM +0300, Baruch Siach wrote:
> Add libbtrfsutil objects to btrfs.static link command. This fixes static
> build failure:
> 
> utils.static.o: In function `parse_qgroupid':
> utils.c:(.text.parse_qgroupid+0xb0): undefined reference to `btrfs_util_is_subvolume'
> props.static.o: In function `prop_read_only':
> props.c:(.text.prop_read_only+0x70): undefined reference to `btrfs_util_set_subvolume_read_only'
> ...
> Makefile:457: recipe for target 'btrfs.static' failed
> make[1]: *** [btrfs.static] Error 1
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Thanks, I found that myself, unfortunatelly after the 4.16 release was
out.

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 5ba76d2eee40..9b97c36a44a5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -453,7 +453,7 @@ btrfs: btrfs.o $(objects) $(cmds_objects) $(libs_static)
>  	@echo "    [LD]     $@"
>  	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
>  
> -btrfs.static: btrfs.static.o $(static_objects) $(static_cmds_objects) $(static_libbtrfs_objects)
> +btrfs.static: btrfs.static.o $(static_objects) $(static_cmds_objects) $(static_libbtrfs_objects) $(libbtrfsutil_objects)

I've added variable static_libbtrfsutil_objects so it follows the same
shceme as static_libbtrfs_objects.

>  	@echo "    [LD]     $@"
>  	$(Q)$(CC) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
>  
> -- 
> 2.16.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
