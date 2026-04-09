Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59538281525;
	Thu,  9 Apr 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775752280; cv=none; b=qpuTzpidDyoO1saqG0LO1bP6BUDO05FQ3VjaxAkbusAI/0wR5wA2OxAcwMNVjbryyQ2khLXZLpkU3InLImyOZQgJsuZ6toOCJMX/8X/PVDTPBaoVCsMKl4AYYl8cRXM4H8dmoiBmaMMEeypttoG/F2JKGOTW4Hg8wx++GMwP25Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775752280; c=relaxed/simple;
	bh=pxmQp3BJ3k3v392XDIseqZvzxHs9Z8Xtk5hrL2t/Igg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pE5ygw2bmipyXNX3fHvxYVd3NBXkvZzMDNEs0VNVyhiT5w1nJeIatLWAX0jRtTFIEK9Yh1Y9iw90L0BQa0X3WoBWrtYCJDyTjoek/qjWaeKopceKlrxzTODgipI4waGdMYd2AoGH755ASMfqT7doDOKu4Hrv7uC/18MFpx/BdNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=dYSCnGiQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=npniuZ8+; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="dYSCnGiQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="npniuZ8+"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 8C1BB1D001B9;
	Thu,  9 Apr 2026 12:31:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 09 Apr 2026 12:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775752278; x=1775838678; bh=7rzsss9VG1
	/+QBq6ytQFQcjW2CXjWpQDa2IJzTVRHHc=; b=dYSCnGiQggXioToqwo0lxxJJuU
	WwWpN4m6E9dCQbV30I5CFvMBftyV79KRzKjxH1aDp/L4pOTuwQ3all1VU7OqrHkl
	zmpgq6tyZ3DSnrq5A42dchTz5NTG9/ynzRcKmqA2qNTC3752YXbEethNbxI9yoj0
	HyzdYYb3GJjbcDxR9iOJWMX6aMHI0RJZejOT9M/mnChnAYqW6gvFejr3tRa7Hp6p
	zxZFQikFlOfR1qxHB+VzrveanEazYizzl0qZWag3oamVWOt+HzpLHLKOljqCRj3a
	S3NlRddnEw1rbQmQlUMnjmZPUYMjCC1cK19iCJik7Ap1EFxErj0Eg+ZUypoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775752278; x=1775838678; bh=7rzsss9VG1/+QBq6ytQFQcjW2CXjWpQDa2I
	JzTVRHHc=; b=npniuZ8+2XVFtWPjiWd+7B/ny3kE8vJQl1bSPjVeBoWKJveJwy8
	XHqW08iwNk0wBHM5kfEDotKRGaT1cmty5uXUx5hursMusL40l7id7GekDUP6hUvn
	iwN7wltb675cjvXElhFlXLBiQq2ygjm67v/It4QdwY7/CBb+DXmZtJDpy7NRJont
	XK3etj4ekMCAzHoqexwkdkhFpDM/8Ca/NJvkyh9kalfX7ifnw4D0SCoNPIHBJ+rr
	nFmTQqFPS3EkpNHcfoGr0XEeVfG/sVUqGAOJqVKkWsNxDeDdkYISqo+xWLEnZGrN
	Gg3ljzu13WnfDuWML0Y2tcSQIXQAkydtgWg==
X-ME-Sender: <xms:VtTXaYGA8sSmiCVut_0pu2URT0pafsDEa7jh1QJszlyIc5YWRBHWAw>
    <xme:VtTXafKqwOgYRToQiqVC0uG-X09Y6PDHbOrZvwVrnng9Z9AkwizHPWtlgYaGxfCg4
    we6cFOufe3Kbs4LVXK48xGIHMLhcf5SKbrxNDegSSpmzqZx6ykJDGo>
X-ME-Received: <xmr:VtTXaclq91PvOnVQ3T9zxYoZTSXLxFJtb6nleGlnjwS6N6zv4LXOgpavtW5WU2hrixbywzf77wcnt9ZU-qIVesCdzVU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvieelkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepkedvke
    ffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehfughmrghnrghnrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfhhsthgvshhtsh
    esvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhs
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfhgumhgrnhgrnhgrsehsuh
    hsvgdrtghomh
X-ME-Proxy: <xmx:VtTXaXRbKxh8nwmrc4mLGx1ig2TFRI9ti6sciX5janL-zheDXX2kBw>
    <xmx:VtTXaeI7e60Bh9hHlXVV-Ga4m7dbtm_win1LZzfikB4Xmg27ghF2qQ>
    <xmx:VtTXadBxyuCzx5SebvVsB0N1dyCqWPHWSjMllrnU5U1x28dHlIYU3g>
    <xmx:VtTXaXDoRYdLbsntuicgx7UWzWCvBM0-ehkhVdiTMPI2eNMok3cOfA>
    <xmx:VtTXaYkWG1smNWkKSRdYmFqZxysl-pRVyY4Z3BrwWTACF_E4LDBa6TK4>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 12:31:17 -0400 (EDT)
Date: Thu, 9 Apr 2026 09:31:05 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: test fsync against a removed directory
Message-ID: <20260409163105.GB2654001@zen.localdomain>
References: <d4b466fd960d1dd8e25f7db75fd323f48053cef1.1775747936.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4b466fd960d1dd8e25f7db75fd323f48053cef1.1775747936.git.fdmanana@suse.com>

