Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46485 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbeELEjc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 May 2018 00:39:32 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fHMHU-0000ab-V0
        for linux-btrfs@vger.kernel.org; Sat, 12 May 2018 06:37:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not
 granted
Date: Sat, 12 May 2018 04:37:10 +0000 (UTC)
Message-ID: <pan$80726$5e140b8f$1befc4bf$b6d42fe5@cox.net>
References: <20180511192651.21324-1-mfasheh@suse.de>
        <20180511192651.21324-3-mfasheh@suse.de> <20180512000634.GG9510@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Darrick J. Wong posted on Fri, 11 May 2018 17:06:34 -0700 as excerpted:

> On Fri, May 11, 2018 at 12:26:51PM -0700, Mark Fasheh wrote:
>> Right now we return EINVAL if a process does not have permission to dedupe a
>> file. This was an oversight on my part. EPERM gives a true description of
>> the nature of our error, and EINVAL is already used for the case that the
>> filesystem does not support dedupe.
>> 
>> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
>> ---
>>  fs/read_write.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 77986a2e2a3b..8edef43a182c 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -2038,7 +2038,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>>  			info->status = -EINVAL;
>>  		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
>>  			     uid_eq(current_fsuid(), dst->i_uid))) {
>> -			info->status = -EINVAL;
>> +			info->status = -EPERM;
> 
> Hmm, are we allowed to change this aspect of the kabi after the fact?
> 
> Granted, we're only trading one error code for another, but will the
> existing users of this care?  xfs_io won't and I assume duperemove won't
> either, but what about bees? :)

>From the 0/2 cover-letter:

>>> This has also popped up in duperemove, mostly in the form of cryptic
>>> error messages. Because this is a code returned to userspace, I did
>>> check the other users of extent-same that I could find. Both 'bees'
>>> and 'rust-btrfs' do the same as duperemove and simply report the error
>>> (as they should).

> --D
> 
>>  		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
>>  			info->status = -EXDEV;
>>  		} else if (S_ISDIR(dst->i_mode)) {
>> -- 
>> 2.15.1
>>

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

