Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbbDBQYF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 12:24:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C15F7ACAC
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2015 16:24:04 +0000 (UTC)
Date: Thu, 2 Apr 2015 18:24:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: incremental send, don't delay directory
 renames unnecessarily
Message-ID: <20150402162404.GQ6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427480757-27307-1-git-send-email-fdmanana@suse.com>
 <1427504386-13179-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427504386-13179-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 28, 2015 at 12:59:46AM +0000, Filipe Manana wrote:
> Even though we delay the rename of directories when they become
> descendents of other directories that were also renamed in the send
> root to prevent infinite path build loops, we were doing it in cases
> where this was not needed and was actually harmful resulting in
> infinite path build loops as we ended up with a circular dependency
> of delayed directory renames.
[...]

> Reported-by: Robbie Ko <robbieko@synology.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Tested-by: David Sterba <dsterba@suse.cz>
