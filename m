Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:57948 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbaKBLI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 06:08:56 -0500
Message-ID: <545610BE.1080508@pobox.com>
Date: Sun, 02 Nov 2014 03:08:46 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com>	<5451699B.4020507@pobox.com>	<54517338.7090606@pobox.com>	<54523D86.5040906@gmail.com>	<58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com>	<pan$2cd78$85acd913$95d42126$8a9a4137@cox.net>	<FC480E52-012E-41E7-902E-2EE3ECFFB90B@colorremedies.com>	<5455B25E.2070703@pobox.com> <20141102134855.33677567@natsu>
In-Reply-To: <20141102134855.33677567@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2014 01:48 AM, Roman Mamedov wrote:
> But afaik balance with -mconvert=raid1 (and no other filters specified)
> shouldn't touch data at all, no?

Ah... you seem to be correct. 8-)

My reading was flawed. I thought that the absence of a -d filter implied 
an "unfiltered activity" (e.g. do it all) not no activity at all. That 
is I was reading those as "filter expressions" not "enable expressions 
with optional filters".

The manual is less than clear.

The usage output is more clear.

By the usage reading (and after checking the code):

Specifying no flags is asking to do everything. So "btrfs balance /path" 
looks at every chunk.

Specifying none of -d -m and -s is the same as specifying all of them, 
so "btrfs balance /path" and "btrfs balance -d -m -s /path" are the same 
operation.

Specifying any of -d -m and/or -s highlights the absence of those not 
specified.

Confusing bit, for example, from wiki

[QUOTE]
If you are getting out of space errors due to metadata being full, try

btrfs balance start -v -dusage=0 /mnt/btrfs
[/QUOTE]

Combined with "Balances only block groups with usage under the given 
percentage. "

Which I was reading -dusage=0 means don't bother with data chunks and 
(and so just fix the metadata), otherwise the mention of using a -d 
filter to affect metadata is perverse.

Blarg... I mean just... blarg...

But now I know. 8-)
