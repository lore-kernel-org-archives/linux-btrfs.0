Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:37970 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069Ab3CTURo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 16:17:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: How to recover uncorrectable errors ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130321012414.3b232660@natsu>
Date: Wed, 20 Mar 2013 14:17:41 -0600
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_COIFFIER?= <frederic.coiffier@free.fr>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Message-Id: <2A1BFD02-9D60-4EBE-957A-C10AF9928DA7@colorremedies.com>
References: <6033676.gK0GbPgrpE@athlonxp> <201303161916.55185.Martin@lichtvoll.de> <3160822.Hx5D6eTo7L@athlonxp> <4B672F76-FAF9-4198-988D-440B6326A275@colorremedies.com> <20130321012414.3b232660@natsu>
To: Roman Mamedov <rm@romanrm.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 20, 2013, at 1:24 PM, Roman Mamedov <rm@romanrm.ru> wrote:

> On Wed, 20 Mar 2013 12:19:18 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>>> 195 Hardware_ECC_Recovered  0x001a   057   055   000    Old_age   Always       -       63508940
> 
>> With such high ECC recovered events, I suspect SDC. 
> 
> If it's a Seagate drive, this is absolutely normal.
> All Seagate drives have a high value in SMART Hardware_ECC_Recovered.

http://forums.seagate.com/t5/Barracuda-XT-Barracuda-Barracuda/Seagate-s-Seek-Error-Rate-Raw-Read-Error-Rate-and-Hardware-ECC/td-p/122382

http://www.silentpcreview.com/forums/viewtopic.php?t=57212

If I read this correctly, the read error rate and hardware ECC recovered are sector counts, so they should be the same.

Nevertheless, the file system isn't happy about checksums. It's not that it isn't finding the checksum data, it's finding errors with it.

Chris Murphy