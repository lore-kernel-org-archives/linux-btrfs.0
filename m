Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33955 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753521AbcLIPnt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 10:43:49 -0500
Received: by mail-yw0-f180.google.com with SMTP id t125so17169192ywc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Dec 2016 07:43:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2d4f5ee2-fc2b-ac48-8f4b-eecf8936b9e1@petaramesh.org>
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <CAJCQCtS8zCMYYiedYpkL4bZE0PvEF+sLGG96Uq=Ms1qjd4uCpg@mail.gmail.com> <2d4f5ee2-fc2b-ac48-8f4b-eecf8936b9e1@petaramesh.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Dec 2016 08:43:48 -0700
Message-ID: <CAJCQCtRgFp6aMRBR8K6PKknGCyC6cxm80tG5xRq8O5hS31pzhA@mail.gmail.com>
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 9, 2016 at 6:45 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Hi Chris, thanks for your answer,
>
> On 12/09/2016 03:58 AM, Chris Murphy wrote:
>> Can you check some bigger files and see if they've become fragmented?
>> I'm seeing 1.4GiB files with 2-3 extents reported by filefrag, go to
>> over 5000 fragments during dedupe. This is not something I recall
>> happening some months ago.
>
> I have checked directories containing VM hard disks, that would be good
> candidates. As they're backed up using full rsyncs, I wouldn't expect
> them to be heavily fragmented (OTOH the whole BTRFS filesystem is lzo
> compressed, and I believe that it may affect the number of extents
> reported by filefrag...?)
>
> Anyway this is the number of fragments that I get for a bunch of VMS HD
> files which are in the range from a couple GB to about 20 GB.
>
> The number of fragments reported by filefrag : 2907, 2560, 314, 10107
>
> If compression has nothing to do with this, then this is heavy
> fragmentation.

It's probably not that fragmented. Due to compression, metadata
describes 128KiB extents even though the data is actually contiguous.

And it might be the same thing in my case also, even though no
compression is involved.


-- 
Chris Murphy
