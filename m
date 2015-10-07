Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbbJGPV1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 11:21:27 -0400
Date: Wed, 7 Oct 2015 17:20:20 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print root item's last_snapshot value.
Message-ID: <20151007152020.GQ7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20151007120638.GA24461@giis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151007120638.GA24461@giis>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2015 at 05:36:38PM +0530, Lakshmipathi.G wrote:
> Include last_snapshot value in print_root(). With btrfs-debug-tree, it 
> helps to identify whether its a snapshot-ed subvolume or not.
> 
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>

Applied, thanks.
