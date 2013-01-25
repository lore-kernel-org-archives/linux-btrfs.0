Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab3AYPcK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:32:10 -0500
Message-ID: <5102A571.8030608@redhat.com>
Date: Fri, 25 Jan 2013 09:32:01 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs-progs: remove btrfsctl, btrfs-show and btrfs-vol
 from default build
References: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de> <51027339.9030604@czarc.net>
In-Reply-To: <51027339.9030604@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/25/13 5:57 AM, Gene Czarcinski wrote:
> On 06/08/2012 02:00 PM, Stefan Behrens wrote:
>> Remove btrfsctl, btrfs-show and btrfs-vol from "all" target of Makefile.

TBH, unless there are objections, I'd rather remove the source files as well.

Having unbuilt source code lying around is potentially even more confusing.

I'd at least move it to a deprecated/ subdir or something, but it'll only
fester and die there as well.  I'd just remove it, if it's time to do so.

Are they fully deprecated?  Is there anything these tools do that btrfs
does not?

-Eric

>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>   Makefile |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index aaf1381..79e7a56 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -18,7 +18,7 @@ bindir = $(prefix)/bin
>>   LIBS=-luuid
>>   RESTORE_LIBS=-lz
>>
>> -progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
>> +progs = mkfs.btrfs btrfs-debug-tree btrfsck \
>>       btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
>>       btrfs-find-root btrfs-restore btrfstune
>>
>>
> I agree.  It is time to remove these old programs; they serve no useful purpose; and they complicate maintenance.
> 
> Gene
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

