Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab3BKRGP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 12:06:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dsterba@suse.cz
Subject: Re: Oops when mounting btrfs partition
Date: Mon, 11 Feb 2013 17:06:10 +0000
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <4028366.UQxPtEU6If@wuerfel> <201302042155.50977.arnd@arndb.de> <20130208161035.GI12339@twin.jikos.cz>
In-Reply-To: <20130208161035.GI12339@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302111706.10332.arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 08 February 2013, David Sterba wrote:
> On Mon, Feb 04, 2013 at 09:55:50PM +0000, Arnd Bergmann wrote:
> > On Saturday 02 February 2013, Chris Mason wrote:
> > 
> > I've done a full backup of all data now, without any further Ooops messages, but
> > I did get these:
> > 
> > [66155.429029] btrfs no csum found for inode 1212139 start 23707648
> 
> The missing csums were caused by a bug introcuded in 3.8-rc1 and fixed
> in rc5.
> 

Ok, thanks for the information.

	Arnd
