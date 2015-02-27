Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbbB0Rxs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 12:53:48 -0500
Date: Fri, 27 Feb 2015 18:53:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: Anand Jain <Anand.Jain@oracle.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, wangshilong1991@gmail.com
Subject: Re: [PATCH] btrfs-progs: per-thread, per-call pretty buffer
Message-ID: <20150227175346.GJ8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130709202443.GJ18717@lenny.home.zabbo.net>
 <1373466615-30013-1-git-send-email-dsterba@suse.cz>
 <5408504C.1050203@oracle.com>
 <20140904194545.GI15881@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140904194545.GI15881@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 04, 2014 at 12:45:45PM -0700, Zach Brown wrote:
> --- a/utils.h
> +++ b/utils.h
> @@ -71,13 +71,17 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>  				 int super_offset);
>  
> -int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
> -#define pretty_size(size) 						\
> -	({								\
> -		static __thread char _str[24];				\
> -		(void)pretty_size_snprintf((size), _str, sizeof(_str));	\
> -		_str;							\
> -	})
> +/*
> + * It's annoying that gcc hasn't yet figured out how to learn about
> + * formats added by register_printf_specifier().  If that were the case
> + * we could just add some %P type and be done with it.  Some day..
> + *
> + *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=47781
> + */
> +float pretty_float(u64 size);
> +char *pretty_suffix(u64 size);
> +#define PF "%.2f%s"
> +#define PA(x) pretty_float(x), pretty_suffix(x)

So I've crawled back to that patch and I'm not all happy to update every
use of pretty_size and the printf string. The user-defined printf format
handlers are not an option.

My proposal that would avoid that:

- predefine a static array of N strings where the pretty numbers would
  fit, eg 32 bytes as is now
- pretty_size will:
  - grab the first unused slot
  - fill it with the string
  - increase index to the array
  - wrap at N
  - return pointer to the prev entry

Normally we're using at most 2 pretty_size calls per printf, so if we
make eg. N = 10, we're relatively safe.

We can keep the easy %s + pretty_size, I really find it convenient to
write it that way.
