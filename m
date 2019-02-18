Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B67C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 23:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3364720818
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 23:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="IdlUEL82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbfBRXtU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 18:49:20 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:36581 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbfBRXtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 18:49:19 -0500
Received: by mail-lj1-f178.google.com with SMTP id g11-v6so15870432ljk.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 15:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z/ePA3tdKPqoc/CEx6BCuzJqF+Rthatxr+V91D0ibko=;
        b=IdlUEL82pbqn1656MQ9L/uWjWsMhbansNgG2xzMD4Qdg9mWXLo2IjgoW9GaFnYGJAl
         qJiQaQlvliS45LGXyudX5ZO8KfnNM8o7Pb9PDk4u6kw/5u0Xrf/3/Gs2wwDRiT/WrREo
         O7q+hDKBx2L/Tdw/0191dGIThR5GwXq4ygc0SFFDTbyVu46lr5BGTKfT8ceqJ5TYQqpl
         4A6+W1qeNt88Y5jvoKLbqxU1UpAltY6cTGgtoD5j+WwV2j8ASRxWJXGbl7b347rdegyL
         FpEVUQQgAwXhkQKwe54+OnJGjxz3qq5SJoWQkaXaA2EfKj0UO1nPHLmuZyVCZMgzRmG7
         pZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z/ePA3tdKPqoc/CEx6BCuzJqF+Rthatxr+V91D0ibko=;
        b=NoZ1zW0qdtFsWo9VS4jmxf2PuUW+lX+oVDgJhqQTTQziJT6vkrkaZnsxPqGOsD11dw
         b2UXF86AiFVsLgGYyUCcK3tYROcu0jsveXDScqM88/FvaCt9rG7idEemQFPPFvFFVddl
         vY22F9p47v3FI2Ghf3wTzrpZ60qpL7gJngBAlUKnJMZjqbX4URJnRUhqdBjuX114oaqo
         FmRvdku9l59tzKWjDCKzy5dzBXxPlhA2u66RQ6IPI6u6+cumL/JqRIsVdTC99bdbArYn
         btaTFIgQ8kbUdgRx5/xQR0C5B0HW+bg6EYRxTLBFkweU6VKjW5qLCIe+rbXTyGx9O3Nj
         N0Zw==
X-Gm-Message-State: AHQUAuZJsfoKoNYCZH6X//kINmNziygtakxNJ7GJXGsHBVNtu8cl0c+p
        D0Klwg3Vo0uzkBl6rKhDuZCjBrhhwttwS1vMEA2rQjmV
X-Google-Smtp-Source: AHgI3IacZbUBYU8/+aQFDqc9hl98/GbEC/ZS3CrIdLIaMvM3UgFQdmiEmV2iCh3ojjSp5xsM8wwUl/lsz769P2gYHzE=
X-Received: by 2002:a2e:2419:: with SMTP id k25mr4526833ljk.38.1550533757657;
 Mon, 18 Feb 2019 15:49:17 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org> <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org> <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org> <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
 <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org>
In-Reply-To: <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 16:49:05 -0700
Message-ID: <CAJCQCtRvxpai3Cs+588T+QjYJbJSs2NE=nzkZ90FY41M9peXog@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 3:58 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>
> Ok, but I don't want to keep old snapshots of the child volumes. Only
> the latest and then diffing it in regards to the master. Would that be
> possible?

In order to do an incremental send/receive you need to have the -p
snapshot on both source and destination file systems. You can delete
snapshots older than that.

I still don't understand why you're diffing in regards to master. It's
going to be inherently inefficient because you've said a large amount
of the contents of master aren't important; but by using it as the -p
reference snapshot, you're asking send to do a comparison that
includes a lot of metadata you don't care about. It's more efficient
to diff the incremental snapshots of the changing state of
"childofmaster" subvolume.

--=20
Chris Murphy
