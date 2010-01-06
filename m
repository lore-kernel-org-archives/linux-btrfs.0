From: jim owens <jowens@hp.com>
Subject: Re: [RFC 00/12] btrfs core patches for direct I/O
Date: Wed, 06 Jan 2010 13:53:02 -0500
Message-ID: <4B44DC0E.5050903@hp.com>
References: <4B425968.4020308@hp.com> <87ocl7bgg0.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87ocl7bgg0.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
> jim owens <jowens@hp.com> writes:
> 
>> The existing core code for pagecache
>> doesn't work for directio because the existing I/O routines depend
>> on peeking inside a struct page to get the valid btrfs inode info.
>> Sorry, no can do, we don't own that page. And rewriting the whole
>> pagecache I/O stack to eliminate dependence on struct page would
>> be too scary IMO.
> 
> That would simply need another passed argument in a few strategic
> places, won't it? I can't imagine it would need a full "rewrite"

I should not have said "rewrite", it is the wrong word, and yes
some changes in some places would be easy.

jim
