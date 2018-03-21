Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbeCUKL2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 06:11:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7F1F1AF82
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 10:11:27 +0000 (UTC)
Date: Wed, 21 Mar 2018 11:09:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
Message-ID: <20180321100903.GR6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
 <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 21, 2018 at 03:16:25PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年03月21日 15:03, Nikolay Borisov wrote:
> > This function was removed in 24bc2843edd5 ("btrfs:
> > Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()") what
> > remains is a defunct declaration. Remove it.
> 
> Nice find, thanks for get this.
> 
> 
> But strangely, I just fetched David's repo, but didn't find that commit
> hash anywhere.
> 
> I'm fetching from git.kernel.org repo, or is that repo only updated when
> pushing to Linus?

The workflow hasn't changed for a few months, but after the last round
of complaints and surprises where are the development patches, I've
updated the wiki page:

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Kernel_module

If there's information missing or unclear, please let me know.
