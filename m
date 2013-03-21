Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab3CUJI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 05:08:26 -0400
Message-ID: <514ACE06.7050001@redhat.com>
Date: Thu, 21 Mar 2013 04:08:22 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: zwu.kernel@gmail.com
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] btrfs-progs: fix one bracket issue in mkfs.btrfs manpage
References: <1363850237-21276-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1363850237-21276-1-git-send-email-zwu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/21/13 2:17 AM, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   In "[ \fB\-f\fP\fI ]", the "\fI" will result in the front half "["of
> "[ -f ]" doesn't the back half "]"; When you issue the command
> "man mkfs.btrfs", you will see the difference.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Whoops, yes. Thanks for spotting that.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/mkfs.btrfs.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
> index cdccd6a..a3f1503 100644
> --- a/man/mkfs.btrfs.8.in
> +++ b/man/mkfs.btrfs.8.in
> @@ -6,7 +6,7 @@ mkfs.btrfs \- create a btrfs filesystem
>  [ \fB\-A\fP\fI alloc-start\fP ]
>  [ \fB\-b\fP\fI byte-count\fP ]
>  [ \fB\-d\fP\fI data-profile\fP ]
> -[ \fB\-f\fP\fI ]
> +[ \fB\-f\fP ]
>  [ \fB\-l\fP\fI leafsize\fP ]
>  [ \fB\-L\fP\fI label\fP ]
>  [ \fB\-m\fP\fI metadata profile\fP ]
> 

