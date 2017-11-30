Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47769 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbdK3OnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 09:43:19 -0500
Date: Thu, 30 Nov 2017 15:41:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes for 4.15-rc2
Message-ID: <20171130144120.GJ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1511980478.git.dsterba@suse.com>
 <CA+55aFz8M-iy-wLCG9d0-+QCk_seLFWFfS9LJEpcmgqKK=9SFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFz8M-iy-wLCG9d0-+QCk_seLFWFfS9LJEpcmgqKK=9SFQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 02:31:24PM -0800, Linus Torvalds wrote:
> On Wed, Nov 29, 2017 at 11:28 AM, David Sterba <dsterba@suse.com> wrote:
> >
> > With signed tag: for-4.15-rc2-tag
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.15-rc2
> 
> Oh, please actually ask me to pull the signed tag (exact same
> pull-request, just point git request-pull at the tag),

Will do next time.

> because now
> what happened was that first I just pulled that branch you mentioned,
> and only noticed that "With signed tag:" notice after I had already
> pulled and was filling in the merge message.
> 
> Anyway, I redid the pull with the proper signed tag, but it was just
> annoying extra work.
> 
> And I wonder how many times I _hadn't_ noticed that, because I didn't
> have your key in my keyring either. Or maybe I caught it the first
> time.

All my previous pull requests were like that. I did the split branch/tag
beacuse the ambiguous name for branch and brings some hassle to push or
remove them. I thought a separate tag with same top commit as the branch
plus mentioning the tag in the mail would be enough to verify the pulled
branch. But apparently was not, sorry for the trouble. 
