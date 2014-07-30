Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:34298 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaG3TkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 15:40:03 -0400
Received: by mail-vc0-f172.google.com with SMTP id im17so2642302vcb.31
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 12:40:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bec96bdc2461f34e88cda22119982fcf.squirrel@webmail.wanet.net>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
	<20140730093821.GJ31950@carfax.org.uk>
	<4161ea8377c20da597d4fdbb65613cf1.squirrel@webmail.wanet.net>
	<CAPDOMVgNRJete6N=q9xYCTo-xaL_E2Kjo=NOcfncGLSKkmGuig@mail.gmail.com>
	<bec96bdc2461f34e88cda22119982fcf.squirrel@webmail.wanet.net>
Date: Wed, 30 Jul 2014 15:40:01 -0400
Message-ID: <CAPDOMVgs4pJ+vKSuQEyuOvPA3neZLGypm3_TdP2F_qXyBCy0yg@mail.gmail.com>
Subject: Re: Work Queue for btrfs compression writes
From: Nick Krause <xerofoify@gmail.com>
To: ashford@whisperpc.com
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 2:31 PM,  <ashford@whisperpc.com> wrote:
> Nick,
>
>> On Wed, Jul 30, 2014 at 11:36 AM,  <ashford@whisperpc.com> wrote:
>>>> On Tue, Jul 29, 2014 at 11:54:20PM -0400, Nick Krause wrote:
>>>>> Hey Guys ,
>>>>> I interested in helping improving the compression of btrfs by using  a
>>>>> set of threads using work queues like XFS
>>>>> or reads and keeping the page cache after reading compressed blocks as
>>>>> these seem to be a great way to improve
>>>>> on  compression performance mostly with large partitions of compressed
>>>>> data.
>>>>
>>>>    I suspect that this may be a medium-sized project, rather than a
>>>> small one. My gut feeling (based on limited experience) is that the
>>>> fallocate extensions project would be considerably simpler.
>>>>
>>>>    Hugo.
>>>
>>> I may be in error, but I believe this may be a bit more complex than
>>> just
>>> routing all reads and writes through a decompression/compression work
>>> queue.  On the write side, it might be better to compress the
>>> synchronous
>>> requests in-line, instead of going through a work queue.  Similarly, on
>>> the read side, it might be better to decompress user-requested data (and
>>> metadata) in-line, and have any system-generated read-ahead data be
>>> decompressed in a work queue (the same work queue?).
>>>
>>> I believe that one of the significant concerns of the above is that the
>>> compression and decompression routines will have to be verified to be
>>> thread-safe.  If BTRFS is using the same compression/decompression
>>> routines that other file-systems use, then the core code is almost
>>> certainly thread-safe.  Any BTRFS wrapper code will have to be verified.
>>
>> Seems that the code from my reading is that the code is using the same
>> compression
>> routines as the other file systems. You seem to have some ideas on how
>> to write this
>> or improve it at least, if you want you can send me a list of ideas
>> that you have.
>
> Sorry.  It's been almost 20 years since I did any serious kernel work, and
> that kernel (not Linux) didn't even know how to page.  There have been too
> many changes since then for me to be able to climb back in with under a
> year of hard work.  Even then, I would select a simpler task than this to
> start on.
>
> What I DO remember is that the layer you're working on is fairly low in
> the stack.  The application, kernel and file-system have already had a
> chance to prioritize the I/O requests as synchronous or asynchronous.
> That prioritization must be properly handled, or the overall stability of
> BTRFS will be at risk.
>
> Good luck.
>
> Peter Ashford
>
Peter,
Seems like a challenge and I like challenges.
Regards Nick
