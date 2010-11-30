From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] btrfs: Make async snapshot ioctl more generic
Date: Tue, 30 Nov 2010 09:13:18 +0800
Message-ID: <4CF44FAE.1010603@cn.fujitsu.com>
References: <4CF35E17.6050705@cn.fujitsu.com> <4CF35E28.4070206@cn.fujitsu.com> <201011291952.11297.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011291952.11297.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> Hi Li,
> 
> great work, but I have some suggestions:
> 
> On Monday, 29 November, 2010, Li Zefan wrote:
>> So we don't have to add new structures as we create more ioctls
>> for snapshots.
>>
>> Now to create async snapshot, set BTRFS_SNAPSHOT_CREATE_ASYNC bit of
>> vol_arg_v2->flags, and then call ioctl(BTRFS_IOCT_SNAP_CREATE_V2).
>>
>> Note: this changes the async snapshot ioctl ABI, which was merged
>> in .37 merge window, so we have to make this change into .37.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |   34 +++++++++++++++++++++-------------
>>  fs/btrfs/ioctl.h |   12 ++++++++----
>>  2 files changed, 29 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 463d91b..d3f1a60 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -935,23 +935,31 @@ out:
>>  
>>  static noinline int btrfs_ioctl_snap_create(struct file *file,
>>  					    void __user *arg, int subvol,
>> -					    int async)
>> +					    bool v2)
> 
> This is a aesthetic suggestion: instead of passing a flag called v2 I suggest 
> to add two wrapper functions, which extract the parameters and passes all 
> available parameter to the "generic" function. Something like:
> 

Sure, as long as it won't result in code duplication and can
improve readability.

> static inline btrfs_ioctl_snap_create_v1(struct file *file, 
> 						void __user *arg, int subvol)
> {
>                 vol_args = memdup_user(arg, sizeof(*vol_args));
>                 if (IS_ERR(vol_args))
>                         return PTR_ERR(vol_args);
>                 name = vol_args->name;
>                 fd = vol_args->fd;
>                 vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> 
> 		btrfs_ioctl_snap_create_generic(file, subvol, name, fd, 0, 0);
> 
> }
> 
> static inline btrfs_ioctl_snap_create_v2(struct file *file, 
> 						void __user *arg, int subvol,
> 						)
> {
>                 vol_args_v2 = memdup_user(arg, sizeof(*vol_args_v2));
>                 if (IS_ERR(vol_args_v2))
>                         return PTR_ERR(vol_args_v2);
> 
>                 ret = snap_check_flags(vol_args_v2->flags, true);
>                 if (ret)
>                         goto out;
> 
>                 name = vol_args_v2->name;
>                 fd = vol_args_v2->fd;
>                 vol_args_v2->name[BTRFS_SNAPSHOT_NAME_MAX] = '\0';
>                 if (vol_args_v2->flags & BTRFS_SNAPSHOT_CREATE_ASYNC)
>                         async = true;
>                 if (vol_args_v2->flags & BTRFS_SNAPSHOT_RDONLY)
>                         readonly = true;
> 
> 		btrfs_ioctl_snap_create_generic(file, subvol, name, fd, async,
> 			 readonly);
> 
> }
> 
> and 
> 
>   	case BTRFS_IOC_SNAP_CREATE:
>   		return btrfs_ioctl_snap_create_v1(file, argp, 0);
> 	case BTRFS_IOC_SNAP_CREATE_V2:
>   		return btrfs_ioctl_snap_create_v2(file, argp, 0);
> 
> 
> Frankly speaking, we could get rid of the subvol parameter adding another 
> wrapper function like "btrfs_ioctl_subvol_create( )", but this would be 
> another story :)
> 

I thought about that too.

