Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbcBXP3F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 10:29:05 -0500
Date: Wed, 24 Feb 2016 16:28:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs-progs: add 'du' command
Message-ID: <20160224152852.GG23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
 <20160201234345.GJ31992@twin.jikos.cz>
 <20160202200921.GH24672@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160202200921.GH24672@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 02, 2016 at 12:09:21PM -0800, Mark Fasheh wrote:
> > Otherwise code looks ok, I saw use of uint64_t, the units help can be
> > extended to the full units set, and maybe other minor things that would
> > be good to fix. I'll do a more fine grained review when applying the
> > patches.
> 
> Awesome thanks for that, let me know if there's anything I can do to help
> the process along.

Patches added to devel, I've added the GPL header and did some trivial
changes, the non-trivial changes go as separate patches.

Please update documentation.

The output can be improved, so the numbers are aligned in columns etc.
