Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17A6C282C4
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B20AD2173B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="li2O7iAM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfBGRPw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 12:15:52 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:38209 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfBGRPw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 12:15:52 -0500
Received: by mail-lj1-f175.google.com with SMTP id c19-v6so537164lja.5
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 09:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvivMthskfnGzB6zLgUlRlptCkd4npQ24HiX6GGFISg=;
        b=li2O7iAMBmkgqyQetBZ0jAapdUN0tZFSmP3Zjtubhmts5WexDjDN4CNx9AlT/dmdnV
         rJKDVxtJnG6YhF0I8nwTSBV12CVf54Eof/ANmbOuyxPSEJ2zgsn3s5AwBPrLdzSP6XmP
         D84sPRvfF4ns4C6dmX7s70Z6wWeiH4eZb/hibU8BmX7p5OG3xlDV+cqnquKYwnOAizw1
         1fOsmKhAUY6eIVHHzv9hG4MfmoCwI/CJrcTdqTYwSi2iETz4IG9lJ2zXc4QwYWfCHyUO
         W3PVKj7TeiBhRv8716eq80vVHRnzGDOq5acHWUc9GDJHhXsgN+uBkid5w3rDt+tjKEM1
         kpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvivMthskfnGzB6zLgUlRlptCkd4npQ24HiX6GGFISg=;
        b=ZKKaE/0ZmrQny69Cc16nd7rBrVt/R9hmLFQQuevLPZ5apHnFp5De/cqRHllFvHKKuT
         PB4rvAnagi+n5AfQnuNZcc2PMYLnWvFI/TE3YSzU6zhOub8n4PAwK0J1WFc1Ld3r4Lz6
         bHVQ26RVO6gS3SDK9tHlaeQ2x55Iq6Exi1qc1naM5FT376qMNrcnm7/fU58IIYoNz9kL
         0ij5oHvGz2PC59rH7zbyKYz6EGGK4daB3gA3CyoFk7Cf30dKpzF1PeXuxwIbite0xHbj
         GR/66qVoCLdOOYZeGmRcIR8vWe7xGQLRsq1K67+S0DdbleLwWDpBDK4bFEOfxbSHDo5p
         bkrw==
X-Gm-Message-State: AHQUAuaIu9by7usnWFfaFhl0I3rEOdFAdZs6V3GMX2nLOwblwrdYGLGS
        KWSjosxBpM3vhzS8UVvicpimp5O4JRTZS+ikFa8iYA==
X-Google-Smtp-Source: AHgI3IZ+9g02prAcrVOrYIxAVfISZmSXvEWpHirEbWe0BBMAIBCmi+9PzrdhVnT+2N6UcBOMv9kyXo5wJ8Mh4s3OfJ4=
X-Received: by 2002:a2e:8719:: with SMTP id m25-v6mr11427092lji.121.1549559750011;
 Thu, 07 Feb 2019 09:15:50 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
In-Reply-To: <2159107.RxXdQBBoNF@t460-skr>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 7 Feb 2019 10:15:38 -0700
Message-ID: <CAJCQCtRuUBfhXQGr29hmOU1mW1wU2jSvr+dun72NAw3O28=cyA@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Stefan K <shadow_7@gmx.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 7, 2019 at 4:04 AM Stefan K <shadow_7@gmx.net> wrote:
>
> Thanks, with degraded  as kernel parameter and also ind the fstab it works like expected
> That should be the normal behaviour, cause a server must be up and running, and I don't care about a device loss, thats why I use a RAID1.

You managed to completely ignore all the warnings associated with
doing this, and then conclude that it's a good idea to subject normal
users to possible data loss or corruption...

> So please change the normal behavior

In the case of no device loss, but device delay, with 'degraded' set
in fstab you risk a non-deterministic degraded mount. And there is no
automatic balance (sync) after recovering from a degraded mount. And
as far as I know there's no automatic transition from degraded to
normal operation upon later discovery of a previously missing device.
It's just begging for data loss. That's why it's not the default.
That's why it's not recommended.



--
Chris Murphy
