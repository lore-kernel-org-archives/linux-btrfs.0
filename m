From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Mon, 29 Nov 2010 13:12:17 -0800
Message-ID: <AANLkTinZtB3o5QXQdwW8-qO6YhJDTLOotrHXD5E2Booo@mail.gmail.com>
References: <4CEE31EF.1020102@cn.fujitsu.com>
	<20101129201017.GB2618@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101129201017.GB2618@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 12:10 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Nov 25, 2010 at 05:52:47PM +0800, Miao Xie wrote:
>> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant =
panic.
>> Meanwhile, they are very ugly and should be handled more propriately=
=2E
>>
>> There are mainly two ways to deal with these BUG_ON()s.
>>
>> 1. For those errors which can be handled well by callers, we just re=
turn their
>> error number to callers.
>>
>> 2. For others, We can force the filesystem readonly when it hits err=
ors, which
>> =C2=A0is what this patchset has done. Replaced BUG_ON() with the int=
erface provided
>> =C2=A0in this patchset, we will get error infomation via dmesg. Sinc=
e btrfs is now
>> readonly, we can save our data safely and umount it, then a btrfsck =
is
>> recommended.
>>
>> By these ways, we can protect our filesystem from panic caused by th=
ose
>> BUG_ONs.
>>
>> ---
>> =C2=A0fs/btrfs/ctree.h =C2=A0 =C2=A0 =C2=A0 | =C2=A0 21 ++++++++++
>> =C2=A0fs/btrfs/disk-io.c =C2=A0 =C2=A0 | =C2=A0 23 +++++++++++
>> =C2=A0fs/btrfs/super.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0100 ++++++++++++=
++++++++++++++++++++++++++++++++++-
>> =C2=A0fs/btrfs/transaction.c | =C2=A0 =C2=A07 +++
>> =C2=A04 files changed, 148 insertions(+), 3 deletions(-)
>>
>
> Overall seems sane, but what about kernels that don't make these chec=
ks? =C2=A0I'm ok
> with "well sucks for them" as an answer, just want to make sure we've=
 at least
> though about it.
>
> Also I'm not sure marking the fs as broken is the right move here. =C2=
=A0Ext3/4 don't
> do this, they just mount read-only, as long as you can still unmount =
the
> filesystem everything comes out ok. =C2=A0Think of the case where we =
just get a
> spurious EIO, the fs should be fine the next time around, there's rea=
son to
> force the user to run fsck in this case.
>

Did you mean "there's no reason to"?

Also I guess you mean this in the case when there is no redundancy
(single and raid0) as the other cases should recover from spurious EIO
at run time.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
