Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A66C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 11:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25412206DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 11:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfCLLKE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:10:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfCLLKD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 07:10:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC340AD47;
        Tue, 12 Mar 2019 11:10:00 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: Check the first key and level for cached extent
 buffer
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312091040.3352-1-wqu@suse.com>
 <a89819cb-bade-3af1-6fbd-a56b40daad0e@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <d3dbe8a5-d561-b9a6-3e27-83c21a4392e1@suse.de>
Date:   Tue, 12 Mar 2019 19:09:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <a89819cb-bade-3af1-6fbd-a56b40daad0e@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/12 下午7:07, Nikolay Borisov wrote:
> 
> 
> On 12.03.19 г. 11:10 ч., Qu Wenruo wrote:
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
>> When reading above tree block, we have extent_buffer->refs = 2 in the
>> context:
>> - initial one from __alloc_extent_buffer()
>>   alloc_extent_buffer()
>>   |- __alloc_extent_buffer()
>>      |- atomic_set(&eb->refs, 1)
>>
>> - one being added to fs_info->buffer_radix
>>   alloc_extent_buffer()
>>   |- check_buffer_tree_ref()
>>      |- atomic_inc(&eb->refs)
>>
>> So even we call free_extent_buffer() in read_tree_block or other similar
>> situation, we only decrease the refs by 1, it doesn't reach 0 and won't
>> be freed right now.
>>
>> The staled eb and its corrupted content will still be kept cached.
>>
>> Further more, we have several extra cases where we either don't do
>> first key check or the check is not proper for all callers:
>> - scrub
>>   We just don't have first key in this context.
>>
>> - shared tree block
>>   One tree block can be shared by several snapshot/subvolume trees.
>>   In that case, the first key check for one subvolume doesn't apply to
>>   another.
>>
>> So for above reasons, a corrupted extent buffer can sneak into the
>> buffer cache.
>>
>> [FIX]
>> Export verify_level_key() as btrfs_verify_level_key() and call it in
>> read_block_for_search() to fill the hole.
>>
>> Due to above described reasons, even we can free corrupted extent buffer
>> from cache, we still need the check in read_block_for_search(), for
>> scrub and shared tree blocks.
>>
>> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202757
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202759
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202761
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202767
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202769
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>> - Commit message update to show the reason why stale ebs are kept in
>>   cache.
>> - Commit message update to show extra reasons why we still need the
>>   check, mainly for scrub and shared tree blocks.
>> ---
>>  fs/btrfs/ctree.c   | 10 ++++++++++
>>  fs/btrfs/disk-io.c | 10 +++++-----
>>  fs/btrfs/disk-io.h |  3 +++
>>  3 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 5a6c39b44c84..7672932aa5b4 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2401,6 +2401,16 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>>  	if (tmp) {
>>  		/* first we do an atomic uptodate check */
>>  		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
>> +			/*
>> +			 * Do extra check for first_key, eb can be stale due to
>> +			 * being cached, read from scrub, or have multiple
>> +			 * parents (shared tree blocks).
>> +			 */
>> +			if (btrfs_verify_level_key(fs_info, tmp,
>> +					parent_level - 1, &first_key, gen)) {
>> +				free_extent_buffer(tmp);
>> +				return -EUCLEAN;
>> +			}
> 
> What about verify_parent_transid? Shouldn't it also be checked here?

Previous btrfs_buffer_uptodate() call implies verify_parent_transid()
check, and that's why btrfs_buffer_uptodate() needs transid parameter.

Thanks,
Qu

> 
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
