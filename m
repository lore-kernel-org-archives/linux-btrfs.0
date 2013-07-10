Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3GJMtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 08:49:18 -0400
Date: Wed, 10 Jul 2013 14:49:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2 1/2] Btrfs-progs: make pretty_sizes() work less error
 prone
Message-ID: <20130710124916.GK18204@suse.cz>
Reply-To: dsterba@suse.cz
References: <1373191092-4316-1-git-send-email-wangshilong1991@gmail.com>
 <20130709202443.GJ18717@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130709202443.GJ18717@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 09, 2013 at 01:24:43PM -0700, Zach Brown wrote:
> > The original codes don't handle error gracefully and some places
> > forget to free memory. We can allocate memory before calling pretty_sizes(),
> > for example, we can use static memory allocation and we don't have to deal
> > with memory allocation fails.
> 
> I agree that callers shouldn't have to know to free allocated memory.
> 
> But I think that we can do better and not have callers need to worry
> about per-call string storage at all.
> 
> How about something like this?

Neat trick! A few neat-picks below. Besides, I guess we can use this
sort of trick with the fi-df patches.

> --- a/utils.c
> +++ b/utils.c
> @@ -1153,12 +1153,13 @@ out:
>  
>  static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
>  			    "PB", "EB", "ZB", "YB"};

I'll drop the ZB, YB suffixes.

> --- a/utils.h
> +++ b/utils.h
> @@ -44,7 +44,15 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  			struct btrfs_fs_devices **fs_devices_mnt);
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>  				 int super_offset);
> -char *pretty_sizes(u64 size);
> +
> +void pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
> +#define pretty_sizes(size) 					\

and rename it to pretty_size as it takes only one number

> +	({							\
> +		static __thread char _str[16];			\

16 is not enough for exabyte scale, that needs at least 20 bytes + 1 for 0.

len(str(2**64)) = 20

-> 24

> +		pretty_size_snprintf(size, _str, sizeof(_str));	\

		pretty_size_snprintf((size), _str, sizeof(_str));	\

As these are only trivial changes I'll fix them at commit time.

> +		_str;						\
> +	})
> +
>  int get_mountpt(char *dev, char *mntpt, size_t size);
>  int btrfs_scan_block_devices(int run_ioctl);
>  u64 parse_size(char *s);
> -- 
> 1.7.11.7
> 
