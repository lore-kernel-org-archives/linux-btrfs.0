Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:33416 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdAWIfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 03:35:02 -0500
Received: by mail-yw0-f179.google.com with SMTP id u68so91719601ywg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 00:35:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <525f6b68-07fa-54ec-4cfb-8e99199ff11c@swiftspirit.co.za>
References: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
 <1485124549.6187.36.camel@scientia.net> <20170122223906.GA24076@carfax.org.uk>
 <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net> <525f6b68-07fa-54ec-4cfb-8e99199ff11c@swiftspirit.co.za>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 23 Jan 2017 09:34:46 +0100
Message-ID: <CANznX5H4vkKCpAfz5gV8iKGY_wDruBPg1x4XZ0_H=vdWRVUG0w@mail.gmail.com>
Subject: Re: RAID56 status?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 7:57 AM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
>
> raid0 stripes data in 64k chunks (I think this size is tunable) across all
> devices, which is generally far faster in terms of throughput in both
> writing and reading data.

I remember seeing some proposals for configurable stripe size in the
form of patches (which changed a lot over time) but I don't think the
idea reached a consensus (let alone if a final patch materialized and
got merged). I think it would be a nice feature though.
