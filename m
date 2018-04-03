Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:43149 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754305AbeDCFzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 01:55:42 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: check: Skip data csum verification for
 metadata dump
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180403053947.5908-1-wqu@suse.com>
 <28d6599f-136a-a053-b4e9-6cb296a35d2a@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9ab95bd6-afcc-fca3-be39-1051d42529bb@gmx.com>
Date: Tue, 3 Apr 2018 13:55:32 +0800
MIME-Version: 1.0
In-Reply-To: <28d6599f-136a-a053-b4e9-6cb296a35d2a@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月03日 13:51, Nikolay Borisov wrote:
> 
> 
> On  3.04.2018 08:39, Qu Wenruo wrote:
>> For metadata dump (fs restored by btrfs-image), since no data is
>> restored check sum verification will definitely report error.
>>
>> Add such check in check_csums() and prompt for user.
>>
>> Issue: #103
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
>> ---
>>  check/main.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 891a6d797756..15c94543946a 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -5601,6 +5601,7 @@ static int check_csums(struct btrfs_root *root)
>>  	int ret;
>>  	u64 data_len;
>>  	unsigned long leaf_offset;
>> +	bool verify_csum = !!check_data_csum;
> 
> nit: Why don't you convert check_data_csum to bool in this patch.

Next thing to do.

> My
> recent testing in !! usage showed that it's generating quite a number of
> additional instructions.

That's pretty interesting.

Would you please shared some more info about this?

Thanks,
Qu

> Not that it will have big impact in this case
> though.
> 
>>  
>>  	root = root->fs_info->csum_root;
>>  	if (!extent_buffer_uptodate(root->node)) {
>> @@ -5623,6 +5624,16 @@ static int check_csums(struct btrfs_root *root)
>>  		path.slots[0]--;
>>  	ret = 0;
>>  
>> +	/*
>> +	 * For metadata dump (btrfs-image) all data is wiped so verifying data
>> +	 * csum is meaningless and will always report csum error.
>> +	 */
>> +	if (check_data_csum && (btrfs_super_flags(root->fs_info->super_copy) &
>> +	    (BTRFS_SUPER_FLAG_METADUMP | BTRFS_SUPER_FLAG_METADUMP_V2))) {
>> +		printf("skip data csum verification for metadata dump\n");
>> +		verify_csum = false;
>> +	}
>> +
>>  	while (1) {
>>  		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
>>  			ret = btrfs_next_leaf(root, &path);
>> @@ -5644,7 +5655,7 @@ static int check_csums(struct btrfs_root *root)
>>  
>>  		data_len = (btrfs_item_size_nr(leaf, path.slots[0]) /
>>  			      csum_size) * root->fs_info->sectorsize;
>> -		if (!check_data_csum)
>> +		if (!verify_csum)
>>  			goto skip_csum_check;
>>  		leaf_offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
>>  		ret = check_extent_csums(root, key.offset, data_len,
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
