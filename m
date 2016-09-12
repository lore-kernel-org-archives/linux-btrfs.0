Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37835 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756103AbcILM0W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:26:22 -0400
Received: by mail-it0-f50.google.com with SMTP id 186so9174970itf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 05:26:22 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 88sm1428413iol.16.2016.09.12.05.26.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Sep 2016 05:26:20 -0700 (PDT)
Subject: Re: Is stability a joke?
To: linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no> <57D53E3A.1030106@online.no>
 <15194548.valIGHoaRh@merkaba> <2682119.DRdtbgPpNZ@merkaba>
 <pan$3e415$d77ee400$5f659e58$3c9cc8bb@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4ec92a4f-0e33-48c6-9510-4aace4b9465e@gmail.com>
Date: Mon, 12 Sep 2016 08:26:17 -0400
MIME-Version: 1.0
In-Reply-To: <pan$3e415$d77ee400$5f659e58$3c9cc8bb@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-11 13:11, Duncan wrote:
> Martin Steigerwald posted on Sun, 11 Sep 2016 14:05:03 +0200 as excerpted:
>
>> Just add another column called "Production ready". Then research / ask
>> about production stability of each feature. The only challenge is: Who
>> is authoritative on that? I´d certainly ask the developer of a feature,
>> but I´d also consider user reports to some extent.
>
> Just a note that I'd *not* call it "production ready".  Btrfs in general
> is considered "stabilizing, not yet fully stable and mature", as I
> normally put it.  Thus, I'd call that column "stabilized to the level of
> btrfs in general", or perhaps just "stabilized", with a warning note with
> the longer form.
>
> Because "production ready" can mean many things to many people.  The term
> seems to come from a big enterprise stack, with enterprise generally both
> somewhat conservative in deployment, and having backups and often hot-
> spare-redundancy available, because lost time is lost money, and lost
> data has serious legal and financial implications.
>
> But by the same token, /because/ they have the resources for fail-over,
> etc, large enterprises can and occasionally do deploy still stabilizing
> technologies, knowing they have fall-backs if needed, that smaller
> businesses and individuals often don't have.
>
> Which is in my mind what's going on here.  Some places may be using it in
> production, but if they're sane, they have backups and even fail-over
> available.  Which is quite a bit different than saying it's "production
> ready" on an only machine, possibly with backups available but which
> would take some time to bring systems back up, and if it's a time is
> money environment, then...
>
> Which again is far different than individual users, some of which
> unfortunately may not even have backups.
>
> If "production ready" is taken to be the first group, with fail-overs
> available, etc, it means something entirely different than it does in the
> second and third cases, and I'd argue that while btrfs is ready for the
> first and can in some cases be ready for the second and the third if they
> have backups, it's definitely *not* "production ready" for the segment of
> the third that don't even have backups.
>
And definitely not for the segment of the second and third who believe 
that RAID is a backup.

It brings to mind one of my friends who I was explaining my home 
server's storage stack to.  When I explained that I could lose three of 
the four primary disks and one of the SSD's and the system would still 
keep running and be pretty much fully usable, his first response was 
'Oh, so you have three backups of the prim,ary disk and one of the 
SSD?'.  We had a long discussion after that where I explained that RAID 
was not a backup, it was for keeping things working when a disk failed 
so you didn't have to restore from a backup.
