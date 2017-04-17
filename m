Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49308 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754309AbdDQWzX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 18:55:23 -0400
Subject: Re: Btrfs/SSD
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
 <20170417232419.04474015@natsu>
 <CAK5rZE548XNECYL5PaEqT01-tvpKbnyfKvf0ZekpcLwqsZ_V6w@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1af861c8-c4b6-5c8f-a7c1-d17f17f202b4@mendix.com>
Date: Tue, 18 Apr 2017 00:55:19 +0200
MIME-Version: 1.0
In-Reply-To: <CAK5rZE548XNECYL5PaEqT01-tvpKbnyfKvf0ZekpcLwqsZ_V6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/17/2017 09:22 PM, Imran Geriskovan wrote:
> [...]
> 
> Going over the thread following questions come to my mind:
> 
> - What exactly does btrfs ssd option does relative to plain mode?

There's quite an amount of information in the the very recent threads:
- "About free space fragmentation, metadata write amplification and (no)ssd"
- "BTRFS as a GlusterFS storage back-end, and what I've learned from
using it as such."
- "btrfs filesystem keeps allocating new chunks for no apparent reason"
- ... and a few more

I suspect there will be some "summary" mails at some point, but for now,
I'd recommend crawling through these threads first.

And now for your instant satisfaction, a short visual guide to the
difference, which shows actual btrfs behaviour instead of our guesswork
around it (taken from the second mail thread just mentioned):

-o ssd:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4

-o nossd:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4

-- 
Hans van Kranenburg
