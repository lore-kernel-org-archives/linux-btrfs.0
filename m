Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hammer.websitemanagers.com.au ([203.98.89.10]:49712 "EHLO
	hammer.websitemanagers.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab3KUKBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 05:01:38 -0500
Message-ID: <528DD86E.8040608@websitemanagers.com.au>
Date: Thu, 21 Nov 2013 20:54:54 +1100
From: Adam Goryachev <mailinglists@websitemanagers.com.au>
MIME-Version: 1.0
To: David Brown <david.brown@hesbynett.no>, stan@hardwarefreak.com,
        James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>
CC: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no>
In-Reply-To: <528DCD36.1060808@hesbynett.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/13 20:07, David Brown wrote:
> I can see plenty of reasons why raid15 might be a good idea, and even
> raid16 for 5 disk redundancy, compared to multi-parity sets.  However,
> it costs a lot in disk space.  For example, with 20 disks at 1 TB each,
> you can have:
>
> raid5 = 19TB, 1 disk redundancy
> raid6 = 18TB, 2 disk redundancy
> raid6.3 = 17TB, 3 disk redundancy
> raid6.4 = 16TB, 4 disk redundancy
> raid6.5 = 15TB, 5 disk redundancy
>
> raid10 = 10TB, 1 disk redundancy
> raid15 = 8TB, 3 disk redundancy
> raid16 = 6TB, 5 disk redundancy
>
>
> That's a very significant difference.
>
> Implementing 3+ parity does not stop people using raid15, or similar
> schemes - it just adds more choice to let people optimise according to
> their needs.
BTW, as far as strange RAID type options to try and get around problems
with failed disks, before I learned about timeout mismatches, I was
pretty worried when my 5 disk RAID5 kept falling apart and losing a
random member, then adding the failed disk back would work perfectly. To
help me feel better about this, I used 5 x 500GB drives in RAID5 and
then used the RAID5 + 1 x 2TB drive in RAID1, meaning I could afford to
lose any two disks without losing data. Of course, now I know RAID6
might have been a better choice, or even simply 2 x 2TB drives in RAID1 :)

In any case, I'm not sure I understand the concern with RAID 7.X (as it
is being called, where X > 2). Certainly you will need to make 1
computation for each stripe being written, for each value of X, so RAID
7.5 with 5 disk redundancy means 5 calculations for each stripe being
written. However, given that drives are getting bigger every year, did
we forget that we are also getting faster CPU and also more cores in a
single "CPU package"?

On a pure storage server, the CPU would normally have nothing to do,
except a little interrupt handling, it is just shuffling bytes around.
Of course, if you need RAID7.5 then you probably have a dedicated
storage server, so I don't see the problem with using the CPU to do all
the calculations.

Of course, if you are asking about carbon emissions, and cooling costs
in the data center, this could (on a global scale) have a significant
impact, so maybe it is a bad idea after all :)

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

