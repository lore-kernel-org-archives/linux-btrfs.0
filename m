Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753274AbdGLVwg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 17:52:36 -0400
Date: Wed, 12 Jul 2017 23:51:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Enable ThreadSanitizer, using D=tsan.
Message-ID: <20170712215122.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712200449.18638-1-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712200449.18638-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 01:04:49PM -0700, Adam Buchbinder wrote:
> Tested with clang-3.9.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> ---
>  Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 81598df..8948301 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -17,6 +17,7 @@
>  #                  abort   - call abort() on first error (dumps core)
>  #                  all     - shortcut for all of the above
>  #                  asan    - enable address sanitizer compiler feature
> +#                  tsan    - enable thread sanitizer compiler feature
>  #                  ubsan   - undefined behaviour sanitizer compiler feature
>  #                  bcheck  - extended build checks
>  #   W=123          build with warnings (default: off)
> @@ -157,6 +158,11 @@ ifneq (,$(findstring asan,$(D)))
>    DEBUG_CFLAGS_INTERNAL += -fsanitize=address
>  endif
>  
> +ifneq (,$(findstring tsan,$(D)))
> +  DEBUG_CFLAGS_INTERNAL += -fsanitize=thread -fPIE
> +  LD_FLAGS += -fsanitize=thread -ltsan -pie

Why do you need to set PIE here? Is is necessary for tsan?

> +endif
> +
>  ifneq (,$(findstring ubsan,$(D)))
>    DEBUG_CFLAGS_INTERNAL += -fsanitize=undefined
>  endif
> -- 
> 2.13.2.932.g7449e964c-goog
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
