Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:37193 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2IEFpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 01:45:54 -0400
Message-ID: <5046E747.7000209@inwind.it>
Date: Wed, 05 Sep 2012 07:46:47 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Shentino <shentino@gmail.com>
CC: Michael <mike@draftx.net>, cwillu <cwillu@cwillu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: rfc: fuzz testing by direct writes to device
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com> <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com> <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com> <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com> <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com> <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com> <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com> <CAGDaZ_qD-RHvZk31GYZRTAjUNJ4dTm1wXk1kQELE2p+=xG3yzA@mail.gmail.com> <5046452C.7090804@libero.it> <CAGDaZ_pCsS=kC-yn5UvtZO7U1V9RzFUcch5=N6XnRxXu2cQoZQ@mail.gmail.com>
In-Reply-To: <CAGDaZ_pCsS=kC-yn5UvtZO7U1V9RzFUcch5=N6XnRxXu2cQoZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2012 03:59 AM, Shentino wrote:
>> >  I am not sure that doing "sed</dev/sdX>/dev/sdX ..." is the right thing to
>> >  do, because it rewrites the full disk. This means that:
>> >  - it takes a lot of time
>> >  - you don't have any control about which part of the disk you change: what
>> >  happens if sed write a block which is update in parallel by BTRFS ?
> Which is one reason I used a sha1 hash of a random read as the search key :P

This doesn't change. The race would be the following:

1- kernel read a sector from the disk
2- sed read a sector from the disk
3- sed write a sector to the disk (the same data or an update one 
doesn't matter)
4- kernel write an update sector to the disk

If 3 and 4 are different data the results are unpredictable. Yes it is a 
very unlikely case, but it could happens.


