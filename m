Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53516C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 13:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFE82173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 13:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfC1N6d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 09:58:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:59948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbfC1N6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 09:58:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D9A2DAF2F;
        Thu, 28 Mar 2019 13:58:30 +0000 (UTC)
Subject: Re: [PATCh v2 9/9] btrfs: inode: Verify inode mode to avoid NULL
 pointer dereference
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-10-wqu@suse.com> <20190328135328.GE29086@twin.jikos.cz>
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
Message-ID: <9152fd71-70d4-be06-6751-ad254c603e47@suse.de>
Date:   Thu, 28 Mar 2019 21:58:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190328135328.GE29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/28 下午9:53, David Sterba wrote:
> On Wed, Mar 20, 2019 at 02:37:17PM +0800, Qu Wenruo wrote:
>> @@ -5726,18 +5734,29 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>>  	struct btrfs_root *sub_root = root;
>>  	struct btrfs_key location;
>> +	u8 di_type = 0;
>>  	int index;
>>  	int ret = 0;
>>  
>>  	if (dentry->d_name.len > BTRFS_NAME_LEN)
>>  		return ERR_PTR(-ENAMETOOLONG);
>>  
>> -	ret = btrfs_inode_by_name(dir, dentry, &location);
>> +	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
>>  	if (ret < 0)
>>  		return ERR_PTR(ret);
>>  
>>  	if (location.type == BTRFS_INODE_ITEM_KEY) {
>>  		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
>> +
>> +		/* Do extra check against inode mode with di_type */
>> +		if (btrfs_inode_type(inode) != di_type) {
>> +			btrfs_crit(fs_info,
>> +"inode mode mismatch with dir: inode mode=0%o btrfs type=%u dir type=%u",
>> +				  inode->i_mode, btrfs_inode_type(inode),
>> +				  di_type);
>> +			iput(inode);
> 
> The iput here seems suspicious.

How? this pairs to that inode = btrfs_iget() line.

And as long as we hit this branch, we will return either a valid inode
or an error pointer.
> 
>> +			return ERR_PTR(-EUCLEAN);
>> +		}
>>  		return inode;
>>  	}
> 
> 5792         index = srcu_read_lock(&fs_info->subvol_srcu);
> 5793         ret = fixup_tree_root_location(fs_info, dir, dentry,
> 5794                                        &location, &sub_root);
> 5795         if (ret < 0) {
> 5796                 if (ret != -ENOENT)
> 5797                         inode = ERR_PTR(ret);
> 5798                 else
> 5799                         inode = new_simple_dir(dir->i_sb, &location, sub_root);
> 5800         } else {
> 5801                 inode = btrfs_iget(dir->i_sb, &location, sub_root, NULL);
> 5802         }
> 
> The iget happens after this block so either there's another one in the caller
> to pair, or the above iput is wrong.

This block is unrelated to above (location.type == BTRFS_INODE_ITEM_KEY)
branch.

Or did I miss something?

Thanks,
Qu

> 
