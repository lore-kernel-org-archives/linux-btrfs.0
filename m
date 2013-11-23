Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:56336 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3KWRjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 12:39:17 -0500
Message-ID: <5290E83F.5080304@hesbynett.no>
Date: Sat, 23 Nov 2013 18:39:11 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: stan@hardwarefreak.com, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no> <528F122C.2040202@hardwarefreak.com> <528F812D.8020105@hardwarefreak.com> <20131123095953.18858e89@notabene.brown>
In-Reply-To: <20131123095953.18858e89@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/11/13 23:59, NeilBrown wrote:
> On Fri, 22 Nov 2013 10:07:09 -0600 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
>
<snip>
>> In the event of a double drive failure in one mirror, the RAID 1 code
>> will need to be modified in such a way as to allow the RAID 5 code to
>> rebuild the first replacement disk, because the RAID 1 device is still
>> in a failed state.  Once this rebuild is complete, the RAID 1 code will
>> need to switch the state to degraded, and then do its standard rebuild
>> routine for the 2nd replacement drive.
>>
>> Or, with some (likely major) hacking it should be possible to rebuild
>> both drives simultaneously for no loss of throughput or additional
>> elapsed time on the RAID 5 rebuild.
>
> Nah, that would be minor hacking.  Just recreate the RAID1 in a state that is
> not-insync, but with automatic-resync disabled.
> Then as continuous writes arrive, move the "recovery_cp" variable forward
> towards the end of the array.  When it reaches the end we can safely mark the
> whole array as 'in-sync' and forget about diabling auto-resync.
>
> NeilBrown
>

That was my thoughts here.  I don't know what state the planned "bitmap 
of non-sync regions" feature is in, but if and when it is implemented, 
you would just create the replacement raid1 pair without any 
synchronisation.  Any writes to the pair (such as during a raid5 
rebuild) would get written to both disks at the same time.

David


