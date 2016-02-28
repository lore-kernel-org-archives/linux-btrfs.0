Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48562 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbcB1N4I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 08:56:08 -0500
Date: Sun, 28 Feb 2016 05:56:07 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160228135607.GB14776@merlins.org>
References: <20160227023938.GB5286@merlins.org> <20160227024533.GB11954@localhost.localdomain> <20160227030304.GC5286@merlins.org> <56D229F8.5080002@oracle.com> <20160228005614.GP19699@merlins.org> <56D25104.9020107@oracle.com> <20160228030930.GS19699@merlins.org> <pan$5fdff$39b005f1$778b3960$a3d0b01e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$5fdff$39b005f1$778b3960$a3d0b01e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 06:49:21AM +0000, Duncan wrote:
> The "defaults" mount option in fstab is just that, the defaults, and
> doesn't really apply as an option because they /are/ the defaults.  The

Yeah, been having this for some 20 years, cut and paste, and I should get
used to just removing it :)

> Additionally, with any reasonably modern util-linux, the last two fields,
> dump and fsck-passno, both default to 0 if not present, so don't need to
> be explicitly included if zero, unless of course you want to as a matter of

Correct. That one is mostly style/cut&paste and an fstab that was created in
1999 or so :)

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
