Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbeAaJA1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 04:00:27 -0500
Subject: Re: [PATCH 0/2] Policy to balance read across mirrored devices
To: Peter Becker <floyd.net@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <80358280-ce31-9049-61a8-c9a4b78f4b2b@oracle.com>
Date: Wed, 31 Jan 2018 17:01:39 +0800
MIME-Version: 1.0
In-Reply-To: <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/31/2018 03:51 PM, Peter Becker wrote:

> A little question about mount -o read_mirror_policy=<devid>.
> 
> How would this work with RAID1 over 3 or 4 HDD's?
> In particular, if the desired block is not available on device <devid>.

  When a stripe is not present on the read optimized disk it will just
  use the lower devid disk containing the stripe (instead of failing back
  to the pid based random disk).

> Could i repeat this option like the device-option to specify a
> order/priority like this:
> 
> mount -o read_mirror_policy= 1,read_mirror_policy= 3

  Yes.

Thanks, Anand
