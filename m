Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:43509 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3A3MB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 07:01:57 -0500
Date: Wed, 30 Jan 2013 13:01:55 +0100
From: Sander <sander@humilis.net>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID 0 across SSD and HDD
Message-ID: <20130130120155.GA20862@panda>
Reply-To: sander@humilis.net
References: <keap27$oqb$1@ger.gmane.org>
 <20130130100201.GN16285@carfax.org.uk>
 <keatr3$65q$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <keatr3$65q$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roger Binns wrote (ao):
> I'm happy to wait till it is available. btrfs has been beneficial to
> me in so many other respects (eg checksums, compression, online
> everything, not having to deal with LVM and friends). I was just
> hoping that joining an SSD and HDD would be somewhat worthwhile now
> even if it isn't close to what hot data will deliver in the future.

Do you know about bcache and EnhanceIO ?

http://bcache.evilpiepirate.org/
and
https://github.com/stec-inc/EnhanceIO

	Sander
