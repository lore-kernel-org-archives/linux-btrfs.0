Return-Path: <SRS0=471q=2K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74638C43603
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Dec 2019 22:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9BF206DA
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Dec 2019 22:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="J89lnbMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfLTWQV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:16:21 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:43311 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfLTWQV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Dec 2019 17:16:21 -0500
Received: by mail-wr1-f53.google.com with SMTP id d16so10800523wre.10
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2019 14:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEbW/fpuyaiu7T8BBl6joo3u4/i+DzGHAGq8d3bRbJI=;
        b=J89lnbMooagzIfz/sTcWUBw+trzw/Zk3Xh7rGinYkR37cqPqTa8ESfx6kk69MGvjz9
         0NYZ4qzXk3uzlsQfxk/DXNYyg9SAnBj/wHUYlbF8xkf3W1Jp6wwUVZGuS5l5gKzvzXgu
         g5Sv+WWewL9NzzCgH/GsAPPcpXs5pbWs8+bGby7nsWuF9mKOX0a+lGMImSJSdRl4w4KR
         YUs43E5dIK3y9lgkx7Frc/ckYmC4YMfwunyRsE3Tyqc0AzbE5RlB9rWuns4d7XAzo2n+
         9frDQUeYJmQgm5/EQ6KmQmFiPCel8ObFCHZoK4slc3QF2BiQ8XI4Wh6/K32NQuJrUSVA
         fe2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEbW/fpuyaiu7T8BBl6joo3u4/i+DzGHAGq8d3bRbJI=;
        b=JFG2rJVHCd4DhwGnMkKp9lpy6u6KwTa3FSYw0fLtLyteukGPiX0UlTmF3WdTENHfaR
         XTk/fdKJgT4djhl97IiatuDdSjY9YB5iXHLaXSbGkT4fG71Va9oYriT+do0DVpO/VDRd
         oLN0hsR/K7zBoWGPBioYippCbcsU+89cFxe0TlLJNt0mRs1D5U385P9ABpALho9FO8JF
         cNrnQ2GJYgZZ8FuWaWd2olSFefFj0so8pcUHnBCXr6pRSRRaAYBA5eNL0xMxoH/D+yVj
         1dgyCO4j6SE7/Z5MFMO7CKinb6ssEpvTlFV+0EM8Xl8g5hXSCb9u1Y2CThH6uDyn6cmi
         bWDA==
X-Gm-Message-State: APjAAAX12Tu0rARYRybCKr0ku5isj3R2O5lszxw+jEqECKNuQga+2PEB
        qUm4ilucxD7iElMC+BCHUqW0vrnHHAdiyFF6o5NH9A==
X-Google-Smtp-Source: APXvYqyJBNChKkZUopPP5iUDLxgyVI9iwAmjMbF6nwNZoKck4lzY0ZFomWJ/8GJ5IxJlgFIlnaknkAKi+OUJS31U5eo=
X-Received: by 2002:adf:82f3:: with SMTP id 106mr17937510wrc.69.1576880179000;
 Fri, 20 Dec 2019 14:16:19 -0800 (PST)
MIME-Version: 1.0
References: <CAAMvbhEidM73zS-tRrtq0eYq_W-TY0BEnFumENkFaqVAwHmruA@mail.gmail.com>
In-Reply-To: <CAAMvbhEidM73zS-tRrtq0eYq_W-TY0BEnFumENkFaqVAwHmruA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 20 Dec 2019 15:16:03 -0700
Message-ID: <CAJCQCtT=-VvzykoVg259-BxGOzwRQedfa25ytB9-u3xfBmrgcw@mail.gmail.com>
Subject: Re: Finding out where a file is stored on the disk
To:     James Courtier-Dutton <james.dutton@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 20, 2019 at 2:51 PM James Courtier-Dutton
<james.dutton@gmail.com> wrote:

> If I have a file on the disk that is using btrfs.
> Is there an API call, IOCTL call that I can make to get from filename
> to which sectors it is stored in?

I'm not sure of a single tool.

[chris@flap Documents]$ sudo filefrag -v UEFI_Spec_2_8_final.pdf
Filesystem type is: 9123683e
File size of UEFI_Spec_2_8_final.pdf is 18586279 (4538 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    4537:    9798022..   9802559:   4538:             last,eof
UEFI_Spec_2_8_final.pdf: 1 extent found
[chris@flap Documents]$ sudo btrfs-map-logical -l $[9798022*4096] /dev/nvme0n1p7
mirror 1 logical 40132698112 physical 31475654656 device /dev/nvme0n1p7
[chris@flap Documents]$ sudo dd if=/dev/nvme0n1p7 bs=1
skip=31475654656 count=64 2>/dev/null | hexdump -C
00000000  25 50 44 46 2d 31 2e 36  0d 25 e2 e3 cf d3 0d 0a  |%PDF-1.6.%......|
00000010  33 30 35 35 31 39 20 30  20 6f 62 6a 0d 3c 3c 2f  |305519 0 obj.<</|
00000020  46 69 6c 74 65 72 2f 46  6c 61 74 65 44 65 63 6f  |Filter/FlateDeco|
00000030  64 65 2f 46 69 72 73 74  20 31 31 37 39 2f 4c 65  |de/First 1179/Le|
00000040
[chris@flap Documents]$



-- 
Chris Murphy
