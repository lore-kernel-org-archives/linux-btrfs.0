Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_MED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC76C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 05:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B742420882
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 05:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="TxfN81U5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B742420882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbeLGF45 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 00:56:57 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:33701 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLGF45 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 00:56:57 -0500
Received: by mail-lf1-f51.google.com with SMTP id i26so2173837lfc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 21:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=cvZpELXvNVrLtN2OP+5UiHlcK1uVfNhQolS3B7XBv7g=;
        b=TxfN81U5AOTI1Bnqx2REDmYaQlE+lPQw19c7w6b8DwoyUB4vsJbZFRxM2fHCpSu0EO
         QSLTFELwH4703oeILOT/DxPHLtdJoKgeVR6QyKJKbdNcB61m5FURO6wtRLLDV3hDRc05
         UwUnAmjYLMQN4jlO1EaZN7hT19nPlQpk+DQsDZ+OBFIc9pMugVfKEJBfEH62hzBddHrc
         McMkLcHa5M0bIufSjVA5rYGeqna7sFT+m/BBjeOeZ/YhS2xFMQ4EKlVbo8maZ5l8kopu
         tVjdoHMPvhiC5LvW2Cb/GqW/2l8m2e6yRKLLuSXPF1KbNNRSCa8iZMXIbj8IUOdcOxJx
         pqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=cvZpELXvNVrLtN2OP+5UiHlcK1uVfNhQolS3B7XBv7g=;
        b=VPqjKL5h5jWWn6ob+0mXD1VCms4sm21GiFbZZnDLHgagHqaYWuwIf57BGoYLIl6kKs
         sN3bN3aU4dMeCjg2sWHntvcLJsA6DnhCuVOOpvJtW9G9at1lvf1NrCO5Co1RchjqcbMR
         QknZh9oBt3W6d8vNCR3pT2RfJiFwMtokTbVv9UkLDplWRv5MIMYFSppiJ87eydusPZmY
         y/BarGR149Qqy+0QH7GPt3tRP9BSRd1C09ABfR7OlhJ+wGMUiMc7dkn8zPOPjzrBZB51
         RrcHIIOM7W4gUzGujCVw7FZDV2xgvUU9vgt/mLLYwB6mv3xLhAIWRg7NLdCtS7TUCQwB
         /ruA==
X-Gm-Message-State: AA+aEWaPJUVfLV3XDrAdqnVTcR2m77KyTJiRVL7rrIFuknPDr1SbQHlS
        gOdr5V+x+8uWwA7R6beQJPKp/KGkydVUo+l3l3NjtAbrRDA=
X-Google-Smtp-Source: AFSGD/Vjb/sm30zLbhwnzw1Yw6N1bJt3+/BcDU77d4IE5+fLNTgitPAHNZw+sb+xiDWk3zw+R6iSPwuLm0JpdU1bg9I=
X-Received: by 2002:a19:a7c1:: with SMTP id q184mr455660lfe.4.1544162214978;
 Thu, 06 Dec 2018 21:56:54 -0800 (PST)
MIME-Version: 1.0
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
In-Reply-To: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 6 Dec 2018 22:56:42 -0700
Message-ID: <CAJCQCtSiYk4RMRWRoaAFchzvinQ4tq1wC_Ru9d8gJWRsebvbTw@mail.gmail.com>
Subject: Re: System unable to mount partition after a power loss
To:     doni.crosby1995@gmail.com,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 6, 2018 at 10:24 PM Doni Crosby <doni.crosby1995@gmail.com> wrote:
>
> All,
>
> I'm coming to you to see if there is a way to fix or at least recover
> most of the data I have from a btrfs filesystem. The system went down
> after both a breaker and the battery backup failed. I cannot currently
> mount the system, with the following error from dmesg:
>
> Note: The vda1 is just the entire disk being passed from the VM host
> to the VM it's not an actual true virtual block device

This is qemu-kvm? What's the cache mode being used? It's possible the
usual write guarantees are thwarted by VM caching.



> btrfs check --recover also ends in a segmentation fault

I'm not familiar with --recover option, the --repair option is flagged
with a warning in the man page.
           Warning
           Do not use --repair unless you are advised to do so by a
developer or an experienced user,


> btrfs --version:
> btrfs-progs v4.7.3

Old version of progs, I suggest upgrading to 4.17.1 and run

btrfs insp dump-s -f /device/
btrfs insp rescue super -v /device/
btrfs check --mode=lowmem /device/

These are all read only commands. Please post output to the list,
hopefully a developer will get around to looking at it.

It is safe to try:

mount -o ro,norecovery,usebackuproot /device/ /mnt/

If that works, I suggest updating your backup while it's still
possible in the meantime.


-- 
Chris Murphy
