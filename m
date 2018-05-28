Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425264AbeE1PyQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:16 -0400
Date: Mon, 28 May 2018 13:29:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <linux@hmclauchlan.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Filipe Manana <FdManana@suse.com>
Subject: Re: [RFC PATCH v2 0/6] btrfs send stream version 2
Message-ID: <20180528112945.GT6649@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180528021443.13923-1-linux@hmclauchlan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 27, 2018 at 10:14:29PM -0400, Howard McLauchlan wrote:
> This is v2 of send stream version 2. The goal is to provide proper
> versioning/compatibility as new features are implemented. v1 can be found here
> [1].

We need to decide the overall approach to the versioning updates. The
wiki page has several problems with v1 that I don't see addressed in
this patchset. So the question is:

1) fix everything we know about now in send protocol v2

2) incremental fixes (eg. this patchset) and version bumps as the missing
   features/bugs get fixed

I'd vote for 1 because 2 is likely to cause usability problems with
kernel and clients with different version support. But eg. rsync has
protocol version 30 and maybe more so handful of versions does not need
to be an issue in the end. We should be ready with version updates for
btrfs but at this moment I haven't thought about all the usability
issues for 2).
