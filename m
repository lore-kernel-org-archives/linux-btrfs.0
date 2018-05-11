Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39775 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbeEKRQZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 13:16:25 -0400
Received: by mail-pf0-f196.google.com with SMTP id a22-v6so3020210pfn.6
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 10:16:25 -0700 (PDT)
Date: Fri, 11 May 2018 10:16:22 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 05/11] Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
Message-ID: <20180511171622.GA29366@vader>
References: <cover.1526025007.git.osandov@fb.com>
 <844bfe29a31c7943053202c36a7990efd2437c69.1526025007.git.osandov@fb.com>
 <20180511100657.GR6649@twin.jikos.cz>
 <CAEzrpqeHVkVAEW+g0mrgt=WKzRQH26L4ZuazU8Htv4=X2aFHiQ@mail.gmail.com>
 <20180511165130.GD6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511165130.GD6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 06:51:30PM +0200, David Sterba wrote:
> On Fri, May 11, 2018 at 12:10:38PM -0400, Josef Bacik wrote:
> > I told him to do this, these flags aren't exposed anywhere are they?
> > They are in-kernel specific stuff, please tell me we aren't exposing
> > these via sysfs?
> 
> No worries, they're completely internal, just that shifting the number
> sequence does not need to be in this patch and should be made
> separately.

Sure, I can split out the renumbering into a separate patch.
