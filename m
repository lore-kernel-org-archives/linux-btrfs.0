Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:47092 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbaLKGQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 01:16:08 -0500
Received: by mail-yh0-f41.google.com with SMTP id a41so2019659yho.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:16:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5488C8FA.2070405@pobox.com>
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
	<CAA7pwKOSKV2Q2HY1DGJVoxbCyQN4kEsZK-Q1yhQHyFYvwCRiEQ@mail.gmail.com>
	<5488C8FA.2070405@pobox.com>
Date: Thu, 11 Dec 2014 07:16:08 +0100
Message-ID: <CAA7pwKM_7FSkdmrrKRyVKTOxgqxhnspvfJcf2Nb0fBWRvuaxUA@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 December 2014 at 23:28, Robert White <rwhite@pobox.com> wrote:
> On 12/10/2014 10:56 AM, Patrik Lundquist wrote:
>>
>> On 10 December 2014 at 14:11, Duncan <1i5t5.duncan@cox.net> wrote:
>>>
>>> Assuming no snapshots still contain the file, of course, and that the
>>> ext* saved subvolume has already been deleted.
>>
>> Got no snapshots or subvolumes. Keeping it simple for now.
>
> Does that mean that you have already manually removed the subvolume that was
> automatically created by btrfs-convert?

Yes.
