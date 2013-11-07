Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19540 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3KGJz3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 04:55:29 -0500
Message-ID: <527B634D.3020701@oracle.com>
Date: Thu, 07 Nov 2013 17:54:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, zab@redhat.com, dsterba@suse.cz
Subject: Re: [PATCH 4/4] btrfs-progs: lblkid wouldn't find non mapper path
 input
References: <1383536745-4635-1-git-send-email-anand.jain@oracle.com> <1383536745-4635-4-git-send-email-anand.jain@oracle.com> <20131106202018.GG27784@localhost.localdomain>
In-Reply-To: <20131106202018.GG27784@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Done.


On 11/07/13 04:20 AM, Josef Bacik wrote:
> On Mon, Nov 04, 2013 at 11:45:45AM +0800, Anand Jain wrote:
>> A new test case when disk is unmounted and if the non mapper
>> disk path is given as the argument to the btrfs filesystem show<arg>
>> we still need this to work but lblkid will pull only mapper disks,
>> it won't match. So this will normalize the input to find btrfs
>> by fsid and pass it to the search.
>>
>> v2: accepts Josef suggested
>>
>> Signed-off-by: Anand Jain<anand.jain@oracle.com>
>> ---
>>   cmds-filesystem.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++---
>>   1 files changed, 55 insertions(+), 4 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index f8e8475..f40178a 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -37,6 +37,7 @@
>>   #include "version.h"
>>   #include "commands.h"
>>   #include "list_sort.h"
>> +#include "disk-io.h"
>>
>>   static const char * const filesystem_cmd_group_usage[] = {
>>   	"btrfs filesystem [<group>]<command>  [<args>]",
>> @@ -414,6 +415,39 @@ static int btrfs_scan_kernel(void *search)
>>   	return 0;
>>   }
>>
>> +static int dev_to_fsid(char *dev, __u8 *fsid)
>> +{
>> +	struct btrfs_super_block *disk_super;
>> +	char *buf;
>> +	int ret;
>> +	int fd;
>> +
>> +	buf = malloc(4096);
>> +	if (!buf)
>> +		return -ENOMEM;
>> +
>> +	fd = open(dev, O_RDONLY);
>> +	if (fd<  0) {
>> +		ret = -errno;
>> +		free(buf);
>> +		return ret;
>> +	}
>> +
>> +	disk_super = (struct btrfs_super_block *)buf;
>> +	ret = btrfs_read_dev_super(fd, disk_super,
>> +			BTRFS_SUPER_INFO_OFFSET);
>> +	if (ret)
>> +		goto out;
>> +
>> +	memcpy(fsid, disk_super->fsid, BTRFS_FSID_SIZE);
>> +	ret = 0;
>> +
>> +out:
>> +	close(fd);
>> +	free(buf);
>> +	return ret;
>> +}
>> +
>>   static const char * const cmd_show_usage[] = {
>>   	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
>>   	"Show the structure of a filesystem",
>> @@ -434,6 +468,8 @@ static int cmd_show(int argc, char **argv)
>>   	int type = 0;
>>   	char mp[BTRFS_PATH_NAME_MAX + 1];
>>   	char path[PATH_MAX];
>> +	__u8 fsid[BTRFS_FSID_SIZE];
>> +	char uuid_buf[37];
>>
>>   	while (1) {
>>   		int long_index;
>> @@ -466,6 +502,10 @@ static int cmd_show(int argc, char **argv)
>>   		if (strlen(search) == 0)
>>   			usage(cmd_show_usage);
>>   		type = check_arg_type(search);
>> +		/*needs spl handling if input arg is block dev
>> +		 *And if input arg is mount-point just print it
>> +		 *right away
>> +		*/
>
> Format screwup.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
