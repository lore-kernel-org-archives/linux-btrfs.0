Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbcEEIRM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 04:17:12 -0400
Date: Thu, 5 May 2016 10:16:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Noah Massey <noah.massey@gmail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Adjust timing of safety delay countdown
Message-ID: <20160505081654.GZ29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462391006-4057-1-git-send-email-noah.massey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462391006-4057-1-git-send-email-noah.massey@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 03:43:26PM -0400, Noah Massey wrote:
> When printing the countdown in the safety delay, the number should
> correspond to the number of seconds remaining to wait at the time the
> delay is printed.
> 
> In other words, there should be a one second sleep after printing '1'.
> 
> Signed-off-by: Noah Massey <noah.massey@gmail.com>

Applied, thanks.
