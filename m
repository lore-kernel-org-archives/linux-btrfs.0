Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luna.xtsubasa.org ([82.196.7.38]:46646 "EHLO luna.xtsubasa.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbaFHOsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 10:48:38 -0400
Received: from localhost (melforce.xtsubasa.org [IPv6:2a02:578:5002:8062::2])
	by luna.xtsubasa.org (Postfix) with ESMTPSA id AAB2250A2A
	for <linux-btrfs@vger.kernel.org>; Sun,  8 Jun 2014 18:48:36 +0400 (MSK)
From: Pavel Volkov <sailor@lists.xtsubasa.org>
To: <linux-btrfs@vger.kernel.org>
Subject: Re: Using BTRFS on SSD now =?iso-8859-1?Q?=3F?=
Date: Sun, 08 Jun 2014 18:48:35 +0400
MIME-Version: 1.0
Message-ID: <62fc4c32-37c4-4c4e-b027-761859a12df4@lists.xtsubasa.org>
In-Reply-To: <yq14mzyzz6l.fsf@sermon.lab.mkp.net>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
 <FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
 <20140605190526.GS7210@merlins.org>
 <pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net>
 <yq14mzyzz6l.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, June 6, 2014 3:58:26 AM MSK, Martin K. Petersen wrote:
> Until then, the following command will give you the answer:
>
> # smartctl -l gplog,0x13 /dev/sda | grep 0000:
> 0000000: 01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 
|................|
>          ^^          ^^
> These two 01 fields indicate that the drive supports queued trim.
>

Is mine a dinosaur drive?

# smartctl -l gplog,0x13 /dev/sda 
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.14.5-gentoo-r1melf] (local 
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

General Purpose Log 0x13 does not exist (override with '-T permissive' 
option)

