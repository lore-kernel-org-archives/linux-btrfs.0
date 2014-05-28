Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaE1RaU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 13:30:20 -0400
Date: Wed, 28 May 2014 19:30:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Add some simple end-to-end tests for btrfs-convert.
Message-ID: <20140528173018.GT5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400692827-14606-1-git-send-email-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400692827-14606-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 21, 2014 at 10:20:27AM -0700, Adam Buchbinder wrote:
> These use the system's mke2fs, and don't require loop devices
> or root privileges.

Nice, thanks.
