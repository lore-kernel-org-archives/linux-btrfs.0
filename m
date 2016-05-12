Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbcELL3k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 07:29:40 -0400
Date: Thu, 12 May 2016 13:29:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/1] btrfs-progs: Typo review of strings and comments
Message-ID: <20160512112916.GN29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 07:50:35PM -0400, Nicholas D Steeves wrote:
> Thank you David Sterba for the btrfs-typos.txt which gave me a head
> start.  Unfortunately I wasn't able finish before btrfs-progs-4.5.3
> was released, because I decided to use emacs'
> ispell-comments-and-strings to do a full review.  I had to rebase to
> kdave's 4.5.2 branch on github, and that is what this patch will
> cleanly apply to.

Yes, patch applied cleanly.

> There were a couple of instances where I wasn't sure what to do; I've
> annotated them, and they are long lines now.  To find them, search or
> grep the diff for 'Steeves'.

Found and updated, most of them real typos, 'strtoull' is name of a C
library functioon.

Thanks.
