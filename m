Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbbFYSMZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 14:12:25 -0400
Date: Thu, 25 Jun 2015 11:12:23 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add no_mtime flag to btrfs-extent-same
Message-ID: <20150625181223.GA10324@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-6-git-send-email-mfasheh@suse.de>
 <20150623151156.GI6761@twin.jikos.cz>
 <20150624201732.GA14931@hungrycats.org>
 <20150625125250.GF726@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150625125250.GF726@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 02:52:50PM +0200, David Sterba wrote:
> On Wed, Jun 24, 2015 at 04:17:32PM -0400, Zygo Blaxell wrote:
> > Is there any sane use case where we would _want_ EXTENT_SAME to change
> > the mtime?  We do a lot of work to make sure that none of the files
> > involved have any sort of content change.  Why do we need the flag at all?
> 
> Good point, I don't see the usecase for updating MTIME.

Yeah there isn't one and I doubt anyone will be upset if we just always
ignore the mtime update. I'll send some new patches shortly.

Thanks for the suggestion Zygo.
	--Mark

--
Mark Fasheh
