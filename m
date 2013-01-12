Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45582 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3ALB4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 20:56:07 -0500
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: dsterba@suse.cz
Subject: Re: 2 errors on scrub
Date: Sat, 12 Jan 2013 12:56:01 +1100
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
References: <201301101138.45428.russell+btrfs@coker.com.au> <20130110120446.GD20089@twin.jikos.cz>
In-Reply-To: <20130110120446.GD20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301121256.01117.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 10 Jan 2013, David Sterba <dsterba@suse.cz> wrote:
> >         total bytes scrubbed: 25.42GB with 2 errors
> >         error details: super=2
> 
> The superblock errors are detected but not corrected right away, because
> next transaction commit will overvrite it.
> 
> Does scub report the errors repeatedly?

Scrub reported the errors repeatedly, but now the errors have gone away (I 
have just done a few scrubs with no errors reported).  So it seems that 
something that happened in the mean time fixed it.

Thanks for your reply.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
