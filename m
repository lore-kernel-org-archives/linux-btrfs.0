Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:46559 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3KWIhy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 03:37:54 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 071B215281
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 08:37:53 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 4sQdhx_rvUov for <linux-btrfs@vger.kernel.org>;
	Sat, 23 Nov 2013 08:37:50 +0000 (GMT)
Message-ID: <5290695E.80506@pocock.com.au>
Date: Sat, 23 Nov 2013 09:37:50 +0100
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Nagios probe for btrfs RAID status?
References: <528F6085.4020603@pocock.com.au> <52902808.8020706@oracle.com>
In-Reply-To: <52902808.8020706@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23/11/13 04:59, Anand Jain wrote:
> 
> 
>> For example, would the command
>>
>>      btrfs filesystem show --all-devices
>>
>> give a non-zero error status or some other clue if any of the devices
>> are at risk?
> 
>  No there isn't any good way as of now. that's something to fix.

Does it require kernel/driver code changes or it should be possible to
implement in the user space utility?

It would be useful for people testing the filesystem to know when they
get into trouble so they can investigate more quickly (and before the
point of no return)

> [btrfs personal user/sysadmin, not a dev, not anything large enough to
> have personal nagios experience...]
> 
> AFAIK, btrfs raid modes currently switch the filesystem to read-only on
> any device-drop error. That has been deemed the simplest/safest policy
> during development, tho at some point as stable approaches the behavior
> could theoretically be made optional.

None of the warnings about btrfs's experimental status hint at that,
some people may be surprised by it.

> So detection could watch for read-only and act accordingly, either
> switching back to read-write or rebooting or simply logging the event,
> as deemed appropriate.

It would be relatively trivial to implement a Nagios check for
read-only, Nagios probes are just shell scripts

What about when btrfs detects a bad block checksum and recovers data
from the equivalent block on another disk?  The wiki says there will be
a syslog event.  Does btrfs keep any stats on the number of blocks that
it considers unreliable and can this be queried from user space?

