Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbeEVKw6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 06:52:58 -0400
Date: Tue, 22 May 2018 12:50:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>,
        Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: allow empty subvol= again
Message-ID: <20180522105014.GC6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4daab3c9993c97f3f962b16fcb9b5d578853765d.1526947478.git.osandov@fb.com>
 <20180522001706.GD14774@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522001706.GD14774@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > This is silly but IMO it's a regression. If you agree, this should
> > probably go to 4.17 + stable. I'll submit an xfstests test shortly.
> 
> Update, we fixed the userspace bug now so I'd be fine if we dropped this
> patch. I guess there's still a possibility that there are other users
> that hit this, so I'll leave it up to you, Dave, whether it's important
> enough to care.

The documentation does not say anything about the empty value of the
path, it's subvol=path, so I'm not sure if empty string is normally
considered a valid path.

I'll add the patch and update documentation, as it's a small issue, but
not really an urgent fix for 4.17. It also has a simple fix, to use / or
"." .
