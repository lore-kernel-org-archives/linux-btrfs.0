Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21646 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbcCIJRU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 04:17:20 -0500
Subject: Re: [PATCH 1/2] fstests: btrfs/011 use replace_options
To: dsterba@suse.cz
References: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
 <20160224124208.GD23746@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <56DFEA15.6010103@oracle.com>
Date: Wed, 9 Mar 2016 17:17:09 +0800
MIME-Version: 1.0
In-Reply-To: <20160224124208.GD23746@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Sorry for the late reply. More below..

On 02/24/2016 08:42 PM, David Sterba wrote:
> On Fri, Feb 19, 2016 at 09:25:28PM +0800, Anand Jain wrote:
>> This patch fixes test btrfs/011 which intended to use -r option
>> but was never used since its associated args 'replace_options'
>> didn't make it to the cli.
>
> After this patch the tests fails due to extra output. I've tested
> several kernels (4.5 rcs), HDD and SSD so it's not caused by my testing
> setup.
>
> --- tests/btrfs/011.out 2013-08-29 11:58:37.000000000 +0200
> +++ /root/xfstests/results//btrfs/011.out.bad   2016-02-24 12:44:45.562234906 +0100
> @@ -1,3 +1,68 @@
>   QA output created by 011
>   *** test btrfs replace
> +bytenr mismatch, want=20987904, have=0
> +Couldn't read chunk root
> +bytenr mismatch, want=20987904, have=0
> +Couldn't read chunk root
::
> +bytenr mismatch, want=20987904, have=0
> +Couldn't read chunk root
>   *** done

Those are 'btrfs fi show' errors on defunct volumes created by
previous test case within btrfs/011 or outside.

An example of reproducing the above error is as below..
---------------------------------------
(a clean start)
# wipefs -a /dev/sd[c-i]
::

(mkfs with 4 devices)
# mkfs.btrfs -f -draid10 -mraid10 /dev/sdc /dev/sdd /dev/sde /dev/sdf
::

# btrfs fi show
Label: none uuid: 55e2335a-6439-43a9-8d42-cb14dd3bb4b5
Total devices 4 FS bytes used 112.00KiB
devid 1 size 4.00GiB used 827.12MiB path /dev/sdc
devid 2 size 4.00GiB used 827.12MiB path /dev/sdd
devid 3 size 4.00GiB used 827.12MiB path /dev/sde
devid 4 size 4.00GiB used 827.12MiB path /dev/sdf


(mkfs with only 3 devices)
# mkfs.btrfs -f /dev/sdc /dev/sdd /dev/sde
::


# btrfs fi show
warning, device 3 is missing
warning, device 2 is missing
warning, device 1 is missing
warning devid 1 not found already
warning devid 2 not found already
warning devid 3 not found already
bytenr mismatch, want=37847040, have=0 <----
Couldn't setup extent tree
bytenr mismatch, want=37863424, have=0
Couldn't setup device tree
Label: none uuid: d57df874-2603-493c-acfc-d200297c9082
Total devices 3 FS bytes used 112.00KiB
devid 1 size 4.00GiB used 1.40GiB path /dev/sdc
devid 2 size 4.00GiB used 417.56MiB path /dev/sdd
devid 3 size 4.00GiB used 1.41GiB path /dev/sde

Label: none uuid: 55e2335a-6439-43a9-8d42-cb14dd3bb4b5
Total devices 4 FS bytes used 112.00KiB
devid 4 size 4.00GiB used 827.12MiB path /dev/sdf
*** Some devices missing
--------------------------------------------

V2 fixes this by starting with a clean set of scratch pool
devices before each sub test case. So that 011.full is clean
as well.
I could reproduce this when I changed the number of scratch
pool devices from 5 to 4. And then the above errors in
011.full can be said to be irrelevant because of a device
which does not belong to scratch pool devices

But, strictly speaking we need to fix 'btrfs fi show' rather.
However I am not too sure why/how those warnings/errors
are useful.

Thanks, Anand
