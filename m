Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab3DLNXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 09:23:08 -0400
Date: Fri, 12 Apr 2013 15:23:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is it currently possible to remount subvolume (not the whole
 filesystem) with nodatacow?
Message-ID: <20130412132306.GW18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5167FF73.2090201@statystyka.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5167FF73.2090201@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 12, 2013 at 02:34:59PM +0200, Adam Ryczkowski wrote:
> If so, please tell me, what is the first confirmed kernel version, which
> supports this. Or at least, is it available on Kernel 3.5.
> 
> I know, that it is possible to assign nodatacow attribute to files with
> "chattr +C <filename>", if the file has zero length.

I'm working on per-subvolume mount options that would make possible to
do what you ask about.

david
