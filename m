Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933879AbdDGRUA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 13:20:00 -0400
Date: Fri, 7 Apr 2017 19:19:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] tests: use receive -e to terminate on end marker
Message-ID: <20170407171958.GW4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170403202108.14859-1-christian.brauner@ubuntu.com>
 <20170403202108.14859-3-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170403202108.14859-3-christian.brauner@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 10:21:08PM +0200, Christian Brauner wrote:
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  tests/misc-tests/018-recv-end-of-stream/test.sh | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/misc-tests/018-recv-end-of-stream/test.sh b/tests/misc-tests/018-recv-end-of-stream/test.sh
> index d39683e9..90655929 100755
> --- a/tests/misc-tests/018-recv-end-of-stream/test.sh
> +++ b/tests/misc-tests/018-recv-end-of-stream/test.sh
> @@ -34,7 +34,7 @@ test_full_empty_stream() {
>  
>  	run_check $TOP/mkfs.btrfs -f $TEST_DEV
>  	run_check_mount_test_dev
> -	run_check $SUDO_HELPER $TOP/btrfs receive -v -f "$str" "$TEST_MNT"
> +	run_check $SUDO_HELPER $TOP/btrfs receive -e -v -f "$str" "$TEST_MNT"

You're changing an existing test, what I expect is a new testcase as the
existing tests cover existing usecases and must not break. However I
don't see now how to fix it, will look into it again next week.
