Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:43748 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbaLASrq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 13:47:46 -0500
Message-ID: <547CB7D0.4040800@pobox.com>
Date: Mon, 01 Dec 2014 10:47:44 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Peter Volkov <pva@gentoo.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stuck with lot's of files
References: <1417434411.20237.1.camel@gentoo.org>
In-Reply-To: <1417434411.20237.1.camel@gentoo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2014 03:46 AM, Peter Volkov wrote:
> Hi, guys.
 > (stuff about getting hung up trying to write to one drive)

That drive (/dev/sdn) is probably starting to fail. Some older drives 
basically go unresponsive when they start to go bad. Particularly if 
they've gone bad enough to have run out of spare tracks/sectors. 
Sometimes they will just refuse to answer. Sometimes they will go into 
"try again" mode, and the same activity will be retried indefinitely. 
This will then fill up your write queues and jam up all sorts of subsystems.

Step 1: Backup your data. Since you didn't RAID your data at all, when 
that drive dies your data is going to go away in fascinating and 
unpredictable ways. (RAID1 metadata with no RAID1 or RAID5 of the data 
means you have essentially no media failure protection.)

Step 2: Turn on SMART (if you can and you can) and check whether the 
drive is in its final moments of life. If your disk is all green lights 
according to smart, you may be able to un-jamb it by just doing a 
balance as described and explained after the next time I quote you.

Step 3: Switch your data mode to RAID5. It will cost you about half of 
your currenly free data space, but it won't leave you _as_ _vulnerable_ 
to complete data loss as you are now. SMART might be wrong about your 
drive being fine if it says it is.

>   # btrfs filesystem df /store/
> Data, single: total=11.92TiB, used=10.86TiB

Reguardless of the above...

You have a terabyte of unused but allocated data storage. You probably 
need to balance your system to un-jamb that. That's a lot of space that 
is unavailable to the metadata (etc).

ASIDE: Having your metadata set to RAID1 (as opposed to the default of 
DUP) seems a little iffy since your data is still set to DUP. This 
configuration is not going to leave you with a mountable filesystem if 
you lose a disk. I'm not sure if the RAID1 layout is going to want to 
put specific datum in specific places, but it might, which if it does 
might leave you in an irreconcilable position.

Either way, you will probably un-jam your system in the short run by 
doing a balance. A full balance (no filter args at all) would be your 
best bet.

FUTHER ASIDE: raid1 metadata and raid5 data might be good for you given 
22 volumes and 10% empty empty space it would only cost you half of your 
existing empty space. If you don't RAID your data, there is no real 
point to putting your metadata in RAID.

[Yes, I said my basic points about your current layout two different 
ways and times. You are either "just a little over-committed on space" 
or you are "about to lose all your data" and it's impossible to tell 
which is the case from here.]

Backup your data. NOW!

