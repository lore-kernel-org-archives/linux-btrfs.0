Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10514C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 22:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5217208B3
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 22:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9N1YVBl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5217208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbeJPFsk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 01:48:40 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:40864 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeJPFsj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 01:48:39 -0400
Received: by mail-lj1-f181.google.com with SMTP id r83-v6so18927883ljr.7
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 15:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hyrQlcx8zIWeP603TXfSsTtdiqNTs8dVdVPXUvzuuGM=;
        b=a9N1YVBlH2Ig3DrySGDZAXmGoC60/4tNw3G+v0CB4DmL+1dUWTA6bHlzVH5cTx1+hU
         qP4Tmclj3wriEhFhQoAbgsZzCLEEGVpYxGobY9ruJc4nNboU1Ad4uWKigDE19ZPi50wW
         QqZRWx6kG5beWhMM7g5sZZipKg4NRx+5oFsaUwNauvq/QIuELY5ltbC9uXWpyDODGrRl
         i82Gy2cbw6+uuI1jQANkKUzQqpJgP8VCBJ2R6CLkUw533HS7OorVnFeuXbqCWrXiAloS
         hUFlA6TueAIVGY2aWVrgahoHr18RdDGH8t8qisgxnPDEPYr3nD5duEUfRmTOdSAoGfl5
         VOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hyrQlcx8zIWeP603TXfSsTtdiqNTs8dVdVPXUvzuuGM=;
        b=mYNYMl3z38LBuoj5I2hKpVtlc/IVNYIai2pcT5Ecm4e7XlGrlF7pgbgoEPHglCZBq1
         W8IkszzNIrRIMHeDTyhOXJ952OB9v2tVmqX+HH1RITCeuQ0H/mtV3VTE7Ua8q8jKHm0U
         tYEymxxzFlLiZ2GBS+tzVPSx6csH79/TlRTFJIAv6EYUYB4RuXWRuZNe9cu8904H75cK
         lkbvJUcvNWD8QwTGs/tJzRBqLDW6rLVCO8FLHSwMAPYy/LgmvhpyZCgtaMOFvLO4jDAq
         XIgFHSJ2sYlquN/CifOgZ8QAhCPy1UxU0ixFN0TpVGLGka5LcvbhblRvcnrCvpYhbk5N
         rQZw==
X-Gm-Message-State: ABuFfojNJ5e2GUaMqHcyeW1EGoMWGfYG3g/R9hT0fQgM7a8/l2ObSt4o
        EIB7HrsNKRF86s5ZYWyo5Px1Hi7pQ8Q=
X-Google-Smtp-Source: ACcGV634AKN1ap5H4YKbzj5FmcfBPCFCbpQfpluPKQZGPzU6ft3jGp+vMco8WuGDsfDSENQ17xxtjw==
X-Received: by 2002:a2e:9445:: with SMTP id o5-v6mr2440360ljh.7.1539640891121;
        Mon, 15 Oct 2018 15:01:31 -0700 (PDT)
Received: from ant-519666801b8 ([95.72.235.248])
        by smtp.gmail.com with ESMTPSA id s4-v6sm2729174ljh.11.2018.10.15.15.01.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 15:01:30 -0700 (PDT)
Date:   Tue, 16 Oct 2018 01:01:29 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Spurious mount point
Message-Id: <20181016010129.df2095c62a99e0203a844e3b@gmail.com>
In-Reply-To: <CAJCQCtR0zVDOS8u5zN2Ddo4+orrx62-L9e5GUnM=OWcwSitftQ@mail.gmail.com>
References: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
        <CAJCQCtSz+=uwXUFGxagoUOYxy99eCJGG-ezLVh0RO=vL=LReEg@mail.gmail.com>
        <20181016002601.5517a4ea66c2c9c5dbdb5471@gmail.com>
        <CAJCQCtR0zVDOS8u5zN2Ddo4+orrx62-L9e5GUnM=OWcwSitftQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy:

> I wasn't aware that SUSE was now using the @ location for
> snapshots, or that it was using Btrfs for /home. For a
> while it's been XFS with a Btrfs sysroot.

Ours does use btrfs for `/' and xfs for `/home' *except*
`/home/hana', which is strange and wonderful, because the
standard usage is there in fstab and hana mount is created
somewhere else.

-- 
()  ascii ribbon campaign -- against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
