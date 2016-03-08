Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbcCHQDF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Mar 2016 11:03:05 -0500
Date: Tue, 8 Mar 2016 17:02:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Moviuro <moviuro@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
Message-ID: <20160308160244.GF30625@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Let me answer here for the whole thread. There are lot of issues to
cover, I think the github way would work here, so the project you've
created for the purpose seems ok to me.

https://github.com/btrfs8-revamp

I assume way more dicussions than actual patches and coding, the web
platform offers commenting at the exact locations of files, issue
tracking works better than over mail.

Initially we'd cover all the stuff mentioned in this thread, naming,
conventions etc. After we agree we can start changing code in btrfs-progs.

We can ask for feedback wider audience in the mailinglist if needed,
possibly with a draft that would be reviewed already.

After we write comprehensive guidelines for the UI, we can add it to
btrfs-progs, I really want to avoid high churn in that repository for
things that are not related to code. For that the revamp repository is
good, the only requirement is a github account.
