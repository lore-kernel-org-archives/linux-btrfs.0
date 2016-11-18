Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40873 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752057AbcKRSRs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 13:17:48 -0500
Date: Fri, 18 Nov 2016 19:17:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: test: fix convert-tests 004 failure
Message-ID: <20161118181744.GD12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611180549.AA00019@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201611180549.AA00019@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2016 at 02:49:51PM +0900, Tsutomu Itoh wrote:
> convert-tests 004 failed because the argument to check_all_images
> is not specified.
> 
> # make test-convert
>     [TEST]   convert-tests.sh
>     [TEST/conv]   004-ext2-backup-superblock-ranges
> find: '': No such file or directory
> #
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
> index c56650b..d764ed8 100755
> --- a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
> +++ b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
> @@ -39,4 +39,4 @@ function check_image() {
>  	rm -f $TEST_DEV
>  }
>  
> -check_all_images
> +check_all_images `pwd`

I'll add a fallback to use the current directory instead of forcing all
callsites to supply it.
