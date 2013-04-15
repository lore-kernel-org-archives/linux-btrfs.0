Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47782 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3DOGqT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:46:19 -0400
Message-ID: <516BA278.6000400@oracle.com>
Date: Mon, 15 Apr 2013 14:47:20 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/9] btrfs-progs: mkfs should first check all disks before
 writing to a disk
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com> <1365141303-10571-4-git-send-email-anand.jain@oracle.com> <20130412160619.GZ18193@twin.jikos.cz>
In-Reply-To: <20130412160619.GZ18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/13/2013 12:06 AM, David Sterba wrote:
> On Fri, Apr 05, 2013 at 01:54:57PM +0800, Anand Jain wrote:
>> In the cases where one of the disk is not suitable for
>> btrfs, then we would fail the mkfs, however we determine
>> that after we have written btrfs to the preceding disks.
>> At this time if user changes mind for not to use btrfs
>> will left with no choice.
>>
>> So this patch will check if all the provided disks are
>> suitable for the btrfs at once before proceeding to
>> create btrfs on a disk.
>
> Good fix and cleanup.
>
>> +void __test_dev_for_mkfs(char *file, int force_overwrite)
>> +{
>> +	int ret, fd;
>> +
>> +	ret = is_swap_device(file);
>> +	if (ret < 0) {
>> +		fprintf(stderr, "error checking %s status: %s\n", file,
>> +			strerror(-ret));
>> +		exit(1);
>
> The exit()s were ok when this code was in main(), but should be
> converted to return for a helper function.

  I got this integrated in v2.


>> +	}
>>   int main(int ac, char **av)
>>   {
>>   	char *file;
>> @@ -1378,6 +1418,8 @@ int main(int ac, char **av)
>>   	char *pretty_buf;
>>   	struct btrfs_super_block *super;
>>   	u64 flags;
>> +	int dev_cnt=0;
>
> 	int dev_cnt = 0;
>
>> +	int saved_optind;
>>
>>   	while(1) {
>>   		int c;
>> +	dev_cnt = ac - optind;
>> +	if (dev_cnt == 0)
>>   		print_usage();
>>
>> +	if (source_dir_set && dev_cnt > 1) {
>> +		fprintf(stderr,
>> +			"The -r option is limited to a single device\n");
>> +		exit(1);
>> +	}
>> +	while (dev_cnt-- > 0) {
>> +		file = av[optind++];
>> +		/* following func would exit on error */
>> +		if (is_block_device(file))
>> +			__test_dev_for_mkfs(file, force_overwrite);
>
> Catch errors here and exit() eventually.
>
>> +	}
>> +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
