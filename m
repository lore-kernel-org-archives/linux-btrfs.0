From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Thu, 8 Mar 2012 16:52:11 +0100
Message-ID: <20120308155211.GF4334@twin.jikos.cz>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2012 at 01:10:45PM +0100, Jacek Luczak wrote:
> kernel BUG at fs/btrfs/delayed-inode.c:1466!

1461         ret = btrfs_delayed_item_reserve_metadata(trans, root, item);
1462         /*
1463          * we have reserved enough space when we start a new transaction,
1464          * so reserving metadata failure is impossible.
1465          */
1466         BUG_ON(ret);

> RAX: 00000000ffffffe4

ENOSPC

>  [<ffffffffa03210e5>] ? __btrfs_unlink_inode+0x172/0x25e [btrfs]
>  [<ffffffffa032158c>] ? btrfs_rename+0x38b/0x55b [btrfs]

rename reserves 20 blocks, but seems that's not enough.  I've never seen
a crash report in rename, and according to the stacktrace there's
nothing suspicious (like selinux related).


david
