From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 2/3] Btrfs: add ioctl to get and reset the device stats
Date: Mon, 12 Dec 2011 14:34:25 +0100
Message-ID: <4EE602E1.4020206@giantdisaster.de>
References: <cover.1323448299.git.sbehrens@giantdisaster.de> <f2f1de6869aab38ff48d60235081257ce2c03bf4.1323448299.git.sbehrens@giantdisaster.de> <1328320.x7SNYXeJA2@venice>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328320.x7SNYXeJA2@venice>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2011 11:24 AM, Goffredo Baroncelli wrote:
> On Friday, 09 December, 2011 17:40:27 Stefan Behrens wrote:
>> An ioctl interface is added to get the device statistic counters.
>> A second ioctl is added to atomically get and reset these counters.
> 
> [...]
> 
>>
>> +static long btrfs_ioctl_get_device_stats(struct btrfs_root *root,
>> +					 void __user *arg, int reset_after_read)
>> +{
>> +	struct btrfs_ioctl_get_device_stats *sa;
>> +	int ret;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
> 
> I agree that the BTRFS_IOC_GET_AND_RESET_DEVICE_STATS should be a privileged 
> operation. But I think that the BTRFS_IOC_GET_DEVICE_STATS should be allowed 
> to everyone. Think about a daemon which look at the error, and then send an 
> email to warn about possible defect. Allowing BTRFS_IOC_GET_DEVICE_STATS to 
> everyone, prevent to run the deamon with root privileges.

I fully agree to your comment and will change it in a v2. Thanks!
