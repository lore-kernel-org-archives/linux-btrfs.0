Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20650 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaFBIT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 04:19:28 -0400
Message-ID: <538C343C.20308@oracle.com>
Date: Mon, 02 Jun 2014 16:22:20 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 4/4] btrfs: create sprout should rename fsid on the sysfs
 as well
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com> <1401096626-13210-5-git-send-email-anand.jain@oracle.com> <20140529125422.GB29992@twin.jikos.cz>
In-Reply-To: <20140529125422.GB29992@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 29/05/14 20:54, David Sterba wrote:
> On Mon, May 26, 2014 at 05:30:26PM +0800, Anand Jain wrote:
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2084,6 +2084,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>>   	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>>
>>   	if (seeding_dev) {
>> +		char fsid_buf[37];
>
> Is there a symbolic constant available? We have one in userspace, but I
> can't find one for kernel, only a few locally defined.

  now defined the same (as in progs) in kernel as well.

>>   		ret = init_first_rw_device(trans, root, device);
>>   		if (ret) {
>>   			btrfs_abort_transaction(trans, root, ret);
>> @@ -2094,6 +2095,13 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>>   			btrfs_abort_transaction(trans, root, ret);
>>   			goto error_trans;
>>   		}
>> +
>> +		/* Sprouting would change fsid of the mounted root,
>> +		 * so rename the fsid on the sysfs
>> +		 */
>> +		sprintf(fsid_buf, "%pU", root->fs_info->fsid);
>
> Would be better do use snprintf explicitly.

  added. Thanks for commenting.

Anand




>> +		if (kobject_rename(&root->fs_info->super_kobj, fsid_buf))
>> +			goto error_trans;
>>   	} else {
>
> Otherwise ok.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
