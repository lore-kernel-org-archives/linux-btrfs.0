From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Disk space accounting and subvolume delete
Date: Wed, 12 May 2010 13:02:07 +0800
Message-ID: <AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
References: <20100510182352.GA21154@untroubled.org>
	 <AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
	 <20100511154518.GA11710@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100511154518.GA11710@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 11, 2010 at 11:45 PM, Bruce Guenter <bruce@untroubled.org> =
wrote:
> On Tue, May 11, 2010 at 08:10:38AM +0800, Yan, Zheng =A0wrote:
>> This is because the snapshot deleting ioctl only removes the a link.
>
> Right, I understand that. =A0That part is not unexpected, as it works=
 just
> like unlink would. =A0However...
>
>> The corresponding tree is dropped in the background by a kernel thre=
ad.
>
> The surprise is that 'sync', in any form I was able to try, does not
> wait until all or even most of the I/O is completed. =A0Apparently th=
e
> standards spec for sync(2) says it is not required to wait for I/O to
> complete, but AFAIK all other Linux FS do wait (the man page for sync=
(2)
> implies as much, as does the info page for sync in glibc).
>
> The only way I've found so far to force this behavior is to unmount, =
and
> that's rather intrusive to other users of the FS.
>
>> We could probably add another ioctl that waits until the tree has be=
en
>> completely dropped.
>
> Since the expected behavior for sync is to wait until all pending I/O
> has been completed, I would argue this should be the default action f=
or
> sync. =A0Am I misunderstanding something?
>

Dropping a tree can be lengthy. It's not good to let sync wait for hour=
s.
=46or most linux FS, 'sync' just force an transaction/journal commit. I=
 don't
think they wait for large operations that can span multiple transaction=
s to
complete.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
