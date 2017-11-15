Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:45371 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752873AbdKOMnd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 07:43:33 -0500
Received: by mail-it0-f66.google.com with SMTP id l196so1566582itl.4
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 04:43:33 -0800 (PST)
Subject: Re: Tiered storage?
To: Marat Khalili <mkh@rqc.ru>, waxhead@dirtcellar.net,
        linux-btrfs@vger.kernel.org
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
References: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
 <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net>
 <8d8b22c1-3e20-64ab-f79f-f9dc3a4060ac@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dd42ed30-7bd1-cc1a-0f78-4920d3181411@gmail.com>
Date: Wed, 15 Nov 2017 07:43:29 -0500
MIME-Version: 1.0
In-Reply-To: <8d8b22c1-3e20-64ab-f79f-f9dc3a4060ac@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-15 04:26, Marat Khalili wrote:
> 
> On 15/11/17 10:11, waxhead wrote:
>> hint: you need more than two for raid1 if you want to stay safe
> Huh? Two is not enough? Having three or more makes a difference? (Or, 
> you mean hot spare?)
They're probably referring to an issue where a two device array 
configured for raid1 which had lost a device and was mounted degraded 
and writable would generate single profile chunks on the remaining 
device instead of a half-complete raid1 chunk.  This, when combined with 
the fact that older kernels only check the filesystem as a whole for 
normal/degraded/irreparable instead of checking individual chunks would 
refuse to mount the resultant filesystem, meant that you only had one 
chance to fix such an array.

If instead you have more than two devices, regular complete raid1 
profile chunks are generated, and it becomes a non-issue.

The second issue (checking degraded status at the chunk level instead of 
volume level) has been fixed in the most recent kernels.

The first issue has not been fixed yet, but I'm pretty sure there are 
patches pending.
