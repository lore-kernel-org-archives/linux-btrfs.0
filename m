Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:47937 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaJPHB7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 03:01:59 -0400
Received: by mail-la0-f44.google.com with SMTP id hs14so2354832lab.17
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 00:01:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <543F213F.5090308@jp.fujitsu.com>
References: <541BED3D.5020803@jp.fujitsu.com>
	<20140929163646.GF11436@twin.jikos.cz>
	<543F213F.5090308@jp.fujitsu.com>
Date: Thu, 16 Oct 2014 08:01:57 +0100
Message-ID: <CAL3q7H4RGcyiejS9JsD7bvF1N4uGPerumEsezceW_HN__yY3Dg@mail.gmail.com>
Subject: Re: [PATCH 1/4] btrfs: correct empty compression property behavior
From: Filipe David Manana <fdmanana@gmail.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>,
        naota <naota@elisp.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2014 at 2:37 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
> Hi David and Chris,
>
> (2014/09/29 18:36), David Sterba wrote:
>>
>> On Fri, Sep 19, 2014 at 05:45:49PM +0900, Satoru Takeuchi wrote:
>>>
>>> In the current implementation, compression property == "" has
>>> the two different meanings: one is with BTRFS_INODE_NOCOMPRESS,
>>> and the other is without this flag.
>>>
>>> So, even if the two files a and b have the same compression
>>> property, "", and the same contents, one file seems to be
>>> compressed and the other is not. It's difficult to understand
>>> for users and also confuses them.
>>
>>
>> Fixing this inconsistency is good, let me think more about the
>> interface.
>
>
> How about these patches? These patches seems not to be merged yet.
> Especially patch 4/4 resolve the bug that atomic two operations
> are separated to the different two transactions. I consider this
> patch should be applied as soon as possible.

Why do you think the possibility of 2 transactions being used are such
a terrible thing that needs immediate attention?

If the first transaction ends up getting committed after calling
btrfs_end_transaction(), and an error (or a crash/reboot) happens
before the second transaction, userspace gets an error and gets to
know the changes weren't fully applied (and the sensible action is to
retry the ioctl later).
The worst it can happen is leaving some compression xattr or flag on
disk after the first transaction commit. But that doesn't prevent
userspace from doing file/directory operations nor much less causes
any data loss or corruption, nor does it cause any metadata
inconsistency reported by btrfsck or scrub for e.g.. So leaving
compression on/off is transparent thing that doesn't affect user
operations.

You can my Reviewed-by: Filipe Manana <fdmanana@suse.com> to the
series if you want.

thanks

>
> Thanks,
> Satoru
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
