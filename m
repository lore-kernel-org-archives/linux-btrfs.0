Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3A1RH5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 12:07:57 -0500
Date: Mon, 28 Jan 2013 18:07:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Fix trival compiler error in cmds-qgroup.c
Message-ID: <20130128170755.GD16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1359223833-8214-1-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359223833-8214-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 26, 2013 at 01:10:33PM -0500, Gene Czarcinski wrote:
> The compiler does not realize that usage() never returns.
> Initializing the variable keeps it quiet.
> Signed-off-by: Gene Czarcinski <gene@czarc.net>

Queued for integration. Thanks.

david
