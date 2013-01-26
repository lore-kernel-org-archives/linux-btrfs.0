Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41403 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3AZCTM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 21:19:12 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Gene Czarcinski <gene@czarc.net>
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
Date: Sat, 26 Jan 2013 13:18:59 +1100
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <51029EFB.90301@czarc.net>
In-Reply-To: <51029EFB.90301@czarc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301261318.59880.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 26 Jan 2013, Gene Czarcinski <gene@czarc.net> wrote:
> OK, I think I have gotten the message that this is a bad idea as 
> implemented and that it should be dropped as such.  I believe that there 
> are some things ("btrfs fi show" comes to mind) which will need root and 
> I am going to explore doing something for that case.  And it also might 
> be reasonable for some situations to issue the message about root if 
> something errors-out.

I think that a message such as Eric proposed of "failed to open /dev/sda: 
Permission denied" is clear enough.  If you run as non-root on a system with 
no security system other than Unix permissions then it will be quite obvious 
that such an error can be fixed by running as root.

But if you are running SE Linux or some other security system then you could 
be prevented from running the program without the root/non-root status of it 
being relevant.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
