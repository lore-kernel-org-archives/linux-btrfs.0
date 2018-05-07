Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57392 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751831AbeEGCQs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 22:16:48 -0400
Subject: Re: [PATCH v2 08/10] btrfs-progs: undelete-subvol: add
 undelete-subvol subcommand
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-9-lufq.fnst@cn.fujitsu.com>
 <13f077b1-7128-cf95-5972-383030aa1114@gmx.com>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <94bb4dcb-699e-7605-5e40-5f8f56a9133c@cn.fujitsu.com>
Date: Mon, 7 May 2018 10:16:43 +0800
MIME-Version: 1.0
In-Reply-To: <13f077b1-7128-cf95-5972-383030aa1114@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/18/2018 01:32 PM, Qu Wenruo wrote:
> 
> 
> On 2018年03月27日 15:06, Lu Fengqi wrote:
>> Add the undelete-subvol subcommand for btrfs rescue. This subcommand is
>> used to recover deleted subvolume left intact on the device.
>>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>> v2: add -s option to specify subvol_id.
>>
>>   cmds-rescue.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 70 insertions(+)
>>
>> diff --git a/cmds-rescue.c b/cmds-rescue.c
>> index c40088ad374e..c5132126e922 100644
>> --- a/cmds-rescue.c
>> +++ b/cmds-rescue.c
>> @@ -25,6 +25,7 @@
>>   #include "disk-io.h"
>>   #include "commands.h"
>>   #include "utils.h"
>> +#include "undelete-subvol.h"
>>   #include "help.h"
>>   
>>   static const char * const rescue_cmd_group_usage[] = {
>> @@ -248,6 +249,73 @@ out:
>>   	return !!ret;
>>   }
>>   
>> +static const char * const cmd_rescue_undelete_subvol_usage[] = {
>> +	"btrfs rescue undelete-subvol [-s <subvolid>] <device>",
>> +	"Undelete deleted subvolume",
>> +	"All deleted subvolume that still left intact on the device will be",
>> +	"recovered. If -s <subvolid> option is given, then just recover the",
>> +	"subvolume which specified by <subvolid>.",
>> +	"",
>> +	"-s <subvolid>	specify the subvolume which will be recovered.",
>> +	NULL
>> +};
>> +
>> +static int cmd_rescue_undelete_subvol(int argc, char **argv)
>> +{
>> +	struct btrfs_fs_info *fs_info;
>> +	char *devname;
>> +	u64 subvol_id = 0;
>> +	int ret;
>> +
>> +	while (1) {
>> +		int c = getopt(argc, argv, "s:");
>> +
>> +		if (c < 0)
>> +			break;
>> +		switch (c) {
>> +		case 's':
>> +			subvol_id = arg_strtou64(optarg);
>> +			if (!is_fstree(subvol_id)) {
>> +				error("%llu is not a valid subvolume id",
>> +						subvol_id);
>> +				ret = -EINVAL;
>> +				goto out;
>> +			}
>> +			break;
>> +		default:
>> +			usage(cmd_rescue_undelete_subvol_usage);
>> +		}
>> +	}
>> +
>> +	if (check_argc_exact(argc - optind, 1))
>> +		usage(cmd_rescue_undelete_subvol_usage);
>> +
>> +	devname = argv[optind];
>> +	ret = check_mounted(devname);
>> +	if (ret < 0) {
>> +		error("could not check mount status: %s", strerror(-ret));
>> +		goto out;
>> +	} else if (ret) {
>> +		error("%s is currently mounted", devname);
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	fs_info = open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES |
>> +				     OPEN_CTREE_PARTIAL);
> 
> I'm not sure if using OPEN_CTREE_PARTIAL here is a good idea.
> 
> As the undelete-subvol looks like a tool to revert stupid user mistake,
> and we expect a healthy fs to be provided.
> And for corrupted fs, we may make the case worse.

Make sense. The flag shouldn't be set here.

-- 
Thanks,
Lu

> 
> Thanks,
> Qu
> 
>> +	if (!fs_info) {
>> +		error("could not open btrfs");
>> +		ret = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	ret = btrfs_undelete_intact_subvols(fs_info->tree_root, subvol_id);
>> +
>> +	close_ctree(fs_info->tree_root);
>> +out:
>> +	return ret;
>> +}
>> +
>>   static const char rescue_cmd_group_info[] =
>>   "toolbox for specific rescue operations";
>>   
>> @@ -260,6 +328,8 @@ const struct cmd_group rescue_cmd_group = {
>>   		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
>>   		{ "fix-device-size", cmd_rescue_fix_device_size,
>>   			cmd_rescue_fix_device_size_usage, NULL, 0},
>> +		{ "undelete-subvol", cmd_rescue_undelete_subvol,
>> +			cmd_rescue_undelete_subvol_usage, NULL, 0},
>>   		NULL_CMD_STRUCT
>>   	}
>>   };
>>
> 



