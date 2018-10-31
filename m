Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3031AC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 05:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C23F32064C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 05:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="vFypAYSo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C23F32064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbeJaOE2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 10:04:28 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42505 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbeJaOE2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 10:04:28 -0400
Received: by mail-lf1-f65.google.com with SMTP id q6-v6so10636856lfh.9
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 22:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=zvSbXgDFxeHLDUj+UjzjSKxLsskBgIbd3cgSPrc9Y3U=;
        b=vFypAYSoN93a8OXyCFX6euZndMVQn65TupxchCE2MCYCV4NKS7c/+XnzeFh/s5J0xa
         uWrbgSAbBBB1H3wENcnltPsGtIc1Z/2W0anAkTOPYjeVaPeAdVQp3+9XBcvArmq7dPlj
         530a4wFx995MpfkZbFgQcw4lnw3Tfx/LwOpCUsWr6Vt+bEzM9hXsVioA8pi3DOMHO/V4
         7uBTBRKFuRvMKpb+xfE8Q8uXzVJ0rRHj7CSJ8HPn0zMLWXRLGUzRKj6Cevz2hnaG3BNV
         O9A8TsXblEXYxpSOsvIx/8ET714IZ1yjLpPK9V7biarwBMKjd5W6R2XZ0WXHIBsUh2m+
         Ef0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=zvSbXgDFxeHLDUj+UjzjSKxLsskBgIbd3cgSPrc9Y3U=;
        b=i8nX3HXdsh/nQ6NwTEfu/NnOamBZaj0Lf6hyKovjqbCxR0skU8sJRBZvcVYM/Jienv
         m6Upuxk3ecJSKUgIJHU/WrqwTiW7tX9Berd514VIh/mzEx5l2msNztL7S7dS1zJcayyw
         zVVERx5QpjprvM7KQxI22LeGGghULPoLV2nhy5NdzzCiTUBUYZWd04dDi0ZT+9PvY0hx
         tk0lDkgAbZWILAqFSFB6EsyPQuPscSa81OHO4+Z/sZbxxAY7gRMDF5HuVeEWU/byCzAU
         J9ksWzSiUDa9mSrTKb78UlmX3HoEsi9AFTjwfcKJcqHoBQnB0h43L8Dr/WQ+VNJRTCHO
         2hZA==
X-Gm-Message-State: AGRZ1gL02xyV7nN8xM2juS9lS/n+luxQdekEOM9f5rG05pKlm/hvPrqa
        QDRXaBqUEMPN0HIEF7955MD346dGC/JGsxrQwdRvfA==
X-Google-Smtp-Source: AJdET5e2O1mORSarlVdaDPj2UDdFpL4VTrGsk66wNRpBMVgCIZSb/PW+HeZUOF4qHU9uM821ZQLzcjd9W6XMP+8UXh8=
X-Received: by 2002:a19:2a9a:: with SMTP id q26mr799770lfq.94.1540962477123;
 Tue, 30 Oct 2018 22:07:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:4f11:0:0:0:0:0 with HTTP; Tue, 30 Oct 2018 22:07:56
 -0700 (PDT)
X-Originating-IP: [192.240.97.84]
In-Reply-To: <CAJCQCtSFnGz+M+xRNzajwdqFbhcAQtLAf8aAqB1xXcbvEd9j7g@mail.gmail.com>
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
 <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
 <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com> <CAJCQCtSFnGz+M+xRNzajwdqFbhcAQtLAf8aAqB1xXcbvEd9j7g@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 31 Oct 2018 01:07:56 -0400
X-Google-Sender-Auth: rleGsmJJwzqXyDKxEM7Hp29BGSE
Message-ID: <CAJCQCtQiqUVNin9Ga7HB8oUrgwQ9h9V+etZLooqX3_Sb_KNz0Q@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Barbet Alain <alian123soleil@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Also, since you don't have any snapshots, you could also find this
conventionally:

# du -sh /*


Chris Murphy
