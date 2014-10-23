Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17401 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbaJWINl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 04:13:41 -0400
Message-ID: <5448B8A5.2010202@oracle.com>
Date: Thu, 23 Oct 2014 16:13:25 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: Petr Janecek <janecek@ucw.cz>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs release 3.17
References: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz> <54476F88.4040509@oracle.com> <20141023065709.GA11511@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20141023065709.GA11511@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Some of the disks on my system were missing and I was able to hit
this issue.


----------------
Check tree block failed, want=12582912, have=0
read block failed check_tree_block
Couldn't read chunk root
warning devid 2 not found already
Check tree block failed, want=143360, have=0
read block failed check_tree_block
Couldn't read chunk root
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
warning, device 1 is missing
----------------


Did a bisect and it leads to this following patch.

----------------
commit 915902c5002485fb13d27c4b699a73fb66cc0f09

     btrfs-progs: fix device missing of btrfs fi show with seed devices
----------------

  Also this patch stalls ~2sec in the cmd btrfs fi show, on my system
  with 48 disks.

Also a simple test case hits some warnings...

----------------
  mkfs.btrfs -draid1 -mraid1 /dev/sdb /dev/sdc
  mount /dev/sdb /btrfs && fillfs /btrfs 100 && umount /btrfs
  wipefs -a /dev/sdb
  modprobe -r btrfs && modprobe btrfs
  mount -o degraded /dev/sdb /btrfs
  btrfs fi show
Label: none  uuid: 9844cd05-1c8c-473e-a84b-bac95aab7bc9
         Total devices 2 FS bytes used 1.59MiB
         devid    2 size 967.87MiB used 104.75MiB path /dev/sdc
         *** Some devices missing

warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
----------------





On 10/23/14 14:57, Petr Janecek wrote:
> Hello,
>
>>   You have mentioned two issues when balance and fi show running
>>   concurrently
>
>    my mail was a bit chaotic, but I get the stalls even on idle system.
> Today I got
>
> parent transid verify failed on 1559973888000 wanted 1819 found 1821
> parent transid verify failed on 1559973888000 wanted 1819 found 1821
> parent transid verify failed on 1559973888000 wanted 1819 found 1821
> parent transid verify failed on 1559973888000 wanted 1819 found 1821
> Ignoring transid failure
> leaf parent key incorrect 1559973888000
>
> from 'btrfs fi sh' while I was just copying something, no balance running.
>
> [...]
>> [PATCH 1/1] btrfs-progs: code optimize cmd_scan_dev() use
>> btrfs_register_one_device()
>> [PATCH 1/2] btrfs-progs: introduce btrfs_register_all_device()
>> [PATCH 2/2] btrfs-progs: optimize btrfs_scan_lblkid() for multiple calls
>>
>> If you could, pls..
>>   Now on 3.17 apply above 3 patches and see if you see any better
>>   performance for the stalling issue.
>
>    no perceptible change: takes ~40 seconds both before and after
> applying. Old version <1 sec.
>
>>   can you do same steps on 3.16 and report what you observe
>
>    So many rejects -- do you have older versions of these patches?
>
>
> Thanks,
>
> Petr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
