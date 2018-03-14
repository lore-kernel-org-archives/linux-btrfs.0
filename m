Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:55604 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbeCNMDQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 08:03:16 -0400
Received: by mail-it0-f67.google.com with SMTP id n136-v6so4246022itg.5
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 05:03:16 -0700 (PDT)
Subject: Re: [RFC PATCH] btrfs: check for SB checksum when scanned
To: Nikolay Borisov <nborisov@suse.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20180313150637.3913-1-anand.jain@oracle.com>
 <8951fcb0-aadd-6a10-50f7-eac44ff41438@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8f0e03e2-a7ca-9197-f415-aee1e41ec02a@gmail.com>
Date: Wed, 14 Mar 2018 08:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <8951fcb0-aadd-6a10-50f7-eac44ff41438@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-14 05:20, Nikolay Borisov wrote:
> On 13.03.2018 17:06, Anand Jain wrote:
>> We aren't checking the SB csum when the device scanned,
>> instead we do that when mounting the device, and if the
>> csum fails we fail the mount. How if we check the csum
>> when the device is scanned, I can't see any reason for
>> why not? any idea?
> 
> So what problems does this solve? Only net "gain" I see is making a
> function public (which is a minus in my book) thus expanding the public
> interface.
> 
A device with bogus SB's is effectively a missing device as far as the 
mount code is concerned.  AFAICT, this patch results in it being treated 
more like a missing device right from the start.

OTOH, I'm not really sure if this is an improvement or not, as I've 
never had to deal with devices with invalid SB's before.
