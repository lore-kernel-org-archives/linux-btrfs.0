Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out13.tpgi.com.au ([220.244.226.123]:34763 "EHLO
	mail13.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753903AbbHNK7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:59:04 -0400
Received: from office.waterlogic.com.au (240.108.240.220.dynamic.dsl.comindico.com.au [220.240.108.240])
	by mail13.tpgi.com.au (envelope-from paul@pauljones.id.au) (8.14.3/8.14.3) with ESMTP id t7EAr2RR030229
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 20:53:05 +1000
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: trim not working and irreparable errors from btrfsck
Date: Fri, 14 Aug 2015 10:51:58 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64596115E0A2@Server.waterlogic.com.au>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
	<5581ABA2.30906@gmail.com>	<21893.29830.540787.159202@localhost.localdomain>
	<B7F2379062E32745A8651FBDB20F64595D45D284@Server.waterlogic.com.au>
	<20150813112331.297d15f6@thetick>
	<CAJCQCtR_9L4oBOcLAfL1gC4UVt1APOU6iSkJ3TBrEcUb0hT3qg@mail.gmail.com>
 <20150814100555.24c01e93@thetick>
In-Reply-To: <20150814100555.24c01e93@thetick>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Marc Joliet
> Sent: Friday, 14 August 2015 6:06 PM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: trim not working and irreparable errors from btrfsck
> 
> Am Thu, 13 Aug 2015 17:14:36 -0600
> schrieb Chris Murphy <lists@colorremedies.com>:
> 
> >
> > Right now I think there's no status because a.) no bug report and b.)
> > not enough information.
> 
> I was mainly asking because apparently there *is* a patch that helps some
> people affected by this, but nobody ever commented on it.  Perhaps there's
> a reason for that, but I found it curious.  (I see now that it was submitted in
> early January, in the thread "[PATCH V2] Btrfs: really fix trim 0 bytes after a
> device delete".)
> 
> I can open a bug (I mean, that's part of being a user of btrfs at this stage), I'm
> just surprised that nobody else has.

I have to use that patch on one of my systems. I just assumed it was never merged because it wasn't quite ready yet. It seems to work fine for me though.


Paul.
