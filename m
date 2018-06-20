Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47669 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbeFTFWl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 01:22:41 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA9E9AED2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 05:22:39 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs-progs: misc-tests: Fix 029 test cases for sudo
 test environment
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180620003839.10629-1-wqu@suse.com>
 <20180620003839.10629-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <72e9636d-d48b-d408-c20d-0e4be345f6f8@suse.com>
Date: Wed, 20 Jun 2018 08:22:38 +0300
MIME-Version: 1.0
In-Reply-To: <20180620003839.10629-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.06.2018 03:38, Qu Wenruo wrote:
> Test misc/029 only works if the test case is executed as root, while for
> sudo usage, it doesn't work as initial mkdir and final cleanup doesn't
> use $SUDO_HELPER.
> 
> Add "run_check $SUDO_HELPER" for such cases to allow it works under sudo
> usage.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Although this seems unrelated to the first patch. I'd advise in this
case to send them as separate patches or if you are going to batch up
multiple fixes add a cover letter saying "just a bunch of random fixes
to xxx" :)

> ---
>  tests/misc-tests/029-send-p-different-mountpoints/test.sh | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/misc-tests/029-send-p-different-mountpoints/test.sh b/tests/misc-tests/029-send-p-different-mountpoints/test.sh
> index 0b42b772e3d7..90465e1d08fd 100755
> --- a/tests/misc-tests/029-send-p-different-mountpoints/test.sh
> +++ b/tests/misc-tests/029-send-p-different-mountpoints/test.sh
> @@ -14,7 +14,7 @@ prepare_test_dev
>  SUBVOL_MNT="$TEST_MNT/subvol"
>  TOPLEVEL_MNT="$TEST_MNT/toplevel"
>  TEST_MNT="$TOPLEVEL_MNT"
> -mkdir -p "$TOPLEVEL_MNT" "$SUBVOL_MNT"
> +run_check $SUDO_HELPER mkdir -p "$TOPLEVEL_MNT" "$SUBVOL_MNT"
>  
>  run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
>  run_check_mount_test_dev
> @@ -47,5 +47,5 @@ run_mustfail_stdout "send -p on 2 mount points" \
>  run_check_umount_test_dev "$SUBVOL_MNT"
>  run_check_umount_test_dev "$TOPLEVEL_MNT"
>  
> -rmdir "$SUBVOL_MNT"
> -rmdir "$TOPLEVEL_MNT"
> +run_check $SUDO_HELPER rmdir "$SUBVOL_MNT"
> +run_check $SUDO_HELPER rmdir "$TOPLEVEL_MNT"
> 
