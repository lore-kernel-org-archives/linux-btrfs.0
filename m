Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:40670 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab3KYABJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 19:01:09 -0500
Message-ID: <52928B8F.3080804@grumpydevil.homelinux.org>
Date: Mon, 25 Nov 2013 00:28:15 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: stan@hardwarefreak.com
CC: John Williams <jwilliams4200@gmail.com>, NeilBrown <neilb@suse.de>,
        James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com>	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>	<528E8FEC.2070204@hardwarefreak.com>	<20131123100753.1820ab7c@notabene.brown>	<5290252A.8020508@hardwarefreak.com>	<20131123160428.6f1c5898@notabene.brown>	<CAJBj3vfsbPoke2spzomBQRGqmSG9RCjwfMG1R4mfmJ8SOBZjvw@mail.gmail.com>	<20131123181208.5103bee4@notabene.brown>	<52917AA8.1040300@hardwarefreak.com> <CAJBj3vdKsmQ=ovG5LnoDz_DqLFp5+o_j0JUWtWTRP+jzbbZkhg@mail.gmail.com> <52926BE3.1000301@hardwarefreak.com>
In-Reply-To: <52926BE3.1000301@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24-11-13 22:13, Stan Hoeppner wrote:
> I freely admit I may have drawn an incorrect conclusion about md 
> parity rebuild performance based on incomplete data. I simply don't 
> recall anyone stating here in ~3 years that their parity rebuilds were 
> speedy, but quite the opposite. I guess it's possible that each one of 
> those cases was due to another factor, such as user load, slow CPU, 
> bus bottleneck, wonky disk firmware, backplane issues, etc. 
The other part to this is, that the list sees what goes wrong. The cases 
where a replacement goes smoothly do not reach the list

Cheers,


Rudy
