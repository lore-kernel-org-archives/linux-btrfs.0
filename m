Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49091 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755115AbcIFKAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 06:00:31 -0400
Date: Tue, 6 Sep 2016 11:58:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        "'Sean Fu'" <fxinrong@gmail.com>, clm@fb.com, anand.jain@oracle.com,
        Filipe Manana <FdManana@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
Message-ID: <20160906095858.GA16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com>
 <57CE3464.7090107@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57CE3464.7090107@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 05, 2016 at 11:13:40PM -0400, Jeff Mahoney wrote:
> >> Since root is only used to get fs_info->chunk_root, why not use fs_info
> >> directly?
> > 
> > Weird.  Exactly this was a part of my fs_info patchset.  I guess I need
> > to go back and check what else is missing.
> 
> Actually, most of this didn't land.  Pretty much anything that's a root
> ->fs_info conversion is in there.

Only half of the patchset has been merged so far because it did not pass
testing, so I bisected to some point. I was about to let you know once
most of 4.9 patches are prepared so there are less merge conflicts.
