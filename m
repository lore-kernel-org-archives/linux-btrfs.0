Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbcFAN4a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 09:56:30 -0400
Date: Wed, 1 Jun 2016 15:55:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck: Add more explanation on low memory
 mode
Message-ID: <20160601135551.GA29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463710867-27127-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463710867-27127-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 10:21:07AM +0800, Qu Wenruo wrote:
> It seems the initial support for low memory mode will come in recent
> release, it's better to add more explanation on the unsupported
> functions, to avoid user reporting known bugs.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  Documentation/btrfs-check.asciidoc | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
> index 4e27863..6b09662 100644
> --- a/Documentation/btrfs-check.asciidoc
> +++ b/Documentation/btrfs-check.asciidoc
> @@ -97,7 +97,14 @@ NOTE: Do not use unless you know what you're doing.
>  check fs in low memory usage mode(experimental)
>  May takes longer time than normal check.
>  +
> -NOTE: Doesn't work with '--repair' option yet.
> +[NOTE]
> +==========================
> +As this feature is still under development, some functions are not implemented
> +yet
> +
> +- No support for '--repair' yet.
> +- Only reduce memory usage of extent tree check. No effect for fs tree yet.
> +==========================

The help text is too short to be useful, I'd like to see something more
comprehensive so the user knows what the low-mem mode does compared to
the current state.
