Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbaKUXmO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 18:42:14 -0500
Date: Sat, 22 Nov 2014 00:42:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: disk-io: replace root args iff only fs_info used
Message-ID: <20141121234213.GG8568@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <danieru.dressler@gmail.com>
 <1416557707-9243-1-git-send-email-danieru.dressler@gmail.com>
 <20141121161509.GD8568@twin.jikos.cz>
 <CAGC3nLAUSy-dJGAzz2THDeX6UoSsbZ8BOWUb2pGRoVSWqQpZaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGC3nLAUSy-dJGAzz2THDeX6UoSsbZ8BOWUb2pGRoVSWqQpZaw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 22, 2014 at 01:37:10AM +0900, Daniel Dressler wrote:
> What would a cover letter be like? Would that be a separate email to
> the list, or maybe the first email in a patch series?

It's a separate mail that does not carry any diff but an overview of
the following patches. The patches are threaded under that mail. This is
what the git command does for you:

  git format-patch -o output --thread --cover-letter from..to

and in the directory 'output' you'll find the cover letter plus patches.
The cover contains some stub and should be edited.  Then send them via
'git send-email'.

> Sorry I've twice looked for the integration repo. I found some that
> look like it could be but those had older commits. Could you direct me
> to the exact branch I'd love to work against it. These patches were
> done against linux-next.

The integration is in Chris' git, but the branch may not be the most
recent compared to Linus' tree or the pending for-linus branches. This
depens on the phase of the development cycle or the stability of the
patches in the integration branch as it's supposed to be base of the
next pull.

What you did is fine under current conditions. If the integration is
made public you can check if your patches are merged or not and then
refresh the patch series eventually.

> I think small one function patches might be best. I have the codebase
> mapped out and each file's functions-to-be-cleaned count varies
> wildly. If I did batch files together and split large files apart
> there would be no rhyme or reason for the groupings. With single
> function patches it is very clear what changes are justified since
> they should only occur in the affected function or in a call-site.
> With multiple functions the call-site changes get mixed up would it
> would be harder to review.

Up to you.
