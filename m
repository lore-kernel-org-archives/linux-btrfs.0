Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3CRR1Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 13:27:24 -0400
Date: Mon, 18 Mar 2013 18:27:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs: Update btrfs restore so it matches all current
 development
Message-ID: <20130318172721.GN7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 01:38:07PM -0400, Josef Bacik wrote:
> I noticed today that a bunch of work that had been done to restore last year
> wasn't in the normal btrfs-progs restore.  So this work forward ports all of the
> patches that were missing, and redoes a bunch of the work that was done to deal
> with really broken file systems so that it uses more of the generic helpers that
> Chris wrote a while ago.  This is based on the latest integration branch, Dave
> if you want to just pull you can do

I've pulled 1-5,7,9 (ie. left out 6,8 -- regex, and 10 which I need to
look at again).

david
