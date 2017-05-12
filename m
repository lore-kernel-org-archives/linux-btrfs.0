Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36245 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbdELUbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 16:31:11 -0400
Received: by mail-lf0-f45.google.com with SMTP id h4so7063612lfj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 13:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170512202756.16bd785f@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Fri, 12 May 2017 22:31:08 +0200
Message-ID: <CAK5rZE5B6M8TcnKmfLGMR8kjQ1GtLXk7Rf8GhUPL8pRfdOTiTw@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/12/17, Kai Krakow <hurikhan77@gmail.com> wrote:
> I don't think it is important for the file system to know where the SSD
> FTL located a data block. It's just important to keep everything nicely
> aligned with erase block sizes, reduce rewrite patterns, and free up
> complete erase blocks as good as possible.

Yeah. "Tight packing" of data into erase blocks will reduce fragmentation
at flash level, but not necessarily the fragmentation at fs level. And
unless we are writing in continuous journaling style (as f2fs ?),
we still need to have some info about the erase blocks.

Of course while these are going on, there is also something like roundrobin
mapping or some kind of journaling would be going on at the low level flash
as wear leveling/bad block replacements which is totally invisible to us.


> Maybe such a process should be called "compaction" and not
> "defragmentation". In the end, the more continuous blocks of free space
> there are, the better the chance for proper wear leveling.


Tight packing into erase blocks seems dominant factor for ssd welfare.

However, fs fragmentation may still be a thing to consider because
increased fs fragmentation will probably increase the # of erase
blocks involved, affecting both read/write performance and wear.

Keeping an eye on both is a though job. Worse there is "two" uncoordinated
eyes one watching the "fs" and the other watching the "flash" making the
whole process suboptimal.

I think the ultimate utopic combination would be "absolutely dumb flash
controller" providing direct access to physical bytes and the ultimate
"Flash FS" making use of possible performance, wear leveling tricks.

Clearly, we are far from it.
