Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3HaFXT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 01:23:19 -0400
Message-ID: <52217F51.4000706@oracle.com>
Date: Sat, 31 Aug 2013 13:29:53 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: mkfs should check for small vol well
 before
References: <1376657550-15011-1-git-send-email-anand.jain@oracle.com> <1377852637-4299-1-git-send-email-anand.jain@oracle.com> <20130830232233.GV23113@twin.jikos.cz>
In-Reply-To: <20130830232233.GV23113@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 08/31/2013 07:22 AM, David Sterba wrote:
> On Fri, Aug 30, 2013 at 04:50:37PM +0800, Anand Jain wrote:
>> This fix the regression introduced by 830427d
>
> ie. that's
> "btrfs-progs: avoid write to the disk before sure to create fs"
>
> please note that the commit id is not stable and may change during
> integration branch updates.
>
> I was not sure if the patch is all ok and had put it into
> integration-next branch (that serves me as a unstable area for things
> that I'd like to look at again). The patch caused Josef some headaches
> and I've left it out from recent integration branches until the problems
> are resolved. With the patch in this email you do so, but let me do more
> testing and then I'll integrate it.

  Thanks for taking care of this David. Let me know if anywhere
  needs more explanation.
  I have been introducing series of device related changes in
  btrfs-progs/mkfs which were/is essential bug fix. Fixes looks
  complex since originally btrfs-progs/mkfs didn't create and
  use much of helper functions in this area, now with these
  fixes its much modular and better.


>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1964,3 +1964,32 @@ int scan_for_btrfs(int where, int update_kernel)
>> +int is_vol_small(char *file)
>> +{
>> +	int fd = -1;
>> +	int e;
>> +	struct stat st;
>> +	u64 size;
>> +
>> +	fd = open(file, O_RDONLY);
>> +	if (fd < 0)
>> +		return -errno;
>> +	if (fstat(fd, &st) < 0) {
>> +		e = -errno;
>> +		close(fd);
>> +		return e;
>> +	}
>> +	size = btrfs_device_size(fd, &st);
>> +	if (size == 0) {
>> +		close(fd);
>> +		return -1;
>> +	}
>> +	if (size < 1024 * 1024 * 1024) {
>
> Would be good to use a properly named constant instead of the magic
> number.

  Yeah I notice that, but didn't want to change from the Original.
  There are other places where this constant is needed as well,
  will spin a separate patch for that hope that's fine.

Thanks
Anand

> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
