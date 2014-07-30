Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:43522 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753342AbaG3PgV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 11:36:21 -0400
Message-ID: <4161ea8377c20da597d4fdbb65613cf1.squirrel@webmail.wanet.net>
In-Reply-To: <20140730093821.GJ31950@carfax.org.uk>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
    <20140730093821.GJ31950@carfax.org.uk>
Date: Wed, 30 Jul 2014 08:36:14 -0700
Subject: Re: Work Queue for btrfs compression writes
From: ashford@whisperpc.com
To: "Hugo Mills" <hugo@carfax.org.uk>, "Nick Krause" <xerofoify@gmail.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Tue, Jul 29, 2014 at 11:54:20PM -0400, Nick Krause wrote:
>> Hey Guys ,
>> I interested in helping improving the compression of btrfs by using  a
>> set of threads using work queues like XFS
>> or reads and keeping the page cache after reading compressed blocks as
>> these seem to be a great way to improve
>> on  compression performance mostly with large partitions of compressed
>> data.
>
>    I suspect that this may be a medium-sized project, rather than a
> small one. My gut feeling (based on limited experience) is that the
> fallocate extensions project would be considerably simpler.
>
>    Hugo.

I may be in error, but I believe this may be a bit more complex than just
routing all reads and writes through a decompression/compression work
queue.  On the write side, it might be better to compress the synchronous
requests in-line, instead of going through a work queue.  Similarly, on
the read side, it might be better to decompress user-requested data (and
metadata) in-line, and have any system-generated read-ahead data be
decompressed in a work queue (the same work queue?).

I believe that one of the significant concerns of the above is that the
compression and decompression routines will have to be verified to be
thread-safe.  If BTRFS is using the same compression/decompression
routines that other file-systems use, then the core code is almost
certainly thread-safe.  Any BTRFS wrapper code will have to be verified.

Peter Ashford

