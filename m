Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58334 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab3BLSN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 13:13:29 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so190715eek.14
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:13:28 -0800 (PST)
Message-ID: <511A8680.7000400@gmail.com>
Date: Tue, 12 Feb 2013 19:14:24 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
In-Reply-To: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/2013 02:25 AM, Tsutomu Itoh wrote:
> Currently, the following commands succeed.
> 
>  # cat /proc/swaps
>  Filename                                Type            Size    Used    Priority
>  /dev/sda3                               partition       8388604 0       -1
>  /dev/sdc8                               partition       9765884 0       -2
>  # mkfs.btrfs /dev/sdc8
>  
>  WARNING! - Btrfs v0.20-rc1-165-g82ac345 IS EXPERIMENTAL
>  WARNING! - see http://btrfs.wiki.kernel.org before using
>  
>  fs created label (null) on /dev/sdc8
>          nodesize 4096 leafsize 4096 sectorsize 4096 size 9.31GB
>  Btrfs v0.20-rc1-165-g82ac345
>  # btrfs fi sh /dev/sdc8
>  Label: none  uuid: fc0bdbd0-7eed-460f-b4e9-131273b66df2
>          Total devices 1 FS bytes used 28.00KB
>          devid    1 size 9.31GB used 989.62MB path /dev/sdc8
>  
>  Btrfs v0.20-rc1-165-g82ac345
>  #
> 
> But we should check out the swap device. So fixed it.



> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
> (this patch is based on Chris's raid56-experimental branch)
> ---
>  mkfs.c  | 18 ++++++++++++++++++
>  utils.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  utils.h |  1 +
>  3 files changed, 68 insertions(+)
> 
> diff --git a/mkfs.c b/mkfs.c
> index 2d3c2af..fdc3373 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1366,6 +1366,15 @@ int main(int ac, char **av)
>  
>  	if (source_dir == 0) {
>  		file = av[optind++];
> +		ret = is_swap_device(file);
> +		if (ret < 0) {
> +			fprintf(stderr, "error checking %s status\n", file);
> +			exit(1);
> +		}

The fact that it is not possible to perform a check shouldn't prohibit
to run a mkfs.btrfs.

It is possible to add a switch to bypass this kind of checks ? We should
allow the user to be not limited by the fact that the check fails. I am
thinking to a "rescue" scenario like boot in a single mode where not al
filesystem are mounted.

I am referring to all the "safety" check not this one only.

BR
G.Baroncelli

[...]
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
