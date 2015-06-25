Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbFYMww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 08:52:52 -0400
Date: Thu, 25 Jun 2015 14:52:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: dsterba@suse.cz, Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add no_mtime flag to btrfs-extent-same
Message-ID: <20150625125250.GF726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-6-git-send-email-mfasheh@suse.de>
 <20150623151156.GI6761@twin.jikos.cz>
 <20150624201732.GA14931@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150624201732.GA14931@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 04:17:32PM -0400, Zygo Blaxell wrote:
> Is there any sane use case where we would _want_ EXTENT_SAME to change
> the mtime?  We do a lot of work to make sure that none of the files
> involved have any sort of content change.  Why do we need the flag at all?

Good point, I don't see the usecase for updating MTIME.
