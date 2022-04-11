Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1F6C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiDKWkN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349179AbiDKWkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Apr 2022 18:40:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888D82E9FC;
        Mon, 11 Apr 2022 15:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3031361783;
        Mon, 11 Apr 2022 22:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F00C385A4;
        Mon, 11 Apr 2022 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649716675;
        bh=CKm7Pg4qG2X/1DTjoTgvcXN4zl4yjMqz4X0OeGA117Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJCXf5O8ujtvG1jmqCWZDRLU1ojKxpoF62dnvk42XyOZObIBC2ig+XmDHOGt+uQ+i
         Oxp5uQxs0GtIT3jr2dSUSNju9v3mt3MjweVEsLGqFTT9IgJ0JwLpy021FmBug9rS0u
         cZzlLKte/zR1S7E7d7EXaPi03kvGVEd1OWz2AAqvPmSa+lsniuG4/vcE6xihnPb1XV
         +7RPPESnReSdja90g8MxHm80f3adyMfaMAVcALvkxBJOks0kkikhQXqsoLYLGdB5U+
         saqiYuQpLSx5ce1OuIfc6NODarHuRCnnSNGwjGEyYpM6ehsNUYZoEJKBxu6yZVTV3F
         c3CJD1sFnABtQ==
Date:   Mon, 11 Apr 2022 15:37:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        brauner@kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] common/rc: fix _try_scratch_mount() and _test_mount()
 when mount fails
Message-ID: <20220411223754.GB16774@magnolia>
References: <0ab59504aef01776ab58f9f92c55e86bf1c75424.1649685964.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab59504aef01776ab58f9f92c55e86bf1c75424.1649685964.git.fdmanana@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:08:38PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After the recent commit 4a7b35d7a76cd9 ("common: allow to run all tests
> on idmapped mounts"), some test that use _try_scratch_mount started to
> fail. For example:
> 
> $ ./check btrfs/131 btrfs/220
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 debian9 5.17.0-rc8-btrfs-next-114 (...)
> MKFS_OPTIONS  -- /dev/sdc
> MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1
> 
> btrfs/131 2s ... - output mismatch (see .../results//btrfs/131.out.bad)
>     --- tests/btrfs/131.out	2020-06-10 19:29:03.818519162 +0100
>     +++ /home/fdmanana/git/hub/xfstests/results//btrfs/131.out.bad (...)
>     @@ -6,8 +6,6 @@
>      Disabling free space cache and enabling free space tree
>      free space tree is enabled
>      Trying to mount without free space tree
>     -mount failed
>     -mount failed
>      Mounting existing free space tree
>      free space tree is enabled
>     ...
>     (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/131.out ...
> btrfs/220 7s ... - output mismatch (see .../results//btrfs/220.out.bad)
>     --- tests/btrfs/220.out	2020-10-16 23:13:46.802162554 +0100
>     +++ /home/fdmanana/git/hub/xfstests/results//btrfs/220.out.bad (...)
>     @@ -1,2 +1,32 @@
>      QA output created by 220
>     +Option fragment=invalid should fail to mount
>     +umount: /home/fdmanana/btrfs-tests/scratch_1: not mounted.
>     +Option nologreplay should fail to mount
>     +umount: /home/fdmanana/btrfs-tests/scratch_1: not mounted.
>     +Option norecovery should fail to mount
>     +umount: /home/fdmanana/btrfs-tests/scratch_1: not mounted.
>     ...
>     (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/220.out ...
> Ran: btrfs/131 btrfs/220
> Failures: btrfs/131 btrfs/220
> Failed 2 of 2 tests
> 
> The reason is that if _try_scratch_mount() fails to mount the filesystem,
> we don't return the failure, instead we call _idmapped_mount(), which
> can succeed and make _try_scratch_mount() return 0 (success). The same
> happens for _test_mount(), however a quick search revealed no tests
> currently relying on the return value of _test_mount().
> 
> So fix that by making _try_scratch_mount() return immediately if it gets
> a mount failure. Also do the same for _test_mount().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Aha, that's why the test cloud reported a 4% test failure rate.

Well, this fixes things, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/rc | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 17629801..37d18599 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -329,11 +329,15 @@ _supports_filetype()
>  # mount scratch device with given options but don't check mount status
>  _try_scratch_mount()
>  {
> +	local mount_ret
> +
>  	if [ "$FSTYP" == "overlay" ]; then
>  		_overlay_scratch_mount $*
>  		return $?
>  	fi
>  	_mount -t $FSTYP `_scratch_mount_options $*`
> +	mount_ret=$?
> +	[ $mount_ret -ne 0 ] && return $mount_ret
>  	_idmapped_mount $SCRATCH_DEV $SCRATCH_MNT
>  }
>  
> @@ -494,12 +498,16 @@ _idmapped_mount()
>  
>  _test_mount()
>  {
> +    local mount_ret
> +
>      if [ "$FSTYP" == "overlay" ]; then
>          _overlay_test_mount $*
>          return $?
>      fi
>      _test_options mount
>      _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
> +    mount_ret=$?
> +    [ $mount_ret -ne 0 ] && return $mount_ret
>      _idmapped_mount $TEST_DEV $TEST_DIR
>  }
>  
> -- 
> 2.35.1
> 
