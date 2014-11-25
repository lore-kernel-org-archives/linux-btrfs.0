Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36303 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaKYKw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 05:52:57 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so250418iec.25
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 02:52:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125103024.GC23574@localhost.localdomain>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <pan.2014.11.24.08.23.25@googlemail.com> <pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
 <CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com> <20141125103024.GC23574@localhost.localdomain>
From: =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>
Date: Tue, 25 Nov 2014 11:52:36 +0100
Message-ID: <CAPLrYEQeOS0n5WA_TazeG1N9AdtjkUc9GEZOUr7JUOxXqg_nnQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
To: bo.li.liu@oracle.com
Cc: John Williams <jwilliams4200@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-11-25 11:30 GMT+01:00 Liu Bo <bo.li.liu@oracle.com>:
> On Mon, Nov 24, 2014 at 11:34:46AM -0800, John Williams wrote:
>> On Mon, Nov 24, 2014 at 12:23 AM, Holger Hoffstätte
>> <holger.hoffstaette@googlemail.com> wrote:
>>
>> > Would there be room for a compromise with e.g. 128 bits?
>>
>> For example, Spooky V2 hash is 128 bits and is very fast. It is
>> noncryptographic, but it is more than adequate for data checksums.
>>
>> http://burtleburtle.net/bob/hash/spooky.html
>>
>> SnapRAID uses this hash, and it runs at about 15 GB/sec on my machine
>> (Xeon E3-1270 V2 @ 3.50Ghz)
>
> Thanks for the suggestion, I'll take a look.
>
> Btw, it's not in kernel yet, is it?
>

The best option would be blake2b, but it isn't implemented in the
kernel. It is not a problem to use it locally (I can upload the code
stripped for usage in kernel).

from https://blake2.net/

Q: Why do you want BLAKE2 to be fast? Aren't fast hashes bad?

A: You want your hash function to be fast if you are using it to
compute the secure hash of a large amount of data, such as in
distributed filesystems (e.g. Tahoe-LAFS), cloud storage systems (e.g.
OpenStack Swift), intrusion detection systems (e.g. Samhain),
integrity-checking local filesystems (e.g. ZFS), peer-to-peer
file-sharing tools (e.g. BitTorrent), or version control systems (e.g.
git). You only want your hash function to be slow if you're using it
to "stretch" user-supplied passwords, in which case see the next
question.

https://blake2.net/
https://github.com/floodyberry/blake2b-opt

Best regards,
Daniel
