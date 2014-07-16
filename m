Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s8.hotmail.com ([65.54.190.19]:52093 "EHLO
	BAY004-OMC1S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967AbaGPQyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 12:54:18 -0400
Message-ID: <BAY172-W58C322A131CC38388C068B0F70@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: File server structure suggestion
Date: Wed, 16 Jul 2014 11:49:13 -0500
In-Reply-To: <pan$3fa75$98459e65$9560b016$e99b83a7@cox.net>
References: <CAGTBuzTWV2jVqy4uScevHbMi-kp4_TRdeR21ZoA3-yOtCXPA=g@mail.gmail.com>,<pan$3fa75$98459e65$9560b016$e99b83a7@cox.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>
> Then there's raid10, which takes more drives and is faster, but is still
> limited to two mirrors. But while I haven't actually used raid10 myself,
> I do /not/ believe it's limited to pair-at-a-time additions. I believe
> it'll take, for instance five devices, just fine, staggering chunk
> allocation as necessary to fill all at about the same rate.
>
I am running just that: 3 separate raid10 btrfs filesystems (root, home, media/backups) on 5 drives and they are unequal sizes too!
My newer drives are bigger and have higher transfer rates which means they get more chunks but overall performance doesn't suffer.
 		 	   		  