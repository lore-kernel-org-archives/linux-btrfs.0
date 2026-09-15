Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68894A5C4B;
	Tue, 15 Sep 2026 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472704; cv=none; b=a/cgMs49zi/1mnMarq39l0E0ADQfoOliyn7SvVzt3UbWB0h+2F0NdJS9WIf0u2V9/Cg6/r8kKhk0snb5PH9kh1BeQILN54OaLnWb8zsWiDFI+uKg5QRUON1x/EO+nWbCpJTzVNzpx7cUAcE+IObQxUtNno3dEIsBDMBgN/tXHSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472704; c=relaxed/simple;
	bh=I9OSMkJAqyTiXYMalQaOUAdmmm0VDGEgLom6apcHYec=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gP90OL/oS3up3iHPNbsyRZfqne+RVwHALZDFYD/jZcjQX7soIYApCfstL2bfrd1p3D+Thb2PoVLr73eyp7ILVUsOA/zB1+zqDLe3WUDLgiH9ziZpyyLhlK72oe1E6Jq1CA+427R7hJUwIf/7uErj0vuCtKUflRNn1WJ4O9cYWBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qpraZtza; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QGwPJ/Wk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1z2YAcmQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=STZq1zq7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qpraZtza";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QGwPJ/Wk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1z2YAcmQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="STZq1zq7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 394F521A9E;
	Tue, 15 Sep 2026 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789472696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnDg373jH78dN5pIlzcrzFxx8vbb4Emva5UqmqlA8Bg=;
	b=qpraZtzanmpj7R1Jkwg1ZHKKEQDMYSY8xvkq6XVPF7eJd2YnzwERexK7bLYvykrvJcxCai
	o8+hcoWFuzN8xPxfy+Uc0jEKLkAl5BzbJ6AYwZLBHpgj7C/ZErVvUnoKmLGbms6ACpTRAY
	lWDo+DYnveuidBmY1AsoVwi8y80Je0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789472696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnDg373jH78dN5pIlzcrzFxx8vbb4Emva5UqmqlA8Bg=;
	b=QGwPJ/WkF/4m6xkn2AxXzqeuw67GWIpTz/c7VMvDiMldQmCUgcja/drPEA3LNTK+h6U4kR
	rX3zzYtuWYaOhbAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789472692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnDg373jH78dN5pIlzcrzFxx8vbb4Emva5UqmqlA8Bg=;
	b=1z2YAcmQdxEMkYP6ILpxAzr+WftWRG4KKRDp2/yLGn1n5wKNPcqkmKCf4d22vhbyjTSS1c
	ejYXsMG0T6jFW5EklIfsdRwOwhFjbRYXwhri5vND34ZVCNyzrNtCv27wSys22L5fyn1bMw
	5LFaPMeawG7IxR2/Ky5a2eAGuu47PVI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789472692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnDg373jH78dN5pIlzcrzFxx8vbb4Emva5UqmqlA8Bg=;
	b=STZq1zq72y1frufu7ivMLSsB+dpmS6zuXU7eMPYnWhm7ALxYfUAAQ85lgrujxIvuAwRbUp
	6zpyVijJkjHxpRCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7661E13693;
	Tue, 15 Sep 2026 11:44:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LtfcJrAvqWrufwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 15 Sep 2026 11:44:49 +0000
Date: Tue, 15 Sep 2026 21:44:31 +1000
From: David Disseldorp <ddiss@suse.de>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana
 <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test that we don't create pointless compressed
 inline extents
Message-ID: <20260915214431.72728a7a.ddiss@suse.de>
In-Reply-To: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
References: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -3.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On Mon, 14 Sep 2026 18:54:23 +0100, fdmanana@kernel.org wrote:

