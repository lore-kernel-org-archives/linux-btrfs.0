Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41389 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaC3DWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 23:22:11 -0400
Received: from 24-182-54-115.dhcp.crcy.nv.charter.com ([24.182.54.115]:41044 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WU6K2-00017r-Sf by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Mar 2014 20:22:11 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WU6Jv-0005I8-H1
	for linux-btrfs@vger.kernel.org; Sat, 29 Mar 2014 20:22:03 -0700
Date: Sat, 29 Mar 2014 20:22:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive still gets out of sync in 3.14.0
Message-ID: <20140330032202.GV22552@merlins.org>
References: <20140322210455.GL28005@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140322210455.GL28005@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 22, 2014 at 02:04:56PM -0700, Marc MERLIN wrote:
> After deleting a huge directory tree in my /home subvolume, syncing
> snapshots now fails with:
> 
> ERROR: rmdir o1952777-157-0 failed. No such file or directory

So, I'm ok again after I deleted my destination snapshot and re-init'ed,
but on multi terabyte backups, this ain't great :)

Do I need to file a bug that btrfs send/receive still gets out of sync
in 3.14, or is it already known and maybe even fixed in btrfs-next?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
