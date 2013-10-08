Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab3JHQi2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 12:38:28 -0400
Date: Tue, 8 Oct 2013 18:38:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] another round of static analysis fixes
Message-ID: <20131008163826.GB12986@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 02:42:53PM -0700, Zach Brown wrote:
> Eric imported a newer git snapshot of btrfs-progs into Red Hat's
> universe which kicked off a static analysis run which found a bunch
> of problems.  This series is my attempt to fix the warnings that I
> agreed were either real bugs or messy code to clean up.
> 
> This is against Dave's integration-next as of:
> 
> commit 62f6537f8c9149283844c5e93a296e147c266247
> Date:   Fri Sep 13 19:32:23 2013 +0800
> 
> And totally untested.  Review please?

Compile-tested!

[02/12] not merged, [08/12] replaces chandan's commit

thanks
