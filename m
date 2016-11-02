Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34389 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754014AbcKBKwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 06:52:32 -0400
Date: Wed, 2 Nov 2016 11:52:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/4] btrfs-progs: introduce new send-dump object
Message-ID: <20161102105229.GA12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-3-quwenruo@cn.fujitsu.com>
 <20161101102209.GW12522@suse.cz>
 <e6a2018c-f335-9c6f-7152-87aea55fb5ec@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6a2018c-f335-9c6f-7152-87aea55fb5ec@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 02, 2016 at 08:37:20AM +0800, Qu Wenruo wrote:
> > PATH_WIDTH is used only here, please hardcode it into the format string.
> >
> > The rest of the patch looks good. I think I've seen some artifacts in
> > the output, but we can tune this later.
> 
> Would you like to share the artifacts so I can handle them in next update?

>From the output of misc test 016:

snapshot: [...] parent_transid= 14
                               ^ extra space

set_xattr:      ./snap_creation/xattr_file      name=user.test, len=1
                                                              ^ comma

also set xattr does not print the attribute data.
