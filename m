Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46950 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaJFJbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 05:31:52 -0400
Message-ID: <5432617B.8050301@oracle.com>
Date: Mon, 06 Oct 2014 17:31:39 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, guihc.fnst@cn.fujitsu.com,
        sandeen@redhat.com
Subject: Re: [PATCH 1/5] btrfs-progs: scan /proc/partitions not all of /dev
 with "-d"
References: <1410571282-3482-1-git-send-email-anand.jain@oracle.com> <20140923170002.GX9715@twin.jikos.cz>
In-Reply-To: <20140923170002.GX9715@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  I am running some tests with larger disks pool (48 disks).
  With that the performance of the various scan methods are as below..

----
scanning BTRFS_SCAN_LBLKID
real    0m0.330s
user    0m0.005s
sys     0m0.026s

scanning BTRFS_SCAN_DEV
real    0m0.010s
user    0m0.002s
sys     0m0.005s

scanning BTRFS_SCAN_PROC
real    0m0.010s
user    0m0.002s
sys     0m0.005s
-----

  This is the time taken to scan 48disks one time by various methods
  we have/had - but our progs do this scan 30times for btrfs fi show.
  yep 30times as show below.. I am working to fix it.

-------
                                 Function: time(us)    count  avg(us)
::
                          get_device_info:     1034       27       38
                     pretty_size_snprintf:     1218      124        9
                    btrfs_scan_one_device:     1790      186        9
                     btrfs_read_dev_super:     1956      116       16
                                 cmd_show:    15418      335       46
                        btrfs_scan_lblkid:   148477       30     4949
-------

  IMO we should still stick to LBLKID scan.
  Just a thought - any idea if its better to provide a compile time
  fallback scan switch, just in case if something fails with lblkid. ?


Thanks, Anand


On 09/24/14 01:00, David Sterba wrote:
> Hi,
>
> all 5 patches will be in the next integration. I haven't tested them
> yet, seems it's a bit more important to make a more stable devel base
> for more updates you might want to send.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
