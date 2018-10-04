Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3183C64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 19:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6615E2083F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 19:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="mB9npKu+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6615E2083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbeJECLA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 22:11:00 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38841 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbeJECLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 22:11:00 -0400
Received: by mail-pl1-f193.google.com with SMTP id b5-v6so5641405plr.5
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2018 12:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WioljIEuoug4BBkFC6po60+HztaeXnDTzAFFrx+8HEY=;
        b=mB9npKu+EaXJJk8TIruXGJyX/DGTIeMguFKniqXY58RVYblUH6pSORrW2fUdhCr99f
         yddTog5gI4P9+Cuyf8jExXOuGKioWMPdNGgA5brWXniCjIfxz3iXV0d/qzHIBQ583cCr
         TgRhGG9rDvJlhlU1mlXCApU8Jw0SLSzcPiV5SLSv93su3HicF47IJglXU8qiGeZGeM77
         UnRdrS9aRm/F5kIscnrcs2eOyAFqPXeImAw0+geOGcZI3UzVV+a44idN2+9bUddv+wQa
         EebZfZMPltWA4YPspLWf3qmjo5qWLsBTB0wgekD24Og4Snn9r4WojeENAQE9yq9nwDCh
         vO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WioljIEuoug4BBkFC6po60+HztaeXnDTzAFFrx+8HEY=;
        b=LyeMWfT1kJN0I8Nqkk5CSiXtWRiNRXF6w5BjdbqmcG4ZxpwQyvhxkwD+6p1AjT09kD
         cYWPCm/FcYawnaTYdOwuzhlgVUFUwdogmRKOlafRURfn9867W7178atO7htLwO7P/FAk
         VuL0nlUfqbYpOLnv1yk1FQkuoON3xXToWmodaQt5ZZK8iDc2FkGD1/ubwihD2uUs5fQK
         IO0LUe9ek/UbnHeW9HhWGFFCZOeqiUYls/eot1RhcW0bJX7+8EjMuzJwpTGNtWDLM9Ll
         vEYcK3t4PXfVMOdPF/oJXahyZZtUEmMqEZuPFX+1Yg4jbSCrnkutHxMd5qvdJF/dBAuF
         7izQ==
X-Gm-Message-State: ABuFfohHqF4yYYqnliswllIGIbxeae6Gcgq3lO/I+g+n934Z7tK2em3x
        LkTOH+WkUINza/82W37ue2fmKg4rdU8=
X-Google-Smtp-Source: ACcGV60BqDSvHWGFj3msegxGrCgnHsU1D0mLTNRT4afKUNErGoKrIBu0cdwwOHc2u9cuenvjMeVIWA==
X-Received: by 2002:a17:902:9b84:: with SMTP id y4-v6mr8095582plp.332.1538680581504;
        Thu, 04 Oct 2018 12:16:21 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::7:7e9a])
        by smtp.gmail.com with ESMTPSA id o24-v6sm8684680pfa.90.2018.10.04.12.16.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 12:16:20 -0700 (PDT)
Date:   Thu, 4 Oct 2018 12:16:19 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/10] btrfs-progs: check: Add support for freespace tree
 fixing
Message-ID: <20181004191619.GH25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-9-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-9-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:19PM +0300, Nikolay Borisov wrote:
> Now that all the prerequisite code for proper support of free space
> tree repair is in, it's time to wire it in. This is achieved by first
> hooking the freespace tree to the __free_extent/alloc_reserved_tree_block
> functions. And then introducing a wrapper function to contains the
> existing check_space_cache and the newly introduced repair code.
> Finally, it's important to note that FST repair code first clears the
> existing FST in case of any problem found and rebuilds it from scratch.

Reviewed-by: Omar Sandoval <osandov@fb.com>

A couple of really trivial nitpicks below that you should feel free to
ignore ;)

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  check/main.c | 47 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index b361cd7e26a0..4daf85aad82c 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -5392,14 +5392,6 @@ static int check_space_cache(struct btrfs_root *root)
>  	int ret;
>  	int error = 0;
>  
> -	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
> -	    btrfs_super_generation(root->fs_info->super_copy) !=
> -	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
> -		printf("cache and super generation don't match, space cache "
> -		       "will be invalidated\n");
> -		return 0;
> -	}
> -
>  	while (1) {
>  		ctx.item_count++;
>  		cache = btrfs_lookup_first_block_group(root->fs_info, start);
> @@ -9417,7 +9409,6 @@ static int do_clear_free_space_cache(struct btrfs_fs_info *fs_info,
>  			ret = 1;
>  			goto close_out;
>  		}
> -		printf("Clearing free space cache\n");

Just out of curiosity, why did you delete this message? The one in the
v2 case is still there.

>  		ret = clear_free_space_cache(fs_info);
>  		if (ret) {
>  			error("failed to clear free space cache");
> @@ -9444,6 +9435,35 @@ static int do_clear_free_space_cache(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> +static int validate_free_space_cache(struct btrfs_root *root)

At first glance, I wouldn't know what the difference is between
check_space_cache() and validate_free_space_cache(); they sound like the
same thing. Maybe rename this to check_and_repair_space_cache() or just
fold the rebuild into check_space_cache(), to be more in line with the
other check steps in fsck?
