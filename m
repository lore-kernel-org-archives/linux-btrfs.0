Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:52114 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab2JZDWr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 23:22:47 -0400
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by m199-177.yeah.net (HMail) with ESMTPA id 809461001A8
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 11:22:44 +0800 (CST)
Received: by mail-la0-f46.google.com with SMTP id h6so2156043lag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 20:22:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025151801.GG10679@twin.jikos.cz>
References: <CAMRmmpLvLEC_SayRxBJHs=-sunrn_oA6Cy=-pRd+s1v4XDE24g@mail.gmail.com>
 <20121025151801.GG10679@twin.jikos.cz>
From: Rock Lee <zimilo@code-trick.com>
Date: Fri, 26 Oct 2012 11:22:01 +0800
Message-ID: <CAMRmmp+HMgd6pgHk313qQgUK7atftBTGE7rcuN9q1Agx02a3Ng@mail.gmail.com>
Subject: Re: [BUG][PATCH][BTRFS-PROGS] Bug overflow fix
To: dave@jikos.cz, Rock Lee <zimilo@code-trick.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, I will improve the patch to get it better.

Thanks,
- Rock

2012/10/25 David Sterba <dave@jikos.cz>:
> On Wed, Oct 24, 2012 at 04:24:02PM +0800, Rock Lee wrote:
>> If there's is a long name directory exists in the /dev, then an
>> overflow will hit in function utils.c btrfs_scan_one_dir:1013!
>>
>> The minimal fix is to use snprintf instead of strcpy.
>>
>> The reason why not using strncpy is that, if there is no null byte
>> among the first n bytes of src, the string  placed  in  dest
>> will not be null - terminated.
>>
>> ---
>> index 3c88d2e..7200aef 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -969,7 +969,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
>>       pending = malloc(sizeof(*pending));
>>       if (!pending)
>>               return -ENOMEM;
>> -     strcpy(pending->name, dirname);
>> +     snprintf(pending->name, sizeof(pending->name), "%s", dirname);
>
> pending is defined as
>
> 919 struct pending_dir {
> 920         struct list_head list;
> 921         char name[256];
> 922 };
>
> and name is supposed to hold a full path, so it should be of PATH_MAX
> (4096) size, 256 is a limit for a single filename.
>
> There's another hardcoded value for a path
>
> 971         dirname_len = strlen(pending->name);
> 972         pathlen = 1024;
> ^^^
> 973         fullpath = malloc(pathlen);
> 974         dirname = pending->name;
>
> that shuld be of PATH_MAX size.
>
> thanks,
> david
