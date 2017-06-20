Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33175 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbdFTR2k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 13:28:40 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:35216)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dNMME-003KSs-8n
        for linux-btrfs@vger.kernel.org; Tue, 20 Jun 2017 17:50:26 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dNMM7-0001Mo-HZ
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 17:50:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22857.21067.160485.588255@tree.ty.sabi.co.uk>
Date: Tue, 20 Jun 2017 17:50:19 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: does using different uid/gid/forceuid/... mount options for different
 subvolumes work / does fuse.bindfs play nice with btrfs?
In-Reply-To: <CADtmLM_wcKDix3RJz3m0_=YiZ=kFtvvT8p359PNq30BusPdHFA@mail.gmail.com>
References: <CADtmLM_wcKDix3RJz3m0_=YiZ=kFtvvT8p359PNq30BusPdHFA@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I intend to provide different "views" of the data stored on
> btrfs subvolumes.  e.g. mount a subvolume in location A rw;
> and ro in location B while also overwriting uids, gids, and
> permissions. [ ... ]

That's not how UNIX/Linux permissions and ACLs are supposed to
work, perhaps you should reconsider such a poor idea.

Mount options are provided to map non-UNIX/Linux filesystems
into the UNIX/Linux permissions and ACLs in a crude way.

If you really want, uid/gid/permissions are an inode property,
and Btrfs via "reflinking" allows sharing of file data between
different inodes. So you can for example create a RW snapshot of
a subvolume, change all ids/permissions/ACLs, and the data space
will still be shared. This is not entirely cost-free.

If you really really want this it may be doable also with mount
namespaces combined with user namespaces, with any filesystem,
depending on yoiur requirements:

http://man7.org/linux/man-pages/man7/user_namespaces.7.html
http://man7.org/linux/man-pages/man7/mount_namespaces.7.html

As to mounting multiple times on multiple directories, that is
possible with Linux VFS regardless of filesystem type, or by
using 'mount --bind' or a variant.
