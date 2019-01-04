Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A04C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 03:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB5F2070D
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 03:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="gqbZ3I5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfADDnS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 22:43:18 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:43358 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfADDnS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 22:43:18 -0500
Received: by mail-lj1-f173.google.com with SMTP id q2-v6so31403929lji.10
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2019 19:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PLTvlhpe7OKbGpE8w5/FGHLvUCvJ3acV14YiPsEV8yE=;
        b=gqbZ3I5t+168quDkYwNNykzDsoFMGj2ouIqXwjcGWPk7uGrFHbBXKiE+W7Q6JnECeo
         +8RROQz2A7C0RtOar7QpZJcAAVxqZHwXvOi+cSbeK9Nis/dgGDUe5nopnhFLfXURfA0+
         gxJC5Cd728Wd6rFAE25lmCNb7+GlMEFRR1KVgmIuxK2tFlqUUjhLLkT3r1ppJxYXFbWF
         KRJzJ8Cu2lHSyDJTT9TdxeLzxPq1npQ4xZJ9hFnH1rbDN7KBggQxvfoVLHFS3LLksZTS
         M048vk3Y3TDQXTm29QyMKm/a0r7xeCCowVImPhaMrH+P7PolKVXgVviYrLLXvdte+6Le
         gQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PLTvlhpe7OKbGpE8w5/FGHLvUCvJ3acV14YiPsEV8yE=;
        b=HyfTuaczZE28bg9y+9nUOF4LCWonXbfo3sFx6OH0zYKHl1j/KUo87rRO7VaQhsOdmV
         oH6a5JwjLNK/ap8o1UScH5DG5Jf8rksm3TmUyBETGpI+oyEJA05ojf6NBkyaZdivZYsF
         RC1lWrZPEzJ/HNhVZT1GGpVvB2Ht3kt4N67/r6kAoUV/10zAZ/5hkq/7yxnmWRDKLGCR
         f9u6OzSHE7+n7yRWQeXraNjPk7XTkZSwCDlNnI+RUneoy8+3811j/8kTYaoKM9ca/HUD
         dWQzGl7WNrXQplfCDd8oE7t169AhhvqEdWeUSdayIqcsBsGnomFQsV18x9qpbseDmsHz
         hDiw==
X-Gm-Message-State: AJcUukdzXJLofFMdhNYgpm2R+A8K5IJw/b31PdKm4vWXm4c5rH5l5q5v
        K3qna+LNNAmJHLCn1aoVXcYWiao1wn9yUEo4NVyqXSYC
X-Google-Smtp-Source: ALg8bN4x8A4uU/FIuSYK1ggQSCT67I1cHC0j45Yz/RiIvrEf2dlSSO4lXvMY8aiEr9o9gL5MhOtPCrAjHogk2D0e0Ug=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr30665806ljd.21.1546573394876;
 Thu, 03 Jan 2019 19:43:14 -0800 (PST)
MIME-Version: 1.0
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com> <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
In-Reply-To: <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 3 Jan 2019 20:43:02 -0700
Message-ID: <CAJCQCtSjaWDCz9rc9_xzQMB+Xa1Ff3CqZA=hWnX=N6E2tshBrQ@mail.gmail.com>
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent backref)
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 3, 2019 at 6:32 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/1/4 =E4=B8=8A=E5=8D=889:15, Chris Murphy wrote:
> > If you use btrfs-image -ss option, there won't be any sensitive
> > information included. Files are hashed. Some short name files or dirs
> > can't be hashed (you'll see a warning) and those are replaced with
> > random garbage instead. There is only metadata with the image, no user
> > data.
>
> Please don't advice -ss for btrfs-image. It's super slow and will easily
> cause tons of noise when running btrfs check on it.

I thought in recent btrfs-progs that -ss was quite a bit faster. The
last time I used it I don't think it was much slower than -s. Anyway I
don't have a preference between hash or garbage, but I don't think
it's realistic for users to give out filenames in images. So is -s OK?



--=20
Chris Murphy
