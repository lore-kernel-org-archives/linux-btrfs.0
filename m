Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36637 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934646AbcJ0R7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 13:59:01 -0400
Received: by mail-pf0-f182.google.com with SMTP id e6so21740977pfk.3
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 10:59:01 -0700 (PDT)
Date: Thu, 27 Oct 2016 10:58:59 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Ignore clang complete file
Message-ID: <20161027175859.GA10692@vader.DHCP.thefacebook.com>
References: <20161027023248.19561-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161027023248.19561-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2016 at 10:32:48AM +0800, Qu Wenruo wrote:
> While most guys are using ctags and cscope with vim, new completion tool
> like vim-clang_completion is gaining its popularity, due to its compiler
> level accuracy simpleness to use.
> 
> Since ctags and cscope are already in .gitignore, I see no reason to
> reject .clang_complete.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 214103d..98b3657 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -64,6 +64,7 @@ config/py-compile
>  config/test-driver
>  configure
>  cscope.out
> +.clang_complete
>  depcomp
>  libtool
>  Makefile
> -- 
> 2.10.1

You can always just add .clang_complete to .git/info/exclude.

-- 
Omar
