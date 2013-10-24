Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58140 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3JXUb5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 16:31:57 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so2917190wgg.20
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 13:31:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69b632706722652312df15e72befaec2b85174df.1379430631.git.dsterba@suse.cz>
References: <cover.1379430631.git.dsterba@suse.cz>
	<69b632706722652312df15e72befaec2b85174df.1379430631.git.dsterba@suse.cz>
Date: Thu, 24 Oct 2013 15:31:55 -0500
Message-ID: <CAKcLGm9tCpw--Omat+f8GoVUHzOA98FTq-mgFzLa=+Y=WH_w+w@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs-progs: separate command ant implementation of
 chunk-recover code
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 17, 2013 at 10:21 AM, David Sterba <dsterba@suse.cz> wrote:
> The command has been moved and we should rename the files accordingly,
> so the entry point is now in cmds-rescue.c and the core functionality
> in it's own file.
>
> Return codes of btrfs_recover_chunk_tree have been simplified not to
> require a define and another file for defintion.
>
> CC: Miao Xie <miaox@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  Makefile        |    3 +-
>  chunk-recover.c | 1745 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  cmds-rescue.c   |   62 ++
>  3 files changed, 1809 insertions(+), 1 deletion(-)
>  create mode 100644 chunk-recover.c
>

I'm not sure if this patch has gone 'final' yet, but since it
relocates the code from cmds-chunk.c to chunk-recover.c, the
cmds-chunk.c file needs to be deleted.
