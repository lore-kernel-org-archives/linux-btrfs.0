Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:60356 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdI3R41 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 13:56:27 -0400
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
 <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
Date: Sat, 30 Sep 2017 19:56:25 +0200
MIME-Version: 1.0
In-Reply-To: <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/17 18:37, Graham Cobb wrote:
> On 30/09/17 14:08, Holger Hoffstätte wrote:
>> A "root" subvolume is identified by a null parent UUID, so adding a new
>> subvolume filter and flag -P ("Parent") does the trick. 
> 
> I don't like the naming. The flag you are proposing is really nothing to
> do with whether a subvolume is a parent or not: it is about whether it
> is a snapshot or not (many subvolumes are both snapshots and also
> parents of other snapshots, and many non-snapshots are not the parent of
> any subvolumes).

You're completely right. I wrote that patch about a year ago because I
needed it for my own homegrown backup program and spent approx. 5 seconds
finding a free option letter; ultimately I ended up using the mentioned
shell hackery as alternative. Anyway, I was sure that at the time the
other letters sounded even worse/were taken, but that may just have been
in my head. ;-)

I just rechecked and -S is still available, so that's good.

> I have two suggestions:
> 
> 1) Use -S (meaning "not a snapshot", the inverse of -s). Along with this
> change. I would change the usage text to say something like:
> 
>  -s list subvolumes originally created as snapshots
>  -S list subvolumes originally created not as snapshots
> 
> Presumably specifying both -s and -S should be an error.

That sounds much better indeed and is a quick fix. While I agree
that the "-P <uuid>/none" filter would be useful too, it's also
a different feature and more work than I want to invest in this
right now. Maybe later "-S" can simply delegate to "-P none".

cheers
Holger
