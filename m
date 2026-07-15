Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB2A32E128
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784144439; cv=none; b=SpH26foWV5fz3zMezOKGiKXyNjymCNFo/IAK+z0CgWjSKLbHkPpQreWdZwRkxw+P67TT0Eoyzr1X+JkYg8F2sJ7kPQKwbisCRJe5W8NRYGj3nJ7z5hj8V8CIIxfLYNhC5uNS8W9bzZaoGLBLSvEL/ffRJb4N/sN32VdWo6KcCC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784144439; c=relaxed/simple;
	bh=ZSgHRErl7FrTeqmOo+0DgdGu8orLbTriElNQLaFJkuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3vtPoXHMKLMHgl94xaRey47MhSY9ofLSPeeP6ongdyPluf4EYE2ywyy1AEWCXDjlEsyQ9Ln54W/eHoXlNghv5rXPi6ioJsjdXpbWx2isyx+/w4Z4ge+ZEi/3E05OPaLpunblfB/zshfH62arILLPMqCA3Cqw1EuhFrKxsWw6K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BTYhY5gP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTYhY5gP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784144436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YCPROUZkJuywiw8KqVhtAiLvhiTjLXOoBQ3u1qlauI=;
	b=BTYhY5gPetqjHYZe5+P8NqELqUn+CkQXRxctLw+fPU4FZXVnogMf+JXYghHWX9ph+SnSAf
	ZGTq2bmPtQSY/okVrr/z117pqwCd1ElLZ21f/++O8eFn70euxyzkdV9Bopt7irCyTfa3GU
	pF63HgzCDu9BJt0+Yi5ztorD8zTwlas=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-d-zf50eYP8y9MsXBbW0EGQ-1; Wed,
 15 Jul 2026 15:40:33 -0400
X-MC-Unique: d-zf50eYP8y9MsXBbW0EGQ-1
X-Mimecast-MFC-AGG-ID: d-zf50eYP8y9MsXBbW0EGQ_1784144432
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F9BB18001F9;
	Wed, 15 Jul 2026 19:40:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DC8D1800576;
	Wed, 15 Jul 2026 19:40:31 +0000 (UTC)
Date: Wed, 15 Jul 2026 15:40:29 -0400
From: Brian Foster <bfoster@redhat.com>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v2] fstests: generic: add a basic cachestat test case
Message-ID: <alfiLTZaQeqG-7J1@bfoster>
References: <20260707113454.120001-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707113454.120001-1-wqu@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Jul 07, 2026 at 09:04:54PM +0930, Qu Wenruo wrote:
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
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Reject "sync" and "dax" mount options
>   Those mount options write back data synchronously, will screw up the
>   buffered write dirtied page reporting.
> 
> - Use AWK_PROG everywhere.
> 
> - Remove the unnecessary redirection for fsync
> ---
>  tests/generic/798     | 61 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out |  2 ++
>  2 files changed, 63 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
> 
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..8888f6a3
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,61 @@
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
> +for num_page in 1 2 4 8 16; do
> +	size=$(($pagesize * $num_page))
> +
> +	echo "=== Test with $num_page pages ===" >> $seqres.full
> +	_scratch_mkfs > /dev/null
> +	_scratch_mount
> +

Do we need a mkfs and remount for each size we're testing? It seems like
we should be able to mkfs and mount once and then just remove the file
per iteration.

> +	# Basic cached number reporting
> +	$XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" \
> +		$SCRATCH_MNT/foobar >> $seqres.full
> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
> +	cat $tmp.output >> $seqres.full
> +	cached=$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}')
> +	dirtied=$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}')
> +
> +	if [ "$cached" -ne "$num_page" ]; then
> +		_fail "cached not matching the page number"
> +	fi
> +
> +	if [ "$cached" -ne "$dirtied" ]; then
> +		_fail "dirtied not matching the page number"
> +	fi

We should expect consistent values for cached and dirtied throughout the
test, right? If so, it might be more useful (and maybe more simple) to
just print the cachestat output on each iteration and let the comparison
to the golden .out file determine pass or failure. Hm?

Brian

> +	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
> +
> +	# Test dirty page number reporting after a fsync.
> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
> +	cat $tmp.output >> $seqres.full
> +	_scratch_unmount
> +	cached=$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}')
> +	dirtied=$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}')
> +
> +	if [ "$cached" -ne "$num_page" ]; then
> +		_fail "cached not matching the page number"
> +	fi
> +	if [ "$dirtied" -ne 0 ]; then
> +		_fail "dirtied pages not zero"
> +	fi
> +done
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/generic/798.out b/tests/generic/798.out
> new file mode 100644
> index 00000000..216d6e93
> --- /dev/null
> +++ b/tests/generic/798.out
> @@ -0,0 +1,2 @@
> +QA output created by 798
> +Silence is golden
> -- 
> 2.51.2
> 
> 

