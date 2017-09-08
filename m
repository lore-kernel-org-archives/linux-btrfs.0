Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35651 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754547AbdIHPZ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 11:25:57 -0400
Received: by mail-wr0-f173.google.com with SMTP id m18so5308332wrm.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 08:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170908131035.GO31874@twin.jikos.cz>
References: <20170908085446.GA7876@rus.uni-stuttgart.de> <20170908131035.GO31874@twin.jikos.cz>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 8 Sep 2017 16:25:55 +0100
Message-ID: <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
Subject: Re: test if a subvolume is a snapshot?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2017 at 14:10, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Sep 08, 2017 at 10:54:46AM +0200, Ulli Horlacher wrote:
> > How can I test if a subvolume is a snapshot?
>
> The inode number is 256 on a btrfs filesystem:
>
> if [ stat -f --format=%T $path = btrfs -a stat --format=%i $path = 256 ]; ...

This oneliner shows how much really basic btrfs tools commands syntax
is broken by design :(
Looking on how so freakishly overcomplicated btrfs command syntax is
that command like above is completely unintuitive and unreadable
sometimes I'm really thinking about start rewrite btrfs-progs to make
btrfs basic tools syntax as similar as it is only possible to ZFS zfs,
zpool and zdb commands on using which in +90% cases you can guess how
necessary syntax must look like without looking on man pages.

Any volunteers want to join to help implement something like this?
Maybe someone already started doing this?

kloczek
-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
