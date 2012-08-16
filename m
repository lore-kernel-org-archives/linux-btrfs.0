Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50997 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2HPFxM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 01:53:12 -0400
Message-ID: <502C8ABC.2000202@oracle.com>
Date: Thu, 16 Aug 2012 13:53:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: use helper for logical resolve
References: <1345092166-7089-1-git-send-email-bo.li.liu@oracle.com> <1345092166-7089-2-git-send-email-bo.li.liu@oracle.com> <502C80DE.3030008@jan-o-sch.net>
In-Reply-To: <502C80DE.3030008@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/16/2012 01:10 PM, Jan Schmidt wrote:
> On Thu, August 16, 2012 at 06:42 (+0200), Liu Bo wrote:
>> We already have a helper, iterate_inodes_from_logical(), for logical resolve,
>> so just use it.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>  fs/btrfs/ioctl.c |   20 +++-----------------
>>  1 files changed, 3 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 405b279..f1ff21a 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
[...]
>> -	extent_item_pos = loi->logical - key.objectid;
>> -	ret = iterate_extent_inodes(root->fs_info, key.objectid,
>> -					extent_item_pos, 0, build_ino_list,
>> -					inodes);
>> -
>> +	path->search_commit_root = 0;
> 
> I came across that search_commit_root as well when re-reading
> iterate_inodes_from_logical. Wouldn't explicitly set the default value here,
> though. We don't do it before each and every call to btrfs_search_slot, either.
> 

ok, will remove the redundant default set.

>> +	ret = iterate_inodes_from_logical(loi->logical, root->fs_info, path,
>> +					  build_ino_list, inodes);
> 
> To maintain the current behavior, we should patch -EINVAL to -ENOENT here.
> 

oops, I should have noticed it.

Thanks for the comments, Jan :)

thanks,
liubo

