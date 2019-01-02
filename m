Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD99C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 10:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B57752171F
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 10:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfABKIm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 05:08:42 -0500
Received: from mout.gmx.net ([212.227.15.15]:39161 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfABKIm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 05:08:42 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MAPoQ-1gUDJj1Nms-00BZVv; Wed, 02
 Jan 2019 11:08:34 +0100
Subject: Re: [PATCH] btrfs-progs: Update backup roots when writing super
 blocks
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181225052845.26322-1-wqu@suse.com>
 <d50be952-a062-5a44-c8f8-48b4077bb441@suse.com>
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
Message-ID: <e05d3d59-a6ad-b349-7025-5240b782c846@gmx.com>
Date:   Wed, 2 Jan 2019 18:08:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <d50be952-a062-5a44-c8f8-48b4077bb441@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:OYtGUVbTBLIBoROJVXDSJAGt9mNqHZ1cw/3WFmAZheiOpENAjpX
 cJ3Pymg+u5bfd5FMxj0Hkna+xeXfuO7a1ZB9OaE6KaU407AR13qV7zfxzF+hXwmQAOuKAuB
 xvRkEPQbZ8MdZksKn3LKt6VTiKcnhcRRe5quhomWQ4VI/hmgcZCvjcZPGLeIX4Fzw7LQyCD
 qroGOvOll5GrW3Y7LANWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ll25QrzTbrA=:qaCKk4u/s4vxFjRX3nDmRI
 cxl7tAZNtGlHefQ/F8LwFbw9JFs3/lYNcXZj9NACFMI5L8MIJReNH+nNTVhW/SeqSggYrwC92
 JfZ41L0GZM1W4RApv0dVTzmHt2LHFTBmSUC7ZdefnngD0BXVlzJXw9FDWkS5z8Vg1M/2JAPaO
 SE1Buox3BITOVoAfRamdmXV/dvBwSpF1RBaNq4UCZXahyaVNa954Ot/JiSq4Hlco9ZCfP/ds7
 jey1y5Bs48GSgwBEDYmmuADFj9RrKytMMqv4M44FhrDAzHfC41JUECAPdBRqLBJysnaL0pVki
 GoqsA3c5f1+lu5yZPrnLKb1/v+cigfE/ty94cj34b/+RfMnUPFulPJiCIkK+mCVB1E/hhOnLp
 CP41FqHdrmdfNBEhr6h2e6h0nX/hPVXhQYoPMnXDrzgmx4VudOb35emTikl56yt2P1maiwij7
 Ortq86rXKAvowmyuIeFKerFxxMz7COQhkbc6y0eeDRK7SBss6xVqBQc530FX18E4XCvneq8E7
 0JGUbNlNJOw9I/YTqHvZj3yVxWh+HluBZ9UIQHAfyaD/C82oAtecZfwywGjMqtOnHFObn0d2L
 nilRC+GngagS98LAmE3Y0f3VwLYYyxMYKyKIyKw8IuVWuRd2JVQxSC2nHfRjew50Q9h9BdtxM
 B4e5vKz1J3DNMzuxEMSfQo2hoUX8r7EHHV+Wf6K8+ahDnQ/55hgjDDOtogtESiw0OPcQk2xMM
 LCUbw3BSYM8EYZ7Xh29BNcWfRJKyTnseldhWI4mVZNAUgoky/gQUACJ2egmmLBA5lDKGbo0Zy
 BBVX59e3ODQ3Kv+p54CvBAVRj/cHnTAkLvn2VG/hzi3rP2ElRRt9hW04iAaKtyaFVOnPwYA3+
 wReGYR5oCZhlCmJaWuqIW9ltjMKGuS5/1N8cxRSsU8dpzVKMKXgtO1smLHykjlUmRr8cAmvQ6
 6XvusIVHHWg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/2 下午4:57, Nikolay Borisov wrote:
> 
> 
> On 25.12.18 г. 7:28 ч., Qu Wenruo wrote:
>> The code is mostly ported from kernel with minimal change.
>>
>> Since btrfs-progs doesn't support replaying log, there is some code
>> unnecessary for btrfs-progs, but to keep the code the same, that
>> unnecessary code is kept as it.
>>
>> Now "btrfs check --repair" will update backup roots correctly.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  disk-io.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 78 insertions(+)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index 133835a4d063..f28a6b526391 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1621,6 +1621,83 @@ write_err:
>>  	return ret;
>>  }
>>  
>> +/*
>> + * copy all the root pointers into the super backup array.
>> + * this will bump the backup pointer by one when it is
>> + * done
>> + */
>> +static void backup_super_roots(struct btrfs_fs_info *info)
>> +{
>> +	struct btrfs_root_backup *root_backup;
>> +	int next_backup;
>> +	int last_backup;
>> +
>> +	last_backup = find_best_backup_root(info->super_copy);
> 
> Slightly offtopic: but find_best_backup_root only partially resembles
> it's kernel counterpart - find_newest_super_backup. And it's missing the
> code for handling wraparound. So in kernel space if the newest root is
> at index 3 and index 0 backup also has the same gen then we switch the
> index to 0, why is this needed?

I'm not sure either.

IIRC kernel shouldn't create two backup roots with the same gen.

> In any case I think
> 'find_best_backup_root' in progs should be renamed to
> 'find_newest_super_backup' and copied from kernel space.
> 
>> +	next_backup = (last_backup + 1) % BTRFS_NUM_BACKUP_ROOTS;
> 
> This logic is different than the kernel one which does:
> last_backup = (next_backup + BTRFS_NUM_BACKUP_ROOTS - 1) %
>                 BTRFS_NUM_BACKUP_ROOTS;
> 
> So in the kernel when info->backup_root_index == 0 then the newest
> backup root is going to be written at position 3, the next one in pos 1,
> the next in pos 2 and so on. OTOH in userspace we might potentially
> start writing at 1 (which doesn't seem problematic per se). So why the
> difference in logic?

The logic is the same, for kernel it's 'last_backup' which should, and
is, going backward one slot.

And the next one is still written to next slot.

Just as the dump super shows:
$ btrfs ins dump-super -f /dev/data/btrfs | grep -A1 "backup "
	backup 0:
		backup_tree_root:	30818304	gen: 10	level: 0
--
	backup 1:
		backup_tree_root:	30621696	gen: 7	level: 0
--
	backup 2:
		backup_tree_root:	30703616	gen: 8	level: 0
--
	backup 3:
		backup_tree_root:	30785536	gen: 9	level: 0

So the logic should be the same.

Just simpler implementation in btrfs-progs, without
fs_info->backup_root_index.

Thanks,
Qu

> 
>> +
>> +	/* just overwrite the last backup if we're at the same generation */
>> +	root_backup = info->super_copy->super_roots + last_backup;
>> +	if (btrfs_backup_tree_root_gen(root_backup) ==
>> +	    btrfs_header_generation(info->tree_root->node))
>> +		next_backup = last_backup;
>> +
>> +	root_backup = info->super_copy->super_roots + next_backup;
>> +
>> +	/*
>> +	 * make sure all of our padding and empty slots get zero filled
>> +	 * regardless of which ones we use today
>> +	 */
>> +	memset(root_backup, 0, sizeof(*root_backup));
>> +	btrfs_set_backup_tree_root(root_backup, info->tree_root->node->start);
>> +	btrfs_set_backup_tree_root_gen(root_backup,
>> +			       btrfs_header_generation(info->tree_root->node));
>> +	btrfs_set_backup_tree_root_level(root_backup,
>> +			       btrfs_header_level(info->tree_root->node));
>> +
>> +	btrfs_set_backup_chunk_root(root_backup, info->chunk_root->node->start);
>> +	btrfs_set_backup_chunk_root_gen(root_backup,
>> +			       btrfs_header_generation(info->chunk_root->node));
>> +	btrfs_set_backup_chunk_root_level(root_backup,
>> +			       btrfs_header_level(info->chunk_root->node));
>> +
>> +	btrfs_set_backup_extent_root(root_backup, info->extent_root->node->start);
>> +	btrfs_set_backup_extent_root_gen(root_backup,
>> +			       btrfs_header_generation(info->extent_root->node));
>> +	btrfs_set_backup_extent_root_level(root_backup,
>> +			       btrfs_header_level(info->extent_root->node));
>> +	/*
>> +	 * we might commit during log recovery, which happens before we set
>> +	 * the fs_root.  Make sure it is valid before we fill it in.
>> +	 */
>> +	if (info->fs_root && info->fs_root->node) {
>> +		btrfs_set_backup_fs_root(root_backup,
>> +					 info->fs_root->node->start);
>> +		btrfs_set_backup_fs_root_gen(root_backup,
>> +			       btrfs_header_generation(info->fs_root->node));
>> +		btrfs_set_backup_fs_root_level(root_backup,
>> +			       btrfs_header_level(info->fs_root->node));
>> +	}
>> +
>> +	btrfs_set_backup_dev_root(root_backup, info->dev_root->node->start);
>> +	btrfs_set_backup_dev_root_gen(root_backup,
>> +			       btrfs_header_generation(info->dev_root->node));
>> +	btrfs_set_backup_dev_root_level(root_backup,
>> +				       btrfs_header_level(info->dev_root->node));
>> +
>> +	btrfs_set_backup_csum_root(root_backup, info->csum_root->node->start);
>> +	btrfs_set_backup_csum_root_gen(root_backup,
>> +			       btrfs_header_generation(info->csum_root->node));
>> +	btrfs_set_backup_csum_root_level(root_backup,
>> +			       btrfs_header_level(info->csum_root->node));
>> +
>> +	btrfs_set_backup_total_bytes(root_backup,
>> +			     btrfs_super_total_bytes(info->super_copy));
>> +	btrfs_set_backup_bytes_used(root_backup,
>> +			     btrfs_super_bytes_used(info->super_copy));
>> +	btrfs_set_backup_num_devices(root_backup,
>> +			     btrfs_super_num_devices(info->super_copy));
>> +};
>> +
>>  int write_all_supers(struct btrfs_fs_info *fs_info)
>>  {
>>  	struct list_head *head = &fs_info->fs_devices->devices;
>> @@ -1630,6 +1707,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
>>  	int ret;
>>  	u64 flags;
>>  
>> +	backup_super_roots(fs_info);
>>  	sb = fs_info->super_copy;
>>  	dev_item = &sb->dev_item;
>>  	list_for_each_entry(dev, head, dev_list) {
>>
