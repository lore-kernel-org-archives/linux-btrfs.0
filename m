Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33318 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbcAYWNs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 17:13:48 -0500
Received: by mail-ig0-f182.google.com with SMTP id z14so44677989igp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 14:13:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A6082C.3030007@netcologne.de>
References: <56A230C3.3080100@netcologne.de>
	<CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
	<56A6082C.3030007@netcologne.de>
Date: Mon, 25 Jan 2016 15:13:47 -0700
Message-ID: <CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 4:34 AM, Christian Rohmann
<crohmann@netcologne.de> wrote:
> Hey there Henk, btrfs-enthusiasts,
>
>
> On 01/24/2016 03:30 AM, Henk Slager wrote:
>> It might be that just a full balance runs faster, so no filters, you
>> could try that. Otherwise I wouldn't know how to speedup, hopefully
>> the fs is still usable while balancing.
>
> Yes the FS is still usable, munin shows just a little increate in iops
> and disk latency. The filter should not affect the performance of a
> balance at all. I am simply saying to only consider chunks which are not
> spread across all disks yet. Finding out a chunks data distribution
> should not add any burden on the balancing.
>
> The balancing is still VERY VERY slow, we still have 93% left to
> balance. But since I did not hit any hardware limit (CPU or disk IO) I
> am confident to say btrfs-balance is buggy in this regard. CPU single
> thread performance will not explode anytime soon. But disks (or SSD)
> will still grow in size and so will their potential iops.
>
> With a 8 - 12 disk array growth I am not doing something crazy that has
> never been done before on a storage array either ;-)

Does anyone suspect a kernel regression here? I wonder if its worth it
to suggest testing the current version of all fairly recent kernels:
4.5.rc1, 4.4, 4.3.4, 4.2.8, 4.1.16? I think going farther back to
3.18.x isn't worth it since that's before the major work since raid56
was added. Quite a while ago I've done a raid56 rebuild and balance
that was pretty fast but it was only a 4 or 5 device test.

-- 
Chris Murphy
