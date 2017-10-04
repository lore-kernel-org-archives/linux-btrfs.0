Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:41588 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdJDNZf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 09:25:35 -0400
Date: Wed, 4 Oct 2017 16:25:11 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: yet another "out of space" on a filesystem with >100 GB free
 space, and strange files which exist but don't exist
Message-ID: <20171004162511.0e3c3257@job>
In-Reply-To: <5db7bfb0a45b2eac399d823c05028452@wpkg.org>
References: <7c6a0bb4ff9b4f09c7ea6f6c7173a994@wpkg.org>
        <e2b27980-dabf-540b-c4c1-8628cc1d47c1@gmail.com>
        <5db7bfb0a45b2eac399d823c05028452@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> "Ghost file" is still there:
> 
> # ls -l 
> /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb|grep set
> ls: cannot access 
> '/var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb/WiredTiger.turtle.set': 
> No such file or directory
> -????????? ? ?      ?                ?            ? 
> WiredTiger.turtle.set

I had similiar issue couple of times, both after unclean shutdown
(power loss), only btrfs check --repair helped with the issue, but I'd
suggest to wait for someone's else input about that as I'm not a
developer.
