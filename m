Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab3CLPYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 11:24:46 -0400
Date: Tue, 12 Mar 2013 16:24:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Antoine Sirinelli <antoine@monte-stello.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add a rule to build a static mkfs.btrfs
Message-ID: <20130312152444.GK7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130311211714.GA8494@kabis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130311211714.GA8494@kabis>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 09:17:17PM +0000, Antoine Sirinelli wrote:
> Static mkfs.btrfs can be used to "bootstrap" a system from a live CD
> which does not provide mkfs.btrfs.
> 
> The executable produced is named mkfs.btrfs.static and built by invoking
> the "static" make rule.

Added to integration queue, thanks.

david
