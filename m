Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46002 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbCFGWq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 01:22:46 -0500
Message-ID: <54F9FE3A.4030405@oracle.com>
Date: Fri, 06 Mar 2015 14:21:30 -0500
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
CC: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH] btrfs-progs: use less memory for pretty_size_mode buffers
References: <1425062244-14807-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1425062244-14807-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/27/2015 01:37 PM, David Sterba wrote:
> Anand reports that the static buffers used for pertty size strings cause
> a stack overflow on SPARC. Zach proposed to change the printf format to
> wrap the number and the suffix into a macro. This would require to
> change all callsites of pretty_size* and is not very convienient to
> write.
>
> This patch replaces the per-call-site static buffers with a limited
> number for slots that would be used on each invokation of pretty_size
> and wrap around. The number of array slots shall be 10 for now, in
> current codebase there are no more than 2 calls to pretty_size in a
> single argument list.
>
> Reported-by: Anand Jain <Anand.Jain@oracle.com>
> CC: Zach Brown <zab@zabbo.net>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>
> Anand, please test on a real SPARC machine.


sorry for the delay David. The patch didn't fix.

I am on origin/integration-20150213 + the patch.

-------------------
(gdb) r fi show
Starting program: /root/anand/devel/btrfs fi show
[Thread debugging using libthread_db enabled]

Program received signal SIGSEGV, Segmentation fault.
0x00000800007caf18 in __vsnprintf_chk () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install 
glibc-2.12-1.132.0.8.el6.sparc64 libblkid-2.17.2-12.14.0.2.el6.sparc64 
libuuid-2.17.2-12.14.0.2.el6.sparc64 lzo-2.03-3.1.el6.1.sparc64 
zlib-1.2.3-29.el6.sparc64
(gdb) where
#0  0x00000800007caf18 in __vsnprintf_chk () from /lib64/libc.so.6
#1  0x00000800007cae88 in __snprintf_chk () from /lib64/libc.so.6
#2  0x000000000018609c in snprintf (size=<value optimized out>, 
str=0x801000333e8 <Address 0x801000333e8 out of bounds>,
     str_size=32, unit_mode=<value optimized out>) at 
/usr/include/bits/stdio2.h:65
#3  pretty_size_snprintf (size=<value optimized out>, str=0x801000333e8 
<Address 0x801000333e8 out of bounds>, str_size=32,
     unit_mode=<value optimized out>) at utils.c:1463
#4  0x000000000010e6e8 in print_one_uuid (argc=<value optimized out>, 
argv=<value optimized out>) at cmds-filesystem.c:424
#5  cmd_show (argc=<value optimized out>, argv=<value optimized out>) at 
cmds-filesystem.c:948
#6  0x000000000010990c in handle_command_group (grp=0x2b9d30, argc=1, 
argv=0x7fefffff408) at btrfs.c:143
#7  0x000000000010d150 in cmd_filesystem (argc=2, argv=0x7fefffff400) at 
cmds-filesystem.c:1315
#8  0x0000000000109898 in main (argc=2, argv=0x7fefffff400) at btrfs.c:245
(gdb)
------------------

Thanks, Anand



>   utils.c           | 18 ++++++++++++++++++
>   utils.h           |  8 ++------
>   3 files changed, 21 insertions(+), 6 deletions(-)
>
> --- a/utils.c
> +++ b/utils.c
> @@ -1366,6 +1366,24 @@ out:
>   	return ret;
>   }
>
> +/*
> + * Note: this function uses a static per-thread buffer. Do not call this
> + * function more than 10 times within one argument list!
> + */
> +const char *pretty_size_mode(u64 size, unsigned mode)
> +{
> +	static __thread int ps_index = 0;
> +	static __thread char ps_array[10][32];
> +	char *ret;
> +
> +	ret = ps_array[ps_index];
> +	ps_index++;
> +	ps_index %= 10;
> +	(void)pretty_size_snprintf(size, ret, 32, mode);
> +
> +	return ret;
> +}
> +
>   static const char* unit_suffix_binary[] =
>   	{ "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
>   static const char* unit_suffix_decimal[] =
> diff --git a/utils.h b/utils.h
> index 82ab5e82a3ff..539797c705b4 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -103,12 +103,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>
>   int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, unsigned unit_mode);
>   #define pretty_size(size) 	pretty_size_mode(size, UNITS_DEFAULT)
> -#define pretty_size_mode(size, mode) 					      \
> -	({								      \
> -		static __thread char _str[32];				      \
> -		(void)pretty_size_snprintf((size), _str, sizeof(_str), (mode)); \
> -		_str;							      \
> -	})
> +const char *pretty_size_mode(u64 size, unsigned mode);
>
>   int get_mountpt(char *dev, char *mntpt, size_t size);
>   int btrfs_scan_block_devices(int run_ioctl);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
