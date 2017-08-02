Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:49812 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751177AbdHBH2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 03:28:18 -0400
Subject: Re: [PATCH 0/2] More nritems range checking
To: Philipp Hahn <hahn@univention.de>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
References: <20170529181900.GV14523@twin.jikos.cz>
 <cover.1496397503.git.hahn@univention.de>
From: Philipp Hahn <pmhahn@pmhahn.de>
Message-ID: <cfebd4ee-adfe-9ef9-33db-2ddb01001a79@pmhahn.de>
Date: Wed, 2 Aug 2017 09:28:15 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1496397503.git.hahn@univention.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Am 02.06.2017 um 12:08 schrieb Philipp Hahn:
> thank you for applying my last patch, but regarding my corrputed file system I
> found two other cases were btrfs crashes:
> - btrfs_del_items() was overlooked by me
> - deleting from an empty node
> 
> Find attached two patches to improve that.
> Please check the second patch hunk 2, as I'm unsure if "mid == nritems" is valid.
> 
> (If someone can give me a hand on how to get my FS fixed again, I would
> appreciate that.)
> 
> Philipp Hahn (2):
>   btrfs-progs: Check slot + nr >= nritems overflow
>   btrfs-progs: Check nritems under-/overflow
> 
>  ctree.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Ping?

Philipp
