Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219A2C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 05:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE7C12075B
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 05:21:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE7C12075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbeJLMvt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 08:51:49 -0400
Received: from mout.gmx.net ([212.227.17.20]:50643 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbeJLMvs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 08:51:48 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldspr-1flMYJ3HhD-00izRc; Fri, 12
 Oct 2018 07:21:01 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldspr-1flMYJ3HhD-00izRc; Fri, 12
 Oct 2018 07:21:01 +0200
Subject: Re: [PATCH v3 1/6] btrfs-progs: image: Use correct device size when
 restoring
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-2-wqu@suse.com>
 <1620cc91-8bec-4b29-adef-10f3f2c6531d@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <f4c9b097-fabd-3a6b-fa1a-da10b169850a@gmx.com>
Date:   Fri, 12 Oct 2018 13:20:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1620cc91-8bec-4b29-adef-10f3f2c6531d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:itKyEk9pS3nqYMFvyvTzL5IHvCYyy3kIBRIl7D0xZDNsqUlzMV3
 p7gk0KXqxhJfyFNGk7OEf5WabBhkmkFlv6+Sr5I9/Ux2pQTmakx48fZZy6y9BqPM8AqgJdb
 DapTJ9hw857qkC6DD5HXQxyaIFaUNP3z1SOoVU7WJHKkscVK4vdvM7f1oxAaW2pnrfL/toc
 7W23cPpURewXcF3DjzIwA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:E9UsoRy2kGc=:P3av7VAPtzVyTw0RuH9WGE
 go89JnA7pnEAH6G8s/gg/JQFTFqsCNg3EPTg7T8qDbdWOEKh94l89+7GwpsExDSV8rQ0Ismw0
 2TIiGWv6bP8P+ls/9dlwR/57X7FOV9bMqNbMapUwHO/uFLiLKwGEs+Zsiga4Kqc5VSjTRKcQ7
 6iAkOuC0ZqFPlQ6Zm+nWaKyAm+8uANTZsb241G2oz6v4v/e8jOqrB0Pr+m23XMlGEh2qey0wa
 po6R+6MwBqy1adp+s3NuOPs0VjANlqGg89Op499xPw7+C9IgOEuNa3iJdZp/6ADlc8rEctxZ5
 UbGD292eHAzOoMboEJ9OHiUCUqhjjbQ53Fw/YfxThQI2qDItkU7/soST2hnU1lDNN+JNmRt0z
 ZJQwnQ7rbCxDeVWvS3nMmKsNdRR3m+w4n2qo4rAJi66dt7BWrZAkfr7qhMGJd0bbi0tkxqHeK
 sWKlH9SR1KStUWbbg3n/NJkGGVHZM/l14FCyB0mHLSv0R7JDDrlU914y8INLZu61VkIZSKZG/
 h2aF8g+CB+e1A2px8xGsICxi97A3VRWw5iNXOGbZzdsEuJynQpFjMw+/Be4xAEPcBWaDSV6U4
 hZzEEPZoSFARu2hTD9cCxhrZX/DrbpYrb6FU27u4MqueiOo18cjMNSgOUGpfGabszGRnMkifM
 POn25LZxjyQrDRiV69sFPK26f54uwrg9+kMl/ChgpShI6go+qVXpq7OzCe2AGE94SsaCh/9rx
 Q7XDnkytSOfSL3WvhRlbMejvVWuzpOMoOJOZym9PAaKWfH/Tnd1qUbR8VrSXVewCTwBoCAueJ
 GdYEQsq9+lLgpOydYmqFckcahDh42k/TyBJw9qPmG03CsgejFw=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/11 下午8:07, Nikolay Borisov wrote:
> 
> 
> On  8.10.2018 15:30, Qu Wenruo wrote:
>> When restoring btrfs image, the total_bytes of device item is not
>> updated correctly. In fact total_bytes can be left 0 for restored image.
>>
>> It doesn't trigger any error because btrfs check never checks
>> total_bytes of dev item.
>> However this is going to change.
>>
>> Fix it by populating total_bytes of device item with the end position of
>> last dev extent to make later btrfs check happy.
> 
> 'Setting it to the end position' really means "setting the total device
> size to the allocated space on the device". Is it more clear if stated
> as the second way ?

Not exactly.

Don't forget that we have 0~1M reserved, and it's possible to have dev
extent holes.
So it's not "allocated space" but really "the end position of the last
dev extent"

Thanks,
Qu

> 
> In any case:
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  image/main.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 45 insertions(+), 3 deletions(-)
>>
>> diff --git a/image/main.c b/image/main.c
>> index 351c5a256938..d5b89bc3149f 100644
>> --- a/image/main.c
>> +++ b/image/main.c
>> @@ -2082,15 +2082,17 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
>>  }
>>  
>>  static int fixup_devices(struct btrfs_fs_info *fs_info,
>> -			 struct mdrestore_struct *mdres, off_t dev_size)
>> +			 struct mdrestore_struct *mdres, int out_fd)
>>  {
>>  	struct btrfs_trans_handle *trans;
>>  	struct btrfs_dev_item *dev_item;
>> +	struct btrfs_dev_extent *dev_ext;
>>  	struct btrfs_path path;
>>  	struct extent_buffer *leaf;
>>  	struct btrfs_root *root = fs_info->chunk_root;
>>  	struct btrfs_key key;
>>  	u64 devid, cur_devid;
>> +	u64 dev_size; /* Get from last dev extents */
>>  	int ret;
>>  
>>  	trans = btrfs_start_transaction(fs_info->tree_root, 1);
>> @@ -2101,16 +2103,56 @@ static int fixup_devices(struct btrfs_fs_info *fs_info,
>>  
>>  	dev_item = &fs_info->super_copy->dev_item;
>>  
>> +	btrfs_init_path(&path);
>>  	devid = btrfs_stack_device_id(dev_item);
>>  
>> +	key.objectid = devid;
>> +	key.type = BTRFS_DEV_EXTENT_KEY;
>> +	key.offset = (u64)-1;
>> +
>> +	ret = btrfs_search_slot(NULL, fs_info->dev_root, &key, &path, 0, 0);
>> +	if (ret < 0) {
>> +		error("failed to locate last dev extent of devid %llu: %s",
>> +			devid, strerror(-ret));
>> +		btrfs_release_path(&path);
>> +		return ret;
>> +	}
>> +	if (ret == 0) {
> 
> nit: I'd prefer if this is an else if since it emphasizes the fact that
> the if/elseif construct works on a single value.
> 
>> +		error("found invalid dev extent devid %llu offset -1",
>> +			devid);
>> +		btrfs_release_path(&path);
>> +		return -EUCLEAN;
>> +	}
>> +	ret = btrfs_previous_item(fs_info->dev_root, &path, devid,
>> +				  BTRFS_DEV_EXTENT_KEY);
>> +	if (ret > 0)
>> +		ret = -ENOENT;
>> +	if (ret < 0) {
> 
> ditto
> 
>> +		error("failed to locate last dev extent of devid %llu: %s",
>> +			devid, strerror(-ret));
>> +		btrfs_release_path(&path);
>> +		return ret;
>> +	}
>> +
>> +	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
>> +	dev_ext = btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +				 struct btrfs_dev_extent);
>> +	dev_size = key.offset + btrfs_dev_extent_length(path.nodes[0], dev_ext);
>> +	btrfs_release_path(&path);
>> +
>>  	btrfs_set_stack_device_total_bytes(dev_item, dev_size);
>>  	btrfs_set_stack_device_bytes_used(dev_item, mdres->alloced_chunks);
>> +	/* Don't forget to enlarge the real file */
>> +	ret = ftruncate64(out_fd, dev_size);
>> +	if (ret < 0) {
>> +		error("failed to enlarge result image: %s", strerror(errno));
>> +		return -errno;
>> +	}
>>  
>>  	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
>>  	key.type = BTRFS_DEV_ITEM_KEY;
>>  	key.offset = 0;
>>  
>> -	btrfs_init_path(&path);
>>  
>>  again:
>>  	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
>> @@ -2275,7 +2317,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
>>  			return 1;
>>  		}
>>  
>> -		ret = fixup_devices(info, &mdrestore, st.st_size);
>> +		ret = fixup_devices(info, &mdrestore, fileno(out));
>>  		close_ctree(info->chunk_root);
>>  		if (ret)
>>  			goto out;
>>
