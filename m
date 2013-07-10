Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48795 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJQVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 12:21:38 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so2972750bkc.35
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 09:21:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130710161255.GD25386@twin.jikos.cz>
References: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
	<1373395794-29140-2-git-send-email-fdmanana@gmail.com>
	<20130710161255.GD25386@twin.jikos.cz>
Date: Wed, 10 Jul 2013 17:21:37 +0100
Message-ID: <CAL3q7H6J22E=cnF73YrH-=fG601f35dBjZhWo+hjYkFX1ZX2Wg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: remove duplicated code in cmds-restore.c
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 5:12 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Jul 09, 2013 at 07:49:53PM +0100, Filipe David Borba Manana wrote:
>> The module cmds-restore.c was defining its own next_leaf()
>> function, which did exactly the same as btrfs_next_leaf()
>> from ctree.c.
>
> This has been removed by Eric's patch present in the integration
> branches:
>  Btrfs-progs: remove cut & paste btrfs_next_leaf from restore
> http://www.spinics.net/lists/linux-btrfs/msg24477.html

Oh, didn't notice that.

>
> but now Chris has a fix in the master branch,
>  btrfs-restore: deal with NULL returns from read_node_slot
> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=194aa4a1bd6447bb545286d0bcb0b0be8204d79f
>
> the code of updated next_leaf is not identical to btrfs_next_leaf and I
> think 'restore' could be more tolerant to partially corrupted
> structures, so both functions could make sense in the end.

Ok, I understand now why both exist.

So please just ignore this patch and the following one
(https://patchwork.kernel.org/patch/2825425/).

thanks

>
> david



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
