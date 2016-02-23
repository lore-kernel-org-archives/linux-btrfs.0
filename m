Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35233 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbcBWR3G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 12:29:06 -0500
Received: by mail-lb0-f171.google.com with SMTP id bc4so105060369lbc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 09:29:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4fec7e2f-8464-6a2e-3096-66155f7a58fd@mokrynskyi.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
	<CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
	<4fec7e2f-8464-6a2e-3096-66155f7a58fd@mokrynskyi.com>
Date: Tue, 23 Feb 2016 18:29:04 +0100
Message-ID: <CAGGqMYQkz0FnU6TFzAqMZf9D3y2-d16xVemoLOW1sC76Eeg-ZA@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Alexander Fougner <fougner89@gmail.com>
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-02-23 18:18 GMT+01:00 Nazar Mokrynskyi <nazar@mokrynskyi.com>:
> But why? I have relatime option, it should not cause changes unless file
> contents is actually changed if I understand this option correctly.
>

*or* if it is older than 1 day. From the manpages:

relatime
              Update inode access times relative to modify or change time.
              Access time is only updated if the previous access time was
              earlier than the current modify or change time.  (Similar to
              noatime, but it doesn't break mutt or other applications that
              need to know if a file has been read since the last time it
              was modified.)

              Since Linux 2.6.30, the kernel defaults to the behavior
              provided by this option (unless noatime was specified), and
              the strictatime option is required to obtain traditional
>>>>>   semantics.  In addition, since Linux 2.6.30, the file's last
              access time is always updated if it is more than 1 day old. <<<<<

Also, if you only use relatime, then you don't need to specify it,
it's the default since 2.6.30 as mentioned above.


> Sincerely, Nazar Mokrynskyi
> github.com/nazar-pc
> Skype: nazar-pc
> Diaspora: nazarpc@diaspora.mokrynskyi.com
> Tox:
> A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8EF5261249
>
> On 23.02.16 18:05, Alexander Fougner wrote:
>>
>> 2016-02-23 17:55 GMT+01:00 Nazar Mokrynskyi <nazar@mokrynskyi.com>:
>>>>>
>>>>> What is wrong with noatime,relatime? I'm using them for a long time as
>>>>> good compromise in terms of performance.
>>>>
>>>> The one option ends up canceling the other, as they're both atime
>>>> related
>>>> options that say do different things.
>>>>
>>>> I'd have to actually setup a test or do some research to be sure which
>>>> one overrides the other (but someone here probably can say without
>>>> further research), tho I'd /guess/ the latter one overrides the earlier
>>>> one, which would effectively make them both pretty much useless, since
>>>> relatime is the normal kernel default and thus doesn't need to be
>>>> specified.
>>>>
>>>> Noatime is strongly recommended for btrfs, however, particularly with
>>>> snapshots, as otherwise, the changes between snapshots can consist
>>>> mostly
>>>> of generally useless atime changes.
>>>>
>>>> (FWIW, after over a decade of using noatime here (I first used it on the
>>>> then new reiserfs, after finding a recommendation for it on that), I got
>>>> tired of specifying the option on nearly all my fstab entries, and now
>>>> days carry a local kernel patch that changes the default to noatime,
>>>> allowing me to drop specifying it everywhere.  I don't claim to be a
>>>> coder, let alone a kernel level coder, but as a gentooer used to
>>>> building
>>>> from source for over a decade, I've found that I can often find the code
>>>> behind some behavior I'd like to tweak, and given good enough comments,
>>>> I
>>>> can often create trivial patches to accomplish that tweak, even if it's
>>>> not exactly the code a real C coder would choose to use, which is
>>>> exactly
>>>> what I've done here.  So now, unless some other atime option is
>>>> specified, my filesystems are all mounted noatime.  =:^)
>>>
>>> Well, then I'll leave relatime on root fs and noatime on partition with
>>> snapshots, thanks.
>>
>> If you snapshot the root filesystem then the atime changes will still
>> be there, and you'll be having a lot of unnecessary changes between
>> each snapshot.
>
>
