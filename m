Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab3CLP0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 11:26:01 -0400
Date: Tue, 12 Mar 2013 16:25:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: output raid[56] options in mkfs.btrfs
Message-ID: <20130312152559.GL7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362947413-3576-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1362947413-3576-1-git-send-email-m@bjorling.me>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 09:30:13PM +0100, Matias Bjørling wrote:
> This patch adds the raid[56] options to the output of mkfs.btrfs help.

Thanks, there was a patch for that in my branch already. Please don't
forget to add your signed-off-by line.

david
