Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55323 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932382AbcISVDu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 17:03:50 -0400
Subject: Re: stability matrix
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net> <20160919152753.GG933@twin.jikos.cz>
 <bc71caf0-4656-382b-479d-e135ee7f4bc7@gmail.com>
 <1474314776.10189.24.camel@scientia.net>
 <7d60b7ae-7a5f-a386-9472-9237cacfb046@fb.com>
 <1474317360.10189.27.camel@scientia.net>
From: Chris Mason <clm@fb.com>
Message-ID: <c2816e5f-c3b9-0ee6-551b-08ef5a175a2b@fb.com>
Date: Mon, 19 Sep 2016 17:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <1474317360.10189.27.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/19/2016 04:36 PM, Christoph Anton Mitterer wrote:
> On Mon, 2016-09-19 at 16:07 -0400, Chris Mason wrote:
>> That's in the blockdev command (blockdev --setro /dev/xxx).
> Well, I know that ;-) ... but I bet most end-user don't (just as most
> end-users assume mount -r is truly ro)...
>

It's a tradeoff, without the log replay traditional filesystems wouldn't 
be able to mount at all after a crash.  Since most init systems default 
to ro at the beginning, it would have been awkward to introduce the 
logging filesystems into established systems.

16+ years later, I still feel it's still the path of least surprise.

-chris
