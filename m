Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762567Ab3DCRX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 13:23:29 -0400
Date: Wed, 3 Apr 2013 19:23:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Harald Glatt <mail@hachre.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Backup Options
Message-ID: <20130403172326.GD18365@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
 <CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com>
 <CAFWF=a=iuvwUdSe7JuH3fMF1vugv4J90nV2D2cZV0E_LXj8RWQ@mail.gmail.com>
 <CAFWF=annpxTBF2_E=LThnqvc942ov=7ivBBqvDGDfci8haMWSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFWF=annpxTBF2_E=LThnqvc942ov=7ivBBqvDGDfci8haMWSA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 03, 2013 at 04:33:22AM +0200, Harald Glatt wrote:
> However what I actually did was:
> # cd /mnt/restore
> # nc -l -p 4444 | btrfs receive .
> 
> After noticing this difference I had to try it again as described in
> my mail and - oh wonder - it works now!! Giving 'btrfs receive' a dot
> as a parameter seems to fail in this case. Is this expected behavior
> or a bug?

Bug. Relative paths do not work on the receive side.

david
