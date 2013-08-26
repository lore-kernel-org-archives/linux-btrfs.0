Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3HZWCi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 18:02:38 -0400
Message-ID: <521BD07B.2050600@redhat.com>
Date: Mon, 26 Aug 2013 17:02:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <20130826215326.GH26818@lenny.home.zabbo.net>
In-Reply-To: <20130826215326.GH26818@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/26/13 4:53 PM, Zach Brown wrote:
>> With this we can
>> go through and convert any BUG_ON()'s that we have to catch actual programming
>> mistakes to the new ASSERT() and then fix everybody else to return errors.
> 
> I like the sound of that!
> 
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3814,6 +3814,22 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
>>  #define btrfs_debug(fs_info, fmt, args...) \
>>  	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
>>  
>> +#ifdef BTRFS_ASSERT
>> +
>> +static inline void assfail(char *expr, char *file, int lin)
>> +{
>> +	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
>> +	       expr, file, line);
>> +	BUG();
>> +}
> 
> I'm not sure why this is needed.

I think it's because we'd like to see the assertion that failed in plain text,
which then would need a function as above, but we'd rather not see that
_every_ ASSERT() failure was at the line of the BUG() in the helper function...

i.e. when xfs trips it does this:

XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),
file: fs/xfs/xfs_trans_buf.c, line: 568
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:108!

note the 2 different line numbers; 568 is what's relevant, 108 is not.

>> +#define ASSERT(expr)	\
>> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> 
> (Passing the assertion is unlikely()?  I know, this is from xfs...
> still.)

hah, that's great.

>> +#else
>> +#define ASSERT(expr)	((void)0)
>> +#endif
> 
> Anyway, if you're going to do it this way, why not:
> 
> 	#ifdef BTRFS_ASSERT
> 	#define btrfs_assert(cond)  BUG_ON(!(cond))
> 	#else
> 	#define btrfs_assert(cond)  do { if (cond) ; } while (0)
> 	#endif

I think the only downside is that the BUG_ON() won't print the
conditional that failed, IIRC.

-Eric

> ?
> 
> - z

