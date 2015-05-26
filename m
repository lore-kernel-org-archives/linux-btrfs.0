Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbbEZOdj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 10:33:39 -0400
Date: Tue, 26 May 2015 16:33:37 +0200
From: David Sterba <dsterba@suse.cz>
To: jekarlson@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: use openat for process_clone in receive
Message-ID: <20150526143337.GJ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432222949-604-1-git-send-email-jekarlson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432222949-604-1-git-send-email-jekarlson@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 06:42:29PM +0300, jekarlson@gmail.com wrote:
> From: Emil Karlson <jekarlson@gmail.com>
> 
> This will fix breakage, when doing chrooted receive with cloned paths
> outside main subvolume.

Applied, thanks.
