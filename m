Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbbHaOdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 10:33:37 -0400
Date: Mon, 31 Aug 2015 16:32:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs-progs: tests: Introduce init_env to
 initialize common env variant
Message-ID: <20150831143257.GT11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
 <d52589ea31baac23ebb0eae3b0950503d5c5d6e8.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d52589ea31baac23ebb0eae3b0950503d5c5d6e8.1440997237.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 01:04:36PM +0800, Zhao Lei wrote:
> For example, $TEST_DIR is common used in severial tests, and have
> duplicated code for initialize.
> 
> These duplicated code not only benifits harddisk vendor, but have
> inconsistent details, as:
>   convert-tests.sh: lack of mkdir
>   fsck-tests/012-leaf-corruption/test.sh: unnecessary mkdir
>   fsck-tests/013-extent-tree-rebuild/test.sh: unnecessary init
>   misc-tests/XXX ...
> And severial error message:
>   _fail "unable to create mount point on $TEST_MNT"
>   _fail "failed to create mount point"
>   ...
> 
> This patch move initizlizaton of $TEST_DIR to common init_env(),
> to avoid above problem, and init_env() can be used to add more
> things in future.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
