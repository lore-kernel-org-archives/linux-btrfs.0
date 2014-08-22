Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:37019 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaHVUFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 16:05:17 -0400
Received: by mail-lb0-f180.google.com with SMTP id v6so9849680lbi.39
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 13:05:15 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, Jiri Kosina <trivial@kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fs/btrfs/tree-log.c: Fix closing brace followed by if
References: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
	<53A499B8.5050107@fb.com>
Date: Fri, 22 Aug 2014 22:05:13 +0200
In-Reply-To: <53A499B8.5050107@fb.com> (Josef Bacik's message of "Fri, 20 Jun
	2014 13:29:44 -0700")
Message-ID: <87iolkthmu.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fb.com> writes:

> On 06/20/2014 12:51 PM, Rasmus Villemoes wrote:
>> Maybe "else if" was meant, but because of the goto out_unlock, it
>> doesn't make a difference. Anyway, I chose the "only whitespace" fix.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>>   fs/btrfs/tree-log.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 9e1f2cd..50af2b9 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -3980,7 +3980,8 @@ again:
>>   		if (ret < 0) {
>>   			err = ret;
>>   			goto out_unlock;
>> -		} if (ret) {
>> +		}
>> +		if (ret) {
>>   			ins_nr = 0;
>>   			btrfs_release_path(path);
>>   			continue;
>>
>
> Nope that's right, thanks,
>
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Was this picked up? I don't see it upstream.

Thanks,
Rasmus
