Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:9069 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbaESVrt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 17:47:49 -0400
Message-ID: <537A7BF9.5060508@swiftspirit.co.za>
Date: Mon, 19 May 2014 23:47:37 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
References: <2308735.51F3c4eZQ7@xev> <ll7lvd$ulk$1@ger.gmane.org> <10946613.XrCytCZfuu@xev> <lldpvm$s7c$1@ger.gmane.org>
In-Reply-To: <lldpvm$s7c$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/19 10:36 PM, Martin wrote:
> On 18/05/14 17:09, Russell Coker wrote:
>> On Sat, 17 May 2014 13:50:52 Martin wrote:
> [...]
>>> Do you see or measure any real advantage?
>> [snip]
This is extremely difficult to measure objectively. Subjectively ... see 
below.
> [snip]
>
> *What other failure modes* should we guard against?

I know I'd sleep a /little/ better at night knowing that a double disk 
failure on a "raid5/1/10" configuration might ruin a ton of data along 
with an obscure set of metadata in some "long" tree paths - but not the 
entire filesystem.

The other use-case/failure mode - where you are somehow unlucky enough 
to have sets of bad sectors/bitrot on multiple disks that simultaneously 
affect the only copies of the tree roots - is an extremely unlikely 
scenario. As unlikely as it may be, the scenario is a very painful 
consequence in spite of VERY little corruption. That is where the 
peace-of-mind/bragging rights come in.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

