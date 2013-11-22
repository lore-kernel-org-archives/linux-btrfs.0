Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:21703 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3KVQHC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 11:07:02 -0500
Message-ID: <528F812D.8020105@hardwarefreak.com>
Date: Fri, 22 Nov 2013 10:07:09 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
MIME-Version: 1.0
To: David Brown <david.brown@hesbynett.no>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no> <528F122C.2040202@hardwarefreak.com>
In-Reply-To: <528F122C.2040202@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/22/2013 2:13 AM, Stan Hoeppner wrote:
> Hi David,
> 
> On 11/21/2013 3:07 AM, David Brown wrote:
...
>> I don't see that there needs to be any changes to the existing md code
>> to make raid15 work - it is merely a raid 5 made from a set of raid1
>> pairs.  
> 
> The sole purpose of the parity layer of the proposed RAID 15 is to
> replace sectors lost due to UREs during rebuild.  AFAIK the current RAID
> 5 and RAID 1 drivers have no code to support each other in this manner.

Minor self correction here-- obviously this isn't the 'sole' purpose of
the parity layer.  It also allows us to recover from losing an entire
mirror, which is a big upshot of the proposed RAID 15.  Thinking this
through a little further, more code modification would be needed for
this scenario.

In the event of a double drive failure in one mirror, the RAID 1 code
will need to be modified in such a way as to allow the RAID 5 code to
rebuild the first replacement disk, because the RAID 1 device is still
in a failed state.  Once this rebuild is complete, the RAID 1 code will
need to switch the state to degraded, and then do its standard rebuild
routine for the 2nd replacement drive.

Or, with some (likely major) hacking it should be possible to rebuild
both drives simultaneously for no loss of throughput or additional
elapsed time on the RAID 5 rebuild.  In the 20TB drive case, this would
shave 18 hours off the total rebuild operation elapsed time.  With
current 4TB drives it would still save 6.5 hours.  Losing both drives in
one mirror set of a striped array is rare, but given the rebuild time
saved it may be worth investigating during any development of this RAID
15 idea.

-- 
Stan
