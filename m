Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35741 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdEPEqy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 00:46:54 -0400
Received: by mail-vk0-f65.google.com with SMTP id x71so7577094vkd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 May 2017 21:46:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201705160301.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201705160301.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 16 May 2017 10:16:52 +0530
Message-ID: <CAKuJGC_anMf9-Mb+Rp2670qaPpjYxpt-ANmQZj0Mu9Z2A17Wcg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: tests: remove variable quotation from convert-tests
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oops, sorry, I introduced those two issues in recent patches and
missed (skipped?) them while testing.  With above patch, 008/009
test-cases are working fine now.  thanks.

On 5/16/17, Tsutomu Itoh <t-itoh@jp.fujitsu.com> wrote:
> In btrfs-progs-v4.11-rc1, the following convert-tests failed.
>
>     [TEST/conv]   008-readonly-image
>     [TEST/conv]     readonly image test, btrfs defaults
> failed: mke2fs -t ext4 -b 4096 -F
> /Build/btrfs-progs-v4.11-rc1/tests/test.img
> test failed for case 008-readonly-image
> Makefile:271: recipe for target 'test-convert' failed
> make: *** [test-convert] Error 1
>     [TEST/conv]   009-common-inode-flags
>     [TEST/conv]     common inode flags test, btrfs defaults
> failed: mke2fs -t ext4 -b 4096 -F
> /Build/btrfs-progs-v4.11-rc1/tests/test.img
> test failed for case 009-common-inode-flags
> Makefile:271: recipe for target 'test-convert' failed
> make: *** [test-convert] Error 1
>
> So, remove quotes from $default_mke2fs.
>
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  tests/convert-tests/008-readonly-image/test.sh     | 2 +-
>  tests/convert-tests/009-common-inode-flags/test.sh | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tests/convert-tests/008-readonly-image/test.sh
> b/tests/convert-tests/008-readonly-image/test.sh
> index b2f1ae37..27c9373e 100755
> --- a/tests/convert-tests/008-readonly-image/test.sh
> +++ b/tests/convert-tests/008-readonly-image/test.sh
> @@ -10,7 +10,7 @@ check_prereq btrfs-convert
>
>  default_mke2fs="mke2fs -t ext4 -b 4096"
>  convert_test_preamble '' 'readonly image test' 16k "$default_mke2fs"
> -convert_test_prep_fs "$default_mke2fs"
> +convert_test_prep_fs $default_mke2fs
>  run_check_umount_test_dev
>  convert_test_do_convert
>  run_check_mount_test_dev
> diff --git a/tests/convert-tests/009-common-inode-flags/test.sh
> b/tests/convert-tests/009-common-inode-flags/test.sh
> index a5828790..02823e14 100755
> --- a/tests/convert-tests/009-common-inode-flags/test.sh
> +++ b/tests/convert-tests/009-common-inode-flags/test.sh
> @@ -11,7 +11,7 @@ check_prereq btrfs-convert
>  fail=0
>  default_mke2fs="mke2fs -t ext4 -b 4096"
>  convert_test_preamble '' 'common inode flags test' 16k "$default_mke2fs"
> -convert_test_prep_fs "$default_mke2fs"
> +convert_test_prep_fs $default_mke2fs
>
>  # create file with specific flags
>  run_check $SUDO_HELPER touch "$TEST_MNT/flag_test"
> --
> 2.12.2
>
> ----
> Tsutomu Itoh  t-itoh@jp.fujitsu.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
