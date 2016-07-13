Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46742 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcGMF1A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 01:27:00 -0400
Date: Tue, 12 Jul 2016 22:26:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: FIDEDUPERANGE with src_length == 0
Message-ID: <20160713052643.GD13625@birch.djwong.org>
References: <20160712003537.GA27653@vader.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160712003537.GA27653@vader.dhcp.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 05:35:37PM -0700, Omar Sandoval wrote:
> Hey, Darrick,
> 
> generic/182 is failing on Btrfs for me with the following output:
> 
> --- tests/generic/182.out       2016-07-07 19:51:54.000000000 -0700
> +++ /tmp/fixxfstests/xfstests/results//generic/182.out.bad      2016-07-11 17:28:28.230039216 -0700
> @@ -1,12 +1,10 @@
>  QA output created by 182
>  Create the original files
> -dedupe: Extents did not match.
>  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
>  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
>  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
>  Compare against check files
>  Make the original file almost dedup-able
> -dedupe: Extents did not match.
>  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
>  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
>  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk
> 
> It looks like that test is checking that a dedupe with length == 0 is
> treated as a dedupe to EOF, but Btrfs doesn't do that [1]. As far as I
> can tell, it never did, but maybe I'm just confused. What was the
> behavior when you introduced that test? That seems like a reasonable
> thing to do, but I wanted to clear this up before changing/fixing Btrfs.

It's a shortcut that we're introducing in the upcoming XFS implementation,
since it shares the same back end as clone/clonerange, which both have
this behavior.

--D

> 
> Thanks.
> 
> 1: http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/ioctl.c?h=v4.7-rc7#n3122
> -- 
> Omar