> From: Filipe Manana <fdmanana@suse.com>
> 
> Verify that we don't create compressed inline extents when the compressed
> data size is not smaller than the uncompressed data size.
> 
> This exercises a regression introduced in kernel 7.1 and that is fixed by
> the following patch:
> 
>   "btrfs: fix creation of compressed inline extents that don't save space"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good and works for me:
Reviewed-by: David Disseldorp <ddiss@suse.de>

A couple of minor nits below...

> ---
>  tests/btrfs/354     | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/354.out |  2 ++
>  2 files changed, 46 insertions(+)
>  create mode 100755 tests/btrfs/354
>  create mode 100644 tests/btrfs/354.out
> 
> diff --git a/tests/btrfs/354 b/tests/btrfs/354
> new file mode 100755
> index 00000000..801dc587
> --- /dev/null
> +++ b/tests/btrfs/354
> @@ -0,0 +1,44 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 354
> +#
> +# Verify that we don't create compressed inline extents when the compressed
> +# data size is not smaller than the uncompressed data size.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick compress
> +
> +. ./common/filter
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: fix creation of compressed inline extents that don't save space"
> +
> +_require_scratch
> +_require_btrfs_command inspect-internal dump-tree
> +
> +algo_list=($(_btrfs_compression_algos))
> +for algo in ${algo_list[@]}; do
> +	_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +	_scratch_mount "-o compress=$algo"
> +
> +	echo 'a file with test content' > $SCRATCH_MNT/foobar
> +	_scratch_unmount
> +	_check_scratch_fs
> +
> +	extent_size=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
> +	      grep 'inline extent' | \
> +	      $AWK_PROG '{ for (i = 1; i < NF; i++) if ($i ~ /^size$/) print $(i + 1) }')
> +	ram_size=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
> +		   grep 'inline extent' | \
> +		   $AWK_PROG '{ for (i = 1; i < NF; i++) if ($i ~ /^ram_bytes$/) print $(i + 1) }')
> +
> +	if [ "$extent_size" -gt "$ram_size" ]; then
> +		echo "inline extent size ($extent_size) greater than ram_size ($ram_size) for algo $algo"
> +	fi

It might be a little nicer to avoid multiple dumps and do the check in
awk. The following works for me, feel free to squash in...

diff --git a/tests/btrfs/354 b/tests/btrfs/354
index 801dc587..e744b945 100755
--- a/tests/btrfs/354
+++ b/tests/btrfs/354
@@ -27,18 +27,20 @@ for algo in ${algo_list[@]}; do
        _scratch_unmount
        _check_scratch_fs
 
-       extent_size=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
-             grep 'inline extent' | \
-             $AWK_PROG '{ for (i = 1; i < NF; i++) if ($i ~ /^size$/) print $(i + 1) }')
-       ram_size=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
-                  grep 'inline extent' | \
-                  $AWK_PROG '{ for (i = 1; i < NF; i++) if ($i ~ /^ram_bytes$/) print $(i + 1) }')
-
-       if [ "$extent_size" -gt "$ram_size" ]; then
-               echo "inline extent size ($extent_size) greater than ram_size ($ram_size) for algo $algo"
-       fi
+       $BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
+               tee -a $seqres.full | \
+               $AWK_PROG -v algo="$algo" '
+                       /inline extent/ {
+                               for (i = 1; i < NF; i++) {
+                                       if ($i ~ /^size$/)
+                                               extent_size = $(i + 1)
+                                       if ($i ~ /^ram_bytes$/)
+                                               ram_size = $(i + 1)
+                               }
+                               if (extent_size > ram_size)
+                                       printf "inline extent size (%d) greater than ram_size (%d) for algo %s\n", extent_size, ram_size, algo
+                       }'

> +done
> +
> +# success, all done

Delete the line above, as we get here on failure too.

> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> new file mode 100644
> index 00000000..8bc7ecf6
> --- /dev/null
> +++ b/tests/btrfs/354.out
> @@ -0,0 +1,2 @@
> +QA output created by 354
> +Silence is golden

