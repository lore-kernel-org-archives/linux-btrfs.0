Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbbHYPi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:38:59 -0400
Date: Tue, 25 Aug 2015 17:38:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] btrfs-progs: Add further checks to btrfs replace start
 command
Message-ID: <20150825153824.GJ10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440048263-6089-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440048263-6089-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 20, 2015 at 07:24:23AM +0200, Goffredo Baroncelli wrote:
> Add further checks to btrfs replace start command.
> 
> The following tests where added in user space before calling
> the ioctl():
> 1) check if the new disk is greather or equal to the old one
> 2) check if the source device is or a block device or a
> numerical dev-id
> 
> These checks are already performed in kernel space; however
> when "btrfs replace start" is ran in background is not possible
> to show any error returned by the ioctl(), so in case of fail 
> the user had to check dmesg to understand the what happened.
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Applied, thanks.
