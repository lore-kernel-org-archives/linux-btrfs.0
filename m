Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46807 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab1LGUuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2011 15:50:05 -0500
Received: by vcbfk14 with SMTP id fk14so853401vcb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Dec 2011 12:50:04 -0800 (PST)
MIME-Version: 1.0
Reply-To: chb@muc.de
In-Reply-To: <CAO47_-9SCmZGCkKmV93t-Q9X_ffaYs8gY_vaiPxtAPwzRzHQ+w@mail.gmail.com>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
	<f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
	<CAO47_--r5NVPLpLRW0ftUs4T3xtEuJqMpAz1t7SYnHGdM0e=Fg@mail.gmail.com>
	<or62i1rxzl.fsf@livre.localdomain>
	<CAO47_-9SCmZGCkKmV93t-Q9X_ffaYs8gY_vaiPxtAPwzRzHQ+w@mail.gmail.com>
Date: Wed, 7 Dec 2011 21:50:04 +0100
Message-ID: <CAO47_--d2oEHCyMafoBLWfbd1WZsASngBh=4_TNiwrwd+QJkGA@mail.gmail.com>
Subject: Re: [PATCH 02/20] Btrfs: initialize new bitmaps' list
From: Christian Brunner <chb@muc.de>
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/1 Christian Brunner <chb@muc.de>:
> 2011/12/1 Alexandre Oliva <oliva@lsd.ic.unicamp.br>:
>> On Nov 29, 2011, Christian Brunner <chb@muc.de> wrote:
>>
>>> When I'm doing havy reading in our ceph cluster. The load and wait-io
>>> on the patched servers is higher than on the unpatched ones.
>>
>> That's unexpected.

In the mean time I know, that it's not related to the reads.

>> I suppose I could wave my hands while explaining that you're getting
>> higher data throughput, so it's natural that it would take up more
>> resources, but that explanation doesn't satisfy me.  I suppose
>> allocation might have got slightly more CPU intensive in some cases, as
>> we now use bitmaps where before we'd only use the cheaper-to-allocate
>> extents.  But that's unsafisfying as well.
>
> I must admit, that I do not completely understand the difference
> between bitmaps and extents.
>
> From what I see on my servers, I can tell, that the degradation over
> time is gone. (Rebooting the servers every day is no longer needed.
> This is a real plus.) But the performance compared to a freshly
> booted, unpatched server is much slower with my ceph workload.
>
> I wonder if it would make sense to initialize the list field only,
> when the cluster setup fails? This would avoid the fallback to the
> much unclustered allocation and would give us the cheaper-to-allocate
> extents.

I've now tried various combinations of you patches and I can really
nail it down to this one line.

With this patch applied I get much higher write-io values than without
it. Some of the other patches help to reduce the effect, but it's
still significant.

iostat on an unpatched node is giving me:

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
avgrq-sz avgqu-sz   await  svctm  %util
sda             105.90     0.37   15.42   14.48  2657.33   560.13
107.61     1.89   62.75   6.26  18.71

while on a node with this patch it's
sda             128.20     0.97   11.10   57.15  3376.80   552.80
57.58    20.58  296.33   4.16  28.36


Also interesting, is the fact that the average request size on the
patched node is much smaller.

Josef was telling me, that this could be related to the number of
bitmaps we write out, but I've no idea how to trace this.

I would be very happy if someone could give me a hint on what to do
next, as this is one of the last remaining issues with our ceph
cluster.

Thanks,
Christian
