From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: fix delayed insertion reservations V2
Date: Sat, 5 Nov 2011 07:23:43 -0500
Message-ID: <CAKcLGm-iBOx2DsSeMznaqO6zUMOPWfCHWS9mz_KOSib8wBgn5g@mail.gmail.com>
References: <20111104211853.GB13434@dhcp231-156.rdu.redhat.com>
	<20111105004756.GA4253@shiny>
	<20111105114635.GB4253@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111105114635.GB4253@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 5, 2011 at 6:46 AM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> On Fri, Nov 04, 2011 at 08:47:56PM -0400, Chris Mason wrote:
>> On Fri, Nov 04, 2011 at 05:18:54PM -0400, Josef Bacik wrote:
>> > V1->V2: I stupidly thought I could get away with some flushing if =
we needed
>> > space but I was wrong, we could deadlock, so add a btrfs_add_bytes=
_noflush
>> > variant that will not do any flushing and will just return ENOSPC =
which will let
>> > us fallback and do our full flushing.
>> > =A0fs/btrfs/ctree.h =A0 =A0 =A0 =A0 | =A0 =A03 +++
>> > =A0fs/btrfs/delayed-inode.c | =A0 36 ++++++++++++++++++++++++++++-=
-------
>> > =A0fs/btrfs/extent-tree.c =A0 | =A0 18 ++++++++++++++++++
>> > =A03 files changed, 49 insertions(+), 8 deletions(-)
>>
>> This helps but it I've got a bunch of these in the log now:
>>
>> btrfs_dirty_inode: 205 callbacks suppressed
>> btrfs: fail to dirty =A0inode 1294 error -28
>> btrfs: fail to dirty =A0inode 1208 error -28
>> btrfs: fail to dirty =A0inode 714 error -28
>> btrfs: fail to dirty =A0inode 1772 error -28
>> btrfs: fail to dirty =A0inode 1389 error -28
>> btrfs: fail to dirty =A0inode 770 error -28
>> btrfs: fail to dirty =A0inode 345 error -28
>> btrfs: fail to dirty =A0inode 1533 error -28
>> btrfs: fail to dirty =A0inode 624 error -28
>> btrfs: fail to dirty =A0inode 1085 error -28
>
> I should add this only seems to happen during xfstest 083.
>

This version of the patch clears the deadlock issue I was seeing with
version 1 of this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
