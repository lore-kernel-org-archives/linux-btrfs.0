From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] FS: btrfs, use helpers for rlimits
Date: Fri, 03 Sep 2010 10:23:23 +0200
Message-ID: <4C80B07B.7050102@suse.cz>
References: <1265832009-8070-1-git-send-email-jslaby@suse.cz> <20100210200134.GK18175@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100210200134.GK18175@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2010 09:01 PM, Chris Mason wrote:
> Thanks, I have this queued up for .34

Hi, this is still not merged. Was it lost?

> On Wed, Feb 10, 2010 at 09:00:09PM +0100, Jiri Slaby wrote:
>> Make sure compiler won't do weird things with limits. E.g. fetching
>> them twice may return 2 different values after writable limits are
>> implemented.
>>
>> I.e. either use rlimit helpers added in
>> 3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
>> or ACCESS_ONCE if not applicable.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Chris Mason <chris.mason@oracle.com>
>> Cc: linux-btrfs@vger.kernel.org
>> ---
>>  fs/btrfs/inode.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index c41db6d..5aa0cef 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -3256,8 +3256,7 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
>>  		return 0;
>>  
>>  	if (attr->ia_size > inode->i_size) {
>> -		unsigned long limit;
>> -		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
>> +		unsigned long limit = rlimit(RLIMIT_FSIZE);
>>  		if (attr->ia_size > inode->i_sb->s_maxbytes)
>>  			return -EFBIG;
>>  		if (limit != RLIM_INFINITY && attr->ia_size > limit) {
>> -- 
>> 1.6.6.1
>>


-- 
js
suse labs
