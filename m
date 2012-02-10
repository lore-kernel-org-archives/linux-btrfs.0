From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Fri, 10 Feb 2012 09:56:43 +0800
Message-ID: <4F34795B.2020004@cn.fujitsu.com>
References: <20270.59513.240729.662692@localhost.localdomain>	<4F3386D8.6010108@cn.fujitsu.com> <20275.60248.386622.516828@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lutz Euler <lutz.euler@freenet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20275.60248.386622.516828@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/09/2012 11:50 PM, Lutz Euler wrote:
> Hi Liu,
> 
> thanks for looking into this!
> 
> You wrote:
> 
>> Would you please test the following patch on your box?
>>
>> thanks,
>> liubo
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 77ea23c..b6e2c92 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7653,9 +7653,16 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
>>  	u64 start;
>>  	u64 end;
>>  	u64 trimmed = 0;
>> +	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
>>  	int ret = 0;
>>  
>> -	cache = btrfs_lookup_block_group(fs_info, range->start);
>> +	/*
>> +	 * try to trim all FS space, our block group may start from non-zero.
>> +	 */
>> +	if (range->len == total_bytes)
>> +		cache = btrfs_lookup_first_block_group(fs_info, range->start);
>> +	else
>> +		cache = btrfs_lookup_block_group(fs_info, range->start);
>>  
>>  	while (cache) {
>>  		if (cache->key.objectid >= (range->start + range->len)) {
>> -- 
>> 1.6.5.2
> 
> I'm sorry but that didn't help.
> I applied the patch on top of v3.3-rc2-172-g23783f8 and still fstrim
> says: "0 bytes were trimmed".
> 
> I left the printk's I mentioned in place. They show that now "cache"
> is not 0 so the "while (cache)" loop is entered but nevertheless
> "btrfs_trim_block_group" is never called. So I put in more printk's
> and found that the objectid is so large that the loop is immediately
> terminated (output of printk's in "//" comments below):
> 
> int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
> {
> 	struct btrfs_fs_info *fs_info = root->fs_info;
> 	struct btrfs_block_group_cache *cache = NULL;
> 	u64 group_trimmed;
> 	u64 start;
> 	u64 end;
> 	u64 trimmed = 0;
> 	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
> 	int ret = 0;
> 
> // range.start = 0, .len = 160815300608, .minlen = 512
> 
> 	/*
> 	 * try to trim all FS space, our block group may start from non-zero.
> 	 */
> 	if (range->len == total_bytes)
> 		cache = btrfs_lookup_first_block_group(fs_info, range->start);
> 	else
> 		cache = btrfs_lookup_block_group(fs_info, range->start);
> 
> // cache != 0
> 
> 	while (cache) {
> 
> // cache->key.objectid = 213702934528
> 
> 		if (cache->key.objectid >= (range->start + range->len)) {
> 			btrfs_put_block_group(cache);
> 			break;
> 		}
> 
> // This line is not reached.
> 
> Here's the output of "btrfs fi show /dev/sda3" again:
> 
> failed to read /dev/sr0
> Label: none  uuid: 88af7576-3027-4a3b-a5ae-34bfd167982f
> 	Total devices 2 FS bytes used 29.05GB
> 	devid    4 size 74.53GB used 40.06GB path /dev/sdb1
> 	devid    3 size 75.24GB used 40.06GB path /dev/sda3
> 

Hi Lutz,

Great thanks for your details, now this should be a worked one.

liubo,
thanks,

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 77ea23c..693241a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7653,12 +7653,22 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
+	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	bool all = false;
 	int ret = 0;
 
-	cache = btrfs_lookup_block_group(fs_info, range->start);
+	/* try to trim all FS space */
+	if (range->len == total_bytes)
+		all = true;
+
+	if (all)
+		/* our block group may start from non-zero */
+		cache = btrfs_lookup_first_block_group(fs_info, range->start);
+	else
+		cache = btrfs_lookup_block_group(fs_info, range->start);
 
 	while (cache) {
-		if (cache->key.objectid >= (range->start + range->len)) {
+		if (!all && cache->key.objectid >= (range->start + range->len)) {
 			btrfs_put_block_group(cache);
 			break;
 		}
-- 
1.6.5.2



> Kind regards,
> 
> Lutz
> 

