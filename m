Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AD935B650;
	Thu,  4 Jun 2026 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780595309; cv=none; b=G9Q/uN02tpa9pS/qCGj46FZhCON2nZocDWYqVB3C4UxwjERuu3HrostHcnOmailU4eQdNd/2jCe/I80+7DUgmyFbaBYEiSk0wJQCYq7JtGrqiWDfdP3vbD0GTWs1vP/6DX6hUZU3ztkSMEAMS2rk9XP/7yMf0+6QYNe0z8Vgr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780595309; c=relaxed/simple;
	bh=7kPe8NOhpEMTwelX0GuYFNbMygoUtCBc2ZTcVFNckYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cf+i56X2o5k/d4AOJzmi/0Z9kcCxhUrb14h6c80U2cwT2uTfslJxyRgUW262bPfWrEFpgD/DndCC2L89rxXGXMbTbuRbqsSPgqCgLb1z8cq4pgV9Sep4F15loEe3sw/R04k0CN34aaH5Q3sujUA7BUQn6IlDYygwCfpmiS8pEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6zgR+1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6zgR+1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B41F00893;
	Thu,  4 Jun 2026 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780595307;
	bh=qF7KJRghuSGQhH5TV/sbNtM9GCZOy6fOueBHMARPXBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F6zgR+1ccpq+3q4vXCIZ6VpeIbcRJMOFlva+dF15+YxPz6q3HPpS3g68qIYNFlNTV
	 d93PgJVT421vPIyhYaHZ8bzJbWAVESQujIbP1Lrivi5xa34J0ER4o5tfCH3yLmODvm
	 bZlaNUWSc+sjdwzhXE1oTOe1Su24uDpZXtKtbj8lrjDCYCmxsXwBjcSa4jond2oPxo
	 MJMTxsnf0xGeAcPXhWp/WJ1SCRX6djo0FgfvGXVRDesjxNrqBss9Dz0rnnJ7eSQpr9
	 ZKBKn1DwZzr0i9dib2D6jrKrxGO9rbkJXurdvwbrnyujd0Q0zuFqtLKXKMbpZxe/Wo
	 8owgcycc2GoLw==
Date: Fri, 5 Jun 2026 01:48:22 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fstests: use MOUNT_OPTIONS to populate
 TEST_FS_MOUNT_OPTS if possible
Message-ID: <aiGsok9xtmdM-q9c@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
References: <20260602001422.24364-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602001422.24364-1-wqu@suse.com>

On Tue, Jun 02, 2026 at 09:44:22AM +0930, Qu Wenruo wrote:
> If the test config only specifies "MOUNT_OPTIONS", but not
> "TEST_FS_MOUNT_OPTS", the mount for TEST_DIR can have inconsistent flag
> after _test_cycle_mount().
> 
> Here is an very simple test case to show the problem:
> 
>  . ./common/preamble
>  _begin_fstest auto
>  _require_test
> 
>  mount | grep "$TEST_DIR"
>  _test_cycle_mount

AFAIK, TEST_FS_MOUNT_OPTS is designed to be the exact counterpart to
MOUNT_OPTIONS. The former applies to TEST_DEV, while the latter affects
SCRATCH_DEV and any other manually created devices (such as loop or dm
devices). Therefore, when testing custom mount options, better to specify
both parameters.

>  mount | grep "$TEST_DIR"
>  _exit 0
> 
> And with "MOUNT_OPTIONS" set to "-o nodatasum" (one of the btrfs mount
> option that affects new inodes), but "TEST_FS_MOUNT_OPTS" not set, then
> running the test, the output will be:
> 
>  QA output created by 348
>  /dev/mapper/test-test on /mnt/test type btrfs (rw,relatime,nodatasum,discard=async,space_cache=v2,subvolid=5,subvol=/)
>  /dev/mapper/test-test on /mnt/test type btrfs (rw,relatime,discard=async,space_cache=v2,subvolid=5,subvol=/)
> 
> This changed mount option will cause several test cases to fail on btrfs
> with MOUNT_OPTIONS="-o nodatasum" set:
> 
> - generic/143
> - generic/154
> - generic/155
> - generic/463
> 
> All above test case fails because the reflink source is from the initial
> test mount, which has "nodatasum" mount option.
> But later after _test_cycle_mount(), no more "nodatasum" flags, causing
> reflink source and destination have different "nodatasum" flags.
> And btrfs will reject such reflink, causing golden output mismatch.
> 
> One way to avoid such problem is to set TEST_FS_MOUNT_OPTS to the same
> as MOUNT_OPTIONS, but I'm not sure if we really want different options
> for test and scratch mounts.
> 
> So here as a compromise, set TEST_FS_MOUNT_OPTS to MOUNT_OPTIONS if
> the former is not set but the latter is already set by the user.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Reason for RFC:
> 
> - Still didn't get why the initial test mount respects MOUNT_OPTIONS
>   If test mount only respects TEST_FS_MOUNT_OPTS, the first mount should
>   not get the MOUNT_OPTIONS.
> 
> - Not sure if TEST_FS_MOUNT_OPTS is needed
>   If not provided, the default config for TEST_FS_MOUNT_OPTS and
>   MOUNT_OPTIONS are the same.
>
>   The introduction of TEST_FS_MOUNT_OPTS is from commit 0e9141e49d4a
>   ("common: add cifs support"), with extra handling for
>   _test_mount_opts().

