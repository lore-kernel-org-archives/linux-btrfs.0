Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57883 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdCOOsQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 10:48:16 -0400
Date: Wed, 15 Mar 2017 15:47:38 +0100
From: David Sterba <dsterba@suse.cz>
To: ednadolski@gmail.com
Cc: linux-btrfs@vger.kernel.org, Edmund Nadolski <enadolski@suse.com>
Subject: Re: [PATCH 1/2] btrfs: provide enumeration for __merge_refs mode
 argument
Message-ID: <20170315144737.GI14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313203204.11857-1-enadolski@suse.com>
 <20170313203204.11857-2-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313203204.11857-2-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 02:32:03PM -0600, ednadolski@gmail.com wrote:
> @@ -809,14 +814,12 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
>  /*
>   * merge backrefs and adjust counts accordingly
>   *
> - * mode = 1: merge identical keys, if key is set
>   *    FIXME: if we add more keys in __add_prelim_ref, we can merge more here.
>   *           additionally, we could even add a key range for the blocks we
>   *           looked into to merge even more (-> replace unresolved refs by those
>   *           having a parent).

The 'FIXME' seems to refer to mode = 1, but now that you remove it, it's
not clear what it's referring to. Mentioning MERGE_IDENTICAL_KEYS would
be good.
