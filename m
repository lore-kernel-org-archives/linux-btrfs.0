Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3KGJzN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 04:55:13 -0500
Message-ID: <527B633C.8030700@oracle.com>
Date: Thu, 07 Nov 2013 17:54:04 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, zab@redhat.com, dsterba@suse.cz
Subject: Re: [PATCH 3/4 v2] btrfs-progs: fs show should handle if subvol(s)
 mounted
References: <1383536745-4635-1-git-send-email-anand.jain@oracle.com> <1383536745-4635-3-git-send-email-anand.jain@oracle.com> <20131106201911.GF27784@localhost.localdomain>
In-Reply-To: <20131106201911.GF27784@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks sent out v3


On 11/07/13 04:19 AM, Josef Bacik wrote:
> On Mon, Nov 04, 2013 at 11:45:44AM +0800, Anand Jain wrote:
>> as of now with out this patch user would see
>> fsinfo per btrfs mount path but which mean multiple
>> entry if more than one subvol is mounted of the same
>> fsid. so this patch will handle that nicely.
>>
>> v2: accepts Zach suggested
>>
>> Signed-off-by: Anand Jain<anand.jain@oracle.com>
>> ---
>>   cmds-filesystem.c |   90 +++++++++++++++++++++++++++++++++--------------------
>>   utils.c           |   88 ++++++++++++++++++++++++++++++++++++++++++---------
>>   utils.h           |    3 +-
>>   3 files changed, 130 insertions(+), 51 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index d2cad81..f8e8475 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -317,6 +317,29 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>>   	return 0;
>>   }
>>
>> +static void handle_print(char *mnt, char *label)
>> +{
>> +	int fd;
>> +	struct btrfs_ioctl_fs_info_args fs_info_arg;
>> +	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
>> +	struct btrfs_ioctl_space_args *space_info_arg;
>> +
>> +	if (get_fs_info(mnt,&fs_info_arg,&dev_info_arg)) {
>> +		fprintf(stdout, "ERROR: get_fs_info failed\n");
>> +		return;
>> +	}
>> +
>> +	fd = open(mnt, O_RDONLY);
>> +	if (fd>  0&&  !get_df(fd,&space_info_arg)) {
>
> 0 is a valid fd.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
