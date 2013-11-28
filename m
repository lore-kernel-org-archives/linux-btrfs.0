Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab3K1Nwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 08:52:32 -0500
Date: Thu, 28 Nov 2013 14:52:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Bogus f_avail/f_bavail in df
Message-ID: <20131128135230.GG25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <alpine.LSU.2.11.1311261155590.2892@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LSU.2.11.1311261155590.2892@nerf07.vanv.qr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 26, 2013 at 12:01:14PM +0100, Jan Engelhardt wrote:
> 
> While btrfs does its resizing, df stats are messed up.
> Seen in linux-3.9.9. Don't know if it still occurs.

Bugreport moved to bugzilla (https://bugzilla.kernel.org/show_bug.cgi?id=66071),
I was not able to add you to CC though.
