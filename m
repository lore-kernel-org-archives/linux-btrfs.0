Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab3JXOIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:08:32 -0400
Date: Thu, 24 Oct 2013 16:08:28 +0200
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: relocate csums properly with prealloc extents -
 for 3.12-rc
Message-ID: <20131024140828.GA28149@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

this needs to go to 3.12, the patch is only in btrfs-next. The bug can
happen with systemd journal + balance, the fix helps quite a lot of
users out there. (https://bugzilla.kernel.org/show_bug.cgi?id=63411)

I have cherry-picked the patch to current master, applies cleanly and
the test btrfs/013 passes, here's my

Tested-by: David Sterba <dsterba@suse.cz>

david
