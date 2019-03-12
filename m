Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E284C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C026214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfCLIkZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:40:25 -0400
Received: from mout.gmx.net ([212.227.15.15]:37325 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbfCLIkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 04:40:25 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MY7ZA-1hYL2A0gaG-00UuqO; Tue, 12
 Mar 2019 09:34:51 +0100
Subject: Re: [PATCH] btrfs: Check the first key and level for cached extent
 buffer
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312074558.32393-1-wqu@suse.com>
 <f7d7989b-cb5c-3148-f9be-874abfe1c1c8@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <d35b0f01-b8da-4b1c-f762-b5af32664d4c@gmx.com>
Date:   Tue, 12 Mar 2019 16:34:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <f7d7989b-cb5c-3148-f9be-874abfe1c1c8@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:9+9FPOU2WNV4cDR834HuRO1SJsnKetc4juwmf8BHPqokZygVCWF
 C6BABGrZiG1f04VcooL2gcsF96AcSTk6lDqkFXf8sJq7naKd5+OMrNJn/jiySK6i+MMQb4Q
 fbBVgbQF3leiAPh7ggJ/nSVs8bgiWQ2ncm5VhShgn/GfrOd48v6mMKAhWqy1vm+QtD8J+OI
 NsA9iiGQD1SzkGT6kLoaw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jPAUZdmWnP8=:zBQeJ7yuPFrFL/Jo0aqtah
 S76D8LgKeqo1Sd0rhH8zZFHPfoF6hKeZ4Xd1LTGXdjH+KfrXP9MQdaShAxbGhTSw1sscmGb+4
 rHZojehaZ9q/In97Awxmq9NMwHTT8EDBnJYKZRQ9hAZoIoHi34LgZWiAHwOHujMs8f6iwVbxA
 rd4TX7lWqfE/aLe/js+hUCeLAP55gfUFk2LC3zWx28FBL1DY2hacpFOP5r/0E6FgAqJw7Zz7M
 gCRO/po0AyT7WF9VzXmBUanf3uhdSJVUIeigBQCmsJ1EC6/URW5EIWvbrCNP25hKpWxh8bAe9
 SlQAhX/SxkUqpZmNq7GaqQmK1/P8AHveKX/dbwdmFUZ95pZeKAyQm33Y5AWmoXOEhPBNSGKQP
 zQYIAqbjxHIHAjizWTwHGRiDgqGr7SKn4YD1YyBaNxb+EqZRmKVzLPLYaYe0fzJV2jMSmme/9
 ZdKeVDE/gJefGlDzSdAitXHzQ1VfElM3Ro9Ax/HWFm3VSovr61BF3rIq6vUuMq6DkvqplGdG1
 gjbRThxduBN9Xa3+jPp6FWldJFu5wqKqGBDfCuHZD/KCAAxacyeCfYF+tFT5PkLLj1xcpnHY/
 rx4cULSWO/ky96juj0NQGUpy94go84Py4KlV172Gp+slXkR/Qc+xDuisCC3eBiXCd79si5qbR
 bR1gadDI6b0eZvSSMalMxZfZAnHM7bqUCkjBRDFDIoLYcV7Sq6KXzFenwCufOeXSIhYGmqZ1g
 fTWNuGAQlGUhvlOxqSwRxdpv1w3ogWOb3mssNINypI6GYe53th+sg8yPpqBDIguoh0G4obz+H
 31qObnu2TBgPwG33xhhtJT5DVWRAntpp/A09bQ0JrJovMHkQE3VLXxHS0KrSUZNrW4W4hPgba
 R+AKfgqiT7rUR5Lo2kVeKhSITzeeIXI+nv1GVwplKNR88Wop0WU+f3Xw6sbDASM93DCSFvE9C
 wW0IpPY/oYg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/12 下午4:28, Nikolay Borisov wrote:
> 
> 
> On 12.03.19 г. 9:45 ч., Qu Wenruo wrote:
>> [BUG]
>> When reading a file from a fuzzed image, kernel can panic like:
>>   BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
>>   assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
>>   ------------[ cut here ]------------
>>   kernel BUG at fs/btrfs/ctree.h:3500!
>>   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>>   RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
>>   Call Trace:
>>    btrfs_lookup_csum+0x52/0x150 [btrfs]
>>    __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
>>    btrfs_submit_bio_hook+0x103/0x170 [btrfs]
>>    submit_one_bio+0x59/0x80 [btrfs]
>>    extent_read_full_page+0x58/0x80 [btrfs]
>>    generic_file_read_iter+0x2f6/0x9d0
>>    __vfs_read+0x14d/0x1a0
>>    vfs_read+0x8d/0x140
>>    ksys_read+0x52/0xc0
>>    do_syscall_64+0x60/0x210
>>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> [CAUSE]
>> The fuzzed image has a corrupted leaf whose first key doesn't match with its parent:
>>   checksum tree key (CSUM_TREE ROOT_ITEM 0)
>>   node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
>>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>>   	...
>>           key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19
>>
>>   leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
>>   leaf 29761536 flags 0x1(WRITTEN) backref revision 1
>>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>>           item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
>>                   range start 8798638964736 end 8798641262592 length 2297856
>>
>> For the first time tree read, it will not pass verify_level_key() check.
>> But the extent buffer will still be cached.
>>
>> Also there is a pitfall in read_block_for_search(), where a cached
>> extent buffer will not be checked for its level and first key.
>>
>> There are context where we read tree block without verifying its
>> first key, such as scrub.
>>
>> So in that case, a corrupted leaf can sneak in and screw up the kernel.
>>
>> [FIX]
>> Export verify_level_key() as btrfs_verify_level_key() and call it in
>> read_block_for_search() to fill the hole.
>>
>> Please note, this will cause a lot of extra error message if we have a
>> bad tree block in any hot tree, but it's still much better to trigger
>> the final safe net in key_search_validate().
>>
>> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202757
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202759
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202761
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202767
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202769
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Additionally which of those 6 issues contain the image which triggers
> this problem or all of them ?

The first contains the image which triggers the exact bug described in
[BUG] section.

The remaining images triggers the same first_key-mismatch-but-cached
problem, and can be rejected by this patch.

Thanks,
Qu

> 
>> ---
>> There is one remaining report where I can't get any kernel message
>> before the VM completely lost reponse.
>> https://bugzilla.kernel.org/show_bug.cgi?id=202763
>> (out-of-bound access in end_bio_extent_readpage() when mounting and operating a crafted btrfs image)
>>
>> And the above case can't be fixed by this patch. Still trying to get a
>> good idea of what's going wrong (AKA good kernel message).
>>
>> There is also another report, which doesn't provide the fuzzed image.
>> https://bugzilla.kernel.org/show_bug.cgi?id=202765
>> (NULL pointer dereference when mounting a crafted btrfs image)
>> ---
>>  fs/btrfs/ctree.c   | 10 ++++++++++
>>  fs/btrfs/disk-io.c | 10 +++++-----
>>  fs/btrfs/disk-io.h |  3 +++
>>  3 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 5a6c39b44c84..37447a7c5b4d 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2401,6 +2401,16 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>>  	if (tmp) {
>>  		/* first we do an atomic uptodate check */
>>  		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
>> +			/*
>> +			 * Do extra check for first_key, as it's possible the
>> +			 * eb is read from the context without first_key
>> +			 * requirement
>> +			 */
>> +			if (btrfs_verify_level_key(fs_info, tmp,
>> +					parent_level - 1, &first_key, gen)) {
>> +				free_extent_buffer(tmp);
>> +				return -EUCLEAN;
>> +			}
>>  			*eb_ret = tmp;
>>  			return 0;
>>  		}
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 298b34721bc0..e2a0cb362d28 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -423,9 +423,9 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>>  	return ret;
>>  }
>>  
>> -static int verify_level_key(struct btrfs_fs_info *fs_info,
>> -			    struct extent_buffer *eb, int level,
>> -			    struct btrfs_key *first_key, u64 parent_transid)
>> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
>> +			   struct extent_buffer *eb, int level,
>> +			   struct btrfs_key *first_key, u64 parent_transid)
>>  {
>>  	int found_level;
>>  	struct btrfs_key found_key;
>> @@ -500,8 +500,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>>  			if (verify_parent_transid(io_tree, eb,
>>  						   parent_transid, 0))
>>  				ret = -EIO;
>> -			else if (verify_level_key(fs_info, eb, level,
>> -						  first_key, parent_transid))
>> +			else if (btrfs_verify_level_key(fs_info, eb, level,
>> +						first_key, parent_transid))
>>  				ret = -EUCLEAN;
>>  			else
>>  				break;
>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>> index 987a64bc0c66..67a9fe2d29c7 100644
>> --- a/fs/btrfs/disk-io.h
>> +++ b/fs/btrfs/disk-io.h
>> @@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mirror)
>>  struct btrfs_device;
>>  struct btrfs_fs_devices;
>>  
>> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
>> +			   struct extent_buffer *eb, int level,
>> +			   struct btrfs_key *first_key, u64 parent_transid);
>>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
>>  				      u64 parent_transid, int level,
>>  				      struct btrfs_key *first_key);
>>
