Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEKQyK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 12:54:10 -0400
Date: Fri, 11 May 2018 18:51:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.cz>, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 05/11] Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
Message-ID: <20180511165130.GD6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526025007.git.osandov@fb.com>
 <844bfe29a31c7943053202c36a7990efd2437c69.1526025007.git.osandov@fb.com>
 <20180511100657.GR6649@twin.jikos.cz>
 <CAEzrpqeHVkVAEW+g0mrgt=WKzRQH26L4ZuazU8Htv4=X2aFHiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEzrpqeHVkVAEW+g0mrgt=WKzRQH26L4ZuazU8Htv4=X2aFHiQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:10:38PM -0400, Josef Bacik wrote:
> I told him to do this, these flags aren't exposed anywhere are they?
> They are in-kernel specific stuff, please tell me we aren't exposing
> these via sysfs?

No worries, they're completely internal, just that shifting the number
sequence does not need to be in this patch and should be made
separately.
