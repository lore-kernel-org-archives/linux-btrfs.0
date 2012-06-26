Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:35760 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab2FZLSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 07:18:06 -0400
Date: Tue, 26 Jun 2012 13:11:47 +0200
From: Sander <sander@humilis.net>
To: Xavier Nicollet <nicollet@jeru.org>, Dmitry MiksIr <miksir@maker.ru>,
        linux-btrfs@vger.kernel.org
Subject: Re: how to cleanup old superblock
Message-ID: <20120626111146.GA20800@panda>
Reply-To: sander@humilis.net
References: <jsafma$896$1@dough.gmane.org>
 <20120625224900.GN28144@twin.jikos.cz>
 <20120626085324.GC16957@jeru.org>
 <20120626101712.GP28144@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120626101712.GP28144@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote (ao):
> Thanks. I redid the calculations and the statement that it 'will not
> touch anything else' may not be correct in rare cases.

What about wipefs?

"wipefs allows to erase filesystem or raid signatures (magic strings)
from the device to make the filesystem invisible for libblkid. wipefs
does not erase the whole filesystem or any other data from the device.
When used without options -a or -o, it lists all visible filesystems and
offsets of their signatures."

	Sander
