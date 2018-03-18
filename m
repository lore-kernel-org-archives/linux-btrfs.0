Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:57085 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750943AbeCRH5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Mar 2018 03:57:06 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Crashes running btrfs scrub
To: Liu Bo <obuil.liubo@gmail.com>, Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <89bfe98b-e16d-44ed-5333-43721bcc81dd@libero.it>
Date: Sun, 18 Mar 2018 08:57:03 +0100
MIME-Version: 1.0
In-Reply-To: <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/18/2018 07:41 AM, Liu Bo wrote:
> ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE / 2) - sizeof(struct btrfs_chunk)) /
> sizeof(struct btrfs_stripe) + 1

	BTRFS_SYSTEM_CHUNK_ARRAY_SIZE = 2048
	sizeof(struct btrfs_chunk)) = 48
	sizeof(struct btrfs_stripe) = 32

So

	(2048/2-48)/32+1 = 31

If my math is correct
gb
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
