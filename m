Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932130AbdIFRZp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 13:25:45 -0400
Date: Wed, 6 Sep 2017 19:24:16 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: test: add new test for inspect-internal
 rootid
Message-ID: <20170906172416.GZ31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f7b5fe23-1339-aa57-a60d-c878d151bff3@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f7b5fe23-1339-aa57-a60d-c878d151bff3@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 05, 2017 at 02:53:15PM +0900, Misono, Tomohiro wrote:
> This new test checks inspect-internal rootid
>  - handle path to subvolume/directory/file as an argument
>  - get different id for each subvolume
>  - get the expected id for each file/directory
>   (i.e. the same as containing subvolume)
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  .../cli-tests/007-inspect-internal-rootid/test.sh  | 50 ++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100755 tests/cli-tests/007-inspect-internal-rootid/test.sh
> 
> diff --git a/tests/cli-tests/007-inspect-internal-rootid/test.sh b/tests/cli-tests/007-inspect-internal-rootid/test.sh
> new file mode 100755
> index 0000000..a7105c7
> --- /dev/null
> +++ b/tests/cli-tests/007-inspect-internal-rootid/test.sh
> @@ -0,0 +1,50 @@
> +#!/bin/bash
> +#
> +# test commands of inspect-internal rootid
> +
> +source "$TOP/tests/common"
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +prepare_test_dev 2g
> +
> +run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
> +run_check_mount_test_dev
> +run_check $SUDO_HELPER chmod a+rw $TEST_MNT
> +cd $TEST_MNT
> +
> +run_check "$TOP/btrfs" subvolume create sub
> +run_check "$TOP/btrfs" subvolume create sub/subsub
> +run_check mkdir dir
> +run_check touch file1
> +run_check touch dir/file2
> +run_check touch sub/file3
> +
> +id1=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid .)          || exit
> +id2=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub)        || exit
> +id3=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/subsub) || exit
> +id4=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir)        || exit
> +id5=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid file1)      || exit
> +id6=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir/file2)  || exit
> +id7=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/file3)  || exit

If the rootid command fails for some reason, the test will appear to
succed right? So, it could be 'exit' and not _fail, as the command is
supposed to pass, but at least the exit code 1 should be there, so the
test wrapper will catch that and the exact error message will appear in
the log.

The test coverage is good and IMO it tests the functionality (not the
command line interface), so it belongs to the misc-tests.

Please add the remaining shell quotes around variables that are not
obviously safe, ie the TEST_MNT/TOP etc.

> +
> +if ! ([ $id1 -ne $id2 ] && [ $id1 -ne $id3 ] && [ $id2 -ne $id3 ]); then
> +	_fail "inspect-internal rootid: each subvolume must have different id"
> +fi
> +
> +if ! ([ $id1 -eq $id4 ] && [ $id1 -eq $id5 ] && [ $id1 -eq $id6 ]); then
> +	_fail "inspect-internal rootid: rootid mismatch found"
> +fi
> +
> +if ! ([ $id2 -eq $id7 ]); then
> +	_fail "inspect-internal rootid: rootid mismatch found"
> +fi
> +
> +run_mustfail "should fail for non exist file" \
> +	"$TOP/btrfs" inspect-internal rootid no_such_file
> +run_mustfail "should fail for non btrfs filesystem" \
> +	"$TOP/btrfs" inspect-internal rootid /dev/null
> +
> +cd ..
> +run_check_umount_test_dev
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
