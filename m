Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbaHQXlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 19:41:18 -0400
Date: Mon, 18 Aug 2014 01:41:16 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, clm@fb.com, jbacik@fb.com,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffm@suse.com, fdmanana@suse.com
Subject: Re: [RFC v3 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140817234116.GF3347@wotan.suse.de>
References: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com> <20140815092950.GZ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140815092950.GZ18016@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 15, 2014 at 10:29:50AM +0100, Al Viro wrote:
> On Thu, Aug 14, 2014 at 07:58:56PM -0700, Luis R. Rodriguez wrote:
> 
> > Christoph had noted that this seemed associated to the problem
> > that the btrfs uses different assignments for st_dev than s_dev,
> > but much as I'd like to see that changed based on discussions so
> > far its unclear if this is going to be possible unless strong
> > commitment is reached.
> 
> Explain, please.  Whose commitment and commitment to what, exactly?

There are two folks, one is the btrfs developers, and the others are
the VFS maintainers to provide proper guidance.

> Having different ->st_dev values for different files on the same
> fs is a bloody bad idea; why does btrfs do that at all?

With the disclosure of stating that I'm new to btrfs as I see its been
done to help cope with the copy on write mechanism, but I welcome btrfs
folks to chime in if there other reasons this was done from an
architectural point of view.

Provided all reasons why this was done are clarified what we'd need
then is proper guidance on what *would* be a much more reasonable
strategy to do what was desired, and finally commitmen from btrfs
folks to change btrfs to switch to this new agreed upon strategy.

> If nothing else,
> it breaks the usual "are those two files on the same fs?" tests...

It would seem that those tests need more context now with copy
on write, even the notion of disk space is all fucked up now, we
need to think of it in terms of different possibilities that the
new filesystems allow us to share data and different outcomes that
could be possible.

  Luis
