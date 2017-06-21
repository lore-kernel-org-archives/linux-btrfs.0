Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35581 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdFUNlS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 09:41:18 -0400
Received: by mail-io0-f169.google.com with SMTP id k93so3785780ioi.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 06:41:18 -0700 (PDT)
Subject: Re: Exactly what is wrong with RAID5/6
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
 <1498049001.6359.4.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dc5044a4-d052-70c4-0f3f-ed72c7c95731@gmail.com>
Date: Wed, 21 Jun 2017 09:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <1498049001.6359.4.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-21 08:43, Christoph Anton Mitterer wrote:
> On Wed, 2017-06-21 at 16:45 +0800, Qu Wenruo wrote:
>> Btrfs is always using device ID to build up its device mapping.
>> And for any multi-device implementation (LVM,mdadam) it's never a
>> good
>> idea to use device path.
> 
> Isn't it rather the other way round? Using the ID is bad? Don't you
> remember our discussion about using leaked UUIDs (or accidental
> collisions) for all kinds of attacks?
Both are bad for different reasons.  For the particular case of sanely 
handling transient storage failures (device disappears then reappears), 
you can't do it with a path in /dev (which is what most people mean when 
they say device path), and depending on how the hardware failed and the 
specifics of the firmware, you may not be able to do it with a 
hardware-level device path, but you can do it with a device ID assuming 
you sanely verify the ID.  Right now, BTRFS is not sanely checking the 
ID (it only verifies the UUID's in the FS itself, it should also be 
checking hardware-level identifiers like WWN).
