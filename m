Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1B7C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 21:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A01862173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 21:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfC1Vz0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:55:26 -0400
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:17335 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbfC1VzZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 17:55:25 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 29 Mar 2019 08:25:22 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h9czZ-0008Du-6P; Fri, 29 Mar 2019 08:55:21 +1100
Date:   Fri, 29 Mar 2019 08:55:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 5/7] fsstress: allow afsync on directories too
Message-ID: <20190328215521.GN26298@dastard>
References: <20190328185458.29033-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328185458.29033-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 06:54:58PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently the afsync function can only be performed against regular files.
> Allow it to operate on directories too, to increase test coverage and allow
> for chances of finding bugs in the filesystem implementation of fsync
> against directories.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  ltp/fsstress.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index ffe78ef7..0fb9e399 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -1767,15 +1767,21 @@ afsync_f(int opno, long r)
>  	struct iocb	iocb;
>  	struct iocb	*iocbs[] = { &iocb };
>  	struct io_event	event;
> +	DIR             *dir = NULL;
>  
>  	init_pathname(&f);
> -	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
>  		if (v)
>  			printf("%d/%d: afsync - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
>  	fd = open_path(&f, O_WRONLY | O_DIRECT);
> +	if (fd < 0 && errno == EISDIR) {
> +		dir = opendir_path(&f);
> +		if (dir)
> +			fd = dirfd(dir);
> +	}

You've added this pattern to about 5 functions now. Please factor
the whole getname/open thing into a helper that can be used
everywhere....

>  	e = fd < 0 ? errno : 0;
>  	check_cwd();
>  	if (fd < 0) {
> @@ -1783,6 +1789,8 @@ afsync_f(int opno, long r)
>  			printf("%d/%d: afsync - open %s failed %d\n",
>  			       procid, opno, f.path, e);
>  		free_pathname(&f);
> +		if (dir)
> +			closedir(dir);
>  		return;
>  	}
>  
> @@ -1791,24 +1799,24 @@ afsync_f(int opno, long r)
>  		if (v)
>  			printf("%d/%d: afsync - io_submit %s %d\n",
>  			       procid, opno, f.path, e);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto out;
>  	}
>  	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>  		if (v)
>  			printf("%d/%d: afsync - io_getevents failed %d\n",
>  			       procid, opno, e);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		goto out;
>  	}
>  
>  	e = event.res2;
>  	if (v)
>  		printf("%d/%d: afsync %s %d\n", procid, opno, f.path, e);
> +out:
>  	free_pathname(&f);
> -	close(fd);
> +	if (dir)
> +		closedir(dir);
> +	else
> +		close(fd);

Same here for close.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
