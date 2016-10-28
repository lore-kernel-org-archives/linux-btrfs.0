Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752728AbcJ1Cyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:54:50 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4134F61B98
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 02:54:50 +0000 (UTC)
Received: from Liberator.local (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9S2snPp018131
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 22:54:50 -0400
Subject: Re: [PATCH] btrfs-progs: fix build for programs including ioctl.h
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <343f2d64-948b-9653-18eb-76ae2e852b88@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ae29e753-b1fc-f433-d498-bc50209bfa8d@redhat.com>
Date: Thu, 27 Oct 2016 21:54:49 -0500
MIME-Version: 1.0
In-Reply-To: <343f2d64-948b-9653-18eb-76ae2e852b88@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/13/16 12:36 PM, Eric Sandeen wrote:
> This was reported when docker failed to build against
> btrfs-progs v4.8.1.
> 
> It includes ioctl.h which now calls BUILD_ASSERT(), which
> is defined in kerncompat.h, which was not included in the
> ioctl.h header file.

Ping?

-Eric
 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/ioctl.h b/ioctl.h
> index a7235c0..abea7ed 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -26,6 +26,12 @@ extern "C" {
>  #include <asm/types.h>
>  #include <linux/ioctl.h>
>  
> +#if BTRFS_FLAT_INCLUDES
> +#include "kerncompat.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
> +
>  #ifndef __user
>  #define __user
>  #endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

