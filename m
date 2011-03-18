From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: properly access unaligned checksum buffer
Date: Fri, 18 Mar 2011 11:56:53 -0400
Message-ID: <1300463770-sup-1372@think>
References: <1300462105-30680-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"adrien.dessemond" <adrien.dessemond@gmail.com>
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1300462105-30680-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-03-18 11:28:25 -0400:
> fixes https://bugzilla.kernel.org/show_bug.cgi?id=29142
> reported on SPARC64, warnings like:
> 
> [ 1523.941667] Kernel unaligned access at TPC[100e4034]
> btrfs_csum_final+0x38/0x3c [btrfs]
> 
> Reported-by: Adrien Dessemond <adrien.dessemond@gmail.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> Tested-by: Adrien Dessemond <adrien.dessemond@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e1aa8d6..8065863 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -198,7 +198,11 @@ u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
>  
>  void btrfs_csum_final(u32 crc, char *result)
>  {
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>      *(__le32 *)result = ~cpu_to_le32(crc);
> +#else
> +    put_unaligned_le32(~crc, result);
> +#endif
>  }

Thanks for fielding this one.  Does put_unaligned_le32 optimize away on
platforms with efficient access?  It would be great if we didn't need
the #ifdef.

-chris


