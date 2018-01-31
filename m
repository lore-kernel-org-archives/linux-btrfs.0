Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45246 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbeAaOZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 09:25:25 -0500
Subject: Re: [PATCH 0/2] Policy to balance read across mirrored devices
To: Peter Becker <floyd.net@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
 <80358280-ce31-9049-61a8-c9a4b78f4b2b@oracle.com>
 <CAEtw4r1PM+zhmQHYXK8SfHczESg=NVsK9O2rd6FZ8-33_7at=A@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cd9f0109-8c7c-3c98-53d8-100f06dcd46f@oracle.com>
Date: Wed, 31 Jan 2018 22:26:33 +0800
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1PM+zhmQHYXK8SfHczESg=NVsK9O2rd6FZ8-33_7at=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/31/2018 06:47 PM, Peter Becker wrote:
> 2018-01-31 10:01 GMT+01:00 Anand Jain <anand.jain@oracle.com>:
>>   When a stripe is not present on the read optimized disk it will just
>>   use the lower devid disk containing the stripe (instead of failing back
>>   to the pid based random disk).
> 
> Is this a good behavior? beause this would eliminate every performance
> benefit of the pid base random disk pick if the requested stripe is
> not present on the read optimized disk.
> Wouldn't it be better to specify a fallback and use the pid base
> random pick as default for the fallback.
> 
> For example:
> 
> RAID 1 over 4 disk's
> 
> devid | rpm | size
> ------------------------
> 1 | 7200 rpm | 3 TB
> 2 | 7200 rpm | 3 TB
> 3 | 5400 rpm | 4 TB
> 4 | 5400 rpm | 4 TB
> 
> mount -o read_mirror_policy=1,read_mirror_policy=2
> 
> Cases:
> 1. if the requested stripe is on devid 3 and 4 the algorithm should
> choise on of both randomly to incresse performance instead of read
> everytime from 3 and never from 4
> 2. if the requested stripe is on devid 1 and 3, all is fine ( in case
> of the queue deep of 1 isn't mutch larger then the queue deep of 3 )
> 3. if the requested stripe is on devid 1 and 2, the algorithm should
> choise on of both randomly to incresse performance instead of read
> everytime from 1 and never from 2
 >
> And all randomly picks of a device should be replaced by a heuristic
> algorithm wo respect the queue deep and sequential reads in the
> future.

  This scenario is very well handled by the pid/heuristic based
  read load balancer, pid based read load balancer is by default still,
  Tim has written IO load based read balancer which can be set using
  this mount option when all integrated together, and it needs
  experiments to see if it can be by default replacing the pid method.
  Further as of now we don't do allocation grouping, so if you have two
  ssd and two hd in a RAID1 its not guaranteed that allocation will
  always span across a SSD and a HD, so there is bit of randomness
  in the allocation itself.

Thanks, Anand
