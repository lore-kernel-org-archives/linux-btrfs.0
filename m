Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab3HNDLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 23:11:07 -0400
Message-ID: <520AF6B1.5020605@oracle.com>
Date: Wed, 14 Aug 2013 11:17:05 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 4/6] btrfs-progs: mkfs.c overwrites fd without appropriate
 close
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com> <1374773730-29957-5-git-send-email-anand.jain@oracle.com> <20130813191408.GI2150@localhost.localdomain> <520AE5A1.1010400@oracle.com>
In-Reply-To: <520AE5A1.1010400@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/14/2013 10:04 AM, Anand Jain wrote:
>
>
> On 08/14/2013 03:14 AM, Josef Bacik wrote:
>> On Fri, Jul 26, 2013 at 01:35:28AM +0800, Anand Jain wrote:
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   mkfs.c |    3 ++-
>>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/mkfs.c b/mkfs.c
>>> index 60f906c..66f558a 100644
>>> --- a/mkfs.c
>>> +++ b/mkfs.c
>>> @@ -1570,6 +1570,8 @@ int main(int ac, char **av)
>>>            * occur by the following processing.
>>>            * (btrfs_register_one_device() fails if O_EXCL is on)
>>>            */
>>> +        if (fd > 0)
>>> +            close(fd);
>>>           fd = open(file, O_RDWR);
>>>           if (fd < 0) {
>>>               fprintf(stderr, "unable to open %s: %s\n", file,
>>> @@ -1581,7 +1583,6 @@ int main(int ac, char **av)
>>>           if (ret) {
>>>               fprintf(stderr, "skipping duplicate device %s in FS\n",
>>>                   file);
>>> -            close(fd);
>>>               continue;
>>>           }
>>>           ret = btrfs_prepare_device(fd, file, zero_end,
>>> &dev_block_count,
>>
>> This breaks mkfs with multiple disks.
>
>   I can't believe as I have been playing with multiple disks
>   quite a lot recently. let me dig more.

  Sorry my mistake.

  Indeed further down btrfs_add_to_fsid() stores fd. closing a
  stored fd is not correct theoretically.

  Josef, Would be keen to know which xfstest caught this. ?

  I am sending a patch to back out this, to be applied on the
  current integration branch if it helps users for the time being.

Thanks, Anand
