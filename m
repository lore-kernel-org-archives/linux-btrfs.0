Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:39105 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbcFJT6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 15:58:17 -0400
Subject: Re: Allocator behaviour during device delete
To: Henk Slager <eye1tm@gmail.com>
References: <00ad8257-ba24-fe62-5c93-8db426afec69@swiftspirit.co.za>
 <f88b62ed-1e17-2f67-8d0d-210ad96cace5@gmail.com>
 <9f5e3c8d-6461-887a-0574-6104f48d0957@swiftspirit.co.za>
 <CAPmG0jarU7qKzWQrE3Z-a6vieQGcei4G6tXQcGkAK6ocabNAsQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <575B1BD4.2010503@mendix.com>
Date: Fri, 10 Jun 2016 21:58:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jarU7qKzWQrE3Z-a6vieQGcei4G6tXQcGkAK6ocabNAsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2016 09:26 PM, Henk Slager wrote:
> On Thu, Jun 9, 2016 at 3:54 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
>>
>> On 06/09/2016 03:07 PM, Austin S. Hemmelgarn wrote:
>>>
>>> OK, I'm pretty sure I know what was going on in this case.  Your
>>> assumption that device delete uses the balance code is correct, and that
>>> is why you see what's happening happening.  There are two key bits that
>>> are missing though:
>>> 1. Balance will never allocate chunks when it doesn't need to.
>
> In relation to discussions w.r.t. enospc and device full of chunks, I
> say this 1. statement and I see different behavior with kernel 4.6.0
> tools 4.5.3
> On a idle fs with some fragmentation, I did balance -dusage=5, it
> completes succesfuly and leaves and new empty chunk (highest vaddr).
> Then balance -dusage=6, does 2 chunks with that usage level:
> - the zero filled last chunk is replaced with a new empty chunk (higher vaddr)
> - the 2 usage=6 chunks are gone
> - one chunk with the lowest vaddr saw its usage increase from 47 to 60
> - several metadata chunks have change slightly in usage

I noticed the same thing, kernel 4.5.4, progs 4.4.1.

When balance starts doing anything, (so relocating >= 1 chunks, not when 
relocating 0), it first creates a new empty chunk. Even if all data that 
is balanced away is added to already existing chunks, the new empty one 
is still always left behind.

When doing balance again with dusage=0, or repeatedly doing so, each 
time a new empty chunk is created, and then the previous empty one is 
removed, bumping up the start vaddr of the new chunk with 1GB each time.

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
