Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62207 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3KVQud (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 11:50:33 -0500
MIME-Version: 1.0
In-Reply-To: <528F122C.2040202@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com>
	<528DCD36.1060808@hesbynett.no>
	<528F122C.2040202@hardwarefreak.com>
Date: Fri, 22 Nov 2013 08:50:32 -0800
Message-ID: <CAK2H+efFuzvOaQe3NMOeBzujvvrrcKcZCmmMXzjTSUpLdJMvHQ@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Mark Knecht <markknecht@gmail.com>
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: David Brown <david.brown@hesbynett.no>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux-RAID <linux-raid@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 22, 2013 at 12:13 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Hi David,
>
> On 11/21/2013 3:07 AM, David Brown wrote:
<SNIP>
>> Shouldn't we be talking about RAID 15 here, rather than RAID 51 ?  I
>> interpret "RAID 15" to be like "RAID 10" - a raid5 set of raid1 mirrors,
>> while "RAID 51" would be a raid1 mirror of raid5 sets.  I am certain
>> that you mean a raid5 set of raid1 pairs - I just think you've got the
>> name wrong.
>
> Now that you mention it, yes, RAID 15 would fit much better with
> convention.  Not sure why I thought 51.  So it's RAID 15 from here.
<SNIP>

For us casual readers & RAID users could you clarify RAID15? Would
that be a bunch of RAID1's grouped together in what appears to be a
RAID5 to the system?

Thanks,
Mark
