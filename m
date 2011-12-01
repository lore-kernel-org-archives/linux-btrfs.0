Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45714 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1LAOu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2011 09:50:57 -0500
Received: by vcbfk14 with SMTP id fk14so1470341vcb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2011 06:50:56 -0800 (PST)
MIME-Version: 1.0
Reply-To: chb@muc.de
In-Reply-To: <or62i1rxzl.fsf@livre.localdomain>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
	<f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
	<CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
	<or62i1rxzl.fsf@livre.localdomain>
Date: Thu, 1 Dec 2011 15:50:56 +0100
Message-ID: <CAO47_-9SCmZGCkKmV93t-Q9X_ffaYs8gY_vaiPxtAPwzRzHQ+w@mail.gmail.com>
Subject: Re: [PATCH 02/20] Btrfs: initialize new bitmaps' list
From: Christian Brunner <chb@muc.de>
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/1 Alexandre Oliva <oliva@lsd.ic.unicamp.br>:
> On Nov 29, 2011, Christian Brunner <chb@muc.de> wrote:
>
>> When I'm doing havy reading in our ceph cluster. The load and wait-io
>> on the patched servers is higher than on the unpatched ones.
>
> That's unexpected.
>
>> This seems to be coming from "btrfs-endio-1". A kernel thread that has
>> not caught my attention on unpatched systems, yet.
>
> I suppose I could wave my hands while explaining that you're getting
> higher data throughput, so it's natural that it would take up more
> resources, but that explanation doesn't satisfy me.  I suppose
> allocation might have got slightly more CPU intensive in some cases, as
> we now use bitmaps where before we'd only use the cheaper-to-allocate
> extents.  But that's unsafisfying as well.

I must admit, that I do not completely understand the difference
between bitmaps and extents.

>From what I see on my servers, I can tell, that the degradation over
time is gone. (Rebooting the servers every day is no longer needed.
This is a real plus.) But the performance compared to a freshly
booted, unpatched server is much slower with my ceph workload.

I wonder if it would make sense to initialize the list field only,
when the cluster setup fails? This would avoid the fallback to the
much unclustered allocation and would give us the cheaper-to-allocate
extents.

Regards,
Christian
