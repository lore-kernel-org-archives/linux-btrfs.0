Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44908 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaJMPkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 11:40:36 -0400
Message-ID: <543BF26C.5070905@prnet.org>
Date: Mon, 13 Oct 2014 17:40:28 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>
CC: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send and kernel 3.17
References: <543450DC.90504@prnet.org>	<1412714780.2374.0@mail.thefacebook.com>	<543A61EE.7070200@prnet.org>	<CANg_oxzGu3SB4Es5tdB4+zsYJ231eWo878XUVPFcoRFM5wNBzA@mail.gmail.com>	<543AF411.3090408@prnet.org>	<543B50F2.2010405@prnet.org> <CANg_oxzzFT5A0Cmn0REAzB5Lm-Tjytp6gaFb5r=F5=zFY-t8Dg@mail.gmail.com>
In-Reply-To: <CANg_oxzzFT5A0Cmn0REAzB5Lm-Tjytp6gaFb5r=F5=zFY-t8Dg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/13/2014 02:40 PM, john terragon wrote:
> Actually it seems strange that a send operation could corrupt the
> source subvolume or fs. Why would the send modify the source subvolume
> in any significant way? The only way I can find to reconcile your
> observations with mine is that maybe the snapshots get corrupted not
> by the send operation by itself but when they are generated with -r
> (readonly, as it is needed to send them). Are the corrupted snapshots
> you have in machine 2 (the one in which send was never used) readonly?
Yes, on both machines there are only readonly snapshots.
