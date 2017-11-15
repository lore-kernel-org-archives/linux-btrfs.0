Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59171 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdKOWJ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 17:09:26 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eF5ro-00031j-9M
        for linux-btrfs@vger.kernel.org; Wed, 15 Nov 2017 23:09:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Tiered storage?
Date: Wed, 15 Nov 2017 22:09:01 +0000 (UTC)
Message-ID: <pan$2f5e9$3d84bf7c$d36ba31d$63a716c0@cox.net>
References: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
        <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net>
        <45d19817-ebf8-65ae-693f-2324ba637a67@gmail.com>
        <916739346.627.1510755008650.JavaMail.zimbra@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roy Sigurd Karlsbakk posted on Wed, 15 Nov 2017 15:10:08 +0100 as
excerpted:

>>> As for dedupe there is (to my knowledge) nothing fully automatic yet.
>>> You have to run a program to scan your filesystem but all the
>>> deduplication is done in the kernel.
>>> duperemove works apparently quite well when I tested it, but there may
>>> be some performance implications.

>> Correct, there is nothing automatic (and there are pretty significant
>> arguments against doing automatic deduplication in most cases), but the
>> off-line options (via the EXTENT_SAME ioctl) are reasonably reliable.
>> Duperemove in particular does a good job, though it may take a long
>> time for large data sets.
>> 
>> As far as performance, it's no worse than large numbers of snapshots.
>> The issues arise from using very large numbers of reflinks.
> 
> What is this "large" number of snapshots? Not that it's directly
> comparible, but I've worked with ZFS a while, and haven't seen those
> issues there.

Btrfs has scaling issues with reflinks, not so much in normal operation, 
but when it comes to filesystem maintenance such as btrfs check and btrfs 
balance.

Numerically, low double-digits of reflinks per extent seems to be 
reasonably fine, high double-digits to low triple-digits begins to run 
into scaling issues, and high triple digits to over 1000... better be 
prepared to wait awhile (can be days or weeks!) for that balance or check 
to complete, and check requires LOTS more memory as well, particularly at 
TB+ scale.

Of course snapshots are the common instance of reflinking, and each 
snapshot is another reflink to each extent of the data in the subvolume 
it covers, so limiting snapshots to 10-50 of each subvolume is 
recommended, and limiting to under 250-ish is STRONGLY recommended.  
(Total number of snapshots per filesystem, where there's many subvolumes 
and snapshots per subvolume falls within the above limits, doesn't seem 
to be a problem.)

Dedupe uses reflinking too, but the effects can be much more variable 
depending on the use-case and how many actual reflinks are being created.

A single extent with 1000 deduping reflinks, as might be common in a 
commercial/hosting use-case, shouldn't be too bad, perhaps comparable to 
a single snapshot, but obviously, do that with a bunch of extents (as a 
hosting use-case might) and it quickly builds to the effect of 1000 
snapshots of the same subvolume, which as mentioned above puts 
maintenance-task time out of the realm of reasonable, for many.

Tho of course in a commercial/hosting case maintenance may well not be 
done as a simple swap-in of a fresh backup is more likely, so it may not 
matter for that scenario.

OTOH, a typical individual/personal use-case may dedup many files but 
only single-digit times each, so the effect would be the same as a single-
digit number of snapshots at worst.

Meanwhile, while btrfs quotas are finally maturing in terms of actually 
tracking the numbers correctly, their effect on scaling is pretty bad 
too.  The recommendation is to keep btrfs quotas off unless you actually 
need them.  If you do need quotas, temporarily disable them while doing 
balances and device-removes (which do implicit balances), then quota-
rescan after the balance is done, because precisely tracking quotas thru 
a balance ends up repeatedly recalculating the numbers again and again 
during the balance, and that just doesn't scale.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

