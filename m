Return-Path: <SRS0=0wlt=2B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B75C00454
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 18:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28F7922B48
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 18:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="DZ9BXRRJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfLKS6n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 13:58:43 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40478 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLKS6n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Dec 2019 13:58:43 -0500
Received: by mail-wr1-f49.google.com with SMTP id c14so25249061wrn.7
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2019 10:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSKdgdYY5opCbmGfJWr/upIg8QDhnphk02uvpiS8sEc=;
        b=DZ9BXRRJRfbvk+0g+r571hkP4dVp9Y/5lOupvmgxK9V1zXXL8v1pU1uvEugrnAfk0k
         HHd1H5E023KKGYPmCbv/wQLcxDM6uqizq/NiJRokaKX95tlycvIe4ZH6fbaTvofm81z2
         xkNi9jGsPlrMEoaDkqS8Db5LQb9LdgEncRwTZauelLz7hr1YZrQ2qd81YOartceckWBa
         laR5ya2T8ieqi5jtVUe5fkHl3Nzf97jbxmDIW5fnejuwnIXvBijeAVUm1YJxrnT5eaQO
         chjpSRDm2UQkXBiWwgjIyvAqTA08Rrjhrhc085BKtypka7QgXpSJkMXa/PDt9T/xoMNk
         EXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSKdgdYY5opCbmGfJWr/upIg8QDhnphk02uvpiS8sEc=;
        b=JBz0vIWo0lk0VgKsacMzJBTt9av9SHoydMo3CULOjJtmLBGERT1raH0ffQ7oPzokCI
         3cas5bkergA4Y/+Pmcc4QTeolqRtFibz01E7E143v2/Cn5W1cyu+bzfPNt4axO5IZvtv
         WB9Da/e4IV1odGPhctDXEIIzOzDQf8ouFe20h7JAE+kcifnuts1m2qgiogu4SXoHGoXc
         cGyr95NuXfH4D43i379KnlyU1iORZPNoGlQmpqa97DhEIlFlEe+MFf4oTDB5AN8lWZHg
         s84cJ1porV2PQP4p4jdsRxQOM2A9ozrYjpi9nPsc+TnWlb5qe4xn5xUaXbqz67QO02LK
         384Q==
X-Gm-Message-State: APjAAAVadvFSDSBQagMeGe2jjXrKNzD7AqtJcrphUfOhKjLRkuIPC6rp
        rfgh/1RHZxOk81l8NpXDjbGUiewwsnhV4k9RIEchTdvrx29jjw==
X-Google-Smtp-Source: APXvYqzXesre9QX82R9h0bn2mWv3UrDphe0ow57qjCZcpDFAWLnv7xuzpof9Pb0IKCFRQCvZLtQAmVx7Id+TGbhFCGo=
X-Received: by 2002:adf:82f3:: with SMTP id 106mr1441133wrc.69.1576090721341;
 Wed, 11 Dec 2019 10:58:41 -0800 (PST)
MIME-Version: 1.0
References: <9df7f98b-271f-8b1d-f360-00a737d49911@gmx.de>
In-Reply-To: <9df7f98b-271f-8b1d-f360-00a737d49911@gmx.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 11 Dec 2019 11:58:25 -0700
Message-ID: <CAJCQCtSWW4ageK56PdHtSmgrFrDf_Qy0PbxZ5LSYYCbr3Z10ug@mail.gmail.com>
Subject: Re: BTRFS with kernel 5.4.1: df -h shows 0 Bytes available but btrfs
 tells me that there are 1.06 TiB free
To:     =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Yes this is being discussed in two other threads:

"df shows no available space in 5.4.1"
"100% disk usage reported by "df", 60% disk usage reported by "btrfs
fi usage" - this breaks userspace behaviour"

Seems pretty clear there is a bug, it just needs to be located and fixed.

--
Chris Murphy