On Thu, Apr 09, 2026 at 04:22:27PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we fsync a directory that became empty after removing it
> and we have a power failure, we are able to mount the filesystem and the
> directory does not exists anymore.
> 
> This exercises a bug found in btrfs which is fixed by the following patch:
> 
>   btrfs: fix missing last_unlink_trans update when removing a directory
> 

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  src/unlink-fsync.c    | 39 ++++++++++++++++++------
>  tests/generic/792     | 69 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/792.out | 10 +++++++
>  3 files changed, 109 insertions(+), 9 deletions(-)
>  create mode 100755 tests/generic/792
>  create mode 100644 tests/generic/792.out
> 
> diff --git a/src/unlink-fsync.c b/src/unlink-fsync.c
> index ce008c6b..364f9226 100644
> --- a/src/unlink-fsync.c
> +++ b/src/unlink-fsync.c
> @@ -4,10 +4,12 @@
>   */
>  
>  /*
> - * Utility to open an existing file, unlink it while holding an open fd on it
> - * and then fsync the file before closing the fd.
> + * Utility to open an existing file or directory, unlink or rmdir it while
> + * holding an open fd on it and then fsync it before closing the fd.
>   */
>  
> +#include <sys/types.h>
> +#include <sys/stat.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> @@ -15,24 +17,43 @@
>  
>  int main(int argc, char *argv[])
>  {
> +	struct stat path_stat;
>  	int fd;
>  	int ret;
>  
>  	if (argc != 2) {
> -		fprintf(stderr, "Use: %s <file path>\n", argv[0]);
> +		fprintf(stderr, "Use: %s <file or dir path>\n", argv[0]);
>  		return 1;
>  	}
>  
> -	fd = open(argv[1], O_WRONLY, 0666);
> +	ret = stat(argv[1], &path_stat);
> +	if (ret == -1) {
> +		perror("stat failed");
> +		exit(1);
> +	}
> +
> +	if (S_ISDIR(path_stat.st_mode))
> +		fd = open(argv[1], O_RDONLY | O_DIRECTORY);
> +	else
> +		fd = open(argv[1], O_WRONLY, 0666);
> +
>  	if (fd == -1) {
> -		perror("failed to open file");
> +		perror("failed to open file/dir");
>  		exit(1);
>  	}
>  
> -	ret = unlink(argv[1]);
> -	if (ret == -1) {
> -		perror("unlink failed");
> -		exit(2);
> +	if (S_ISDIR(path_stat.st_mode)) {
> +		ret = rmdir(argv[1]);
> +		if (ret == -1) {
> +			perror("rmdir failed");
> +			exit(2);
> +		}
> +	} else {
> +		ret = unlink(argv[1]);
> +		if (ret == -1) {
> +			perror("unlink failed");
> +			exit(2);
> +		}
>  	}
>  
>  	ret = fsync(fd);
> diff --git a/tests/generic/792 b/tests/generic/792
> new file mode 100755
> index 00000000..892ca2d8
> --- /dev/null
> +++ b/tests/generic/792
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 792
> +#
> +# Test that if we fsync a directory that became empty after removing it and we
> +# have a power failure, we are able to mount the filesystem and the directory
> +# does not exists anymore.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +. ./common/filter
> +. ./common/dmflakey
> +
> +_require_scratch
> +_require_test_program unlink-fsync
> +_require_dm_target flakey
> +
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +	"btrfs: fix missing last_unlink_trans update when removing a directory"
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_require_metadata_journaling $SCRATCH_DEV
> +_init_flakey
> +_scratch_mount
> +
> +# Create our first directory and define its permissions (we will later change
> +# them).
> +mkdir $SCRATCH_MNT/dir1
> +chmod a+rwx $SCRATCH_MNT/dir1
> +
> +# Created another directory inside that first directoy and then another one at
> +# the top level.
> +mkdir $SCRATCH_MNT/dir1/dir2
> +mkdir $SCRATCH_MNT/dir3
> +
> +# Persist everything done so far.
> +_scratch_sync
> +
> +# Do some change to the first directory, like change its permissions, fsync it.
> +chmod o-rwx $SCRATCH_MNT/dir1
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/dir1
> +
> +# Now move the second directory from dir1 to dir3, so that dir1 becomes empty.
> +mv $SCRATCH_MNT/dir1/dir2 $SCRATCH_MNT/dir3/
> +
> +# Now open an fd for dir1, rmdir it and fsync it before closing the fd.
> +$here/src/unlink-fsync $SCRATCH_MNT/dir1
> +
> +# Simulate a power failure and replay the log/journal.
> +# The mount should succeed, dir1 must not exist anymore and dir2 must now be
> +# inside dir3.
> +_flakey_drop_and_remount
> +
> +echo -e "Filesystem content after power failure:\n"
> +# Exclude 'lost+found' dir from ext4 and last line if it's blank (due to removal
> +# of 'lost+found').
> +ls -R $SCRATCH_MNT/ | grep -v 'lost+found' | sed -e '${/^$/d;}' | _filter_scratch
> +
> +_exit 0
> diff --git a/tests/generic/792.out b/tests/generic/792.out
> new file mode 100644
> index 00000000..f806258c
> --- /dev/null
> +++ b/tests/generic/792.out
> @@ -0,0 +1,10 @@
> +QA output created by 792
> +Filesystem content after power failure:
> +
> +SCRATCH_MNT/:
> +dir3
> +
> +SCRATCH_MNT/dir3:
> +dir2
> +
> +SCRATCH_MNT/dir3/dir2:
> -- 
> 2.47.2
> 