>>  {
>>  	struct btrfs_ioctl_vol_args *vol_args = NULL;
>> -	struct btrfs_ioctl_async_vol_args *async_vol_args = NULL;
>> +	struct btrfs_ioctl_vol_args_v2 *vol_args_v2 = NULL;
>>  	char *name;
>>  	u64 fd;
>>  	u64 transid = 0;
>> +	bool async = false;
>>  	int ret;
>>  
>> -	if (async) {
>> -		async_vol_args = memdup_user(arg, sizeof(*async_vol_args));
>> -		if (IS_ERR(async_vol_args))
>> -			return PTR_ERR(async_vol_args);
>> +	if (v2) {
>> +		vol_args_v2 = memdup_user(arg, sizeof(*vol_args_v2));
>> +		if (IS_ERR(vol_args_v2))
>> +			return PTR_ERR(vol_args_v2);
>>  
>> -		name = async_vol_args->name;
>> -		fd = async_vol_args->fd;
>> -		async_vol_args->name[BTRFS_SNAPSHOT_NAME_MAX] = '\0';
>> +		if (vol_args_v2->flags & ~BTRFS_SNAPSHOT_CREATE_ASYNC) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +
>> +		name = vol_args_v2->name;
>> +		fd = vol_args_v2->fd;
>> +		vol_args_v2->name[BTRFS_SNAPSHOT_NAME_MAX] = '\0';
>> +		if (vol_args_v2->flags & BTRFS_SNAPSHOT_CREATE_ASYNC)
>> +			async = true;
>>  	} else {
>>  		vol_args = memdup_user(arg, sizeof(*vol_args));
>>  		if (IS_ERR(vol_args))
>> @@ -966,13 +974,13 @@ static noinline int btrfs_ioctl_snap_create(struct 
> file *file,
>>  
>>  	if (!ret && async) {
>>  		if (copy_to_user(arg +
>> -				offsetof(struct btrfs_ioctl_async_vol_args,
>> +				offsetof(struct btrfs_ioctl_vol_args_v2,
>>  				transid), &transid, sizeof(transid)))
>>  			return -EFAULT;
>>  	}
>> -
>> +out:
>>  	kfree(vol_args);
>> -	kfree(async_vol_args);
>> +	kfree(vol_args_v2);
>>  
>>  	return ret;
>>  }
>> @@ -2235,7 +2243,7 @@ long btrfs_ioctl(struct file *file, unsigned int
>>  		return btrfs_ioctl_getversion(file, argp);
>>  	case BTRFS_IOC_SNAP_CREATE:
>>  		return btrfs_ioctl_snap_create(file, argp, 0, 0);
>> -	case BTRFS_IOC_SNAP_CREATE_ASYNC:
>> +	case BTRFS_IOC_SNAP_CREATE_V2:
>>  		return btrfs_ioctl_snap_create(file, argp, 0, 1);
>>  	case BTRFS_IOC_SUBVOL_CREATE:
>>  		return btrfs_ioctl_snap_create(file, argp, 1, 0);
>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>> index 17c99eb..bc70584 100644
>> --- a/fs/btrfs/ioctl.h
>> +++ b/fs/btrfs/ioctl.h
>> @@ -30,10 +30,14 @@ struct btrfs_ioctl_vol_args {
>>  	char name[BTRFS_PATH_NAME_MAX + 1];
>>  };
>>  
>> -#define BTRFS_SNAPSHOT_NAME_MAX 4079
>> -struct btrfs_ioctl_async_vol_args {
>> +#define BTRFS_SNAPSHOT_CREATE_ASYNC	(1ULL << 0)
>> +
>> +#define BTRFS_SNAPSHOT_NAME_MAX 4039
>> +struct btrfs_ioctl_vol_args_v2 {
>>  	__s64 fd;
>>  	__u64 transid;
>> +	__u64 flags;
>> +	__u64 unused[4];
>>  	char name[BTRFS_SNAPSHOT_NAME_MAX + 1];
>>  };
> 
> Why the unused fields ? What happens if you use a more recent btrfs-tools 
> which take advantage of these fields but the kernel is an old one ? At the 

It's common that we reserve some place in an ABI for future expansion.
If later those unused bytes are used, it should make sure it won't
break old kernels.

> minimum please check the flags so
> 	(flags^(BTRFS_SNAPSHOT_CREATE_ASYNC|BTRFS_SNAPSHOT_RDONLY)) == 0

This is checked.

> and
> 	unused[0..3] == 0

No, we don't need to check this. I don't think other ioctls that have
reserved bytes check this.

> 
> For future expansion I suggest to use a different ioctl. To me it seems a more 
> robust API.

I'd like to avoid new ioctls if possible. If we had had some reserved
bytes in struct btrfs_ioctl_vol_args, we wouldn't need to create
a v2 ioctl.

> 
>>  
>> @@ -187,6 +191,6 @@ struct btrfs_ioctl_space_args {
>>  				    struct btrfs_ioctl_space_args)
>>  #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
>>  #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
>> -#define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
>> -				   struct btrfs_ioctl_async_vol_args)
>> +#define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
>> +				   struct btrfs_ioctl_vol_args_v2)
> 
> I repeat: great work, please take my comments only a suggestion to improve 
> instead of an empty criticism.
> 

Thanks!

> Regards
> G.Baroncelli
> 
>>  #endif
>> -- 
>> 1.6.3
>>
