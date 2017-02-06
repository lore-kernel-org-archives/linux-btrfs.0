Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36245 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdBFMhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 07:37:35 -0500
Received: by mail-it0-f68.google.com with SMTP id f200so8485763itf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Feb 2017 04:37:35 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i184sm4163921itf.15.2017.02.06.04.37.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Feb 2017 04:37:32 -0800 (PST)
Subject: Re: Is it possible to have metadata-only device with no data?
To: linux-btrfs@vger.kernel.org
References: <14453691486330921@web21h.yandex.ru>
 <0dbbe15a-59f7-ef0e-1ed6-83fec7ef165a@mendix.com>
 <pan$76944$e15dabff$cb6ce271$3ab68bb5@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f9011015-ff3d-7ea0-3f0b-4831dc83a2db@gmail.com>
Date: Mon, 6 Feb 2017 07:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <pan$76944$e15dabff$cb6ce271$3ab68bb5@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-05 23:26, Duncan wrote:
> Hans van Kranenburg posted on Sun, 05 Feb 2017 22:55:42 +0100 as
> excerpted:
>
>> On 02/05/2017 10:42 PM, Alexander Tomokhov wrote:
>>> Is it possible, having two drives to do raid1 for metadata but keep
>>> data on a single drive only?
>>
>> Nope.
>>
>> Would be a really nice feature though... Putting metadata on SSD and
>> bulk data on HDD...
>
> FWIW, it's on the list to be implemented in the future, but there's a lot
> more things on that list than devs working on btrfs, and the feature
> development and stabilization trend is that features often take much
> longer than anticipated, particularly to properly stabilize (to the level
> of the rest of btrfs, which is in general stabilizing but not yet fully
> stable, so stabilization is relative, here), which has slowed down the
> pipeline of new features due to the devs having their hands full
> stabilizing currently done but not yet properly stabilized features.
There are also a number of higher priority features than this.  While it 
would be a wonderful feature to have, it doesn't exactly have a 
particularly significant impact on broad usability.  Most of the 
features being actively worked on are trying to gain parity (no pun 
intended) with other multi-device storage stacks.  Working quotas, 
parity-RAID, hot-spares, and n-way replication are all pretty 
significant to the usability of BTRFS in a pretty large number of 
situations, which is a large part of why they (other than n-way 
replication) are the primary focus right now for development.
