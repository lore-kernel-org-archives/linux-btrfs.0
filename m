Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44286 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaDDOQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 10:16:41 -0400
Received: by mail-lb0-f176.google.com with SMTP id 10so2530212lbg.35
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 07:16:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <533EBDEA.4050704@fb.com>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
	<20140404135922.GV29256@twin.jikos.cz>
	<533EBDEA.4050704@fb.com>
Date: Fri, 4 Apr 2014 15:16:39 +0100
Message-ID: <CAL3q7H4dt3pMUb8D0S5=xPjmPG=o1AQn_vWO5rTGMD1UyRjfug@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 4, 2014 at 3:12 PM, Chris Mason <clm@fb.com> wrote:
>
>
> On 04/04/2014 09:59 AM, David Sterba wrote:
>>
>> On Tue, Apr 01, 2014 at 11:53:19PM +0100, Filipe David Borba Manana wrote:
>>>
>>> This implements the tmpfile callback of struct inode_operations,
>>> introduced
>>> in the linux kernel 3.11 [1], and implemented already by some
>>> filesystems.
>>
>>
>> Nice!
>>
>> Btw, would be good to mention 'O_TMPFILE' at lest in the changelog.
>>
>>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
>>
>>   CC: linuxpatches@star.c10r.facebook.com
>>
>> how many likes so far?
>
>
> He got a Nice from me ;)  That's for when a like alone won't do.
>
> It doesn't look like xfstests has an O_TMPFILE test?

It has now, if you look at Dave's latest xfstests update e-mail he
sent earlier today.
For reference, I used this for testing:
https://friendpaste.com/4n46iUoo4ZdqTAdkPntqYe (plus scrub, send,
btrfsck, etc)

>
> -chris
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
