Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-dannielle.wadns.net ([41.185.62.29]:45917 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754358AbaKRNYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 08:24:54 -0500
Message-ID: <546B48A0.1070206@swiftspirit.co.za>
Date: Tue, 18 Nov 2014 15:24:48 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141118123646.01239614@natsu>
In-Reply-To: <20141118123646.01239614@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/18 09:36, Roman Mamedov wrote:
> On Tue, 18 Nov 2014 09:29:54 +0200
> Brendan Hide <brendan@swiftspirit.co.za> wrote:
>
>> Hey, guys
>>
>> See further below extracted output from a daily scrub showing csum
>> errors on sdb, part of a raid1 btrfs. Looking back, it has been getting
>> errors like this for a few days now.
>>
>> The disk is patently unreliable but smartctl's output implies there are
>> no issues. Is this somehow standard faire for S.M.A.R.T. output?
> Not necessarily the disk's fault, could be a SATA controller issue. How are
> your disks connected, which controller brand and chip? Add lspci output, at
> least if something other than the ordinary "to the motherboard chipset's
> built-in ports".

In this case, yup, its directly to the motherboard chipset's built-in ports. This is a very old desktop, and the other 3 disks don't have any issues. I'm checking out the alternative pointed out by Austin.

SATA-relevant lspci output:
00:1f.2 SATA controller: Intel Corporation 82801JD/DO (ICH10 Family) SATA AHCI Controller (rev 02)


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

