Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946701Ab3BHQKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 11:10:38 -0500
Date: Fri, 8 Feb 2013 17:10:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Oops when mounting btrfs partition
Message-ID: <20130208161035.GI12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4028366.UQxPtEU6If@wuerfel>
 <20130202152035.GA24264@shiny>
 <201302042155.50977.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302042155.50977.arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 04, 2013 at 09:55:50PM +0000, Arnd Bergmann wrote:
> On Saturday 02 February 2013, Chris Mason wrote:
> 
> I've done a full backup of all data now, without any further Ooops messages, but
> I did get these:
> 
> [66155.429029] btrfs no csum found for inode 1212139 start 23707648

The missing csums were caused by a bug introcuded in 3.8-rc1 and fixed
in rc5.

david
