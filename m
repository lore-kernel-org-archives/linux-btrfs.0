Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38592 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3HMEH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 00:07:59 -0400
Message-ID: <5209B107.7040506@oracle.com>
Date: Tue, 13 Aug 2013 12:07:35 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/11] btrfs-progs: scan /dev/mapper in filesystem show
 and device scan
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1373866257-10519-1-git-send-email-anand.jain@oracle.com> <1373866257-10519-7-git-send-email-anand.jain@oracle.com> <20130805170419.GE5284@twin.jikos.cz>
In-Reply-To: <20130805170419.GE5284@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/08/2013 01:04, David Sterba wrote:
> On Mon, Jul 15, 2013 at 01:30:52PM +0800, Anand Jain wrote:
>> This patch adds --mapper option to btrfs device scan and
>> btrfs filesystem show cli, when used will look for btrfs
>> devs under /dev/mapper and will use the links provided
>> under the /dev/mapper.
>
>> In the long run I want the usage of /dev/mapper path
>> (along with /proc/partitions) be the default option to
>> scan for the btrfs devs. (/proc/partitions must be scanned
>> as well because to include the mapper blacklisted devs.)
>
> Well, we want to avoid using own scanning and always consult the blkid
> cache, so I'd rather stop adding user-visible changes to this command.




  here is a test prog "t" (attached inline below) using blkid.
  t picks up both non multipath path and mapper path as below.
----
# ./t
Device: /dev/sdb        b03095dc-8eb5-40c9-8790-da6977110799
Device: /dev/sdc        abc347f2-dfcc-46bf-a4ac-e21fba7ff1a3
Device: /dev/mapper/mpatha      b03095dc-8eb5-40c9-8790-da6977110799
Device: /dev/mapper/mpathb      abc347f2-dfcc-46bf-a4ac-e21fba7ff1a3
Found 4
------

  However when

  /etc/multipath.conf
  defaults {
         user_friendly_names no
  }

  then the mapper paths are not friendly enough to use
-------
# ./t
Device: /dev/sdb        b03095dc-8eb5-40c9-8790-da6977110799
Device: /dev/sdc        abc347f2-dfcc-46bf-a4ac-e21fba7ff1a3
Device: /dev/mapper/1ATA     VBOX HARDDISK VB96b6139c-83f38bf1 
b03095dc-8eb5-40c9-8790-da6977110799
Device: /dev/mapper/1ATA     VBOX HARDDISK VBc6ab3781-f63da170 
abc347f2-dfcc-46bf-a4ac-e21fba7ff1a3
Found 4
------

  in this case the /dev/dm-<n> would have been better to use.
  and our own scan does the better job here.. as it
  reads /proc/partition and gives priority to dm-<n> paths
------
btrfs fi show
Label: none  uuid: abc347f2-dfcc-46bf-a4ac-e21fba7ff1a3
         Total devices 1 FS bytes used 28.00KiB
         devid    1 size 2.00GiB used 240.75MiB path /dev/dm-1

Label: none  uuid: b03095dc-8eb5-40c9-8790-da6977110799
         Total devices 1 FS bytes used 28.00KiB
         devid    1 size 1.98GiB used 238.25MiB path /dev/dm-0
-------

  so as of now having our scan is better than blkid.

  Now for the users who want to use the user friendly name
  provided by mapper. the newly introduced option --mapper
  which just looks under /dev/mapper will help.

Thanks, Anand


----------------t.c--------------
#include <stdio.h>
#include <blkid/blkid.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>

main()
{
         char *type;
         char str[100];
         int total = 0;
         blkid_dev_iterate iter = NULL;
         blkid_dev dev = NULL;
         blkid_cache cache = NULL;

         memset(str, '0', 100);
         if (blkid_get_cache(&cache, 0) < 0)
                 return -1;

         blkid_probe_all(cache);
         iter = blkid_dev_iterate_begin(cache);
         //blkid_dev_set_search(iter, NULL, NULL);
         blkid_dev_set_search(iter, "TYPE", "btrfs");

         while (blkid_dev_next(iter, &dev) == 0) {
                 dev = blkid_verify(cache, dev);
                 if (!dev)
                         continue;
                 else {
                         total++;
                         printf("Device: %s\t%s\n",
                 blkid_dev_devname(dev),
                                 blkid_get_tag_value(cache,"UUID",
                                 blkid_dev_devname(dev)));
                 }
         }
         blkid_dev_iterate_end(iter);
         printf("Found %d\n", total);
         return total;
}

