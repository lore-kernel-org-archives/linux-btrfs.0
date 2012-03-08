From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Thu, 8 Mar 2012 20:35:06 +0100
Message-ID: <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120308155211.GF4334@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/8 David Sterba <dave@jikos.cz>:
> On Thu, Mar 08, 2012 at 01:10:45PM +0100, Jacek Luczak wrote:
>> kernel BUG at fs/btrfs/delayed-inode.c:1466!
>
> 1461 =A0 =A0 =A0 =A0 ret =3D btrfs_delayed_item_reserve_metadata(tran=
s, root, item);
> 1462 =A0 =A0 =A0 =A0 /*
> 1463 =A0 =A0 =A0 =A0 =A0* we have reserved enough space when we start=
 a new transaction,
> 1464 =A0 =A0 =A0 =A0 =A0* so reserving metadata failure is impossible=
=2E
> 1465 =A0 =A0 =A0 =A0 =A0*/
> 1466 =A0 =A0 =A0 =A0 BUG_ON(ret);
>
>> RAX: 00000000ffffffe4
>
> ENOSPC
>
>> =A0[<ffffffffa03210e5>] ? __btrfs_unlink_inode+0x172/0x25e [btrfs]
>> =A0[<ffffffffa032158c>] ? btrfs_rename+0x38b/0x55b [btrfs]
>
> rename reserves 20 blocks, but seems that's not enough. =A0I've never=
 seen
> a crash report in rename, and according to the stacktrace there's
> nothing suspicious (like selinux related).

There were quite many things happening in the system at that time.
Can't really tell what could trigger this.

Complete logs: http://91.234.146.107/~difrost/logs/tampere_log.gz

-Jacek
