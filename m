Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:43802 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbeH2Nwz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 09:52:55 -0400
Received: by mail-lj1-f177.google.com with SMTP id m84-v6so3825771lje.10
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 02:56:47 -0700 (PDT)
Subject: Re: DRDY errors are not consistent with scrub results
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
From: ein <ein.net@gmail.com>
Message-ID: <ef6a2ce8-43d8-59cd-194b-566da77ba8dd@gmail.com>
Date: Wed, 29 Aug 2018 11:56:44 +0200
MIME-Version: 1.0
In-Reply-To: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/28/2018 12:51 AM, Cerem Cem ASLAN wrote:
> Hi,
>

Good morning.

>
> I'm not sure how to proceed at the moment. Taking succesfull backups
> made me think that everything might be okay but I'm not sure if I
> should continue trusting the drive or not. What additional checks
> should I perform?
> 

Can you please show also:

btrfs dev stats /path/to/the/mount/point


-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10
