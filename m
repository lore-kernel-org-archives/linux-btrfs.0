Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2GaCJp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 22:09:45 -0400
Received: by pbbrp8 with SMTP id rp8so10818342pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 19:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50173463.5060405@cn.fujitsu.com>
References: <CA+=FuiWE4QVFrbTY_dQyABABJyvD=xtpEFKe4Ob9pqeZQ9NysA@mail.gmail.com>
	<1343696005-23703-1-git-send-email-alexander.karbstein@gmail.com>
	<50173463.5060405@cn.fujitsu.com>
Date: Tue, 31 Jul 2012 04:09:45 +0200
Message-ID: <CA+=FuiXwBp1kL9z04UOnZ4sqkPLZS=D21XQ4yjxYQQXpHg69ZQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: Enabled setting root subvolume with subvolid=0
From: Alexander Karbstein <alexander.karbstein@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Liu,

thanks, you are so right. I just got it exactly the wrong way (I read
btrfs-progs-unstable and thought this must be the bleeding edge one
;-). I should have read your e-Mail before.
I will revise it asap. But I have to let it wait for tomorrow... Gotta
sleep now.

Best Regards,
Alex


2012/7/31 Liu Bo <liubo2009@cn.fujitsu.com>:
> On 07/31/2012 08:53 AM, Alexander Karbstein wrote:
>
>> The command btrfs subvolume set-default 0 /path/to/fs changed the
>> default subvolume to whatever subvolume was currently mounted on
>> /path/to/fs. This patch changes this behaviour to set the default
>> subvolume to BTRFS_FS_TREE_OBJECTID in case the user asks for
>> subvolid=0
>>
>
>> Signed-off-by: Alexander Karbstein <alexander.karbstein@gmail.com>
>> ---
>>  btrfs_cmds.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
>> index f2b6355..699d9b0 100644
>> --- a/btrfs_cmds.c
>> +++ b/btrfs_cmds.c
>> @@ -964,6 +964,11 @@ int do_set_default_subvol(int nargs, char **argv)
>>               fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
>>               return 30;
>>       }
>> +
>> +     /* Using the original root fs tree */
>> +     if (objectid == 0ULL) {
>> +             objectid = BTRFS_FS_TREE_OBJECTID;
>> +     }
>>       ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
>>       e = errno;
>>       close(fd);
>
>
> Seems that you're using an old btrfs-prog source code, now the file is cmds-subvolume.c
>
> And also checkpatch.pl complains about style errors while checking this.
>
> thanks,
> liubo
