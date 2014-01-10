Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaAJON5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 09:13:57 -0500
Date: Fri, 10 Jan 2014 15:13:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Pascal VITOUX <vitoux.pascal@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: skip non-regular files while defragmenting
Message-ID: <20140110141355.GO6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389307634-8226-1-git-send-email-vitoux.pascal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389307634-8226-1-git-send-email-vitoux.pascal@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 09, 2014 at 11:47:14PM +0100, Pascal VITOUX wrote:
> Skip non-regular files to avoid ioctl errors while defragmenting.
> 
> They are silently ignored in recursive mode but reported as errors when
> used as command-line arguments.

Nice, thanks, added to integration.
