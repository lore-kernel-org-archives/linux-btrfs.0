From: Arand Nash <ienorand@gmail.com>
Subject: Re: grub-1.99 and btrfs-only
Date: Mon, 07 Nov 2011 23:42:39 +0100
Message-ID: <4EB85EDF.1070003@gmail.com>
References: <1485076.Kk29g2Lexo@funbeast> <4EB848AB.1000006@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB848AB.1000006@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/11/11 22:07, Phillip Susi wrote:
> (...)
> 
> I'm still getting a "sparse file not allowed" error during boot, and
> have to press enter to continue though.  Still not tracked that one down.

https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/736743

Missing feature in GRUB, see Colin Watson's comments in partucular.
