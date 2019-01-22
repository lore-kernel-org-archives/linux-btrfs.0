Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6E2C282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 04:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CCC4217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 04:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="u7XwR7PJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfAVEgq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 23:36:46 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:46516 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfAVEgq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 23:36:46 -0500
Received: by mail-lf1-f47.google.com with SMTP id y14so17026029lfg.13
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 20:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q0tCVhsfpTSFQE0tz3Q2NMvau/TiflnjuIPfOX3z9kU=;
        b=u7XwR7PJsu/kDQSfpawPUxdw5eIcfeVENeqlf5oSYf8l/15bfrY4AteQs0gKNQrR75
         v71mh4tRoeMB3b6SfvNHo78aKmOZYdhg4+f4kUNldz8i0bxVhCFrfpC5LmgP9d+jw9DC
         LpNWUdSRzutZB1CsFthHDHY9InEMQ6/NZ1TRrwrbpY+oK24zFcCSUwjdC+AHNy4e5xq/
         pl/A/xnHVwy65FI+fQzMfYoqUfiC80YstI0IPjTRPsWsYU09EeKCVCWqYALx0+WmLzfP
         t3bKKVdFSIf47i2YAshffm2sbH7NQJkTA14tBXHbt3B66i3NrnidoPfrh2xu2R2kBNWl
         dixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q0tCVhsfpTSFQE0tz3Q2NMvau/TiflnjuIPfOX3z9kU=;
        b=CuxxYeOBN7JYaUVTxBNlS+DdksioCdV9Ay15b+f2a/sr7iQnXQe0VE7xPZn8XnKNL4
         6wrpJsrfqGCvWLIHF3ymf7WtVRQqtoQGlM+4sqTRZW2niS/76V1x6Luker5yVLGBWCai
         qEDi467xSsmlOfFeerga0B71QgB75IJxQraC7m2bG7NVCk4JbhAiiBa4EC44eKiAu2bj
         7mU/KtA9INYZyzBmUq4j//hs/yoS4DkvSOctvyuTka4uBJpVQURu0BwsSNRW80MtIAP5
         5/GeOcVlWzzzUqpcqtfTQ+L0MYtcNMfx5RtzrvSxDp+grV3+jvCcROSu+W6qKgfix0Hc
         Kimg==
X-Gm-Message-State: AJcUukeFzwpBmhZhgVltbwJu24LQcVPlCNPWYPbNG+wQcJyWkh+V936x
        9OZPjHpd1tWuIOi3mrk7L+XlSCsPnym2XUvAwlcgTJnO
X-Google-Smtp-Source: ALg8bN4A22AFo1kfLuLWkoU12rX0RjMyTp/CUQGdR4dSaqZtmJLGZlzVM/g7/wyneZLKYTA0iNm8hSIR73o3+X0LobM=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr19074558lfg.89.1548131803687;
 Mon, 21 Jan 2019 20:36:43 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au> <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 21 Jan 2019 21:36:32 -0700
Message-ID: <CAJCQCtSik1toy+w91_x8V9y=nEcox_JQcT=F=dz4OCYZy76rSQ@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Dennis K <dennisk@netspace.net.au>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 21, 2019 at 3:23 PM Chris Murphy <lists@colorremedies.com> wrote:

> I literally never use the 'property set' feature to set ro and unset
> ro because I think it's dangerous.

Also, there is a distinction between 'btrfs snapshot -r' and 'btrfs
property set ro true' - the former creates a snapshot. The later
creates a read only subvolume. They aren't the same thing. If you try
both methods and then point 'btrfs sub show' to each original
subvolume, you will see only the snapshot is tracked as a snapshot,
and only a snaphot properly has its own unique UUID as well as a
referencing parent UUID.

That is why your workflow is failing. Not that 'property set' is
somehow broken; I consider it dangerous to combine a snapshotting
workflow with one that depends on unsetting the ro flag on a snapshot,
where you make changes to that snapshot outside the snapshotting
regimen. Doing so makes that subvolume/snapshot totally invalid as
either a parent or source for send/receive.


-- 
Chris Murphy
