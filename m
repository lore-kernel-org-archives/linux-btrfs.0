Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbcGMNos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 09:44:48 -0400
Date: Wed, 13 Jul 2016 15:44:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Add ratelimit to btrfs printing
Message-ID: <20160713134432.GM10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160713121526.GJ10595@twin.jikos.cz>
 <1468415955-30804-2-git-send-email-kernel@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468415955-30804-2-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 13, 2016 at 04:19:15PM +0300, Nikolay Borisov wrote:
> This patch adds ratelimiting to all messages which are not
> using the _rl version of the various printing APIs in btrf. This
> is designed to be used as a safety net, since a flood messages
> might cause the softlockup detector to trigger. To reduce
> interference between different classes of messages use a separate
> ratelimit state for every class of message.

Added to 4.8 queue, with some minor tweaks, thanks.
