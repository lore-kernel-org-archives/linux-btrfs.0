Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:46783 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbcGaBlq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 21:41:46 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id CC3B3600A7
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 03:41:42 +0200 (CEST)
Subject: Re: Balance and subvolume delete causes deadlock and metadata
 corruption
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <426e3db1-f06b-523a-be2c-261f47091f64@mendix.com>
 <329413bd-0490-13bf-93db-3b495dfd5d7b@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <af4fad32-edea-8f14-2b85-26ce482e0c6f@mendix.com>
Date: Sun, 31 Jul 2016 03:41:42 +0200
MIME-Version: 1.0
In-Reply-To: <329413bd-0490-13bf-93db-3b495dfd5d7b@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/31/2016 02:13 AM, Hans van Kranenburg wrote:
> On 07/31/2016 01:18 AM, Hans van Kranenburg wrote:
>> blahblahblahblahblalahba
>>
>> Doing a btrfs check now on the block device, will fup with the output.
>>
> 
> Output so far:
> 
> -# btrfs check /dev/xvdc 2>&1 | tee btrfs-check-xvdc
> checking extents
> ref mismatch on [3649516437504 16384] extent item 0, found 1
> Backref 3649516437504 parent 4100606377984 root 4100606377984 not found
> in extent tree
> backpointer mismatch on [3649516437504 16384]
> owner ref check failed [3649516437504 16384]
> ref mismatch on [4091477114880 16384] extent item 0, found 1
[...]
> ref mismatch on [4103438221312 16384] extent item 0, found 1
> Backref 4103438221312 parent 4100606377984 root 4100606377984 not found
> in extent tree
> backpointer mismatch on [4103438221312 16384]
> owner ref check failed [4103438221312 16384]
> checking free space tree
> checking fs roots
> [...]
> 

Yay...

checking free space tree
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/xvdc
UUID: 37c37071-4080-418b-a27a-29d7d15ec00d
cache and super generation don't match, space cache will be invalidated
found 1877500653751 bytes used err is 0
total csum bytes: 1805473324
total tree bytes: 28709109760
total fs tree bytes: 26028736512
total extent tree bytes: 589660160
btree space waste bytes: 4777447505
file data blocks allocated: 2809995116544
 referenced 2809992523776

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
