Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46684 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731405AbeG0Bbz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 21:31:55 -0400
Subject: Re: Lockdep splat with v4.18.6
To: Ross Zwisler <zwisler@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
References: <CAOxpaSXsmo+HUCs7Gmyb3EbuqzZhxdZ6_NGvCm7MSyZfa91MCg@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2ca50550-a35b-59bf-2f65-5fbef23d926f@oracle.com>
Date: Fri, 27 Jul 2018 08:15:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAOxpaSXsmo+HUCs7Gmyb3EbuqzZhxdZ6_NGvCm7MSyZfa91MCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Ross,

  Thanks for the report. I have analyzed it here [1] earlier and is
  harmless since lockdep checks doesn't seem to account for the
  difference in the lock time-space, there is similar fix in block
  layer as well (which I am unable to pull the ref as of now, but
  will try again). And this happened after we have added [2]
  [1]
   https://www.spinics.net/lists/linux-btrfs/msg79708.html
  [2]
   542c5908abfe84f7
   btrfs: replace uuid_mutex by device_list_mutex in btrfs_open_devices

  I am consolidating the locks in parts, will be fixed.

Thanks, Anand


On 07/27/2018 06:09 AM, Ross Zwisler wrote:
> I was testing my new xfstest posted here:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2018-July/016850.html
> 
> against a btrfs test device + scrach device setup, and hit a lockdep
> splat.  I'm using vanilla v4.18.6.
> 
> I've attached the splats to this mail, one just as it happened in
> dmesg and one passed through kasan_symbolize.py for files, line
> numbers, etc.
> 
> Thanks,
> - Ross
> 
