Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00F7C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90184217D6
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMzVEQiM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbfAVPYp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:24:45 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]:41640 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbfAVPYp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 10:24:45 -0500
Received: by mail-yb1-f181.google.com with SMTP id j10so8687514ybj.8
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 07:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cUgXPY1Z6Lp32545BjtkrAbX0r+rWAwqZPFngleCGXQ=;
        b=dMzVEQiMV8TiOx1vwDX30nntWz6HQmx/VKOJrbhun9AG0qEyzAWvK82OBeZVCl1t7t
         sIFHTCS9Si6y6IVxGHZPu3IhLfJExGi/fxDtigcZ9Jr8f0zmcaclF39sYW8zsvjnLM4l
         OGUaD/+OBO4TVbrfYXoXhIuMoPiP1jrfTkttVG0ZAzy30pxHEoVLtvQceEayqkz+m5jS
         Q3/usKwjRblyfOG49hsWav1jBX3sfeYt24oaHsCD1UTbVR18NEIXFLd1KiKp0xvAHKNd
         jnmwxD6ZYaEdbUoMwvbca1upGld+t0EufZe8wCPOy7IwqfzMQPbTkwzn3ohk1asR1NuE
         0TmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cUgXPY1Z6Lp32545BjtkrAbX0r+rWAwqZPFngleCGXQ=;
        b=TttSk8xohrSOpKMS0xTS7c1LmHhChUKQI2NJWANJLweCPLfVm4Uw6G2BWTINngBpYs
         egzktUsemDLke+5QdyR9hlVpe1KIdoLDkh2ZGrrSBCThxMKA/8K68WzjOOOHvnGEADPb
         Paam5lfI3nyrSP7TeyYZ+mMotKv1FhBtx2i90bErWJ+VSYBrro8bIFRuGsPnyHUX1CpO
         CJRl4fkkcfPqjdgoFpFWY2I5iDgpp2SvkdElLu+aTFhs/KpOfziLV6nlhkHQxu5Fpn6J
         ACiAcHnem5mMU33VbRgG19dBPKHsOhItq2eUSecLEGS+c4yx0Svngjj5UNG77iTaZmx5
         mPUg==
X-Gm-Message-State: AJcUukf8Oai0NFFZ6kzRkXPJjkaxSJGeTyxbzHzH1nZr0NYZ6OrQp0BC
        vWaIA6jdxl3NtMr4h6zjgeUMpGmP0rr84Xh/6Ifo/+qQ
X-Google-Smtp-Source: ALg8bN75LFHMpb33FHoqrJMrO19jfleo8P7Lh7uvNd7z+sCnW36Ff7tzeKhcdHXHaBuJLfugsliFFbyrNil4NbIir9E=
X-Received: by 2002:a25:cd08:: with SMTP id d8mr21144645ybf.375.1548170684054;
 Tue, 22 Jan 2019 07:24:44 -0800 (PST)
MIME-Version: 1.0
From:   Eli V <eliventer@gmail.com>
Date:   Tue, 22 Jan 2019 10:24:32 -0500
Message-ID: <CAJtFHURMDnM9EMAeLE4yr-UbWHa=o8M0=Yvm-MZp8ixWykfxFw@mail.gmail.com>
Subject: btrfs receive deadlock and questions
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I seem to have it a deadlock trying out btrfs send & receive. Now I
haven't used btrfs send & receive much, so don't have much experience
with them. Anyways, bug report and stack traces:
https://bugzilla.kernel.org/show_bug.cgi?id=202383

Seems like the receive is hung as well as several kworkers. It's about
1.2TB into a 9TB or so transfer onto a brand new pretty empty fs. This
is just a btrfs send snapshot, not an incremental. That was supposed
to come next. If this was an rsync based backup I'd just kill the
rsync process and restart it, not sure if there's a way to restart a
btrfs send receive, or if I'd have to delete the partially created
snapshot on the destination and restart the send. I guess I could just
use rsync to finish the copy of the initial snapshot as well before
using send | receive for the incrementals. Thoughts and options would
be appreciated, thanks.

-Eli
