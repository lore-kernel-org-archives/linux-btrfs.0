Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34792 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbcGEX7P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 19:59:15 -0400
Received: by mail-vk0-f54.google.com with SMTP id t66so2022074vka.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 16:59:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <577AEE25.9000704@mail.ru>
References: <5776CF08.5040601@mail.ru> <CAPmG0jaDczRh3wLULW17pNSxKHnCPY0A3UxchsDy5C=xHH8XCQ@mail.gmail.com>
 <577AEE25.9000704@mail.ru>
From: Henk Slager <eye1tm@gmail.com>
Date: Wed, 6 Jul 2016 01:59:13 +0200
Message-ID: <CAPmG0jb8rTdTYp=RzYciXRVaF5y0obJX439zc95p4nSAuHOyug@mail.gmail.com>
Subject: Re: btrfs defrag questions
To: Dmitry Katsubo <dma_k@mail.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 5, 2016 at 1:15 AM, Dmitry Katsubo <dma_k@mail.ru> wrote:
> On 2016-07-01 22:46, Henk Slager wrote:
>> (email ends up in gmail spamfolder)
>> On Fri, Jul 1, 2016 at 10:14 PM, Dmitry Katsubo <dma_k@mail.ru> wrote:
>>> Hello everyone,
>>>
>>> Question #1:
>>>
>>> While doing defrag I got the following message:
>>>
>>> # btrfs fi defrag -r /home
>>> ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
>>> total 1 failures
>>>
>>> I feel that something went wrong, but the message is a bit misleading.
>>>
>>> Provided that Dropbox is running in the system, does it mean that it
>>> cannot be defagmented?
>>
>> I think it is a matter of newlines in btrfs-progs and/or stdout/stderr mixup.
>>
>> You should run the command with -v and probably also with -f, so that
>> it gets hopefully clearer what is wrong.
>
> Running with "-v -f" (or just "-v") result the same output:
>
> ...
> /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/select.so
> /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/grp.so
> /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/posixffi.libc._posixffi_libcERROR: defrag failed on /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox: Success
> .so
> /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/_functools.so
> /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox
> /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/_csv.so
> ...
>
> This is not a matter of newlines:
>
> $ grep -rnH 'defrag failed' btrfs-progs
> btrfs-progs/cmds-filesystem.c:1021:       error("defrag failed on %s: %s", fpath, strerror(e));
> btrfs-progs/cmds-filesystem.c:1161:                       error("defrag failed on %s: %s", argv[i], strerror(e));
>
>> That it fails on dropbox is an error I think, but maybe known: Could
>> be mount option is compress and that that causes trouble for defrag
>> although that should not happen.
>
> True, compression is enabled.

The reason I mentioned compression is that this adds another layer
between the disksectors and the (4K) pages in RAM. My thinking is that
if defrag is done by the kernel (which is the case AFAIK), it should
in theory be possible to hook at some layer, so that in the case in
this email defrag should be able to work.

The big question is, if it is worth the (probably complex)
implementation effort, independent whether you consider this bug or a
feature enhancement.

My experience with manual defrag (so initiated by btrfs-progs) is that
it can take long time and the result can be worse than a copy-mv
sequence (real copy, no --reflink, so done with cat or dd or rsync)
and is also way faster. This is for files in GiB range and with
snapshots existing (no compression). With no compression and no
snapshots, it might be different.

>> You can defrag just 1 file, so maybe you could try to make a reproducible case.
>
> When I run it on one file, it works as expected:
>
> # btrfs fi defrag -r -v /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox
> ERROR: cannot open /home/user/.dropbox-dist/dropbox-lnx.x86-5.4.24/dropbox: Text file busy
>
>> What kernel?
>> What btrfs-progs?
>
> kernel v4.4.6
> btrfs-tools v4.5.2
>
>>> Question #2:
>>>
>>> Suppose that in above example /home/ftp is mounted as another btrfs
>>> array (not subvolume). Will 'btrfs fi defrag -r /home' defragment it
>>> (recursively) as well?
>>
>> I dont know, I dont think so, but you can simply try.
>
> Many thanks, now I see how can I check this. Unfortunately it does not
> descend into submounted directories.
>
> --
> With best regards,
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
