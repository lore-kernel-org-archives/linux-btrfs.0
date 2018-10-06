Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B14C65BD0
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 11:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7CCA2147D
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 11:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJo0GArQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7CCA2147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbeJFS2G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 14:28:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41150 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeJFS2G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 14:28:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id q17-v6so7996422plr.8;
        Sat, 06 Oct 2018 04:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1rsGdFt+MWBNhZP10kWU8mb2gyofwJSnnl4HadGsJes=;
        b=PJo0GArQ2G3+diZmMMiTkaRRsB06y+VdxhLQ6jHJVDKU0NPKUfGmkq8YDQ9XpDnbvl
         kHYTKxS8n4Pk6hkY1GdcwVzJ3f+TsbhQzQCTK+oaI7prc5wKpqyEx2+HF+b3Gx5DjnRe
         Ji7oH2PgbYBsjb3u7yKY6Xdx82PNFICcMT0qamxnnp+dpGKJydktnm38PDs34eTxJAEC
         F1kH35ggE09Q0yVMaVYStyYI0wVGghwOBUrrBJgaIzgQdoov/H2LBMJ5uLmHF+osUntB
         yQQHixlUnmuPyrj7aB3iiHPrYVHdDWSfHmKYWhAFM5NdXANHxlThZECukabzxfe/DEjG
         k4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1rsGdFt+MWBNhZP10kWU8mb2gyofwJSnnl4HadGsJes=;
        b=mSFVzQPPPan4oLODKxE1z0V3jFwCKLD9lPPIxChp8bYvZfZt1nobwm92ZaLoGo9ZcW
         d6gPboQ3bCY4oMZblIAlgXa+HVq2eNuVs2Xm1hL2g9R0PW2zKNHWRD4d46Qaqf61U/qg
         otcJUoVJJAABp+7dkTDv16uMTFs5+2TZf+rbzoA5WveGTPHFY8bZv0sAEhCyhu+BaBiQ
         t1YTTsAJkUn0OSzf9jh2+1OFjlWTQa9npm4bOHCPKeTym8QaEIIw0IQTW9Gmp0eZDWXX
         js3Ct5hLgQYJIEzOV0od5DQ4grJxyt5qbjC93bwALZ+pqaLkOAvx1XiJKGkpFy1F2zBR
         gNMA==
X-Gm-Message-State: ABuFfogj1kZObYU9gIdNERbkHRXxl9lbL0gH542UtXPTMV007JO/eXFz
        EV+KHUGi3DZC5UtihpTdXWMjK4c2+PE=
X-Google-Smtp-Source: ACcGV614VSEoVBJhEIn1SZYPTdIXK++u4oyFpQO+MC6Oqwc53AHxseK7EsPdCYmKk4P5++fFTfvo/A==
X-Received: by 2002:a17:902:a50e:: with SMTP id s14-v6mr15631941plq.78.1538825113235;
        Sat, 06 Oct 2018 04:25:13 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id v63-v6sm12667930pgd.69.2018.10.06.04.25.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Oct 2018 04:25:12 -0700 (PDT)
Date:   Sat, 6 Oct 2018 19:25:07 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/9] geneirc/077 fix min size for btrfs
Message-ID: <20181006112507.GL17817@desktop>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537849462-619-4-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 25, 2018 at 12:24:16PM +0800, Anand Jain wrote:
> If btrfs need to be tested at its default blockgroup which is non-mixed,
> then it needs at least 256mb.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

(Sorry for the late review..)

> ---
>  tests/generic/077 | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tests/generic/077 b/tests/generic/077
> index ef6af18c83e3..ec236992513f 100755
> --- a/tests/generic/077
> +++ b/tests/generic/077
> @@ -49,8 +49,7 @@ rm -f $seqres.full
>  _scratch_unmount >/dev/null 2>&1
>  echo "*** MKFS ***"                         >>$seqres.full
>  echo ""                                     >>$seqres.full
> -SIZE=`expr 50 \* 1024 \* 1024`
> -_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
> +_scratch_mkfs_sized $((256 * 1024 *1024))   >>$seqres.full 2>&1 \
>  	|| _fail "mkfs failed"

Hmm, this test copies "/lib/modules/" to fill the original 50M
filesystem (which seems a bad way to me)

"
# Something w/ enough data to fill 50M of fs...
filler=/lib/modules/
...
echo "*** populate filesystem, pass #1" | tee -a $seqres.full
cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
...
"

It works most of the time as "/lib/modules" is usually larger than 50M,
but it may not fullfil the fs with 256M size.

I think we should fix the way to fill the fs too.

Thanks,
Eryu

>  _scratch_mount
>  mkdir $SCRATCH_MNT/subdir
> -- 
> 1.8.3.1
> 
