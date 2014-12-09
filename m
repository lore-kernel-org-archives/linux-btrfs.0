Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:43220 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbaLIXUQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 18:20:16 -0500
Message-ID: <548783AE.6090600@pobox.com>
Date: Tue, 09 Dec 2014 15:20:14 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>	<20141122222606.GO8916@merlins.org>	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>	<20141123000503.GQ32735@carfax.org.uk>	<20141123010742.GA16599@merlins.org>	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com> <CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
In-Reply-To: <CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 02:29 PM, Patrik Lundquist wrote:
> Data, single: total=1.35TiB, used=1.35TiB
> System, single: total=32.00MiB, used=112.00KiB
> Metadata, single: total=3.00GiB, used=1.55GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

P.S. you should re-balance your System and Metadata as "DUP" for now. 
Two copies of that stuff is better than one as right now you have no 
real recovery path for that stuff. If you didn't make that change on 
purpose it probably got down-revved from DUP automagically when you 
tired to RAID it. e.g. block-by-block the dups were removed but then 
there was no place to put the mirrored copy.

