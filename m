Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33880 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbcAQV1x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 16:27:53 -0500
Received: by mail-ig0-f171.google.com with SMTP id ik10so44276979igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Jan 2016 13:27:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <569BFCB1.2000107@xoxy.net>
References: <5698B534.4040202@xoxy.net>
	<CAGqmi76EQ1NYFhp7hdwdrP0VTNXdSYgePje036UGRWDnUV=EWw@mail.gmail.com>
	<CAL3q7H7pQ576qKqknWEA2Trgu4hn_6SV00vm2fLwz=_MJ8Nw2Q@mail.gmail.com>
	<569BFCB1.2000107@xoxy.net>
Date: Sun, 17 Jan 2016 14:27:52 -0700
Message-ID: <CAJCQCtTg0s=f8FTPtXsn7-g-Lf=duBDH2ATV-muB34XVG_Ce0A@mail.gmail.com>
Subject: Re: Copying between lzo compressed BtrFS's: de/re-compressing.
From: Chris Murphy <lists@colorremedies.com>
To: Diagon <kernel.boxy@xoxy.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 17, 2016 at 1:42 PM, Diagon <kernel.boxy@xoxy.net> wrote:
> On 01/15/2016 04:25 AM, Filipe Manana wrote:
>> On Fri, Jan 15, 2016 at 9:56 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>
>>> 2016-01-15 12:00 GMT+03:00 Diagon <kernel.boxy@xoxy.net>:
>
>>>> I'm copying a large number of files between two lzo compressed BtrFS
>>>> filesystems on different drives mounted on the same machine. It appears
>>>> that the files are being de/re-compressed. Is there a way avoid this?
>>>
>>> If you just copy files, files will be decompressed while reading and
>>> recompressed while writing
>>> For avoiding this, you must use send receive feature
>>
>> No, send/receive does not avoid decompression on the send side nor
>> re-compression at the receiving side. The receiving side writes the
>> data from a send stream, which is uncompressed, to the destination
>> filesystem using standard system calls like write/pwrite.
>
> So, just to spell it out, I understand that de/re-compression is
> unavoidable?  (And I'll post that to my stackexchange question.)

It's unavoidable when replicating data across file systems
(send/receive, rsync, cp). It's avoidable if you use a seed device,
add a new device, then delete the seed. While the volume UUID changes
with this process, the duplicate volume is essentially the same as the
source (the process copies chunks), which means the chunk profile is
also preserved.

-- 
Chris Murphy
