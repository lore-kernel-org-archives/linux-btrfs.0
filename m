Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35854 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933392AbcK2O65 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 09:58:57 -0500
Received: by mail-io0-f172.google.com with SMTP id m5so155653520ioe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 06:58:56 -0800 (PST)
Subject: Re: True size of btrfs data chunk
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi74qK2v0JCtAjan8aju+sK3LWPWwMgnJOP3i2srrqnLHSA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <44a745cd-ebb0-e62b-371c-8a37edd951fb@gmail.com>
Date: Tue, 29 Nov 2016 09:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAGqmi74qK2v0JCtAjan8aju+sK3LWPWwMgnJOP3i2srrqnLHSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-29 09:32, Timofey Titovets wrote:
> Hi, as wiki say https://btrfs.wiki.kernel.org/index.php/Glossary:
> A part of a block group. Chunks are either 1 GiB in size (for data) or
> 256 MiB (for metadata).
This is only about the normal case.  Chunks are variable in size.  In 
most cases, data chunks will be 1GB and metadata 256MB.  They will 
however be smaller if there isn't enough space left for a full chunk, 
and will get larger as well once you get past a certain filesystem size 
(I don't remember the exact size, but I've seen people talking about big 
(double digit TB sized) filesystems with 5GB+ sized data chunks).
>
> Btrfs tools show me that allocated size is not 1GiB aligned, things
> are changes? I miss something?
>
> # btrfs fi df /; btrfs fi usage /;
> Data, single: total=1.41GiB, used=704.47MiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=256.00MiB, used=54.30MiB
> GlobalReserve, single: total=32.00MiB, used=0.00B
> Overall:
>    Device size:                   4.00GiB
>    Device allocated:              1.69GiB
>    Device unallocated:            2.31GiB
>    Device missing:                  0.00B
>    Used:                        758.79MiB
>    Free (estimated):              3.03GiB      (min: 3.03GiB)
>    Data ratio:                       1.00
>    Metadata ratio:                   1.00
>    Global reserve:               32.00MiB      (used: 0.00B)
>
> Data,single: Size:1.41GiB, Used:704.47MiB
>   /dev/sda1       1.41GiB
>
> Metadata,single: Size:256.00MiB, Used:54.30MiB
>   /dev/sda1     256.00MiB
>
> System,single: Size:32.00MiB, Used:16.00KiB
>   /dev/sda1      32.00MiB
>
> Unallocated:
>   /dev/sda1       2.31GiB
>
> Thanks.
>

