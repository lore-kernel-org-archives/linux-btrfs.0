Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ftx-008-i770.relay.mailchannels.net ([50.61.143.70]:32389 "EHLO
	ftx-008-i770.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbbLAKWw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 05:22:52 -0500
Subject: Re: [RFC] Btrfs device and pool management (wip)
To: Chris Murphy <lists@colorremedies.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <565C01F1.5030108@oracle.com> <565C625C.7060503@gmail.com>
 <CAJCQCtQPdzQG0She3yjxAmDmXSAphdMriW11Pe=BMrBRXYTh6Q@mail.gmail.com>
 <565CB3A2.30705@gmail.com>
 <CAJCQCtS1VTsTEzgf6Qx6zvdv3AR8UnUWZc-esn3skpYS2=VVDg@mail.gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <565D7106.9050302@swiftspirit.co.za>
Date: Tue, 1 Dec 2015 12:05:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS1VTsTEzgf6Qx6zvdv3AR8UnUWZc-esn3skpYS2=VVDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2015 11:09 PM, Chris Murphy wrote:
> On Mon, Nov 30, 2015 at 1:37 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> I've had multiple cases of disks that got one write error then were fine for
>> more than a year before any further issues.  My thought is add an option to
>> retry that single write after some short delay (1-2s maybe), and if it still
>> fails, then mark the disk as failed.
> Seems reasonable.
I think I added this to the Project Ideas page on the wiki a *very* long 
time ago
https://btrfs.wiki.kernel.org/index.php/Project_ideas#False_alarm_on_bad_disk_-_rebuild_mitigation

"After a device is marked as unreliable, maintain the device within the 
FS in order to confirm the issue persists. The device will still 
contribute toward fs performance but will not be treated as if 
contributing towards replication/reliability. If the device shows that 
the given errors were a once-off issue then the device can be marked as 
reliable once again. This will mitigate further unnecessary rebalance. 
See http://storagemojo.com/2007/02/26/netapp-weighs-in-on-disks/ - 
"[Drive Resurrection]" as an example of where this is a significant 
feature for storage vendors."
>
>>> Agreed. Maybe it would be an error rate (set by ratio)?
>>>
>> I was thinking of either:
>> a. A running count, using the current error counting mechanisms, with some
>> max number allowed before the device gets kicked.
>> b. A count that decays over time, this would need two tunables (how long an
>> error is considered, and how many are allowed).
>
> OK.
>
>
>


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

