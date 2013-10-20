Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3JTRV4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 13:21:56 -0400
Date: Sun, 20 Oct 2013 19:21:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] btrfs: commit transaction after deleting a subvolume
Message-ID: <20131020172154.GH1032@suse.cz>
Reply-To: dsterba@suse.cz
References: <1377901546-22434-1-git-send-email-dsterba@suse.cz>
 <20131020121959.4917.92120@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131020121959.4917.92120@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 20, 2013 at 08:19:59AM -0400, Chris Mason wrote:
> My objections are pretty similar to Josef's.  But, there's no reason we
> can't change the progs to optionally trigger a commit.

Works for me, though I'm not clear what should be the default.

> What I want to avoid is bulk snapshot deletion triggering a commit for
> each individual snapshot.  

I agree and came to the same conclusion later on.

david
