From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] resolve compile error on -rt
Date: Sun, 1 Jun 2008 15:23:55 -0400
Message-ID: <200806011523.56076.chris.mason@oracle.com>
References: <alpine.LNX.1.10.0806012105130.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0806012105130.4055@fbirervta.pbzchgretzou.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 01 June 2008, Jan Engelhardt wrote:
> Required to make it compiled with -rt patchset.

I thought -rt had the rcu page cache patches as well.  Btrfs should need 
larger changes for that.

Thanks for the bdi patch, I'll queue that up.

-chris
