Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaEWJbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 05:31:43 -0400
Date: Fri, 23 May 2014 11:39:36 +0200
From: David Disseldorp <ddiss@suse.de>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfstests: add helper require function
 _require_btrfs_cloner
Message-ID: <20140523113936.6dace4f7@f163.suse.de>
In-Reply-To: <1400817931-32326-1-git-send-email-fdmanana@gmail.com>
References: <1400817931-32326-1-git-send-email-fdmanana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 23 May 2014 05:05:30 +0100, Filipe David Borba Manana wrote:

> So that the same check (btrfs cloner program presence) can be reused
> by other tests.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  common/rc       | 7 +++++++
>  tests/btrfs/035 | 4 +---
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index d1788d1..f27ee53 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2085,6 +2085,13 @@ _require_fssum()
>  	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
>  }
>  
> +_require_btrfs_cloner()
> +{
> +	CLONER_PROG=$here/src/cloner
> +	[ -x $CLONER_PROG ] || \
> +		_notrun "cloner binary not present at $CLONER_PROG"
> +}

Would prefer to avoid the reliance on $here, but it appears that other
common/rc functions make the same assumption.

Reviewed-by: David Disseldorp <ddiss@suse.de>

Cheers, David
