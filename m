Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55759 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3AJLBh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:01:37 -0500
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: 2 errors on scrub
Date: Thu, 10 Jan 2013 22:01:31 +1100
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
References: <201301101138.45428.russell+btrfs@coker.com.au> <20130110085523.GS19051@carfax.org.uk>
In-Reply-To: <20130110085523.GS19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201301102201.31654.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 10 Jan 2013, Hugo Mills <hugo@carfax.org.uk> wrote:
>    Looks like broken superblocks, from that message. There's probably
> more information in your kernel logs.

The only BTRFS message I see in the kernel log is "btrfs: unlinked 3 orphans" 
which happens every time a cron job makes a snapshot of /home.  Why does it do 
that?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
