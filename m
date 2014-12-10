Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:44410 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaLJS4u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 13:56:50 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so1577645yha.32
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 10:56:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$adbdd$de0c5a95$a95c46aa$74eda7e0@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
	<548839EE.6080404@pobox.com>
	<pan$adbdd$de0c5a95$a95c46aa$74eda7e0@cox.net>
Date: Wed, 10 Dec 2014 19:56:50 +0100
Message-ID: <CAA7pwKOSKV2Q2HY1DGJVoxbCyQN4kEsZK-Q1yhQHyFYvwCRiEQ@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 December 2014 at 14:11, Duncan <1i5t5.duncan@cox.net> wrote:
>
> From there... I've never used it but I /think/ btrfs inspect-internal
> logical-resolve should let you map the 182109... address to a filename.
> From there, moving that file out of the filesystem and back in should
> eliminate that issue.

btrfs inspect-internal logical-resolve 1821099687936 /mnt gives me the
filename and it's only a 54175 bytes file.


> Assuming no snapshots still contain the file, of course, and that the
> ext* saved subvolume has already been deleted.

Got no snapshots or subvolumes. Keeping it simple for now.
