Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47133 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755791AbdIHNME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 09:12:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACECEAEB3
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 13:12:03 +0000 (UTC)
Date: Fri, 8 Sep 2017 15:10:35 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908131035.GO31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170908085446.GA7876@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 10:54:46AM +0200, Ulli Horlacher wrote:
> How can I test if a subvolume is a snapshot?

The inode number is 256 on a btrfs filesystem:

if [ stat -f --format=%T $path = btrfs -a stat --format=%i $path = 256 ]; ...

The directory that's result of snapshotting a subvolume, also called
EMPTY_SUBVOL has inode number 2, but that's not considered a normal
subvolume.
