From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: Disk space accounting and subvolume delete
Date: Wed, 12 May 2010 22:56:54 +0100
Message-ID: <AANLkTiliPmtYH-46TdbqzLjRzUhcwoW_dUmLQPOf-3bK@mail.gmail.com>
References: <20100510182352.GA21154@untroubled.org>
	 <AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
	 <20100511154518.GA11710@untroubled.org>
	 <AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12 May 2010 06:02, Yan, Zheng <yanzheng@21cn.com> wrote:
> On Tue, May 11, 2010 at 11:45 PM, Bruce Guenter <bruce@untroubled.org=
> wrote:
>> On Tue, May 11, 2010 at 08:10:38AM +0800, Yan, Zheng =C2=A0wrote:
>>> This is because the snapshot deleting ioctl only removes the a link=
=2E
>>
>> Right, I understand that. =C2=A0That part is not unexpected, as it w=
orks just
>> like unlink would. =C2=A0However...
>>
>>> The corresponding tree is dropped in the background by a kernel thr=
ead.
>>
>> The surprise is that 'sync', in any form I was able to try, does not
>> wait until all or even most of the I/O is completed. =C2=A0Apparentl=
y the
>> standards spec for sync(2) says it is not required to wait for I/O t=
o
>> complete, but AFAIK all other Linux FS do wait (the man page for syn=
c(2)
>> implies as much, as does the info page for sync in glibc).
>>
>> The only way I've found so far to force this behavior is to unmount,=
 and
>> that's rather intrusive to other users of the FS.
>>
>>> We could probably add another ioctl that waits until the tree has b=
een
>>> completely dropped.
>>
>> Since the expected behavior for sync is to wait until all pending I/=
O
>> has been completed, I would argue this should be the default action =
for
>> sync. =C2=A0Am I misunderstanding something?
>>
>
> Dropping a tree can be lengthy. It's not good to let sync wait for ho=
urs.
> For most linux FS, 'sync' just force an transaction/journal commit. I=
 don't
> think they wait for large operations that can span multiple transacti=
ons to
> complete.

Disclaimer: I know nothing about the internals of Btrfs!

I have an analogy as a way to thinking about what deleting a snapshot
entails (which I hope isn't totally bogus).

Deleting a clone of a file system is not like unlinking a single file.
 It is analogous to deleting a directory tree.  Syncing in the middle
of a recursive delete will wait for the in flight I/O to complete, but
it would not wait for the unlink requests from the portion of the
directory tree not yet traversed.  The same would be true when the
kernel thread deletes the snapshot by recursing through it's tree.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
