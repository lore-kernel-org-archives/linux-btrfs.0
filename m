Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab3JPQLv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 12:11:51 -0400
Date: Wed, 16 Oct 2013 09:11:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, dsterba@suse.cz,
        jbacik@fusionio.com
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
Message-ID: <20131016161150.GA12895@infradead.org>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 16, 2013 at 03:04:56PM +0100, Filipe David Borba Manana wrote:
> This test is motivated by an issue found by a btrfs user, addressed
> and described by the following GNU/Linux kernel patch:

Might be a little too nipicky, but there's no "GNU/Linux" kernel, it's
just Linux.

As for the test: thanks a lot for sending it a long here, but can you
please create a new testcase for the specific inheritance bug instead
of adding it to an existing test case?

>  # real QA test starts here
> -_supported_fs xfs udf
> +_supported_fs xfs udf btrfs

Of course enabling the existing tests for btrfs is still fine (although
it should be a second patch)

> -chacl $acl3 largeaclfile
> +if [ "$FSTYP" != "btrfs" ]; then
> +	chacl $acl3 largeaclfile
> +else
> +	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
> +fi

Does btrfs support unlimited ACLs?  If not we should test one above the
limit here.

