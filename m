Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3IPPuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 11:50:18 -0400
Date: Mon, 16 Sep 2013 17:50:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Ross Kirk <ross.kirk@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop unused parameter from btrfs_item_nr
Message-ID: <20130916155006.GU6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
 <1379343489-20066-2-git-send-email-ross.kirk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379343489-20066-2-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 03:58:09PM +0100, Ross Kirk wrote:
> Remove unused eb parameter from btrfs_item_nr

Hmm it's been unused since day one

5f39d397dfbe140a14edecd4e73c34ce23c4f9ee
Mon Oct 15 16:14:19 2007

> Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
