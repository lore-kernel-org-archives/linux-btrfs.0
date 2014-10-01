Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36924 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaJALkN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Oct 2014 07:40:13 -0400
Message-ID: <542BE946.8020500@oracle.com>
Date: Wed, 01 Oct 2014 19:45:10 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: force overwrite should wipe stale SB
References: <1409932284-30895-1-git-send-email-anand.jain@oracle.com> <20141001112606.GO11436@twin.jikos.cz>
In-Reply-To: <20141001112606.GO11436@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/01/2014 07:26 PM, David Sterba wrote:
> On Fri, Sep 05, 2014 at 11:51:24PM +0800, Anand Jain wrote:
>> +static void wipe_existing_fs(int fd)
>> +{
> ...
>> +	blkid_probe_enable_partitions(pr, 1);
>> +
>> +	while (blkid_do_probe(pr) == 0)
>> +		blkid_do_wipe(pr, 0);
>
> Reported by a user on IRC, I verified it on one of my old test boxes.
> The function is missing in older versions of blkid and causes comilation
> errors:
>
>      [CC]     utils.o
> utils.c: In function ‘wipe_existing_fs’:
> utils.c:705:3: warning: implicit declaration of function ‘blkid_do_wipe
>
> utils.o: In function `wipe_existing_fs':
> /labs/dsterba/btrfs-progs/utils.c:705: undefined reference to `blkid_do_wipe'
> collect2: ld returned 1 exit status
 >
> blkid_do_wipe is from Novembe 2011, so nothing really new, but I'd still
> like to keep the backward compatibility of btrfs-progs.  The

> implementation of blkid_do_wipe uses some internal data so it's not
> possible to simply copy the implementation. Maybe wiping the first
> megabyte is enough.

  for the sake of backward compatible.. the only choice I see as of now
  yes to write our own wipe. will send one.

Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
