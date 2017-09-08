Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33102 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbdIHQMN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 12:12:13 -0400
Received: by mail-wr0-f180.google.com with SMTP id a43so5541543wrc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 09:12:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170908153816.GD23980@carfax.org.uk>
References: <20170908085446.GA7876@rus.uni-stuttgart.de> <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com> <20170908153816.GD23980@carfax.org.uk>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 8 Sep 2017 17:12:11 +0100
Message-ID: <CABB28Cx4zo1Pr7TbmxYgJAOmms3PrYftxcks8iHCQSx5a2Xq1g@mail.gmail.com>
Subject: Re: test if a subvolume is a snapshot?
To: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2017 at 16:38, Hugo Mills <hugo@carfax.org.uk> wrote:
[..]
>> sometimes I'm really thinking about start rewrite btrfs-progs to make
>> btrfs basic tools syntax as similar as it is only possible to ZFS zfs,
>> zpool and zdb commands on using which in +90% cases you can guess how
>> necessary syntax must look like without looking on man pages.
>>
>> Any volunteers want to join to help implement something like this?
>> Maybe someone already started doing this?
>
>    The main complaint that can be directed at the btrfs command is
> that its output is rarely machine-processable. It would therefore make
> sense to have a "--table" or "--structured" mode for output, which
> would be more trivially parsable by shell tools.

Output of the btrfs command it is coooooompletely different pair of shoes.
On making btrfs tools similar to ZFS analogues *obviously* output
should be as same similar.
By this would possible to solve complains about unreadable output in one go.

For example zfs command parseable output is possible to generate by
add -p switch in those subcommands where it is needed (no --tables or
--structures .. just one switch).

Instead reinventing the wheel just please try to look first how it is
already done in completely predictable/guessable way:
https://www.freebsd.org/cgi/man.cgi?query=zfs&sektion=8
https://www.freebsd.org/cgi/man.cgi?query=zpool&sektion=8

kloczek
-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
