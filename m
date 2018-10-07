Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA1DC65C31
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D401A2088F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VwNOQFu5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D401A2088F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbeJGNOn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 09:14:43 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:43315 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbeJGNOn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 09:14:43 -0400
Received: by mail-qt1-f178.google.com with SMTP id q41-v6so17935399qtq.10
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Oct 2018 23:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Mr8VmhsFz9vuxfuVIN0SWH7Z5oJPpSuQXi9hW4etHo=;
        b=VwNOQFu55wnUwHH27bnhFzBFWqI+Yw52T+bZcxC/oUW/lVMO6+gD06/aCRtvetP/SY
         u9qHiXhtBBA640KBt9yUL3pIcfi0IVbvdo3BUaEfSxKYDrk3lrdcsbMqmpHE5orpjhGZ
         Of2AEsY6lJWOpv6z9NtIiXH3qqXzTOMsEp7qx2JNt9zaRurDCbp5I4HcXyCkCXjLuHYt
         XsKE2qRwJeHj2TWCYQunuSKIjIbrE0hQH7OQNUB9O1C+CN2cOInEEIOVW/73tdRT9XPC
         A5d9iZsh/Spm/SJAwVVG4splUgqdIsTsHZf7fv5FzReogmYV830Ey7n7zJIkHeP6RJNv
         UhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Mr8VmhsFz9vuxfuVIN0SWH7Z5oJPpSuQXi9hW4etHo=;
        b=i/bhX8cliDUqayl0Dk1f8TRKkgXrUcB8w664K8TRuHUPAeRtfD7R3jOi8u0spZz4kq
         3XPeCCrN75zIOW26/ibAbiwHlIk6FmXhKLAxIm4fuIzCHs7CjNbCA0nJcuBfz52S7ycY
         9Og2SbLS5ujTxl3AdpgJsCSSg6uobWsQaiXmLMNYy2bJSEVqRicrQeRPlV8eUJ5QbEwX
         xH0i00WtjdzQ1+c7oAlsxvwAoFjVLc5DnmdMZgs9K50AI0DnrSV+dCB1iFjY9A9JSfD8
         H7lW4yZrn37Mkl/XlGMiSn2Lnm+/gsxBAuN0IpQbAzJUUKzIM7RVpaoTxsk2Ejb6hV/h
         QPWw==
X-Gm-Message-State: ABuFfoiF4BktwZdjbdqA8kk77JrfdMpSxSLWWpq0nwRRZkhvt8wCt3b/
        FcNoaWhPqCVMwo8jWETjDo0f4G3zumymsEcccNKR3A==
X-Google-Smtp-Source: ACcGV62ktsW7OremTaROPYB9dkmoO2C3zgu0TANbdsIOCiMG2ZmBxnhSPJy7UeQFsIbp8G48PSabbsoL1xIpsySSHN0=
X-Received: by 2002:ac8:190e:: with SMTP id t14-v6mr14963492qtj.327.1538892512466;
 Sat, 06 Oct 2018 23:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <ca47dc8e-a99d-f1b9-d3c1-a79794d6f3ac@georgianit.com>
In-Reply-To: <ca47dc8e-a99d-f1b9-d3c1-a79794d6f3ac@georgianit.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 08:08:21 +0200
Message-ID: <CAG__1a7Z-sx4=x14edd0CHMrOKPkxij1aUyBsLQ=OFbp1gFNqg@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     remi@georgianit.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Did you try a btrfs device scan  ?

Tried it, it returns nothing.
