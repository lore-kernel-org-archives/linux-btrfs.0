Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:38453 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754426AbeCROqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Mar 2018 10:46:35 -0400
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
 <89bfe98b-e16d-44ed-5333-43721bcc81dd@libero.it>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <028cce7d-18d3-3676-3041-cde4303c2a26@inwind.it>
Date: Sun, 18 Mar 2018 15:46:32 +0100
MIME-Version: 1.0
In-Reply-To: <89bfe98b-e16d-44ed-5333-43721bcc81dd@libero.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/18/2018 08:57 AM, Goffredo Baroncelli wrote:
> 	BTRFS_SYSTEM_CHUNK_ARRAY_SIZE = 2048
> 	sizeof(struct btrfs_chunk)) = 48
> 	sizeof(struct btrfs_stripe) = 32
> 
> So
> 
> 	(2048/2-48)/32+1 = 31
> 
> If my math is correct

my math was wrong:

	sizeof(struct btrfs_chunk)=80

so the maximum number of disk is: (2048/2-80)/32+1 = 30

Does make sense putting some warning in btrfs kernel module, and in some btrfs command like:
- btrfs fi show
- btrfs dev add

and in the wiki ? 30 device are a big number, however not unreachable...


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
