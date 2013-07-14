Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63463 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3GNOvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 10:51:08 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so10451201pbb.6
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 07:51:08 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2] Btrfs-progs: fix memory leak in open_file_or_dir()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <51E2B871.5000801@oracle.com>
Date: Sun, 14 Jul 2013 22:51:02 +0800
Cc: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        "wangsl.fnst@cn.fujitsu.com" <wangsl.fnst@cn.fujitsu.com>
Message-Id: <A7A90748-86A8-4C99-9E11-F8EEDB417CE6@gmail.com>
References: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com> <1373791722-29998-1-git-send-email-anand.jain@oracle.com> <4C2AE033-0C93-419A-9FD2-C8E0B0A7A942@gmail.com> <51E2B871.5000801@oracle.com>
To: anand jain <anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> 
> 
> On 14/07/2013 21:58, Wang Shilong wrote:
>> Hello Anand and David,
>> 
>> I use the tool valgrind to whether there exists memory leak:
>> 
>> valgrind  --tool=memcheck  --trace-origins=yes --leak-chek=full btrfs sub list /mnt
>> There still exists memory leak related to open_file_or_dir() (After applying this patch).
>> 
>> I guess it is because we should call closedir(dirstram) rather than close(fd) if opening a directory.
>> Maybe we can make open_file_or_dir() something like:
> 
>> open_file_or_dir(char *name, DIR **dirstream)
>> 
>> if we opened a directory, we close it by calling closeidr(dirstream).
>> elsewise, close(fd) is ok!..
>> 
>> I am wondering why close(fd) can not just finish this work¡­¡­
> 
> now I get your broader point of view. For some reason it
> gave me an impression you are trying to handle a proper
> cleanup operation if when dirfd(dirstream) fails and below
> patch would just address that.
> 
> Now when open_file_or_dir() is successful we still need a
> proper closing code.  May be its a good idea to write a new
> patch to include that.. it touches a lot of places.

Yeah, i try to do something like:

open_file_or_dir(char *name, DIR **dirstream)

It really touches a lot of places.. So i hesitate if there is a better method to
do this..

Thanks
Wang
> 
> Thanks, Anand
> 
> 
>> Thanks,
>> Wang
>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> 
>>> After calling opendir() successfully, closedir() should be
>>> also called to free memory. Otherwise, memory leak happens.
>>> 
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> Reviewed-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> utils.c |    6 ++++--
>>> 1 files changed, 4 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/utils.c b/utils.c
>>> index d3bec9b..4b3c778 100644
>>> --- a/utils.c
>>> +++ b/utils.c
>>> @@ -1503,7 +1503,7 @@ int open_file_or_dir(const char *fname)
>>> {
>>> 	int ret;
>>> 	struct stat st;
>>> -	DIR *dirstream;
>>> +	DIR *dirstream = NULL;
>>> 	int fd;
>>> 
>>> 	ret = stat(fname, &st);
>>> @@ -1520,7 +1520,9 @@ int open_file_or_dir(const char *fname)
>>> 		fd = open(fname, O_RDWR);
>>> 	}
>>> 	if (fd < 0) {
>>> -		return -3;
>>> +		fd = -3;
>>> +		if (dirstream)
>>> +			closedir(dirstream);
>>> 	}
>>> 	return fd;
>>> }
>>> -- 
>>> 1.7.7.6
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 

