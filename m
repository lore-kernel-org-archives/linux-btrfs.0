Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38613 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbJYNmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 09:42:55 -0400
Received: by igbdj2 with SMTP id dj2so41363280igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2015 06:42:54 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <c84e02ac-4e81-4a11-b8d8-3660d3e0eb77@aei.ca>
References: <20151024173617.GA26012@nbnb1>
	<CAL3q7H5H_Qdq0NAhiDOVw=JLYPJPuHhhSZPgUSQm=oYN+yXK=g@mail.gmail.com>
	<c84e02ac-4e81-4a11-b8d8-3660d3e0eb77@aei.ca>
Date: Sun, 25 Oct 2015 13:42:54 +0000
Message-ID: <CAL3q7H4UGXsOOFoTVcw6=EsEaroT3nCwandenJXOhdxiaBVAdw@mail.gmail.com>
Subject: Re: btrfs double send
From: Filipe Manana <fdmanana@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: kolcon@kolcon.net,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 25, 2015 at 1:38 PM, Ed Tomlinson <edt@aei.ca> wrote:
> Filipe,
>
> Its still not perfect.  Here I can do sequential sends a few times then I
> get something like this:
>
> [root@grover snap]# sh -x brh
> + base=/snap/shot
> ++ date +%Y-%V-%u_%m-%d_%H:%M
> + stamp=2015-43-6_10-24_10:24
> + btrfs subv snapshot -r /snap/homevol /snap/shot.2015-43-6_10-24_10:24
> Create a readonly snapshot of '/snap/homevol' in
> '/snap/shot.2015-43-6_10-24_10:24'
> + sync
> + /usr/bin/time -f 'send %E' nice -19 ionice -c3 btrfs send -v -p /snap/shot
> /snap/shot.2015-43-6_10-24_10:24
> + btrfs receive -v /backup/snap
> At subvol /snap/shot.2015-43-6_10-24_10:24
> At snapshot shot.2015-43-6_10-24_10:24
> receiving snapshot shot.2015-43-6_10-24_10:24
> uuid=cb3ad856-ca0f-f744-b7c3-b33f2d5bc8d3, ctransid=625267
> parent_uuid=cb3ad856-ca0f-f744-b7c3-b33f2d5bc8d3, parent_ctransid=619893
> ERROR: unlink home/ed/Maildir/.spam/dovecot.index.log.2 failed. No such file
> or directory
> Command terminated by signal 13
> send 1:49.64
> + sync
> + btrfs subv delete /snap/shot
> Delete subvolume (no-commit): '/snap/shot'
> + sync
> + mv /snap/shot.2015-43-6_10-24_10:24 /snap/shot
>
>
> so there is another bug hiding in the code, its usually something in my
> Maildir that shows in the log.

Different and unrelated problem.
Yes, we know there are still some problems regarding send issuing
invalid/outdated paths to the send stream. Nothing to do with
incorrect uuids in the send stream.

>
> Please let me know if there is anything you would like me to try.  I am
> running 4.2 with the 4.3 for-linus tree applied and the 4.2.x patches with
> btrfs fixes removed.  On top of this are a few patches from this list.
>
> TIA
> Ed Tomlinson
>
> On Saturday, October 24, 2015 1:52:21 PM EDT, Filipe Manana wrote:
>>
>> On Sat, Oct 24, 2015 at 6:36 PM,  <kolcon@kolcon.net> wrote:
>>>
>>> Hello,
>>>
>>> I would like to do backups based on btrfs send/receive.
>>>
>>> So I though I would do a transfer over portable HDD and then incremental
>>> sends (using -p) over network.
>>>
>>> Initial : ...
>>
>>
>> It's a bug, we got it recently reported and fixed.
>> The fix is in Chris' integration branch for the upcoming 4.4 merge window:
>>
>>
>> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.4&id=b96b1db039ebc584d03a9933b279e0d3e704c528
>>
>> cheers
>>>
>>>
>>> Best regards,
>>>
>>> Lubos
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
