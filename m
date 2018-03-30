Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbeC3SHB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 14:07:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96FC9AF74
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 18:07:00 +0000 (UTC)
Date: Fri, 30 Mar 2018 20:04:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests/mkfs: Test if mkfs.btrfs --rootdir
 can handle broken soft link well
Message-ID: <20180330180433.GU30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180329012644.17822-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180329012644.17822-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 09:26:44AM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Test fixed and applied, thanks.

> ---
>  .../016-rootdir-bad-symbolic-link/test.sh          | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100755 tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh
> 
> diff --git a/tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh b/tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh
> new file mode 100755
> index 000000000000..d12efa629042
> --- /dev/null
> +++ b/tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh
> @@ -0,0 +1,26 @@
> +#!/bin/bash
> +# Regression test for mkfs.btrfs --rootdir with bad symbolic link
> +# (points to non-existing location)
> +#
> +# Since mkfs.btrfs --rootdir will just create symbolic link other than
> +# follow it, we shouldn't hit any problem
> +
> +source "$TEST_TOP/common"
> +
> +check_prereq mkfs.btrfs
> +
> +prepare_test_dev
> +
> +tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
> +
> +non_existing="/no/such/file"

Adding a few $RANDOM will make the below almost impossible.

> +
> +if [ -f "$non_existing" ]; then
> +	# Some smartass don't want to this test case to run
> +	_not_run "Some one created $non_exist, which is not expect to exist"
                                   ^^^^^^^^^^

> +fi
> +
> +run_check ln -sf "$non_existing" "$tmp/foobar"
> +
> +run_check "$TOP/mkfs.btrfs" -f --rootdir "$tmp" "$TEST_DEV"
> +run_check "$TOP/btrfs" check "$TEST_DEV"

rm -rf -- "$tmp"
