From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 2/2] btrfs: fix deadlock when doing reservation
Date: Thu, 16 Jun 2011 09:36:53 -0500
Message-ID: <BANLkTikPyw1tFcXvF9+eKWXjJdSYTxWU5A@mail.gmail.com>
References: <4DF88DCF.2030502@cn.fujitsu.com>
	<4DF8B722.2090704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF8B722.2090704@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/6/15 Josef Bacik <josef@redhat.com>:
> On 06/15/2011 06:47 AM, Miao Xie wrote:
>> The following deadlock may happen when doing reservation for metadat=
a:
>>
>> Task0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Flush thread =A0=
 =A0 =A0 =A0 =A0 =A0Task1
>> start_transaction()
>> =A0 shrink_delalloc()
>> =A0 =A0 writeback_inodes_sb_nr()
>> =A0 =A0 =A0 wait for flush thread
>> =A0 =A0 =A0 end.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_wr=
itepages()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cow_=
file_range()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_commit_transaction
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait num_writer =3D=3D 1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (wait Task0 end
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0transaction)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 star=
t_transaction()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
wait trans commit
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
end
>>
>> Task0 -> Flush thread -> Task1 -> Task0
>>
>> Fix the above deadlock by doing reservation before the trans handle =
has
>> been joined into the transaction.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>
> I've already taken care of this in
>
> [PATCH 1/2] Btrfs: do transaction space reservation before joining th=
e
> transaction
>
> Thanks,
>
> Josef

I've been trying to run down an issue with btrfs freezing with the
3.0_rc btrfs patch set.  I've found a test case that repeatably
freezes up on my system, and have been surveying the patches on the
list to see if the issue has already been resolved.

I've been successful in addressing the deadlock by applying Miao Xie's
patches (I've tested with both "[1/2] btrfs: fix wrong reservation
when doing delayed inode operations" and "[2/2] btrfs: fix deadlock
when doing reservation").

I've only been partially successful in running my test case with Josef
Bacik's patches (the deadlock is cleared; however, now I'm running
into a premature ENOSPC).

When evaluating Josef's patches, I've applied:
Btrfs: account for space reservations properly V2
Btrfs: fix btrfs_update_reserved_bytes usage
[1/2] Btrfs: do transaction space reservation before joining the transa=
ction
[2/2] Btrfs: serialize flushers in reserve_metadata_bytes

My test kernels are 2.6.39.1 kernels merged with the for-linus branch
of Chris' Btrfs unstable kernel tree.

If Miao Xie's patch is not going to be adopted, I'd like to get a
clearer idea of the specific patches that are being put forward to
address this issue, and I'll apply my test case against those patches.

It's possible that I've applied too many of Josef's proposed patches
from the Mailing List, so let me know if I need to go another
direction.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
