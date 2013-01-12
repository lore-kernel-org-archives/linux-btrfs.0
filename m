Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:39605 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab3ALIkm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 03:40:42 -0500
Received: from [212.54.34.134] (helo=smtp3.gn.mail.iss.as9143.net)
	by smtpq3.gn.mail.iss.as9143.net with esmtp (Exim 4.71)
	(envelope-from <r.wobben@home.nl>)
	id 1Ttwdt-0005OW-K3
	for linux-btrfs@vger.kernel.org; Sat, 12 Jan 2013 09:40:41 +0100
Received: from 524a811f.cm-4-3c.dynamic.ziggo.nl ([82.74.129.31] helo=[127.0.0.1])
	by smtp3.gn.mail.iss.as9143.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <r.wobben@home.nl>)
	id 1Ttwdt-0001IP-As
	for linux-btrfs@vger.kernel.org; Sat, 12 Jan 2013 09:40:41 +0100
Message-ID: <50F1218C.4000701@home.nl>
Date: Sat, 12 Jan 2013 09:40:44 +0100
From: Roelof Wobben <r.wobben@home.nl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: partition question
References: <50F06639.6030409@home.nl> <818D716E-CEFF-4170-B470-574D6E98375E@colorremedies.com> <20130111223845.GV19051@carfax.org.uk>
In-Reply-To: <20130111223845.GV19051@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op 11-1-2013 23:38, Hugo Mills schreef:
> On Fri, Jan 11, 2013 at 03:34:25PM -0700, Chris Murphy wrote:
>> On Jan 11, 2013, at 12:21 PM, Roelof Wobben <r.wobben@home.nl> wrote:
>>> I have one thing I think I don't really understand about btrfs,
>>>
>>> Normally if I use ext4 I make a  3 partitions for my distro.
>>>
>>> one for boot about 1G
>>> one for home about 30G
>>> one for root for the rest of my 100G.
>>>
>>> Now I wonder if I want to do the same with btrfs.
>>>
>>> Can I do the same so make 3 partitions with btrfs or can I better make 1 partiton of 100G and make the /boot /home and  / subvolumes of the big partitiion.
>>>
>>> Can one of you btfrs gurus shine a light of this matter ?
>> You can make one Btrfs volume with /boot, /home, and / as
>> subvolumes. GRUB2 2.00 can boot this arrangement, and that's the
>> first caveat which is that many distributions are using older
>> versions of GRUB2. It even works with Btrfs data/metadata profiles
>> single, dup; and multiple device raid 0, 1, 10; and compression
>> zlib, and lzo.
>>
>> Swap still needs to be on a separate partition, as I don't think
>> Btrfs is supporting swapfiles yet still, but maybe someone else can
>> comment on the status of that.
>     I don't know this area of the code at all well, but as I understand
> it, there's been some work in the kernel (swap over NFS) which lays
> down some of the underlying infrastructure we'd need to support
> swapfiles on btrfs, but we don't have anything beyond that. I don't
> know of anyone working on it, either.
>
>     Hugo.
>

Im testing Crux where I must make a custom partiion scheme before I can 
start the installer.
And Im making this scheme before because people told me that was the 
best way to work.

Roelof

