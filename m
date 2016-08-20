Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35187 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbcHTPhT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 11:37:19 -0400
Received: by mail-oi0-f66.google.com with SMTP id e80so8375955oig.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Aug 2016 08:37:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
 <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 20 Aug 2016 09:37:17 -0600
Message-ID: <CAJCQCtR8rWJHePsBH_oG-V=pSLLztnZY35JyST88_ggasdNrxA@mail.gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
To: Chris Murphy <lists@colorremedies.com>
Cc: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 20, 2016 at 9:21 AM, Chris Murphy <lists@colorremedies.com> wrote:

>If you
> deleted this udev rule, you run the risk of some boots sometimes
> having a slightly delayed drive becoming available and the volume
> wrongly being mounted degraded when it's not necessary.

Yuck. Revision time!

If you were to delete this udev rule, it's possible to end up with an
unnecessary degraded mount, simply due to a drive spinning up slower
or otherwise having delayed readiness.

Add on: Silently always mounting degraded in order to anticipate
needing unattended degraded mounts will almost certainly lead to data
loss. Btrfs just isn't ready for this yet. It has no concept of device
faulty state still although patches for this are available for testing
(not merged). So yeah, buyer beware. If you don't care about uptime
and unattended operation, just self-healing during normal operation,
then it's OK but you have to remain vigilant, and aware of Btrfs
limitations, including it's lazy repair of formerly missing devices
that reappear. It only fixes passively on reads. To completely fix it,
you have to do a scrub, and you must do it before another drive goes
missing or you can lose the whole file system. Btrfs has no partial
resync like what's offered with mdadm arrays with a write-intent
bitmap.



-- 
Chris Murphy
