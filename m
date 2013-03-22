Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60681 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab3CVM3e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 08:29:34 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MfCFw-1U46cA0b7K-00OmtC for
 <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 13:29:32 +0100
Message-ID: <514C4EAA.8010908@gmx.net>
Date: Fri, 22 Mar 2013 13:29:30 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, Koen De Wit <koen.de.wit@oracle.com>
Subject: Re: Adding a non-empty subvol to a qgroup
References: <514C33A2.9050709@oracle.com> <3E907C97-0CAE-4A08-8866-C36BF2388FEC@gmail.com>
In-Reply-To: <3E907C97-0CAE-4A08-8866-C36BF2388FEC@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22.03.2013 13:03, Wang Shilong wrote:
> Hello Arne,
> 
> Since "quota rescan" has not been implemented yet,
> 
> overflow can happen, so until now, we can have a check when
> doing accounting in the kernel, if the referenced/exclusive is not
> enough to delete, we just make it to be 0 and give a warning.
> 
> Otherwise, user may get a strange integer(because of type u64).
> How do you think ? or we just wait for the implement of rescan.

I think we already print it negatively. Please just leave it as
it is.

Thanks,
Arne

> 
> Thanks,
> Wang
> 
>> All,
>>
>> When adding a subvolume to a qgroup, pre-existing files in that subvolume are not counted in the referenced/exclusive space of the qgroup. Is this intended behavior ?
>>
>> I create a subvol with one file:
>>
>>  # mkfs.btrfs /dev/sdg
>>  # mount /dev/sdg /mnt/fulldisk
>>  # cd /mnt/fulldisk
>>  # btrfs quota enable ./
>>  # btrfs sub create sub1
>>  # dd if=/dev/zero of=sub1/file1 bs=100000 count=1
>>  # sync
>>  # btrfs qgroup show ./
>>  0/257 106496 106496
>>
>> Now I create a new qgroup on level 1 and add the qgroup of sub1 to it :
>>
>>  # btrfs qgroup create 1/0 ./
>>  # btrfs qgroup assign 0/257 1/0 ./
>>  # sync
>>  # btrfs fi sync ./
>>  # btrfs quota rescan ./
>>  # btrfs quota rescan ./sub1
>>  # btrfs qgroup show ./
>>  0/257 106496 106496
>>  1/0 0 0
>>
>> The pre-existing file does not contribute to the space numbers.
>>
>> Let's create a new file:
>>
>>  # dd if=/dev/zero of=sub1/file2 bs=50000 count=1
>>  # sync
>>  # btrfs qgroup show ./
>>  0/257 159744 159744
>>  1/0 53248 53248
>>
>> We see that only the new file is included in the space numbers.
>>
>> Now I remove the first file:
>>
>>  # rm -f sub1/file1
>>  # sync
>>  # btrfs qgroup show ./
>>  0/257 57344 57344
>>  1/0 -49152 -49152
>>
>> The space numbers go below zero. Even if the behavior above is intended, the removal of the pre-existing file should not result in negative space numbers.
>>
>> Koen.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

