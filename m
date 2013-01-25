Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:53053 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3AYL5q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 06:57:46 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130125115745.YAO17456.eastrmfepo201.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 25 Jan 2013 06:57:45 -0500
Message-ID: <51027339.9030604@czarc.net>
Date: Fri, 25 Jan 2013 06:57:45 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs-progs: remove btrfsctl, btrfs-show and btrfs-vol
 from default build
References: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2012 02:00 PM, Stefan Behrens wrote:
> Remove btrfsctl, btrfs-show and btrfs-vol from "all" target of Makefile.
>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>   Makefile |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index aaf1381..79e7a56 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -18,7 +18,7 @@ bindir = $(prefix)/bin
>   LIBS=-luuid
>   RESTORE_LIBS=-lz
>
> -progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
> +progs = mkfs.btrfs btrfs-debug-tree btrfsck \
>   	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
>   	btrfs-find-root btrfs-restore btrfstune
>
>
I agree.  It is time to remove these old programs; they serve no useful 
purpose; and they complicate maintenance.

Gene
