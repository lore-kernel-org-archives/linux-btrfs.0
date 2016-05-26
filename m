Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcEZIIg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 04:08:36 -0400
Date: Thu, 26 May 2016 01:08:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/7] xfs/104: don't enospc when ag metadata overhead grows
Message-ID: <20160526080835.GB20307@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <146424222875.6278.15144771781299434088.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146424222875.6278.15144771781299434088.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +for i in `seq 125 -1 90`; do
> +	fillsize=`expr $i \* 1048576`
> +	out="$(_fill_scratch $fillsize 2>&1)"
> +	echo "$out" | grep -q 'No space left on device' && continue
> +	test -n "${out}" && echo "$out"
> +	break
> +done

That's a bit of an odd loop, and it would seem an inverted grep
would seem more obvious.  But otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
