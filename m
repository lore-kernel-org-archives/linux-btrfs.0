Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E7BC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 19:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68242083F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 19:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="LmBHone7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D68242083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbeJECNI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 22:13:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36251 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbeJECNI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 22:13:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id b7-v6so3858515pfo.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2018 12:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+wyfotJO5u3mxD7XsvzQhGlbx+YcBsREeDUqWIXKfyU=;
        b=LmBHone7jKrk8XeH5eWiMr1caJp52P0B7dVLA4eHEyrlWySxOiOCcDy7FbMJ7PWjlu
         yQoM3jmQKckksRXECQn3MBTVaeobcjQhEgUTPUBDVBN+YnUsaNU5XAFKW018nvq6/494
         YPd/nx6b08A634rjUFtDDd9zK7gUkBoMd9CnouopnCdNczw2LzsY70U9FCnr8JkL5KJh
         yNTrATYyLYcCXI3C8hGQIhASMyWw6rXigWSiXYujr+Fk0pYFNT3GLuTMsI6HVnP3Lmgu
         xnv/BMFLyulNFR3wzR0bvXsyBZoetCwXTr9UXyzG7kSj1SLcTV3N8LFFRqMy2CohzLph
         E10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+wyfotJO5u3mxD7XsvzQhGlbx+YcBsREeDUqWIXKfyU=;
        b=BOY10qKB1RZ4yxcXwVaTU1H2JJCI0XspQz6AOvItdiwKx9lSmEkfL3z70k3M3Yo5U3
         WSfdWCg60x/N0qBZnWsXuy/5tXasagdEHnapSedRIbIE9eKFNmtrqRkTwhTAB8EbxWyq
         VzhOnXXBRkPL+R8LvwaUIWlU6mZrUG31O7KNVbdeOjrptMsXW1CqWRRYnbMrQSTjAemZ
         Op5N6BgZgwuRsAo5jd/2HvmUw9/62OuRylecSzLE0zrIvE/SlALHndm5daE5KcWbvRzs
         CeGY+YgxgtlVWfYlqM9EuvxiaJIjxzftAKkcKFfhzIf8fhYtU2bPyjkDwxZxxZIhyNk7
         tnJA==
X-Gm-Message-State: ABuFfohPmzHmMqaDfd5v4kD/AILThIlwJkhcVIQU30Z2LJiLhfC9i8uC
        soasSp4q5xoddd025Hif5l5AMw==
X-Google-Smtp-Source: ACcGV63UteeU8SUzz+yuDb9r0uDSeynZO/ZAJtViJmr2zz5iFDCBks/ZBaR8Meqhaufuxs9YBzNMGA==
X-Received: by 2002:a63:5558:: with SMTP id f24-v6mr7142002pgm.37.1538680709530;
        Thu, 04 Oct 2018 12:18:29 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::7:7e9a])
        by smtp.gmail.com with ESMTPSA id r1-v6sm8540281pff.145.2018.10.04.12.18.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 12:18:28 -0700 (PDT)
Date:   Thu, 4 Oct 2018 12:18:28 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] btrfs-progs: check: Fix wrong error message in
 case of corrupted bitmap
Message-ID: <20181004191828.GI25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-11-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-11-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:21PM +0300, Nikolay Borisov wrote:
> Similarly to the fix in e444c7bfa65f ("btrfs-progs: check: Fix wrong
> error message in case of corrupted extent") this commits addresses the
> same problem but for corrupted bitmap objects.

Oops.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  free-space-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/free-space-tree.c b/free-space-tree.c
> index 3b7e8a3fe4f5..690da44a739d 100644
> --- a/free-space-tree.c
> +++ b/free-space-tree.c
> @@ -1302,7 +1302,7 @@ static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
>  		if (key.objectid + key.offset > end) {
>  			fprintf(stderr,
>  	"free space bitmap ends at %llu, beyond end of block group %llu-%llu\n",
> -				key.objectid, start, end);
> +				key.objectid + key.offset, start, end);
>  			(*errors)++;
>  			break;
>  		}
> -- 
> 2.7.4
> 