No, actually TEST_FS_MOUNT_OPTS is far more than that. For example, you can
check commit 3839d29973, it has TEST_FS_MOUNT_OPTS in _test_mount. But at
that time xfstests was still under its original form, there was not common/
directory.

Then 8c4905a4 create common/ directory and common/rc, then TEST_FS_MOUNT_OPTS
started to appear in common/rc:_test_mount().

Then commit 0e9141e4 brought in _test_mount_opts for CIFS, but it didn't change
the logic of TEST_FS_MOUNT_OPTS for TEST_DEV mount. And we can learn about why
CIFS need a seperated TEST_FS_MOUNT_OPTS from its wiki link:

  https://wiki.samba.org/images/9/99/Xfstests.local.config.txt

Therefore, TEST_FS_MOUNT_OPTS has been dedicated entirely to TEST_DEV by design
since the very inception of xfstests, and this principle seems to have remained
unchanged. The real issue now is that we run into a conflict between
TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS when the helpers try to detect features,
particularly those that depend on mount options.

As for whether TEST_FS_MOUNT_OPTS is still necessary, I feel we need more
discussion on this. Some upper filesystems might still need it, and the original
purpose of keeping it separate for XFS testing probably deserves a deeper look.
(CC'ing Dave Chinner, who might know more that that history :)

About your current Btrfs tests, I would highly recommend specifying both
TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS at the same time. (I always do that
actually).

Regarding the feature detection mismatch, a quick fix could be making TEST_FS_MOUNT_OPTS
default to MOUNT_OPTIONS when it's not set. That said, it is still worth double-checking
the initial purpose of TEST_FS_MOUNT_OPTS, just in case I miss something.

Thanks,
Zorro

> 
>   But nowadays the special handling is moved to _common_mount_opts(),
>   shared by both scratch and test mounts.
>   Not sure if there is any fs that requires split options for test and
>   scratch.
> 
> - Possible reduced coverage
>   Ignoring MOUNT_OPTIONS and requiring extra TEST_FS_MOUNT_OPTS can cause
>   reduced coverage, as one may expect MOUNT_OPTIONS to affect both test
>   and scratch devices.
> ---
>  common/config | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/common/config b/common/config
> index d5299d5b..12e94088 100644
> --- a/common/config
> +++ b/common/config
> @@ -419,8 +419,14 @@ _mount_opts()
>  	export MOUNT_OPTIONS=$(_common_mount_opts)
>  }
>  
> +# Must be called before _mount_opts().
>  _test_mount_opts()
>  {
> +	# Use $MOUNT_OPTIONS if provided.
> +	if [ ! -z "$MOUNT_OPTIONS" ]; then
> +		export TEST_FS_MOUNT_OPTS="$MOUNT_OPTIONS"
> +		return
> +	fi
>  	export TEST_FS_MOUNT_OPTS=$(_common_mount_opts)
>  }
>  
> @@ -823,8 +829,8 @@ get_next_config() {
>  
>  	parse_config_section $1
>  	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
> -		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
>  		[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
> +		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
>  		[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
>  		[ -z "$FSCK_OPTIONS" ] && _fsck_opts
>  
> @@ -915,8 +921,8 @@ if [ -z "$CONFIG_INCLUDED" ]; then
>  	fi
>  	FSTYP=${FSTYP:=xfs}
>  	export FSTYP
> -	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
>  	[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
> +	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
>  	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
>  	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
>  else
> -- 
> 2.51.2
> 
> 
