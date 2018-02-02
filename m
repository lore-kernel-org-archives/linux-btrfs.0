Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753525AbeBBSNV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 13:13:21 -0500
Date: Fri, 2 Feb 2018 19:11:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo.btrfs@gmx.com
Subject: Re: [RFC PATCH v2 3/4] btrfs-progs: Modify rootdir files when use
 mkfs.btrfs
Message-ID: <20180202181107.GB18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
 <1517560445-5712-4-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517560445-5712-4-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 04:34:04PM +0800, Gu Jinxiang wrote:
> Since there is no $TOP/Documentation file after package the testsuite.
> So use a common file that is usually exsits.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  tests/misc-tests/002-uuid-rewrite/test.sh       | 4 ++--
>  tests/misc-tests/003-zero-log/test.sh           | 2 +-
>  tests/mkfs-tests/004-rootdir-keeps-size/test.sh | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/misc-tests/002-uuid-rewrite/test.sh b/tests/misc-tests/002-uuid-rewrite/test.sh
> index 158bda90..27341322 100755
> --- a/tests/misc-tests/002-uuid-rewrite/test.sh
> +++ b/tests/misc-tests/002-uuid-rewrite/test.sh
> @@ -25,7 +25,7 @@ test_uuid_random()
>  
>  	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
>  		--uuid $origuuid \
> -		--rootdir $TOP/Documentation \
> +		--rootdir /lib/modules/`uname -r`/ \

As an easy source of filesystem data it's ok, maybe in the log term
something more deterministic should be implemented. The size of the
modules is unpredictable and may not fit on the filesystem and the test
would fail.

The size of the Documentation/ is 388KiB on my system, the modules are
+260MiB, that also makes the test run longer for no reason.
