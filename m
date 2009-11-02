From: John Dong <jdong@ubuntu.com>
Subject: Re: announcement of deduplication in Sun ZFS
Date: Mon, 2 Nov 2009 18:26:00 -0500
Message-ID: <706AB5DA-1173-490C-8E62-FC8136DB375A@ubuntu.com>
References: <934f64a20911021225o12acdb81u7a8a55afbf49963b@mail.gmail.com> <5f8586d40911021251n75161177s1230f44c1a4b9917@mail.gmail.com> <200911031004.57592.chris@csamuel.org>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911031004.57592.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I don't think ZFS has any goals of being resilient to errors as far as  
recovering from them without backups / redundant disks.... Errors  
would still be detected though more data of course would be  
unavailable potentially.
On Nov 2, 2009, at 6:04 PM, Chris Samuel wrote:

> On Tue, 3 Nov 2009 07:51:52 am Alex Dedul wrote:
>
>> In any way thats a nice and interesting feature, thanks! :)
>
> My concern would be that it increases the impact of a corruption of  
> the block
> that has been de-dup'd - in other words if the block that now  
> represents the
> same data in lots of files gets trashed then all those files have  
> corrupt
> data. This implies that you would want to keep around at least one  
> other copy
> of that data to be resilient in the face of corruption (checksums  
> will let you
> detect it, but not necessarily recover from it without duplicate  
> copies).
>
> Given that ZFS prides itself on detecting errors it would be strange  
> if they
> hadn't considered this in the implementation but I couldn't see any  
> mention of
> it.
>
> cheers,
> Chris

