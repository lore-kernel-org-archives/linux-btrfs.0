Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38855 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3KDDle (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 22:41:34 -0500
Message-ID: <52771766.7020401@oracle.com>
Date: Mon, 04 Nov 2013 11:41:26 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: lblkid wouldn't find non mapper path input
References: <1383064490-28875-1-git-send-email-anand.jain@oracle.com> <20131029164019.GG4543@localhost.localdomain>
In-Reply-To: <20131029164019.GG4543@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks for the comments. Sorry for the delay. more inline
  below. V2 has been sent out.



On 10/30/13 12:40 AM, Josef Bacik wrote:
> On Wed, Oct 30, 2013 at 12:34:50AM +0800, Anand Jain wrote:
>> A new test case when disk is unmounted and if the non mapper
>> disk path is given as the argument to the btrfs filesystem show<arg>
>> we still need this to work but lblkid will pull only mapper disks,
>> it won't match. So this will normalize the input to find btrfs
>> by fsid and pass it to the search.
>>
>> Signed-off-by: Anand Jain<anand.jain@oracle.com>
>> ---
>>   cmds-filesystem.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
>>   1 files changed, 49 insertions(+), 3 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index fcabdb0..3a494fd 100644
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
>
> No magic numbers.

yep. but it followed the tradition

# egrep 37 *.c | egrep char | wc -l
14

later I shall write a new patch to change all 14 together
including this.

>>   	while (1) {
>>   		int long_index;
>> @@ -480,11 +516,21 @@ static int cmd_show(int argc, char **argv)
>>   				if (!ret)
>>   					/* given block dev is mounted*/
>>   					search = mp;
>> -				else
>> +				else {
>
> This isn't the right format, needs to add braces for the if part too.

  ok. fixed it. (looks like checkpatch.pl needs an update which failed
  to catch this).


>> +					ret = dev_to_fsid(search, fsid);
>> +					if (ret) {
>> +						fprintf(stderr,
>> +							"ERROR: No btrfs on %s\n",
>> +							search);
>> +						return 1;
>> +					}
>> +					uuid_unparse(fsid, uuid_buf);
>> +					search = uuid_buf;
>> +					type = BTRFS_ARG_UUID;
>>   					goto devs_only;
>> +				}
>>   			}
>> -		}
>> -		if (type == BTRFS_ARG_MNTPOINT) {
>> +		} else if (type == BTRFS_ARG_MNTPOINT) {
>
> This looks like it will break something if we fall through from above?  Thanks,


  Thanks for the comments. I reviewed again and I don't think so,
  here we need special handle if the input is a block dev
  (additionally if input is a mount-point we just want to finish
  the job). For rest of the input types (uuid or unknown => which could
  be a label) no special handling is required, just a fall though is
  fine. I have added the additional comments in the code.

Thanks Anand


> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
