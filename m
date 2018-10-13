Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC74C6787C
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA6820868
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lffQkI5U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAA6820868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbeJMIbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 04:31:23 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:54123 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbeJMIbX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 04:31:23 -0400
Received: by mail-it1-f195.google.com with SMTP id q70-v6so21359687itb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 17:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwnI3RJPfLZxh2WwTbmHr/8ZiekiuZhfutxziplanLc=;
        b=lffQkI5UgZXPKqu442UTAk6/7/7uZIwm9ycs8E7VAYpLhqyz+yawfqklRKSxZV9BMW
         KpkSShVgexS8jPy13k4q3+sMD8LKWcbi1XVzdmaoRhD7CUJnZNXRsLYIvaFvCMeYg53a
         zyn5YMHLrmgbwQJyqwLRMZkSKl6a60B4nyUSqYPna5RpcqWrVfo2byIGuO9naReuLM3a
         QQ0DjfNdsbtd/g8zduIR90uI82y7TwJMF7BCXsEZzdYLwZX1Y5d66viYYp9yDsUaBzH5
         TWl6MMGmBRuvccWeM6JnlEIv0CNCNo0IrQ6VNIiTg7uVg57Bwz1mf47S+PwjGVb2Ysdf
         2G/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwnI3RJPfLZxh2WwTbmHr/8ZiekiuZhfutxziplanLc=;
        b=secWGOsgoq3b0Zz8YzbnwZQ+cYRns59gzTP3Rf4yDN3lFml9k6kUrlusnY5YAE9kz7
         cwQKO59sJZOhp0qO595F8M2QYI2us8+tmXW8aMmAny2CEXfKd03IizOVyplw8+YUHt8O
         zM7ogy4GLSFsmqn9IAoHu77cW7RmtkEpcQL+tIdGZD/xayOy4kUvRbjHtoGB14NSCzCw
         aoTc9YZ+WJkQOy04UrL0x820Fqh4h3lKldLkGUIVycZfj5pQi/N/Ki5WnrSv+Cu0eeqm
         SIQNLyLGJRMoleA7bZX2ZtdjoE/U18/Uv44+k+lid8e5bPZ+aXZhx3ns7od1Wzy/6abJ
         iNfQ==
X-Gm-Message-State: ABuFfojyDQiSnpz1Jn6/BzOth2vNc7tm4b2OzJCKCESrxJsFijJBd4+F
        z81VAy/QywV37eMpYbDZipB6VGJwU01JTQ8UmU8=
X-Google-Smtp-Source: ACcGV62KP+/TJfHmCnAHdjXbWXbRW7mMwf6TWUbcbYcFlyqGsgPD9sD9QxG5uWToT3TrUAxN/mp95GNmLrxQBkbx2rs=
X-Received: by 2002:a24:4cc2:: with SMTP id a185-v6mr6255561itb.81.1539392181354;
 Fri, 12 Oct 2018 17:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20181012204544.27137-1-fdmanana@kernel.org> <20181012233725.27290-1-fdmanana@kernel.org>
In-Reply-To: <20181012233725.27290-1-fdmanana@kernel.org>
From:   Liu Bo <obuil.liubo@gmail.com>
Date:   Fri, 12 Oct 2018 17:56:10 -0700
Message-ID: <CANQeFDCb67Uv6dyL2cGGx99oxKOEB-_HpRLOKTzgn72WDHzXGA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix null pointer dereference on compressed
 write path error
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 4:38 PM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> At inode.c:compress_file_range(), under the "free_pages_out" label, we can
> end up dereferencing the "pages" pointer when it has a NULL value. This
> case happens when "start" has a value of 0 and we fail to allocate memory
> for the "pages" pointer. When that happens we jump to the "cont" label and
> then enter the "if (start == 0)" branch where we immediately call the
> cow_file_range_inline() function. If that function returns 0 (success
> creating an inline extent) or an error (like -ENOMEM for example) we jump
> to the "free_pages_out" label and then access "pages[i]" leading to a NULL
> pointer dereference, since "nr_pages" has a value greater than zero at
> that point.
>
> Fix this by setting "nr_pages" to 0 when we fail to allocate memory for
> the "pages" pointer.
>

Looks good.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201119
> Fixes: 771ed689d2cd ("Btrfs: Optimize compressed writeback and reads")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>
> V2: Updated changelog.
>
>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 66c6c4103d2f..d6b61b1facdd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -503,6 +503,7 @@ static noinline void compress_file_range(struct inode *inode,
>                 pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
>                 if (!pages) {
>                         /* just bail out to the uncompressed code */
> +                       nr_pages = 0;
>                         goto cont;
>                 }
>
> --
> 2.11.0
>
