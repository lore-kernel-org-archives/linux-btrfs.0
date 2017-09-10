Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:44392 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750902AbdIJUSF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 16:18:05 -0400
Date: Sun, 10 Sep 2017 23:17:27 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: FLJ <feci2048@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Help me understand what is going on with my RAID1 FS
Message-ID: <20170910231727.65bbb2aa@demfloro.ru>
In-Reply-To: <bae7bedb-4f3a-3779-e6c7-9d3879cb1d27@gmail.com>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
        <1F3219B0-72B2-4201-8C96-E6FBFD02A413@demfloro.ru>
        <bae7bedb-4f3a-3779-e6c7-9d3879cb1d27@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Drive1      Drive2    Drive3
> > X           X
> > X                         X
> >             X             X
> > 
> > Where X is a chunk of raid1 block group.  
> 
> But this table clearly shows that adding third drive increases free
> space by 50%. You need to reallocate data to actually make use of it,
> but it was done in this case.

It increases it but I don't see how this space is in any way useful
unless data is in single profile. After full balance chunks will be
spread over 3 devices, how it helps in raid1 data profile case?
