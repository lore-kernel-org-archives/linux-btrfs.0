Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804DAC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBC520644
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="L5nP5etc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BBC520644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbeJKKFw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 06:05:52 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:46055 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbeJKKFv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 06:05:51 -0400
Received: by mail-lj1-f173.google.com with SMTP id j4-v6so6742044ljc.12
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 19:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=z6TiSPQzpCYm/Y2Kb8YOGZSM8OrecCXtNztkcLQtrWg=;
        b=L5nP5etcfZCwnURsLX+wHrRfplsrPosOHBhuacwSFyLxOsMRpKplnlj+XAFZlDtx7O
         NUyj63vaAToYaoTSRCX/UO2zJotqhJjsPTIq9fUI2N0mEh0dyU7KV4dDBIdYfsi/7lmv
         L4gN9Y1G4VvCqTE44W+gaj1fFuGfMrVj8MhInwmcOX9zTryDJgVPlxJmUk1TAF5csZHR
         lO08X/UUf2JeZh52WwzXq8iOrrdQt/QmU2W9A0/lAaEdhvYUG7XlGBuuvVBX5vg/9PrO
         4zAx/ZHKPM6Dyiecl/0DhXOqCVaFD3T+YNd7vaONwXiJcAgFvenxgDMLHF/7OD93Olyz
         RacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=z6TiSPQzpCYm/Y2Kb8YOGZSM8OrecCXtNztkcLQtrWg=;
        b=t+Sda01Muw77T6/1c/xhCFCGnoOwLYmr6z8uYP+wjachCwo0kZ0ZOCz3Sj8tct1k4C
         oxUVBLPXjb1GNInt2jRs08L84q0XSAJR/LSDqSQwXJXrD/YGDSx3Lp7mtq+9y7Dhu3mh
         QOebd6fiVi7ofee4BLqNKabTfb9ZzprpROtiDyolk8XfR8/fKwuu40moVcZur0WSx6jq
         9WGiT+Ic72GqlK3ajpkQjKCVsETSsIxBKKckMtMWwR4rwDckx6ExtU+UNHgZplG1BrcE
         6UXrbZnWAzEo2vPN1pi1jFfT32A/dBQj+vgcBGuFs52EX5rULfXnPYyk0KlSCQ5ogyf0
         Kg8w==
X-Gm-Message-State: ABuFfoj5cAh9v4SC7+V1LI0SCEMKt0N+BXeh2aFJK3bvos+zkUzJndku
        2orpvAPo1I6/W3b5pb9HQtD0oIkrExyBuv8cqcfP+w==
X-Google-Smtp-Source: ACcGV62SQEQRpfdOuNQL3outZtj1F6YSX4PXQHWsXgJppw3xWo8cYicao41hUI/WFJUCOCw9KmZT9PVDSLgWaYmTf04=
X-Received: by 2002:a2e:9e88:: with SMTP id f8-v6mr15773615ljk.142.1539225646025;
 Wed, 10 Oct 2018 19:40:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 19:40:45
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>
References: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Oct 2018 20:40:45 -0600
X-Google-Sender-Auth: VumoQyL6FaHY1lWX88kyAxz1N60
Message-ID: <CAJCQCtSUWe6sFLQr2JnEQPfRjSC4KBhMTY_ko1wt2pGJ3PMxow@mail.gmail.com>
Subject: Re: Recovery options for damaged beginning of the filesystem
To:     Shapranov Vladimir <equidamoid@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 9, 2018 at 10:47 PM, Shapranov Vladimir
<equidamoid@gmail.com> wrote:
> Hi,
>
> I've got a filesystem with first ~50Mb accidentally dd'ed.
>
> "btrfs check" fails with a following error (regardless of "-s"):
> checksum verify failed on 21037056 found FC8A6557 wanted 2F51D090
> checksum verify failed on 21037056 found FC8A6557 wanted 2F51D090
> checksum verify failed on 21037056 found 1EDD5E47 wanted 222F7E7F
> checksum verify failed on 21037056 found 1EDD5E47 wanted 222F7E7F
> bytenr mismatch, want=21037056, have=13515002166904211737
> ERROR: cannot read chunk root
> ERROR: cannot open file system
>
> "mount -o ro /dev/sdf1 /mnt/tmp" fails, while "mount -o ro,subvol=X /mnt/tmp" succeeds for "/" and couple subvolumes.

What do you get for 'btrfs rescue super -v /dev/sdf1' ?

I thought the kernel code will not mount a Btrfs if the first super is
not present or valid (checksum match)?




-- 
Chris Murphy
