Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932889AbeD0TSU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 15:18:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A0666ACAE
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 19:18:19 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: build: use m4_flatten instead of
 m4_chomp
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20180427185637.16642-1-jeffm@suse.com>
 <20180427185637.16642-4-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <75b17e5e-520f-7c23-b592-047e2b150474@suse.com>
Date: Fri, 27 Apr 2018 15:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <20180427185637.16642-4-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/27/18 2:56 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 2e1932e6a38 (btrfs-progs: build: simplify version tracking)
> started m4_chomp to strip the newlines from the version file.  m4_chomp
> was introduced in autoconf 2.64 but SLE11 ships with autoconf 2.63.
> For purposes of just stripping the newline, m4_flatten is sufficient.

Scratch that.  The previous patch also requires autoconf 2.64.

-Jeff

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 17880206..a0cebf15 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1,5 +1,5 @@
>  AC_INIT([btrfs-progs],
> -	m4_chomp(m4_include([VERSION])),
> +	m4_flatten(m4_include([VERSION])),
>  	[linux-btrfs@vger.kernel.org],,
>  	[http://btrfs.wiki.kernel.org])
>  
> 


-- 
Jeff Mahoney
SUSE Labs
