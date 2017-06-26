Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55683 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751353AbdFZKqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 06:46:23 -0400
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170620231202.GB5303@merlins.org>
 <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
 <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org>
 <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com>
 <20170622025330.GX5303@merlins.org>
 <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com>
 <20170623040601.akpyyvh3dgry6nn5@merlins.org>
 <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
 <20170623161750.r7utffpsmyl5tcik@merlins.org>
 <20170624023409.GT14690@merlins.org>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <0d93c1c4-1feb-b589-0c8f-1fced7b77686@cn.fujitsu.com>
Date: Mon, 26 Jun 2017 18:46:16 +0800
MIME-Version: 1.0
In-Reply-To: <20170624023409.GT14690@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017年06月24日 10:34, Marc MERLIN wrote:
> On Fri, Jun 23, 2017 at 09:17:50AM -0700, Marc MERLIN wrote:
>> Thanks for looking at this.
>> I have applied your patch and I'm still re-running check in lowmem. It takes about 24H so I'll
>> post the full results when it's done.
> 
> Ok, here is the output of the check with btrfs-progs freshly synced from
> git, including Lu's just added patch.
> 
> Obviously while I'm happy to give further debug info on why my filesystem is in that state and
> while check --repair sees nothing to repair, suggestions on how to clean those warnings up, unless they are not going to affect filesystem operation, would be greatly appreciated :)
> 
> Thanks,
> Marc

Thanks for the updated information. I'm sorry that the false alert make 
you feel nervous.

> 
> ERROR: root 3862 EXTENT_DATA[18170706 4096] interrupt
> ERROR: root 3862 EXTENT_DATA[18170706 16384] interrupt
> ERROR: root 3862 EXTENT_DATA[18170706 20480] interrupt
> ERROR: root 3862 EXTENT_DATA[18170706 135168] interrupt
> ERROR: root 3862 EXTENT_DATA[18170706 1048576] interrupt
> ERROR: errors found in fs roots

However, this looks like another problem. Could you dump this file tree 
by the following command?
# btrfs-debug-tree -t 3862 <dev> | grep -C 10 18170706

-- 
Thanks,
Lu


