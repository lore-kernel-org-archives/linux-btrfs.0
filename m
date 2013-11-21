Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KUDXi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 22:23:38 -0500
Message-ID: <528D7ED4.1000300@oracle.com>
Date: Thu, 21 Nov 2013 11:32:36 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH v4 2/3] btrfs-progs: fs show should handle if subvol(s)
 mounted
References: <1384514735-24761-1-git-send-email-anand.jain@oracle.com> <1384514735-24761-2-git-send-email-anand.jain@oracle.com> <20131120141856.GH5007@twin.jikos.cz>
In-Reply-To: <20131120141856.GH5007@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/20/2013 10:18 PM, David Sterba wrote:
> On Fri, Nov 15, 2013 at 07:25:34PM +0800, Anand Jain wrote:
>>   static int btrfs_scan_kernel(void *search)
>>   {
>> -	int ret = 0, fd;
>> -	FILE *f;
>> -	struct mntent *mnt;
>> -	struct btrfs_ioctl_fs_info_args fs_info_arg;
>> -	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
>> -	struct btrfs_ioctl_space_args *space_info_arg;
>> +	int ret = 0;
>>   	char label[BTRFS_LABEL_SIZE];
>> -
>> -	f = setmntent("/proc/self/mounts", "r");
>> -	if (f == NULL)
>> -		return 1;
>> -
>> -	memset(label, 0, sizeof(label));
>> -	while ((mnt = getmntent(f)) != NULL) {
>> -		if (strcmp(mnt->mnt_type, "btrfs"))
>> +	char mnt[BTRFS_PATH_NAME_MAX + 1];
>> +	struct btrfs_ioctl_fslist *fslist;
>> +	struct btrfs_ioctl_fslist *fslist_saved;
>
>      [CC]     cmds-send.o
> cmds-filesystem.c: In function ‘btrfs_scan_kernel’:
> cmds-filesystem.c:461:29: warning: variable ‘fslist_saved’ set but not used [-Wunused-but-set-variable]

  Thanks David. That was something for later todo which I missed.
  sorry my mistake. Sent out v5.

>> +	u64 cnt_fs;
>> +	int cnt_mnt;
>> +	__u8 *fsid;
>> +	__u64 flags;
>> +
>> +	ret = get_fslist(&fslist, &cnt_fs);
>> +	if (ret)
>> +		return ret;
>> +	fslist_saved = fslist;
>> +	while (cnt_fs--) {
>> +		fsid = fslist->fsid;
>> +		flags = fslist->flags;
>> +		fslist++;
>> +		if (!(flags & BTRFS_FS_MOUNTED))
>>   			continue;
>> -		ret = get_fs_info(mnt->mnt_dir, &fs_info_arg,
>> -				&dev_info_arg);
>> +		memset(mnt, 0, BTRFS_PATH_NAME_MAX + 1);
>> +		memset(label, 0, sizeof(label));
>> +		ret = fsid_to_mntpt(fsid, mnt, &cnt_mnt);
>>   		if (ret)
>>   			return ret;
>> -
>> -		if (get_label_mounted(mnt->mnt_dir, label)) {
>> -			kfree(dev_info_arg);
>> +		if (get_label_mounted(mnt, label))
>>   			return 1;
>> -		}
>> -		if (search && !match_search_item_kernel(fs_info_arg.fsid,
>> -					mnt->mnt_dir, label, search)) {
>> -			kfree(dev_info_arg);
>> +
>> +		if (search && !match_search_item_kernel(fsid,
>> +					mnt, label, search))
>>   			continue;
>> -		}
>>
>> -		fd = open(mnt->mnt_dir, O_RDONLY);
>> -		if ((fd != -1) && !get_df(fd, &space_info_arg)) {
>> -			print_one_fs(&fs_info_arg, dev_info_arg,
>> -					space_info_arg, label, mnt->mnt_dir);
>> -			kfree(space_info_arg);
>> -			memset(label, 0, sizeof(label));
>> -		}
>> -		if (fd != -1)
>> -			close(fd);
>> -		kfree(dev_info_arg);
>> +		handle_print(mnt, label);
>>   		if (search)
>>   			return 0;
>>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
