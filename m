Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3AWQaG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 11:30:06 -0500
Date: Wed, 23 Jan 2013 17:30:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Skender <skender@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        jbacik@fusionio.com
Subject: Re: BTRFS dmesg error
Message-ID: <20130123163004.GL28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130121060136.GA11275@blackspider>
 <20130121110026.GE19967@twin.jikos.cz>
 <20130121202016.GA24179@blackspider>
 <20130122141702.GC28263@twin.jikos.cz>
 <20130122214125.GA15469@blackspider>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130122214125.GA15469@blackspider>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 08:41:25AM +1100, Skender wrote:
> The only lines the have anythinf with btrfs are as follows:
[...]

That lacks information to analyze the error, so let's try it the usual
way. I'm not sure if you can grab the state of free space (via
btrfs fi df) from the time it happened, but that would at least say if
it was the ENOSPC case.

thanks,
david
