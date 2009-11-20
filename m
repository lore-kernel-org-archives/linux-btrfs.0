From: David Nicol <davidnicol@gmail.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Fri, 20 Nov 2009 14:05:11 -0600
Message-ID: <934f64a20911201205j70b5b9cfm40260a4a3a6c7b0b@mail.gmail.com>
References: <200911201950.06662.kreijack@libero.it> <934f64a20911201124q2a42fddek87d3f8fe864b3c41@mail.gmail.com>
	<20091120195017.GZ3110@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091120195017.GZ3110@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2009 at 1:50 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> COW semantics require touching btree nodes all the way up to the root=
 of
> the btree, but this is different from the directory. =C2=A0Directorie=
s are
> stored in the btree, but you won't have to touch more than 8 or so bt=
ree
> levels regardless of how deep your directory tree is.
>
> -chris

Thanks for straightening me out on that point.

Still, 8 might be a lot.

Regardless of the decoupling of btrees and directories, am I right in
thinking that mounted subvolumes instead of directories would (1)
reduce contention (2) reduce the number of levels touched since number
of levels is a function of the number of fs entities in the volume,
therefore (3) defining a file system entity that transparently becomes
a mounted subvolume (by transparently I mean without an additional
mount command) and (4) crafting a utility to streamline
creation-and-implied-mounting of the entity type from #3 would make
sense?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
