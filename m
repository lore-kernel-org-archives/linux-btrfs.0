Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DFCC04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 03:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24E1620850
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 03:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="A4WV0ODp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24E1620850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbeLDDQT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 22:16:19 -0500
Received: from mail-lf1-f41.google.com ([209.85.167.41]:33252 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbeLDDQT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 22:16:19 -0500
Received: by mail-lf1-f41.google.com with SMTP id i26so10841908lfc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 19:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A8fu2NitM8fK3cciPfvog9wqpXgdJ3k+ALqRt2wbIgU=;
        b=A4WV0ODpk67gehEj/BxBMNq3NltLk7xXb4Kx711FhfeuNR4kfxntLXJnf5hID+O//l
         OP5e3XU3vm5dlCPq67BLUqofkisIXKHI3ocAtSLVV9KFn9ePlRKeYTOyZukiqHCCPYZZ
         Ip9seqPRIosVqANUw6mEswVozSMrpzdU3YhPbJcaFZLJvvD2mU5ohYMQt/ZRPRX+vRT4
         xeErdAGmcf0+No/E7UMwS9aKgs8zL2QcjkDTLO5+NsiHBJvQBK4QHBN29XPeUFTjcXtz
         x4n2ldUxXzFukIA09AgF1mlfzB4kd1ECm4FDhpILTLKidRU5nxyHjKXZ+H9974BUPfkk
         be/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A8fu2NitM8fK3cciPfvog9wqpXgdJ3k+ALqRt2wbIgU=;
        b=IBnHlxgannpjqG8NffvDq0yWQp4wFkFPHBZnbZOR0RK+q9XDXF0Mk1BMP/MhN2WJ7l
         DhG0/HNnbb4ec2Xo77LS0hGic8V/dbALf5UK80DJWVQltfHI1tvSC1EuDYX3cws5Sl9j
         HBK5zZK4KmYWxtj9JywdSQwnOVkq7CD4F3QIy8alFiHzHuE9IIZUayIryRw16YtU6K8H
         HaZccxZQY77cjAJDa8AgTVaEw/R7dVEshfnXIe77GGoPICSixPGChAXvKvbmx/vbscEj
         M/rycFtLB6FzYWyb7PCg2fc5CnlGNvkA4uNdV/mth+osiq9OtVCPJo0zdWNkw1S1KT1Z
         ymBQ==
X-Gm-Message-State: AA+aEWY6RYkdiJMCMBl2JiGdAaj+5crtoVn27/Y4KGgALvyLJC/jpAn3
        egIanmrWvFstMOjSgx7C9NPd2MVM67d7Qbj9wksaHA==
X-Google-Smtp-Source: AFSGD/WC0RrNPf5XCsN7aWG8zdAJMvOvRInXEqJKwbcYvYcEqc/oiwvKdV2BqsigYsEvxX/b9NtlFw/h8Ky9Bxt1rcQ=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr10143949lfg.89.1543893376703;
 Mon, 03 Dec 2018 19:16:16 -0800 (PST)
MIME-Version: 1.0
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com> <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
 <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com> <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
In-Reply-To: <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 3 Dec 2018 20:16:05 -0700
Message-ID: <CAJCQCtRgzw=UPfHxeaiDzqKGzrbSKz-B3xfUpBjYM4GGe=W4YA@mail.gmail.com>
Subject: Re: Need help with potential ~45TB dataloss
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>, bolderbast@duckstad.net,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Also useful information for autopsy, perhaps not for fixing, is to
know whether the SCT ERC value for every drive is less than the
kernel's SCSI driver block device command timeout value. It's super
important that the drive reports an explicit read failure before the
read command is considered failed by the kernel. If the drive is still
trying to do a read, and the kernel command timer times out, it'll
just do a reset of the whole link and we lose the outcome for the
hanging command. Upon explicit read error only, can Btrfs, or md RAID,
know what device and physical sector has a problem, and therefore how
to reconstruct the block, and fix the bad sector with a write of known
good data.

smartctl -l scterc /device/
and
cat /sys/block/sda/device/timeout

Only if SCT ERC is enabled with a value below 30, or if the kernel
command timer is change to be well above 30 (like 180, which is
absolutely crazy but a separate conversation) can we be sure that
there haven't just been resets going on for a while, preventing bad
sectors from being fixed up all along, and can contribute to the
problem. This comes up on the linux-raid (mainly md driver) list all
the time, and it contributes to lost RAID all the time. And arguably
it leads to unnecessary data loss in even the single device
desktop/laptop use case as well.


Chris Murphy
