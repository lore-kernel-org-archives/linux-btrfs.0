Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36377 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755375AbcHXSmS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 14:42:18 -0400
Received: by mail-oi0-f45.google.com with SMTP id f189so35119321oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 11:42:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com> <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 Aug 2016 12:16:32 -0600
Message-ID: <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2016 at 11:59 AM, Chris Murphy <lists@colorremedies.com> wrote:
> Plugging in the 'btrfs check' reporte backrefs into btrfs-debug-tree
>
> [chris@f24s ~]$ sudo btrfs-debug-tree -b 16913485824 /dev/mapper/brick1
> btrfs-progs v4.7
> checksum verify failed on 16913485824 found FEAA7A13 wanted 20000000
> checksum verify failed on 16913485824 found FEAA7A13 wanted 20000000
> bytenr mismatch, want=16913485824, have=14276644976086482944
> ERROR: failed to read 16913485824
>
>
> [chris@f24s ~]$ sudo btrfs-debug-tree -b 246050455552 /dev/mapper/brick1
> btrfs-progs v4.7
> checksum verify failed on 246050455552 found E4E3BDB6 wanted 00000000
> checksum verify failed on 246050455552 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=246050455552, have=0
> ERROR: failed to read 246050455552
>
>
> [chris@f24s ~]$ sudo btrfs-debug-tree -b 285446881280 /dev/mapper/brick1
> btrfs-progs v4.7
> checksum verify failed on 285446881280 found 6BB60B47 wanted C9310000
> checksum verify failed on 285446881280 found 6BB60B47 wanted C9310000
> bytenr mismatch, want=285446881280, have=5188146780436697072
> ERROR: failed to read 285446881280


Looks like the above is simply invalid usage on my part. The backref
value doesn't apply to btrfs-debug-tree -b and must be some other
thing. Those values don't show up as either nodes or leaves, only as a
reference to extent data. But a complete btrfs-debug-tree has no
complaints about the file system, so I'm still not sure the btrfs
check complaints are valid.


-- 
Chris Murphy
