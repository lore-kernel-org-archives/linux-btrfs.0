Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:45876 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab2J1UKX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 16:10:23 -0400
Date: Sun, 28 Oct 2012 20:09:58 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Chris Murphy <chris@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121028200958.GK2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <201210281133.10571.Martin@lichtvoll.de>
 <508D0FC5.1020404@inwind.it>
 <201210281216.43983.Martin@lichtvoll.de>
 <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com>
 <20121028190601.GJ2381@yeono.kjorling.se>
 <4B78F4E8-C65F-4436-A0BD-147CD776B7A7@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4B78F4E8-C65F-4436-A0BD-147CD776B7A7@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 Oct 2012 13:42 -0600, from chris@colorremedies.com (Chris Murphy):
>> * "btrfs" _is_ the file system administration tool. In a way, it makes
>>  sense that the data provided by it will be geared more toward
>>  technically minded people.
> 
> It is a fair point. But this is not LVM or md raid. It's way easier
> to understand and manage already, even with some trouble spots. But
> in the area of storage pool/volume management it's perhaps
> potentially more complex due to subvolumes and actually usable
> snapshots.
> 
> So, I must refuse part of the premise that sysadmins and storage
> experts aren't also ordinary people. They can benefit too from
> useful "at a glance" information that, again, doesn't mislead them.

I did not mean to imply that "sysadmins and storage experts aren't
also ordinary people" who can benefit from an "at a glance" view of
their storage situation. Quite to the contrary, that's one point I
have raised in this thread: the usefulness of an "at a glance" view of
the storage situation. But I can also certainly see the side of the
argument that they could reason their way around the concept of raw
storage capacity and allocation multipliers. After all, by the time
you get down to the "a few days of ordinary added data" range of free
space remaining, which would be when the exact numbers _really_ begin
to matter, you should be on top of adding more storage capacity
anyway.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
