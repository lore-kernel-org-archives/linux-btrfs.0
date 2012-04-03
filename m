From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: do not mount when we have a sectorsize unequal
 to PAGE_SIZE
Date: Tue, 03 Apr 2012 16:35:28 +0800
Message-ID: <4F7AB650.3000108@cn.fujitsu.com>
References: <1333418213-2718-1-git-send-email-liubo2009@cn.fujitsu.com> <20120403080659.GF1084@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120403080659.GF1084@x2.net.home>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2012 04:06 PM, Karel Zak wrote:
> On Tue, Apr 03, 2012 at 09:56:53AM +0800, Liu Bo wrote:
>> Our code is not ready to cope with a sectorsize that's not equal to PAGE_SIZE.
>> It will lead to hanging-on while writing something.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  fs/btrfs/disk-io.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 20196f4..b9866f2 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2254,9 +2254,9 @@ int open_ctree(struct super_block *sb,
>>  		goto fail_sb_buffer;
>>  	}
>>  
>> -	if (sectorsize < PAGE_SIZE) {
>> -		printk(KERN_WARNING "btrfs: Incompatible sector size "
>> -		       "found on %s\n", sb->s_id);
>> +	if (sectorsize != PAGE_SIZE) {
>> +		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
>> +		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
> 
>  That's strange. Does it mean that if I create the filesystem and then
>  reboot to another kernel with different PAGE_SIZE then the filesystem
>  is unaccessible for me?
> 
>     Karel
> 

I'm afraid yes until we can deal with sectorsize and PAGE_SIZE gracefully.

For now, I didn't test if a read will cause oops or not, but if it's ok, an alternative way is to make FS readonly.

thanks,
liubo
