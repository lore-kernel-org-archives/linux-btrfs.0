Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC8AC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 13:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38ABC2184B
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 13:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfAWNxF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:53:05 -0500
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:21340
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbfAWNxF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 08:53:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CqBAC1cEhc/1rB77ZjGwEBAQEDAQE?=
 =?us-ascii?q?BBwMBAQGBZYIEgTEEMyeEAYh5jHEIJTUBg0yVfDgBhDoEAgKCeyM4EgEDAQE?=
 =?us-ascii?q?BAQEBAm0ohUoBAQEBAgEjMyMQCw4KAgImAgI5HgYNBgIBAYMegXoHrBmBL4V?=
 =?us-ascii?q?DhG2BC4tNgUA/gTgMZH1QLogKgjUiApBVkVEJgjOLd4NwHoFnJoV0gk+HSJ0?=
 =?us-ascii?q?LIYFWTR8ZgyeCJxeOMi4wgQMBh0sGgkcBAQ?=
X-IPAS-Result: =?us-ascii?q?A2CqBAC1cEhc/1rB77ZjGwEBAQEDAQEBBwMBAQGBZYIEg?=
 =?us-ascii?q?TEEMyeEAYh5jHEIJTUBg0yVfDgBhDoEAgKCeyM4EgEDAQEBAQEBAm0ohUoBA?=
 =?us-ascii?q?QEBAgEjMyMQCw4KAgImAgI5HgYNBgIBAYMegXoHrBmBL4VDhG2BC4tNgUA/g?=
 =?us-ascii?q?TgMZH1QLogKgjUiApBVkVEJgjOLd4NwHoFnJoV0gk+HSJ0LIYFWTR8ZgyeCJ?=
 =?us-ascii?q?xeOMi4wgQMBh0sGgkcBAQ?=
X-IronPort-AV: E=Sophos;i="5.56,511,1539619200"; 
   d="scan'208";a="197725655"
Received: from 182-239-193-90.ip.adam.com.au (HELO Nostromo.Underworld) ([182.239.193.90])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 23 Jan 2019 21:53:01 +0800
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
From:   Dennis Katsonis <dennisk@netspace.net.au>
Openpgp: preference=signencrypt
Message-ID: <b36e4ef6-6f07-1430-45a0-df9d44d472fe@netspace.net.au>
Date:   Thu, 24 Jan 2019 00:52:58 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/23/19 10:25 PM, Andrei Borzenkov wrote:
> On Wed, Jan 23, 2019 at 1:45 PM Dennis Katsonis <dennisk@netspace.net.au> wrote:
>> I think my previous e-mail did not go through.  Basically, if it is
>> assumed that a btrfs-receive operation will result in a subvolume which
>> matches the source file for file, then this assumption or expectation
>> won't be met if one deletes files from the subvolume at the receiving
>> end which is going to be referred to as the parent.
>>
> 
> This is oxymoron. btrfs send/receive apply to read-only subvolumes.
> You are not able to modify them. 


> 
>> This can happen inadvertently,
> 
> It cannot. You do not inadvertently make subvolume read-write. 
It's not the individual steps which happen inadvertently, its that
particular workflow which can happen (i.e.; someone decides to play
around with a replicated snapshot, and flips the ro bit to do so).  Any
subsequent children sent later won't be true replicates on the receiving
end.

They would have to either make a habit of not flipping that ro bit at
all (there is nothing to say don't do it, and there are valid reasons to
do so) or anticipate they may need that subvolume as a parent anytime in
the future and that parents must be the same on both ends (there is
nothing which states that parents have to be identical on both ends for
btrfs-receive to operate).  If they do modify ANY subvolume created by
btrfs-receive, they must remember in the future somehow never to use
them as parents.

BTRFS allows an ad-hoc, unstructured approach to managing snapshots and
replication, but the cost I suppose is there are more corner cases and
more potential for users to use the system in a manner which differs
from the devs.


> 
> That said, better if btrfs did not allow flipping read-only bit in the
> first place.
> 
>> or even through filesystem corruption
>> (which I experienced).
>>
> 
> And if corruption happened after applying changes? End result in the
> same. Of course it would be perfect if btrfs could notice and warn
> you, I just do not see how it can realistically be implemented.
>If the tools can't prevent it, the documentation should, and should also
ideally describe the mode of failure (i.e., if the subvolumes are
different, btrfs-receive won't necessarily fail, but can produce a
subvolume which is not identical to that sent.

At the moment, one must infer that the statement that clones must be
identical at both ends.
