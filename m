Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61605 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbaBCR2H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 12:28:07 -0500
Message-ID: <52EFD19C.3050404@fb.com>
Date: Mon, 3 Feb 2014 12:27:56 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: disable snapshot aware defrag for now
References: <1391029530-17686-1-git-send-email-jbacik@fb.com> <20140203144802.GK1364@twin.jikos.cz>
In-Reply-To: <20140203144802.GK1364@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/03/2014 09:48 AM, David Sterba wrote:
> On Wed, Jan 29, 2014 at 04:05:30PM -0500, Josef Bacik wrote:
>> It's just broken and it's taking a lot of effort to fix it, so for now just
>> disable it so people can defrag in peace.  Thanks,
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>   fs/btrfs/inode.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 3b65987..8c0bc31 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -2628,7 +2628,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>>   			EXTENT_DEFRAG, 1, cached_state);
>>   	if (ret) {
>>   		u64 last_snapshot = btrfs_root_last_snapshot(&root->root_item);
>> -		if (last_snapshot >= BTRFS_I(inode)->generation)
>> +		if (0 && last_snapshot >= BTRFS_I(inode)->generation)
> That's not very flexible, how are we supposed to test that in the
> meantime? Editing sources is not the peferred way.

Well since I'm the only one currently working on fixing it I'm not 
worried about it.  If anybody else wants to fix it they can easily 
change it themselves.  It is so totally broken that I don't want it 
being turned on by anybody who can't edit this and change it 
themselves.  Thanks,

Josef
