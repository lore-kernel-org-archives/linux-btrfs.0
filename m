Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47704 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2FEXso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 19:48:44 -0400
Received: by pbbrp8 with SMTP id rp8so8120449pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 16:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338939792.11962.4.camel@joe2Laptop>
References: <cover.1338889066.git.joe@perches.com> <20120605142826.d92316a0.akpm@linux-foundation.org>
 <1338934303.5780.8.camel@joe2Laptop> <20120605151754.a794ac7c.akpm@linux-foundation.org>
 <1338936572.5780.29.camel@joe2Laptop> <20120605162910.caccb0d4.akpm@linux-foundation.org>
 <1338939316.11962.3.camel@joe2Laptop> <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
 <1338939792.11962.4.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 6 Jun 2012 01:48:22 +0200
Message-ID: <CAPXgP10DEsqtz9xbPUQ3xCwdFGTTYyTGSd7yEcU2vUr3SJ83Sw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 6, 2012 at 1:43 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-06-06 at 01:39 +0200, Kay Sievers wrote:

>> > # echo "\001Hello Andrew" > /dev/kmsg
>> > /dev/kmsg has
>> > 12,774,2462339252;\001Hello Andrew
>>
>> Try "echo -e"? The stuff is copied verbatim otherwise.
>
> # echo -e "\001Hello Kay" > /dev/kmsg
> gives
> 12,776,3046752764;\x01Hello Kay

Don't you need two bytes to trigger the logic?

Kay
