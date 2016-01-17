Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender153-mail.zoho.com ([74.201.84.153]:22618 "EHLO
	sender153-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbcAQUmi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 15:42:38 -0500
Subject: Re: Copying between lzo compressed BtrFS's: de/re-compressing.
References: <5698B534.4040202@xoxy.net>
 <CAGqmi76EQ1NYFhp7hdwdrP0VTNXdSYgePje036UGRWDnUV=EWw@mail.gmail.com>
 <CAL3q7H7pQ576qKqknWEA2Trgu4hn_6SV00vm2fLwz=_MJ8Nw2Q@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Diagon <kernel.boxy@xoxy.net>
Message-ID: <569BFCB1.2000107@xoxy.net>
Date: Sun, 17 Jan 2016 12:42:25 -0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7pQ576qKqknWEA2Trgu4hn_6SV00vm2fLwz=_MJ8Nw2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/15/2016 04:25 AM, Filipe Manana wrote:
> On Fri, Jan 15, 2016 at 9:56 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:

>> 2016-01-15 12:00 GMT+03:00 Diagon <kernel.boxy@xoxy.net>:

>>> I'm copying a large number of files between two lzo compressed BtrFS
>>> filesystems on different drives mounted on the same machine. It appears
>>> that the files are being de/re-compressed. Is there a way avoid this?
>>
>> If you just copy files, files will be decompressed while reading and
>> recompressed while writing
>> For avoiding this, you must use send receive feature
> 
> No, send/receive does not avoid decompression on the send side nor
> re-compression at the receiving side. The receiving side writes the
> data from a send stream, which is uncompressed, to the destination
> filesystem using standard system calls like write/pwrite.

So, just to spell it out, I understand that de/re-compression is
unavoidable?  (And I'll post that to my stackexchange question.)

>> Have a nice day,
>> Timofey.

Thanks
/D.

