Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C953DC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 15:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DEC213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 15:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="mrCUxovz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78DEC213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbeJIXJh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:09:37 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:34814 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeJIXJh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 19:09:37 -0400
Received: by mail-lj1-f177.google.com with SMTP id j17-v6so2051515lja.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=1FZ8EQ4x2wywRgpVCyCPHgiuzWnSKoIKX+JsjsZdjEo=;
        b=mrCUxovzsyJZiHsqJU2RI/27KFC2tzFPCebHijr5aGghrVeoD0UfJRLFsyjo26Hj5M
         7ewKYNbXWkOvMahPiebCBy8x7TtPkaDX1LlJ/V++DJ1+kDsb0DLXI51Mu5fajmB7CKk1
         8qGpEwPmAnolJ7vXMsA6bHtt8hqG4cK8qKe9TtF/68wX5dWD/CjVL8TFF3gak/VVsnzK
         xyfzwxSkhzLD8HmsqACHEjTXt3W7p6KDJyC9W1DwAVlwfPbw0X6GYZH2hvFD7qMNwluv
         33PtkTNNtvNwkhSJW/0CJOZySpca8nYD08OkqPZJGHIKG/2BuYvh/SPjZCNLK7IgLvec
         acZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=1FZ8EQ4x2wywRgpVCyCPHgiuzWnSKoIKX+JsjsZdjEo=;
        b=MmJYXzMBXtdOnfp3x7G0j4I+EB2LEwKDXxWEgUQFPvjGoDZgvNUa2t+jepfUyu/hU1
         QdjpDpwg9zC2bSwbgDb1MzTzBA8QxtUJvJTYOXi0kLLoUvsLculnEcyR2iM3ickdk3Qb
         3JkgJoGFSAMK2EyP+AqRReWUL3SrNsRtqqePY+85R7ybuEicwuuzZ9KtGO1g7F5ktXQI
         9ZSDZKDrzKv3Yz5MK3VEedlKJPszfIotHXwhxdjhLWjGFDhuj6JM/7WaYb9bX++Uufwb
         qaBu1SxrzhdjkvgNQimmZhfLP2VcExTPbz9eqe4BItURvFU/kethxgxDHDvfq08qZ+SA
         7joQ==
X-Gm-Message-State: ABuFfohwK71Z7LEhKomoPbbyUQaxqi6GcFiXxTJbjK/9ek0E2E0JiKGk
        hmvaza01/O1kN3E4QyhYC+EqHCk/P27BBuM3XvlyKz+6
X-Google-Smtp-Source: ACcGV608IaXNMNxGx8F+LLGhS1XRow570EGvmlX2ORDWx4nxX5qEcndrHjmB6C4bak4D2yhdtW1X74hezDr8gD+6IO0=
X-Received: by 2002:a2e:9e88:: with SMTP id f8-v6mr11832224ljk.142.1539100321461;
 Tue, 09 Oct 2018 08:52:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Tue, 9 Oct 2018 08:52:00 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <BN6PR01MB2531060A61AD3B85A93DF82CF3E70@BN6PR01MB2531.prod.exchangelabs.com>
References: <BN6PR01MB2531060A61AD3B85A93DF82CF3E70@BN6PR01MB2531.prod.exchangelabs.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 9 Oct 2018 09:52:00 -0600
X-Google-Sender-Auth: MMDjG8Q0chY74KhVsv2VQuJp1zE
Message-ID: <CAJCQCtTAu8qrcB7cd3dKGstgSd32UjkWB5jZc5jbRJ0KXmHgRQ@mail.gmail.com>
Subject: Re: CoW behavior when writing same content
To:     "Gervais, Francois" <FGervais@distech-controls.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 9, 2018 at 8:48 AM, Gervais, Francois
<FGervais@distech-controls.com> wrote:
> Hi,
>
> If I have a snapshot where I overwrite a big file but which only a
> small portion of it is different, will the whole file be rewritten in
> the snapshot? Or only the different part of the file?

Depends on how the application modifies files. Many applications write
out a whole new file with a pseudorandom filename, fsync, then rename.

>
> Something like:
>
> $ dd if=/dev/urandom of=/big_file bs=1M count=1024
> $ cp /big_file root/
> $ btrfs sub snap root snapshot
> $ cp /big_file snapshot/
>
> In this case is root/big_file and snapshot/big_file still share the same data?

You'll be left with three files. /big_file and root/big_file will
share extents, and snapshot/big_file will have its own extents. You'd
need to copy with --reflink for snapshot/big_file to have shared
extents with /big_file - or deduplicate.


-- 
Chris Murphy
