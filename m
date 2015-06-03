Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25426 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbbFCHt6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 03:49:58 -0400
Message-ID: <556EB19D.6010807@oracle.com>
Date: Wed, 03 Jun 2015 15:49:49 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: avoid duplicate checks on user provided
 devid
References: <1433139918-820-1-git-send-email-anand.jain@oracle.com> <20150602151234.GH6761@twin.jikos.cz>
In-Reply-To: <20150602151234.GH6761@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/02/2015 11:12 PM, David Sterba wrote:
> On Mon, Jun 01, 2015 at 02:25:17PM +0800, Anand Jain wrote:
>> kernel is already checking it (rightly), we don't need to check that in the user land.
>
> Sometimes it's useful to duplicate the checks in userspace because we
> can fail early and return the error message directly, compared to
> messages in syslog or a simple errno.

  right. But here what do you feel about the gain obtained vs additional
  code thats required ?

  My take: get_fs_info() calls check_mounted_where() which in turn calls
  btrfs_scan_lblkid(), which is system wide scan of all block devices,
  thats heavy weight.

  My past tests showed visible delay/jitter in the output of
  'btrfs fi show -d' when btrfs scrub is running. The main culprit
  is check_mounted_where calling btrfs_scan_lblkid. so its recommend
  to run get_fs_info() only if required.

> Have you observed that the userspace checks were problematic?

  Nope. Just a cleanup. With this patch cmd_start_replace() would
  should match with cmd_rm_dev().
  As both 'btrfs dev del <devid> ..' and 'btrfs replace start <devid> .."
  intentions are same, so theoretically up to certain extent their codes
  should match.

>> @@ -214,33 +213,7 @@ static int cmd_start_replace(int argc, char **argv)
>>   	}
>>
>>   	if (is_numerical(srcdev)) {
>> -		struct btrfs_ioctl_fs_info_args fi_args;
>> -		struct btrfs_ioctl_dev_info_args *di_args = NULL;
>> -
>>   		start_args.start.srcdevid = arg_strtou64(srcdev);
>> -
>> -		ret = get_fs_info(path, &fi_args, &di_args);
>
> This does additional checks, like checking where it's mounted.

  in this part of the if statement srcdev is <num> and is devid.
  get_fs_info check does not help.

  What did I miss ?

Thanks Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
