Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbeGLGmz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 02:42:55 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
To: Pete <pete@petezilla.co.uk>, Martin Raiber <martin@urbackup.org>,
        linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
 <010201648357d71c-04a86c88-517f-4aca-904b-ba94aae5d99f-000000@eu-west-1.amazonses.com>
 <d8905b5a-a2cc-605c-a5c8-e295a683d8b9@petezilla.co.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f2a31092-4ba6-f319-d8fa-64f6e96bac02@suse.com>
Date: Thu, 12 Jul 2018 09:34:45 +0300
MIME-Version: 1.0
In-Reply-To: <d8905b5a-a2cc-605c-a5c8-e295a683d8b9@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.07.2018 23:59, Pete wrote:
> On 07/10/2018 09:38 AM, Martin Raiber wrote:
> 
>> This is probably a known issue. See
>> https://www.spinics.net/lists/linux-btrfs/msg75647.html
>> You could apply the patch in this thread and mount with enospc_debug to
>> confirm it is the same issue.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> OK, I've applied the patch, by hand, and hopefully put it in the right
> place.  Need to learn to patch better.
> 
> Booted the (rebuilt with make ; make modules_install syslinux etc)
> kernel with the option enospc_debug for the two btrfs file systems (1st
> entry for each in fstb.  I was not expecting to get the issue to appear
> quickly as it took several days to hit previously.  However, on checking
> I see another error, not sure if it is related, still is in extent-tree.c.
> 
> https://drive.google.com/file/d/1K12MfpWFB1aHSXBga1Rym5terbmHeDfI/view?usp=sharing

This is just a warn_on saying that btrfs didn't manage to reserve space
for a CoW operation on the checksum tree ( so metadata). But did your
machine crash at that time, i.e why don't you paste the text but post
images?

> 
> 
> Pete
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
