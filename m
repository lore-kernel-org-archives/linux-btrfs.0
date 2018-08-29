Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:38824 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2Sjz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 14:39:55 -0400
Subject: Re: btrfs fi du unreliable?
To: Jorge Bastos <jorge.mrbastos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAHzMYBT22xie_4Tjp+Zn6w7DG0sDAdkRRDrgesUvJ60j0TrmnA@mail.gmail.com>
 <7660605b-d456-308a-7040-720ff31f7181@georgianit.com>
 <CAHzMYBSTpG1f=2KoLA1w34H_k7N2CHthXm0bxb0qVq8UrroQZw@mail.gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <1bfe1211-79b7-c2aa-7b48-53820e9e71bd@cobb.uk.net>
Date: Wed, 29 Aug 2018 15:33:47 +0100
MIME-Version: 1.0
In-Reply-To: <CAHzMYBSTpG1f=2KoLA1w34H_k7N2CHthXm0bxb0qVq8UrroQZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29/08/18 14:31, Jorge Bastos wrote:
> Thanks, that makes sense, so it's only possible to see how much space
> a snapshot is using with quotas enable, I remember reading that
> somewhere before, though there was a new way after reading this latest
> post .

My extents lists scripts (https://github.com/GrahamCobb/extents-lists)
can tell you the answers to questions like this. In particular, see the
extents-to-remove script.

However, be aware of the warning in the documentation:
---------------------------------------------------
Be warned: the last three examples take a very LONG TIME (and require a
lot of space in $TMPDIR) as they effectively have to get the file
extents for almost every file on the disk (and sort them multiple
times). They take over 12 hours on my system!
---------------------------------------------------

I don't know if there are any better tools which work faster.
