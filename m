Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39612 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaASOrw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 09:47:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W4tfD-0000IL-3I
	for linux-btrfs@vger.kernel.org; Sun, 19 Jan 2014 15:47:51 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 15:47:51 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 15:47:51 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfs scrub ioprio
Date: Sun, 19 Jan 2014 14:49:04 +0100
Message-ID: <gn1tqa-i9d.ln1@hurikhan77.spdns.de>
References: <5292C7F7.8010200@jrs-s.net> <pan.2013.11.26.00.50.14.749597@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstaette <holger.hoffstaette@googlemail.com> schrieb:

> On Sun, 24 Nov 2013 22:45:59 -0500, Jim Salter wrote:
> 
>> TL;DR scrub's ioprio argument isn't really helpful - a scrub murders
>> system performance til it's done.
>> 
>> My system:
>> 
>> 3.11 kernel (from Ubuntu Saucy)
> 
> I don't run Ubuntu, but *maybe* they use the deadline IO scheduler by
> default, which does not handle IO priorities (by design). So maybe make
> sure your devices don't say "deadline" in /sys/block/sdX/queue/scheduler,
> and if they do, set them to cfq.

OTOH I've switched from CFQ to Deadline in Gentoo and IO responsiveness has 
greatly improved since then (spinning rust). The system boots faster, is 
able to start programs faster during IO stress, but swapping seems to stress 
the system a lot more. But since I got 16 GB RAM this is not a big problem. 
Throughput is not as good as with CFQ - but this is a desktop system: 
latency counts more than throughput, and that improved a lot.

I've tried BFQ before switching to Deadline but BFQ just does not cut it. 
During high IO loads it simply does not feel interactive although it was 
designed to guarantee exactly that. The fact that it also made my kernel 
unstable (with bfq related backtraces in the kernel log) I've switched away 
from it.

But I have to admit that I'm using the following setting to reduce processes 
blocking on high IO loads, tho you should have enough RAM to use it:

$ cat /etc/local.d/nr_requests.start 
#!/bin/sh

for nr_requests in /sys/block/sd[abc]/queue/nr_requests; do
        echo -n 4096 >$nr_requests
done

My btrfs pool spans sd[abc].

I'm using a weekly scrubbing job and a daily rsync backup job and see no 
drawbacks from using deadline scheduler, rather it improved a lot.

@OP:

I suggest looking at the surrounding parameters also for trouble shooting: 
Maybe the SATA driver just doesn't cut it? Maybe a BIOS setting is wrong 
(AHCI mode?)... Does your system run low on RAM (with deadline this can 
become a heavy bottleneck)? Also, 3.12 kernel improved btrfs performance, 
you may want to try that first.

Did you check which IO scheduler is in use?

BTW: Yes, Ubuntu has switched from CFQ to Deadline by default for servers 
and desktops - with the same finding I had when trying. CFQ is more or less 
optimized for the general usecase and tries to behave like the old 
anticipatory scheduler, but it is designed with "fair" bandwidth 
distribution in mind which hurts interactivity a lot. But desktop systems 
feel fast by reducing latency, not by improving or fair-sharing bandwidth. 
Most servers need low latency for good service response times, throughput is 
not important. So deadline is not a bad choice for most use-cases (I know, 
"most use-cases" is subjective but I think for the edge-cases which benefit 
from CFQ the user already knows how to switch to the right scheduler). We've 
switched all our virtualized servers from CFQ to noop and they are running a 
lot better now with much decreased IO latency and lower IO wait. I think 
"fair bandwidth distribution" is just no longer that important with devices 
being able to deliver 100+ MB/s of bandwidth and low latency becomes more 
and more important...

But: YMMV... ;-)

Regards,
Kai

