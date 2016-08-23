Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757947AbcHWLsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 07:48:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88089AD2D
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 11:48:16 +0000 (UTC)
Date: Tue, 23 Aug 2016 13:47:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: don't create or leak aliased root while cleaning
 up orphans
Message-ID: <20160823114711.GK16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b17bdd58-a727-5995-ce8d-266bbe2917f3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b17bdd58-a727-5995-ce8d-266bbe2917f3@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 17, 2016 at 09:58:33PM -0400, Jeff Mahoney wrote:
> commit 909c3a22da3 (Btrfs: fix loading of orphan roots leading to BUG_ON)
> avoids the BUG_ON but can add an aliased root to the dead_roots list or
> leak the root.
> 
> Since we've already been loading roots into the radix tree, we should
> use it before looking the root up on disk.
> 
> Cc: <stable@vger.kernel.org> # 4.5
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
