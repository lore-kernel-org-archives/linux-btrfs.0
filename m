Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47242 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaLQTro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 14:47:44 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so17371886wiw.4
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 11:47:43 -0800 (PST)
Message-ID: <5491DE39.3060204@gmail.com>
Date: Wed, 17 Dec 2014 20:49:13 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC][BTRFS-PROGS] Improve output of mkfs.btrfs command
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it> <548FA5B6.3020607@jp.fujitsu.com>
In-Reply-To: <548FA5B6.3020607@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2014 04:23 AM, Satoru Takeuchi wrote:
> Hi Goffredo,
[...]
> 
> It removes "Incompat" from original message. I consider
> "Backward Incompatible Feature" is better. I consider,
> the word, "incompatible", is very important for users.

Right, another good catch.
> 
> In addition, original version (without your patch) has
> the message turning on mixed-bg. However, the "Features"
> line of new version doesn't show mixed-bg. Is it a bug
> or am I missing something?

In my second example I didn't pass the -M switch. This is the reason
why mixed-bg is missing.

Below the new example (I update the code a bit)

# mkfs.btrfs -L btrfs-test -f -M -m raid5 -d raid5 /dev/vd[b-k]"
BTRFS filesystem summary:
  Label:		btrfs-test
  UUID:			d1581dc6-d07b-40d4-8d9e-0e0810e43839

  Node size:		4096
  Leaf size:		4096
  Sector size:		4096
  Initial chunks:
    Data+Metadata:	9.01GiB
    System:		18.06MiB
  Metadata profile:	RAID5
  Data profile:		RAID5
  Mixed mode:		YES
  SSD detected:		NO
  Incompat features:	mixed-bg, extref, raid56
  Number of devices:	10
    UUID                                  ID    SIZE    PATH
    ------------------------------------  --  --------- -----------
    816b6fe0-5672-429f-9a8e-e5be363abc7f   1   50.00GiB /dev/vdb
    86e54b61-7856-4ad8-bb03-39c018b6fbc0   2   50.00GiB /dev/vdc
    bca3a70d-32d0-40d1-8cdf-a77338c7dd09   3   50.00GiB /dev/vdd
    2838c80f-080c-4c75-a351-525243f8b710   4   50.00GiB /dev/vde
    b00e139d-f4d5-426e-8670-2f6b6cac4e8c   5   50.00GiB /dev/vdf
    95f3a828-fdfc-4f06-882d-eda6c91b0ad1   6   50.00GiB /dev/vdg
    5a0083d6-edf2-4d50-b60e-0e44773f1543   7   50.00GiB /dev/vdh
    d89b09dc-269c-40bc-9807-07c6ca5aa638   8    2.00GiB /dev/vdi
    ffc6a0f0-2659-41a8-b8ae-0ffe931c5eff   9    2.00GiB /dev/vdj
    5bd84fa0-7055-4090-89b7-a1fac849c11c  10    2.00GiB /dev/vdk

  Total devices size:                         356.01GiB



> 
> Thanks,
> Satoru
> 
>>    Number of devices:	10
>>      UUID                                  ID    SIZE    PATH
>>      ------------------------------------  --  --------- -----------
>>      62121322-5666-4ecf-bc8e-c9b3d9f60db9   1   50.00GiB /dev/vdb
>>      6158cb13-3ae8-42b6-8603-660f1e5c8a7a   2   50.00GiB /dev/vdc
>>      b49516db-ddf5-4f54-8831-a4babc79e901   3   50.00GiB /dev/vdd
>>      00b03d81-7d29-4894-8050-9dd205f97c41   4   50.00GiB /dev/vde
>>      f119a2ec-5ef0-436c-805e-c1b0612b05ca   5   50.00GiB /dev/vdf
>>      adee4f58-e094-4bd4-8c56-941527524f8d   6   50.00GiB /dev/vdg
>>      a8299171-2024-4057-ba56-1f83bf6d7e2e   7   50.00GiB /dev/vdh
>>      b694e275-e454-4dbd-beb0-e33c388cffa2   8    2.00GiB /dev/vdi
>>      7cbe04b5-36cd-4ea7-be82-206d5487914e   9    2.00GiB /dev/vdj
>>      7c320654-675e-456b-ac23-cfb148b8ea57  10    2.00GiB /dev/vdk
>>
>>    Total disks size:                           356.01GiB
>>
>>
>> Each information is in its own row. The disks are listed with more
>> information (disk uuid, id, size of each disk...)
>> Nodesize, Leafsize, Sectorsize are separated by the filesystem size.
>>
>> The metadata/data profile are displayed (before this information was missed).
>> Also the size of the data/metadata/system chunk are displayed.
>>
>> This is an RFC to collect suggestions.
>>
>>
>> These changes are also available via github
>> https://github.com/kreijack/btrfs-progs/commit/44fc80342b9c238f41b803cb0b9b4efe9b66d56f
>>
>>
>> BR
>> G.Baroncelli
>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
