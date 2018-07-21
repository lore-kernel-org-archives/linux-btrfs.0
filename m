Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:40661 "EHLO
        18.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbeGUJ02 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 05:26:28 -0400
Received: from player738.ha.ovh.net (unknown [10.109.146.175])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id A56E41C255A
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jul 2018 08:07:28 +0200 (CEST)
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-btrfs@vger.kernel.org
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
 <alpine.DEB.2.21.999.1807201548500.2131@trent.utfs.org>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <c17458b7-d725-effb-01b6-7244d8b8ed00@web.de>
Date: Sat, 21 Jul 2018 08:07:03 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.999.1807201548500.2131@trent.utfs.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> [  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080: errno=-5
>> IO failure
> 
> Are there no other messages in syslog? "IO failure" (from
> fs/btrfs/super.c:75) sounds like a problem with the underlying device.
> Maybe try w/o the "discard" mount option? Does "cat /dev/sdc2 > /dev/null"
> complete w/o errors?

The messages prior to that were a few 100 seconds older and unrelated, I 
think it was something from usb.
The dump from Ubuntu worked without any error messages. The device also 
was still accessible, only RO. I could power down the system normal.


Alexander
