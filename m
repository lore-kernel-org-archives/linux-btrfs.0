Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16518C2BC61
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 09:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0533B20827
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 09:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fplc7pVh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0533B20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbeJ2STQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 14:19:16 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43309 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbeJ2STP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 14:19:15 -0400
Received: by mail-oi1-f194.google.com with SMTP id j202-v6so5978954oih.10
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2018 02:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WbLZqpn7uGPmOpV/+rYJAhAXnzNghobavNkRYodmDEU=;
        b=Fplc7pVhgOBgq5WnyiUSOFXM0h1sQgUnjSDxekMiXpL5pAfXYqjsueY+6HqP0jAtdY
         T6IX/ihwLUcjnkYL9cxOorUluiUeEYoydxH8iXBj/tkBQraXuPmNyxkRFWH143MxV9Ep
         HkDHzwqtqMR+4dcmmMVQC0bXckbm0QhezVrYIigyeX2UnPmmVPwXglUGNMh01UnU9WG0
         X5FqD2Ao0b3TMjTek1rP5jYrck2aU205kAPAA7oy/7dYCl/Km2JFmTzgQ9uWHdRK+t+K
         4yvwedWEuR330XbDoPuSKSSdqNQQ3/WsMQZdtvQPu5RkVa0o5LUHARS6suPeBe0miQU1
         Mj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WbLZqpn7uGPmOpV/+rYJAhAXnzNghobavNkRYodmDEU=;
        b=Rf8zjkFENgzYD7+Jz+5sp14xRaVtLn7SgLecaO/1zs3aoUdvABn78IELLPLMESTzjp
         hLQVZcg+pXN8wYK4DCPFRMSrm0sXfZR3ZXBPeXMn9cMeWpP3uy1ZX0YlvIQ0JGq5tOLX
         FNpcpLeOMJjKKjrX/QYS+ImCwnYJtaeHsKV0JyRdbVxl/lcTLSUgERV/CHJbCqB5Sn4f
         1FTDLKMyFAJjdb2LAOlITCeTh771nD+e9NK8vFQ5gxUFoD0V5JBjNINNBYYxubegJgAv
         5be2clBqLI3oL0wRGlSHqqPI936zLcQLTyWAfC/ajnbN42bJrkLCpgOeTiLD4+rtZTLL
         QHUg==
X-Gm-Message-State: AGRZ1gLl4YDFrJRbUZ10mr8bHCACD4HtgIpLBcuMGiW46zkkYtUfnXA2
        SbWzipPjqSp34mHKVAkTZz5UxuivwubC4uV3IfU=
X-Google-Smtp-Source: AJdET5fnLxlyeTP5FpvfodtCZkhMh7OiVW6jAmN/JdoXQ4chnZ8Jx2+Mt7bTa0GTqJULlmSOQDSPKjH75BNIPadz97c=
X-Received: by 2002:aca:5e83:: with SMTP id s125-v6mr7564642oib.134.1540805485399;
 Mon, 29 Oct 2018 02:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH=dxU4QoRn71+JF3BYC3OZ+=PHfwy59thiVRrZ9OhjxNVzULA@mail.gmail.com>
In-Reply-To: <CAH=dxU4QoRn71+JF3BYC3OZ+=PHfwy59thiVRrZ9OhjxNVzULA@mail.gmail.com>
From:   Henk Slager <eye1tm@gmail.com>
Date:   Mon, 29 Oct 2018 10:31:14 +0100
Message-ID: <CAPmG0jaAGuogO-DGg+i+WTEAC4+M-GpObLkToY-hKD0Duvp71Q@mail.gmail.com>
Subject: Re: a new kind of "No space left on device" error
To:     davestechshop@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 7:20 AM Dave <davestechshop@gmail.com> wrote:
>
> This is one I have not seen before.
>
> When running a simple, well-tested and well-used script that makes
> backups using btrfs send | receive, I got these two errors:
>
> At subvol snapshot
> ERROR: rename o131621-1091-0 ->
> usr/lib/node_modules/node-gyp/gyp/pylib/gyp/MSVSVersion.py failed: No
> space left on device
>
> At subvol snapshot
> ERROR: rename o259-1095-0 -> myser/.bash_profile failed: No space left on device
>
> I have run this script many, many times and never seen errors like
> this. There is plenty of room on the device:
>
> # btrfs fi df /mnt/
> Data, single: total=18.01GiB, used=16.53GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> Metadata, DUP: total=1.00GiB, used=145.12MiB
> GlobalReserve, single: total=24.53MiB, used=0.00B
>
> # df -h /mnt/
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdc2        54G   17G   36G  33% /mnt
>
> The send | receive appears to have mostly succeeded because the final
> expected size is about 17G, as shown above. That will use only about
> 1/3 of the available disk space, when completed. I don't see any
> reason for "No space left on device" errors, but maybe somebody here
> can spot a problem I am missing.
What kernel and progs versions?
What are the mount options for the filesystem?
Can you tell something about the device /dev/sdc2 (SSD, HDD, SD-card,
USBstick, LANstorage, etc)?
Could it be that your ENOSPACE has the same cause as this:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg81554.html
