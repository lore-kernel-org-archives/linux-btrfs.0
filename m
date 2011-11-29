From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write
 devices V2
Date: Tue, 29 Nov 2011 09:55:10 +0800
Message-ID: <4ED43B7E.1030106@cn.fujitsu.com>
References: <1312205910-13053-1-git-send-email-apw@canonical.com> <20111128121041.GA19498@elie.hsd1.il.comcast.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Andy Whitcroft <apw@canonical.com>,
	Josef Bacik <josef@redhat.com>,
	Ivan Vilata i Balaguer <ivan@selidor.net>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128121041.GA19498@elie.hsd1.il.comcast.net>
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 28 Nov 2011 06:11:06 -0600, Jonathan Nieder wrote:
> Hi,
> 
> Andy Whitcroft wrote:
> 
>> When we mount a btrfs filesystem from read-only media there will be no
>> read/write devices; for example mounting an SD card with its lock enabled.
>> This triggers an immediate BUG during mount:
>>
>>   kernel BUG at .../fs/btrfs/super.c:984!
> [...]
>> BugLink: http://bugs.launchpad.net/bugs/816770
>> Signed-off-by: Andy Whitcroft <apw@canonical.com>
>> ---
> 
> Fixes http://bugs.debian.org/649847
> Tested-by: Ivan Vilata i Balaguer <ivan@selidor.net>
> 
> This patch fixes a regression introduced by 6d07bcec969a ("btrfs: fix
> wrong free space information of btrfs"), which hit mainline in
> v2.6.38-rc1.  Josef Bacik acked the patch, but I can't seem to find it
> in linux-next, linux-btrfs, or Josef's btrfs-work tree.  Maybe it was
> just forgotten.
> 
> What can I do to help this patch get unstuck?

I think We should make this behaviour similar to the traditional file systems,
such as ext3/4. That is the available space should show the size of all the free space
which we may used to store the file data, even we mount it on the read-only mode.
This patch didn't fix the problem completely.

Thanks
Miao

>>  fs/btrfs/super.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 15634d4..ae4367a 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -980,7 +980,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>>  	int i = 0, nr_devices;
>>  	int ret;
>>  
>> -	nr_devices = fs_info->fs_devices->rw_devices;
>> +	nr_devices = fs_info->fs_devices->open_devices;
>>  	BUG_ON(!nr_devices);
>>  
>>  	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
>> -- 
>> 1.7.4.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
