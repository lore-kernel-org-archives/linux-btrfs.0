Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37093 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBGJ67 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 04:58:59 -0500
Message-ID: <52F4B0B8.2080804@oracle.com>
Date: Fri, 07 Feb 2014 18:08:56 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Goffredo Baroncelli <kreijack@libero.it>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com> <1390812770-11720-2-git-send-email-anand.jain@oracle.com> <20140127084709.GK3314@carfax.org.uk> <20140206194935.GT1364@twin.jikos.cz> <52F3EC15.1000508@libero.it> <20140206220535.GV1364@suse.cz>
In-Reply-To: <20140206220535.GV1364@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks for the comments.

  mainly here sysfs way defeats the purpose - debug as
  mentioned. Sysfs would/should show only mounted disks,
  the ioctl way doesn't have such a limitation (of course
  as I commented memory dump way would have been best choice
  but I got stuck with that approach if anybody wants to give
  a try with that approach you are most welcome).

  IMO no harm to have both sysfs way and ioctl way let user
  or developer use which were is suitable in their context.

Thanks, Anand


On 02/07/2014 06:05 AM, David Sterba wrote:
> On Thu, Feb 06, 2014 at 09:09:57PM +0100, Goffredo Baroncelli wrote:
>>> With 3.14 the sysfs interface is available, but the devices under
>>>   /sys/fs/btrfs/<fs-uuid>/devices/...
>>> are symlinks to the sysfs devices, so this btrfs-specific device
>>> information has to be located in a separate directory.
>>
>> yes please; it would scale better than the ioctl()s; anyway I suggest 1
>> file per property, and not "...one file that holds all the stats
>>   about the device"
>
> Well, we can do both, I don't have a preference and both make sense.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
