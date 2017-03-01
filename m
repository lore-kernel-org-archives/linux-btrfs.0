Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51981 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdCAIxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 03:53:43 -0500
Subject: Re: [PULL] Btrfs cleanups for 4.11, part 2
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
References: <cover.1488289094.git.dsterba@suse.com>
 <32c50d9d-7b59-718b-7e95-43bef27b9b91@fb.com>
Cc: linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <319756cf-e9f8-d904-dbf1-6b6fdceca291@suse.com>
Date: Wed, 1 Mar 2017 09:36:38 +0200
MIME-Version: 1.0
In-Reply-To: <32c50d9d-7b59-718b-7e95-43bef27b9b91@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.03.2017 00:35, Chris Mason wrote:
> 
> 
> On 02/28/2017 10:09 AM, David Sterba wrote:
>> Hi,
>>
>> this is the second half of the 4.11 batch, the rest of the cleanups.
>> Please
>> pull, thanks.
>>
>> The following changes since commit
>> 6288d6eabc7505f42dda34a2c2962f91914be3a4:
>>
>>   Btrfs: use the correct type when creating cow dio extent (2017-02-22
>> 15:55:03 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>> for-chris-4.11-part2
>>
>> for you to fetch changes up to 20a7db8ab3f2057a518448b1728d504ffadef65e:
>>
>>   btrfs: add dummy callback for readpage_io_failed and drop checks
>> (2017-02-28 14:29:24 +0100)
>>
> 
> Thanks Dave, I've got this along with Filipe's pull.

Kbuild reported the following warning: 

 fs/btrfs/scrub.c: In function 'check_extent_to_block':
>> fs/btrfs/scrub.c:4259:24: error: passing argument 1 of 'btrfs_get_extent' from incompatible pointer type [-Werror=incompatible-pointer-types]
     em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
                           ^~~~~
   In file included from fs/btrfs/scrub.c:21:0:
   fs/btrfs/ctree.h:3169:20: note: expected 'struct inode *' but argument is of type 'struct btrfs_inode *'
    struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
                       ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/btrfs_get_extent +4259 fs/btrfs/scrub.c

32159242 Gui Hecheng 2014-11-10  4253  	if (ordered) {
32159242 Gui Hecheng 2014-11-10  4254  		btrfs_put_ordered_extent(ordered);
32159242 Gui Hecheng 2014-11-10  4255  		ret = 1;
32159242 Gui Hecheng 2014-11-10  4256  		goto out_unlock;
32159242 Gui Hecheng 2014-11-10  4257  	}
32159242 Gui Hecheng 2014-11-10  4258  
32159242 Gui Hecheng 2014-11-10 @4259  	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
32159242 Gui Hecheng 2014-11-10  4260  	if (IS_ERR(em)) {
32159242 Gui Hecheng 2014-11-10  4261  		ret = PTR_ERR(em);
32159242 Gui Hecheng 2014-11-10  4262  		goto out_unlock;

I guess changing the definition of btrfs_get_extent in ctree.h got missed to 
being converted to struct btrfs_inode. Could you be able to fix it up?


> 
> -chris
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
