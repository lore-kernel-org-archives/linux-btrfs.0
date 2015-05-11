Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbbEKQcy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 12:32:54 -0400
Date: Mon, 11 May 2015 18:32:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs changes (issues?) on OS upgrade
Message-ID: <20150511163252.GW23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1798034232.614027.1431151384353.JavaMail.apache@nm33.abv.bg>
 <20150509085844.GA839393@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150509085844.GA839393@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 09, 2015 at 10:58:44AM +0200, Tomasz Torcz wrote:
> On Sat, May 09, 2015 at 09:03:04AM +0300, Милен Христов wrote:
> > 
> > 1. Before the upgrade, the size of the entire array was reported as 9TB
> > (roughly), both on the server (I use conky to monitor server status) and via
> > samba on Windows clients. After the upgrade, the size is reduced to 4.55 TB
> > which seems to better reflect what the actual usable space is, but is
> > unexpected to me (I read some articles on the web about the difficulties in
> > calculating free space on a btrfs filesystem). Is this expected?  > 
> 
>   This was changed in kernel 3.17:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ba7b6e62f420f5a8832bc161ab0c7ba767f65b3d

That's right. Before this patch, the space in df was reported in
physical bytes, ie 9TB. The patch recalculates the space to the logical
size according to the raid profiles, so it's 9/2 ~ 4.55 TB afterwards.
