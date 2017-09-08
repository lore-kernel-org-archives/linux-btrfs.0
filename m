Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756777AbdIHSz0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 14:55:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64D76ABB2
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 18:55:25 +0000 (UTC)
Date: Fri, 8 Sep 2017 20:53:57 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908185357.GW31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <20170908184157.GB7876@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170908184157.GB7876@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 08:41:57PM +0200, Ulli Horlacher wrote:
> On Fri 2017-09-08 (15:10), David Sterba wrote:
> > On Fri, Sep 08, 2017 at 10:54:46AM +0200, Ulli Horlacher wrote:
> > 
> > > How can I test if a subvolume is a snapshot?
> > 
> > The inode number is 256 on a btrfs filesystem:
> > 
> > if [ stat -f --format=%T $path = btrfs -a stat --format=%i $path = 256 ]; ...
> > 
> > The directory that's result of snapshotting a subvolume, also called
> > EMPTY_SUBVOL has inode number 2, but that's not considered a normal
> > subvolume.
> 
> This is not true.

Oh I see, I've read the mail too quickly sorry, not just a subvolume but
really a snapshot. Then the simple inode number check does not work of
cours, the answer is more or less what Peter Grandi replied.
