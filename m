Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:39196 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752892AbcLMXwx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 18:52:53 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DDE37AC0109
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Dec 2016 08:52:08 +0900 (JST)
Subject: Re: [PATCH 3/3] btrfs-progs: convert-test: trigger chunk allocation
 after convert
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20161213094415.30912-1-quwenruo@cn.fujitsu.com>
 <20161213094415.30912-4-quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <3f0a48ad-9e38-1919-530c-537acf342b5a@jp.fujitsu.com>
Date: Wed, 14 Dec 2016 08:51:56 +0900
MIME-Version: 1.0
In-Reply-To: <20161213094415.30912-4-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/12/13 18:44, Qu Wenruo wrote:
> Populate fs after convert so we can trigger data chunk allocation.
> This can expose too restrict old rollback condition
> 
> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  tests/common         | 4 ++++
>  tests/common.convert | 3 +++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/tests/common b/tests/common
> index 571118a..4a1330f 100644
> --- a/tests/common
> +++ b/tests/common
> @@ -486,6 +486,10 @@ generate_dataset() {
>  				run_check $SUDO_HELPER ln -s "$dirpath/$long_filename" "$dirpath/slow_slink.$num"
>  			done
>  			;;
> +		large)
> +			run_check $SUDO_HELPER dd if=/dev/urandom bs=32M count=1 \
> +			of="$dirpath/$dataset_type" bs=32M >/dev/null 2>&1
> +			;;

Too many bs=.

Thanks,
Tsutomu

>  	esac
>  }
>  
> diff --git a/tests/common.convert b/tests/common.convert
> index a2d3152..8c9242e 100644
> --- a/tests/common.convert
> +++ b/tests/common.convert
> @@ -160,6 +160,9 @@ convert_test_post_checks_all() {
>  	convert_test_post_check_checksums "$1"
>  	convert_test_post_check_permissions "$2"
>  	convert_test_post_check_acl "$3"
> +
> +	# Create a large file to trigger data chunk allocation
> +	generate_dataset "large"
>  	run_check_umount_test_dev
>  }
>  
> 

