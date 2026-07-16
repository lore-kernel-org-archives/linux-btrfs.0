Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742B3B8111
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 10:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784196316; cv=none; b=VAJtqv4gFSVNniFGc0Xebi7pUTukZdkHc4KgPRrmqbFLhTzdvu250YQ0wDqv1DLuEP6rwmrZ5INg/KE35st6C8bSGCGCbC0LBo7sgho8YKMqAUKIfZVipEKQyRbIGo+BFcj8+7jkmes0biPsoh/+U7RURA0iDNLSip7+XYy8Kjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784196316; c=relaxed/simple;
	bh=BgBToixEvidZUtjJ0CRiH8gNaOivp4xK6i/KkYkQ6ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyUJG+/mKxSnJEFe5sE+5gHQbN2ZMw8y7A5XTQCc0g3dEWCZK32oPGXhvhUdcZj97cplGOknRHZX0Quw9rKvJla/sHyxxyijbfkvFnkNS+PgK1w9ENbKW+FHvqsvLoBtSehXhybV2yBbn4ydNalIdW86FTX/CP71/ph17U3jMQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aKtRX8wU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aKtRX8wU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784196314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DI+PDORv1aJVAQtbMTNnHI2lUR6TrryOZGxBa77OmvQ=;
	b=aKtRX8wU/8nltuHr+gdGyqh2Wj6VVhepi4QV3kmSrjRa3BJN/7jJ+NBuMpSe9sZkEcCJGm
	2BEw2oCE4OFDLMLtsab5X/V5b2yYGELVxzFeT/Vsc1xWM6qbAAbz/CM8kdoj1Zcg+AgfUH
	M+eRPDJn1X8LLrPeSJ25RfbezDqetPk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-p1E7IKNGMo6nFj3jYYpVEA-1; Thu,
 16 Jul 2026 06:05:09 -0400
X-MC-Unique: p1E7IKNGMo6nFj3jYYpVEA-1
X-Mimecast-MFC-AGG-ID: p1E7IKNGMo6nFj3jYYpVEA_1784196307
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C478B1956053;
	Thu, 16 Jul 2026 10:05:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6B771955F74;
	Thu, 16 Jul 2026 10:05:06 +0000 (UTC)
Date: Thu, 16 Jul 2026 06:05:04 -0400
From: Brian Foster <bfoster@redhat.com>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic: add a basic cachestat test case
Message-ID: <alis0DbcUX9Dd897@bfoster>
References: <20260715223716.5965-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715223716.5965-1-wqu@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Jul 16, 2026 at 08:07:16AM +0930, Qu Wenruo wrote:
> The test case is inspired by LTP, where there is a regression on 64K
> page size systems with btrfs, that after a fsync, cachestat() still
> report dirty pages.
> 
> The test case itself is pretty simple, fill the file with a buffered write that is
> 1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
> number match the page number.
> 
> Then do a fsync(), and make sure the dirty page number reduced to 0
> meanwhile cached is still the same.
> 
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1270397
> Reviewed-by: Anand Jain <asj@kernel.org>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v3:
> - Use golden output to greatly simplify the test case
> 
> - Do not mkfs for each size, just remove the original file
> 
> v2:
> - Reject "sync" and "dax" mount options
>   Those mount options write back data synchronously, will screw up the
>   buffered write dirtied page reporting.
> 
> - Use AWK_PROG everywhere.
> 
> - Remove the unnecessary redirection for fsync
> ---

Nice. Thanks for the tweaks!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/generic/798     | 39 +++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out | 16 ++++++++++++++++
>  2 files changed, 55 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
> 
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..0fe37646
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 798
> +#
> +# Basic tests for cachestat()
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +_require_xfs_io_command "cachestat"
> +_require_scratch
> +# Any mount option that writes data back synchronously should be rejected.
> +# Or it will screw up the dirtied page reporting for buffered writes.
> +_exclude_scratch_mount_option "dax"
> +_exclude_scratch_mount_option "sync"
> +
> +pagesize=$(_get_page_size)
> +
> +_scratch_mkfs > /dev/null
> +_scratch_mount
> +
> +for num_page in 1 2 4 8 16; do
> +	size=$(($pagesize * $num_page))
> +
> +	echo "=== Test with $num_page pages ==="
> +
> +	rm -f $SCRATCH_MNT/foobar
> +	$XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" $SCRATCH_MNT/foobar > /dev/null
> +	# Basic cached number reporting
> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar
> +
> +	# Test dirty page number reporting after a fsync.
> +	$XFS_IO_PROG -c "fsync" -c "cachestat 0 $size" $SCRATCH_MNT/foobar
> +done
> +
> +_scratch_unmount
> +_exit 0
> diff --git a/tests/generic/798.out b/tests/generic/798.out
> new file mode 100644
> index 00000000..ca6ead3c
> --- /dev/null
> +++ b/tests/generic/798.out
> @@ -0,0 +1,16 @@
> +QA output created by 798
> +=== Test with 1 pages ===
> +Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +Cached: 1, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +=== Test with 2 pages ===
> +Cached: 2, Dirty: 2, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +Cached: 2, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +=== Test with 4 pages ===
> +Cached: 4, Dirty: 4, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +Cached: 4, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +=== Test with 8 pages ===
> +Cached: 8, Dirty: 8, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +Cached: 8, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +=== Test with 16 pages ===
> +Cached: 16, Dirty: 16, Writeback: 0, Evicted: 0, Recently Evicted: 0
> +Cached: 16, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
> -- 
> 2.51.2
> 

