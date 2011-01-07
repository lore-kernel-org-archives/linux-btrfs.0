From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfsck segmentation fault
Date: Fri, 7 Jan 2011 16:29:53 -0600
Message-ID: <AANLkTi=0FwYG-O+7MiOhfPiJwdDNc5enxX7hijumMqd2@mail.gmail.com>
References: <4D278280.4060907@math.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Andrew Schretter <schrett@math.duke.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D278280.4060907@math.duke.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 3:15 PM, Andrew Schretter <schrett@math.duke.edu=
> wrote:
> I have a 10TB btrfs filesystem over iSCSI that is currently unmountab=
le. =A0I'm
> currently running Fedora 13 with a recent Fedora 14 kernel (2.6.35.9-=
64.fc14.i686.PAE)
> and the system hung with messages like :
>
> parent transid verify failed on 5937615339520 wanted 48547 found 4854=
2
>
> I've rebooted and and am attempting to recover with btrfsck from the =
btrfs-progs-unstable
> git tree, but it is segfaulting after finding a superblock and listin=
g out 3 of the
> "parent transid" messages. =A0Anyone have any ideas?
>
> I tried btrfsck /dev/sdb, btrfsck -s 1 /dev/sdb, and btrfsck -s 2 /de=
v/sdb with the
> same result for each. =A0The btrfsck binary I compiled does work on a=
 small (800MB) test
> btrfs file system. =A0I suspect it may be due to the size of the file=
system I am trying
> to repair.

Segfaulting is what the current btrfsck does when it finds a problem;
it doesn't try to fix anything yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
