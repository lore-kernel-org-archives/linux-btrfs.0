Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83408C00449
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 15:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D6C20841
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 15:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pd3dTwsn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49D6C20841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbeJGW0G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 18:26:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44793 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbeJGW0G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 18:26:06 -0400
Received: by mail-pg1-f193.google.com with SMTP id g2-v6so6704750pgu.11;
        Sun, 07 Oct 2018 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pOD8vCtbd/3wLAT53HXJlvsdyTW3bfTvnXiBtqIabpI=;
        b=Pd3dTwsneJIU+7Js71vx6TQmJlpZE1AIbSOlnlzKs8YwBoj2B8oitQIMVLe5rz2iyp
         we+9PCJiImzIkKtBix31p4Uqlf4Pd3h9NqR3Wn+zi1OCLbXTDeyyKS1gCIkL0S1Q1nXr
         hR9Qt79k0O7+QLCZV0Wjh8/34YQRlYAf4OQO7ERXU/ZGesgY+C9bAZxNJCCxtCEU9ik0
         bvs87aaEEwvGYgTj1MXdFTK408sYLUScTzDHU9eYPk3ZPXPXhuXbyYizqgTq6/1/XvBQ
         lRsw6kZzFCp8GKSKXUYWZpnBE0Ec2aMQjcaJOkxo9g2rkPL3hNvjOmo40VzI8Pg2//o5
         iQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pOD8vCtbd/3wLAT53HXJlvsdyTW3bfTvnXiBtqIabpI=;
        b=Kg7VZ8T3aXPBHdSe763swZnObjdtUyBN0TZMugrGJ75qRV8X5gtn3zBXISLcnEltep
         g+LH93FQYFGXoSFyYAIxXWMsDmeYopWwmo4X2B0XRhZt7kA9/cr8ub/INtRza/DLZO8Q
         7dLB0M1RNat787m3jFctMEbUc1mKilB/GG8gkzGBv3sGzXHlLr7WP4Iyi+1hLKLwVsS2
         wyFa5Fvjo8LYSYdxx5aejkzuxgIB9i8bh5fyMLhyeqNTMWkMLKH7r1ue8Yl6Lb9Qu5xZ
         0Jwnh+FRh+v6qUuf+VeY/FGXouVKxb2xvyQPOt5T9TJd2bFJmu0bLPzoFdWdFVOgWaN6
         PdaA==
X-Gm-Message-State: ABuFfojUc5f0fENejWVGtf43WzVHFweoaEYJN9ypOPc/Kq6t7yysmnP8
        2dz0woVVVkNwcXl91Ibm9oE=
X-Google-Smtp-Source: ACcGV62AHsgVAauMR+fQDzSDGnDPHpMoIHhjF3EuOFAZ4WeUatahDEN76m8h5QVJE0/UxtsRBktBTw==
X-Received: by 2002:a63:e601:: with SMTP id g1-v6mr17937916pgh.290.1538925510706;
        Sun, 07 Oct 2018 08:18:30 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id f1-v6sm25064604pgc.4.2018.10.07.08.18.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 07 Oct 2018 08:18:30 -0700 (PDT)
Date:   Sun, 7 Oct 2018 23:18:21 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/9] generic/102 open code dev_size
 _scratch_mkfs_sized()
Message-ID: <20181007151821.GP17817@desktop>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-6-git-send-email-anand.jain@oracle.com>
 <6bdc26df-7beb-53dd-69a2-c3d1789cf3c9@suse.com>
 <d5e4b2ef-6e8b-f760-9e5a-13c93533abb2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5e4b2ef-6e8b-f760-9e5a-13c93533abb2@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 12:08:56PM +0800, Anand Jain wrote:
> 
> 
> On 09/25/2018 06:54 PM, Nikolay Borisov wrote:
> > 
> > 
> > On 25.09.2018 07:24, Anand Jain wrote:
> > > Open code helps to grep and find out parameter sent to the
> > > _scratch_mkfs_sized here.
> > > 
> > > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > 
> > IMO this is noise, you can just as simply do
> > "grep _scratch_mkfs_sized" and then open the file to inspect the actual
> > argument. But it's up to the xfstest maintainers
> 
>  I am ok. Its just a nice cleanup.
> 
> Thanks, Anand

I prefer dropping patch 5/6/7, as I don't think they're that necessary.

BTW, other patches from this series but patch 3 ("geneirc/077 fix min
size for btrfs") look fine to me, I'm taking them in this week's update.

Thanks,
Eryu

> 
> > > ---
> > >   tests/generic/102 | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/tests/generic/102 b/tests/generic/102
> > > index faf940ac5070..aad496a5bc69 100755
> > > --- a/tests/generic/102
> > > +++ b/tests/generic/102
> > > @@ -31,8 +31,7 @@ _require_scratch
> > >   rm -f $seqres.full
> > > -dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
> > > -_scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
> > > +_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
> > >   _scratch_mount
> > >   for ((i = 0; i < 10; i++)); do
> > > 
