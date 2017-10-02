Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:42522 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdJBK3S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 06:29:18 -0400
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Re: Why do full balance and deduplication reduce available free  space?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 02 Oct 2017 12:29:17 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <e5bd0dc3-f7a5-7461-0630-6f755425009f@mendix.com>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
 <e5bd0dc3-f7a5-7461-0630-6f755425009f@mendix.com>
Message-ID: <569fb850091001ea7476100eae050c00@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il 2017-10-02 12:16 Hans van Kranenburg ha scritto:
> On 10/02/2017 12:02 PM, Niccolò Belli wrote:
>> [...]
>> 
>> Since I use lots of snapshots [...] I had to
>> create a systemd timer to perform a full balance and deduplication 
>> each
>> night.
> 
> Can you explain what's your reasoning behind this 'because X it needs
> Y'? I don't follow.

Available free space is important to me, so I want snapshots to be 
deduplicated as well. Since I cannot deduplicate snapshots because they 
are read-only, then the data must be already deduplicated before the 
snapshots are taken. I do not consider the hourly snapshots because in a 
day they will be gone anyway, but daily snapshots will stay there for 
much longer so I want them to be deduplicated.

Niccolò
