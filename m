From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: do not loop through raid types when looking for
 free extent
Date: Tue, 14 Dec 2010 09:54:12 +0800
Message-ID: <AANLkTimObyLj=f7W9jdqxd1f7tQ9HVeUpsKRRgKKkLwn@mail.gmail.com>
References: <1289942524-29637-1-git-send-email-josef@redhat.com>
	<AANLkTikXh1di6qoN5EgCdbH+20ZCzSdOD8UcXja-Sn_c@mail.gmail.com>
	<1292290233-sup-3270@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292290233-sup-3270@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 14, 2010 at 9:33 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Yan, Zheng's message of 2010-11-16 20:38:23 -0500:
>> On Wed, Nov 17, 2010 at 5:22 AM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > There is a bug in find_free_extent where if we don't find a free e=
xtent in the
>> > raid type we are looking for, we loop through to the next raid typ=
e. =A0This is
>> > not ok since we need to make sure we honor the raid types we are g=
iven. =A0So
>> > instead kill this check and get the proper index for the raid type=
 we want from
>> > the allocator. =A0Thanks,
>> >
>>
>> Loop through raid types is for handling failure in the middle of rai=
d type
>> conversion.
>
> The problem is that nothing prevents it from looping back to a raid0
> chunk when we really want raid1 or raid10. =A0And mkfs leaves behind =
a
> small raid0 chunk (4MB) that is uses as it assembles all the devices.

check code at end of btrfs_read_block_groups, it prevents allocating
from raid0 when there are mirrored block groups.

>
> I confirmed that we often use the small raid0 chunk even in raid1 or
> raid10.
>
> Please take a look at this commit:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.git;=
a=3Dcommit;h=3D83a50de97fe96aca82389e061862ed760ece2283
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
