Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34798 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab2GDNxZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 09:53:25 -0400
Date: Wed, 4 Jul 2012 15:53:05 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.4.4: BUG: Bad rss-counter state x
Message-ID: <20120704135305.GM5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120704050555.GB6807@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120704050555.GB6807@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Jul 03, 2012 at 10:05:55PM -0700, Marc MERLIN wrote:
> Since I heard absolutely nothing on my last but and corruption report, I'm
> not sure if they are useful or wanted (please let me know).

They are, both useful and wanted, thanks.

> The last thing I've seen with 3.4.4 is this:
> kernel: [116130.309667] btrfs: unlinked 25 orphans
> kernel: [117951.440823] BUG: Bad rss-counter state mm:ffff8801e2a4c080 idx:1 val:-1
> kernel: [117951.440832] BUG: Bad rss-counter state mm:ffff8801e2a4c080 idx:2 val:1
> kernel: [119720.558186] btrfs: unlinked 12 orphans

This is not a btrfs bug, first hit for 'bug rss-counter' pointed me to

http://comments.gmane.org/gmane.linux.kernel/1316358 (kernel 3.4.2)
->
https://lkml.org/lkml/2012/6/9/47

david
