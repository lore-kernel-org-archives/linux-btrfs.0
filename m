Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:57933 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LSHpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 02:45:16 -0500
Message-ID: <28252221.2330091355903104722.JavaMail.defaultUser@defaultHost>
Date: Wed, 19 Dec 2012 08:45:04 +0100 (CET)
From: "kreijack@inwind.it" <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
To: <jeff.liu@oracle.com>
Subject: R: Re: [RFC PATCH V6 2/2] Btrfs: Add a new ioctl to change the
 label of a mounted file system
Cc: Goffredo Baroncelli <kreijack@gmail.com>, <miaox@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

below my comments

>----Messaggio originale----
>Da: jeff.liu@oracle.com
>Data: 19/12/2012 4.42
>A: <kreijack@inwind.it>
>Cc: "Goffredo Baroncelli"<kreijack@gmail.com>, <miaox@cn.fujitsu.com>, <linux-
btrfs@vger.kernel.org>, <anand.jain@oracle.com>
>Ogg: Re: [RFC PATCH V6 2/2] Btrfs: Add a new ioctl to change the label of a 
mounted file system
>
>Hi Goffredo,
>
>Thanks for your review.
>
>On 12/19/2012 02:00 AM, Goffredo Baroncelli wrote:
>> Hi Jeff,
>> 
>> On 12/18/2012 04:31 AM, Miao Xie wrote:
>> [...]
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> [...]
[...]
>>>> +
>>>> +	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE)
>>>> +		return -EINVAL;
>>>> +
[....]
>>>> +
>>>> +	strcpy(super_block->label, label);
>> 
>> I think that you removed for mistake the following line
>> 
>> +	label[BTRFS_LABEL_SIZE - 1] = '\0';
>I removed it since it was used to cut the label string off the max array
>size but now we have the previous strnlen().
>> 
>> In the V5 patch it was present.
>> 
>> May be we could replace strcpy() with strlcpy(super_block->label, label,
>> BTRFS_LABEL_SIZE-1) ?
[...]
>
>But does the current implementation make anything wrong? :)

Sorry, you are right. The check of strnlen() is enough...

>
>Thanks,
>-Jeff
>> 
>> BR
>> G.Baroncelli
>> 
>
>


