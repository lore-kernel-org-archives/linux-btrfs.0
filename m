Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61191 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbcKRGgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 01:36:42 -0500
Subject: Re: [PATCH 2/3] btrfs-progs: test: expand size of test device of
 fsck-tests 013
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <965496ad-0b2c-31af-2de5-e47bd3c7d586@gmx.com>
Date: Fri, 18 Nov 2016 14:36:28 +0800
MIME-Version: 1.0
In-Reply-To: <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/18/2016 01:47 PM, Tsutomu Itoh wrote:
> In my test environment, size of /lib/modules/`uname -r`/* is
> larger than 1GB, so test data can not copy to testdev.
> Therefore we need expand the size of testdev.

IMHO the correct fix is to enhance populate_fs() to fill the fs into a 
given size, other than using the unreliable copy.

Thanks,
Qu

>
> # make test-fsck
>     [TEST]   fsck-tests.sh
>     [TEST/fsck]   013-extent-tree-rebuild
> failed: cp -aR /lib/modules/4.9.0-rc5/ /test/btrfs-progs/tests/mnt
> test failed for case 013-extent-tree-rebuild
> Makefile:272: recipe for target 'test-fsck' failed
> make: *** [test-fsck] Error 1
> #
>
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  tests/fsck-tests/013-extent-tree-rebuild/test.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
> index f678e29..92c5d04 100755
> --- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
> +++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
> @@ -7,7 +7,7 @@ check_prereq mkfs.btrfs
>  check_prereq btrfs
>
>  setup_root_helper
> -prepare_test_dev 1G
> +prepare_test_dev 2G
>
>  # test whether fsck can rebuild a corrupted extent tree
>  test_extent_tree_rebuild()
>
