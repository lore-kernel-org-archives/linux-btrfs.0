Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:37723 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755312AbaG3Sbk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 14:31:40 -0400
Message-ID: <bec96bdc2461f34e88cda22119982fcf.squirrel@webmail.wanet.net>
In-Reply-To: <CAPDOMVgNRJete6N=q9xYCTo-xaL_E2Kjo=NOcfncGLSKkmGuig@mail.gmail.com>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
    <20140730093821.GJ31950@carfax.org.uk>
    <4161ea8377c20da597d4fdbb65613cf1.squirrel@webmail.wanet.net>
    <CAPDOMVgNRJete6N=q9xYCTo-xaL_E2Kjo=NOcfncGLSKkmGuig@mail.gmail.com>
Date: Wed, 30 Jul 2014 11:31:39 -0700
Subject: Re: Work Queue for btrfs compression writes
From: ashford@whisperpc.com
To: "Nick Krause" <xerofoify@gmail.com>
Cc: ashford@whisperpc.com, "Hugo Mills" <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nick,

> On Wed, Jul 30, 2014 at 11:36 AM,  <ashford@whisperpc.com> wrote:
>>> On Tue, Jul 29, 2014 at 11:54:20PM -0400, Nick Krause wrote:
>>>> Hey Guys ,
>>>> I interested in helping improving the compression of btrfs by using  a
>>>> set of threads using work queues like XFS
>>>> or reads and keeping the page cache after reading compressed blocks as
>>>> these seem to be a great way to improve
>>>> on  compression performance mostly with large partitions of compressed
>>>> data.
>>>
>>>    I suspect that this may be a medium-sized project, rather than a
>>> small one. My gut feeling (based on limited experience) is that the
>>> fallocate extensions project would be considerably simpler.
>>>
>>>    Hugo.
>>
>> I may be in error, but I believe this may be a bit more complex than
>> just
>> routing all reads and writes through a decompression/compression work
>> queue.  On the write side, it might be better to compress the
>> synchronous
>> requests in-line, instead of going through a work queue.  Similarly, on
>> the read side, it might be better to decompress user-requested data (and
>> metadata) in-line, and have any system-generated read-ahead data be
>> decompressed in a work queue (the same work queue?).
>>
>> I believe that one of the significant concerns of the above is that the
>> compression and decompression routines will have to be verified to be
>> thread-safe.  If BTRFS is using the same compression/decompression
>> routines that other file-systems use, then the core code is almost
>> certainly thread-safe.  Any BTRFS wrapper code will have to be verified.
>
> Seems that the code from my reading is that the code is using the same
> compression
> routines as the other file systems. You seem to have some ideas on how
> to write this
> or improve it at least, if you want you can send me a list of ideas
> that you have.

Sorry.  It's been almost 20 years since I did any serious kernel work, and
that kernel (not Linux) didn't even know how to page.  There have been too
many changes since then for me to be able to climb back in with under a
year of hard work.  Even then, I would select a simpler task than this to
start on.

What I DO remember is that the layer you're working on is fairly low in
the stack.  The application, kernel and file-system have already had a
chance to prioritize the I/O requests as synchronous or asynchronous. 
That prioritization must be properly handled, or the overall stability of
BTRFS will be at risk.

Good luck.

Peter Ashford

