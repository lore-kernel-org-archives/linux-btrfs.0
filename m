Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33144 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcK1Tjh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:39:37 -0500
Received: by mail-io0-f194.google.com with SMTP id j92so24859139ioi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 11:39:36 -0800 (PST)
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
To: Christoph Anton Mitterer <calestyo@scientia.net>, kreijack@inwind.it,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <20161126185402.GK8685@hungrycats.org>
 <59e0b1c7-51a9-ede4-6571-fa0b20394145@inwind.it>
 <451f26a9-2880-9887-c17e-97c2690a2baa@cn.fujitsu.com>
 <ad8f8dd8-123f-bbf3-04fb-bb6b64a050fd@inwind.it>
 <1480359711.6747.13.camel@scientia.net>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56437dde-944a-52dd-146d-d94824ed408e@gmail.com>
Date: Mon, 28 Nov 2016 14:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <1480359711.6747.13.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-28 14:01, Christoph Anton Mitterer wrote:
> On Mon, 2016-11-28 at 19:45 +0100, Goffredo Baroncelli wrote:
>> I am understanding that the status of RAID5/6 code is so badly
> Just some random thought:
>
> If the code for raid56 is really as bad as it's often claimed (I
> haven't read it, to be honest) .... could it perhaps make sense to
> consider to start it from scratch? And/or merge it with a more generic
> approach that allows n-way-parity RAIDs (I think such patch was posted
> hear some year(s) ago).
Such a suggestion for higher order parity support was made some time ago 
(at least a year and a half I believe, probably more).  It was at the 
time stated that it was planned after n-way replication and raid5/6.

Personally I feel that sort of road-map is misguided, as all three are 
functionally interdependent as the original proposal had suggested, and 
I'm also of the opinion that the raid5/6 code probably should be redone 
from scratch (I wasn't the one who wrote it, and can't contribute much 
more than some attempts at testing as a third-party, so I obviously 
can't make that decision myself).  Doing so would likely make it much 
easier to implement higher order parity (and arbitrary 
striping/replication, which is something I'm _very_ interested in).  The 
existing code isn't bad in a stylistic or even traditional coding sense, 
but makes a significant number of poor choices in the high-level side of 
things (all the issues with parity for example).  If we just want 
working raid5/6, then working on the existing implementation is fine. 
If we want support for arbitrary combinations of 
striping/replication/parity (which would be a killer feature and 
something that BTRFS could actually say nothing else has), then 
rewriting from scratch is probably easier because of some of the 
low-level design choices made in the raid5/6 code.

Part of the problem though is that there are more admins and support 
focused people than coders involved.  In my case I very much do not have 
the expertise to work on kernel code beyond tweaking constants and 
twiddling default values for things (I'm technically a programmer, but 
90% of the work I do is sysops type stuff written in a mix of sh, 
Python, and about 7 different data serialization formats).
