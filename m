Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36842 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeAaKrc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 05:47:32 -0500
Received: by mail-lf0-f48.google.com with SMTP id t79so19991779lfe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:47:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <80358280-ce31-9049-61a8-c9a4b78f4b2b@oracle.com>
References: <20180130063020.14850-1-anand.jain@oracle.com> <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
 <80358280-ce31-9049-61a8-c9a4b78f4b2b@oracle.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Wed, 31 Jan 2018 11:47:29 +0100
Message-ID: <CAEtw4r1PM+zhmQHYXK8SfHczESg=NVsK9O2rd6FZ8-33_7at=A@mail.gmail.com>
Subject: Re: [PATCH 0/2] Policy to balance read across mirrored devices
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-31 10:01 GMT+01:00 Anand Jain <anand.jain@oracle.com>:
>  When a stripe is not present on the read optimized disk it will just
>  use the lower devid disk containing the stripe (instead of failing back
>  to the pid based random disk).

Is this a good behavior? beause this would eliminate every performance
benefit of the pid base random disk pick if the requested stripe is
not present on the read optimized disk.
Wouldn't it be better to specify a fallback and use the pid base
random pick as default for the fallback.

For example:

RAID 1 over 4 disk's

devid | rpm | size
------------------------
1 | 7200 rpm | 3 TB
2 | 7200 rpm | 3 TB
3 | 5400 rpm | 4 TB
4 | 5400 rpm | 4 TB

mount -o read_mirror_policy=1,read_mirror_policy=2

Cases:
1. if the requested stripe is on devid 3 and 4 the algorithm should
choise on of both randomly to incresse performance instead of read
everytime from 3 and never from 4
2. if the requested stripe is on devid 1 and 3, all is fine ( in case
of the queue deep of 1 isn't mutch larger then the queue deep of 3 )
3. if the requested stripe is on devid 1 and 2, the algorithm should
choise on of both randomly to incresse performance instead of read
everytime from 1 and never from 2

And all randomly picks of a device should be replaced by a heuristic
algorithm wo respect the queue deep and sequential reads in the
future.
