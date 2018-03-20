Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:60273 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751269AbeCTUEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 16:04:30 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Crashes running btrfs scrub
To: Liu Bo <obuil.liubo@gmail.com>, waxhead@dirtcellar.net,
        David Sterba <dsterba@suse.cz>
Cc: Mike Stevens <michael.stevens@bayer.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
 <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <ae7fb47a-c05e-ed23-58cf-e4c05a5334ef@inwind.it>
Date: Tue, 20 Mar 2018 21:04:23 +0100
MIME-Version: 1.0
In-Reply-To: <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/19/2018 07:06 PM, Liu Bo wrote:
[...]
> 
> So Mike's case is, that both metadata and data are configured as
> raid6, and the operations, balance and scrub, that he tried, need to
> set the existing block group as readonly (in order to avoid any
> further changes being applied during operations are running), then we
> got into the place where another system chunk is needed.
> 
> However, I think it'd be better to have some warnings about this when
> doing a) mkfs.btrfs -mraid6, b) btrfs device add.

What about in the kernel dmesg during the mount

> 
> David, any idea?
> 
> thanks,
> liubo
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
