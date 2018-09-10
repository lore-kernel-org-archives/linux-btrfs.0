Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59224 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726657AbeIJWwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:52:54 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A08D4ADC5
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:57:37 +0000 (UTC)
Date: Mon, 10 Sep 2018 19:57:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: Add test for missing device delete
 error value
Message-ID: <20180910175720.GV24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180903094614.2667-1-nborisov@suse.com>
 <20180903100257.5789-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180903100257.5789-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 01:02:57PM +0300, Nikolay Borisov wrote:
> Add a test which ensures the kernel returns the correct error value
> when missing device removal is requested. This test verifies that kernel
> refactoring didn't broken the return value.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  tests/misc-tests/011-delete-missing-device/test.sh | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
> index 4c976421c091..b799a25c201d 100755
> --- a/tests/misc-tests/011-delete-missing-device/test.sh
> +++ b/tests/misc-tests/011-delete-missing-device/test.sh
> @@ -44,6 +44,21 @@ test_delete_missing()
>  	run_check_umount_test_dev
>  }
>  
> +test_missing_error()
> +{
> +	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
> +	run_check_mount_test_dev
> +	local out
> +	out=$(run_mustfail_stdout "Unexpected success" \

Which would become:

  unexpected success: Unexpected success

You'd win the error message of the year :) The text is supposed to be
more specific what was not expected, eg. "missing device removed".
