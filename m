From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck: checksum verify failed
Date: Thu, 12 Nov 2009 09:50:51 -0500
Message-ID: <20091112145051.GB3196@think>
References: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
 <20091112140233.GB5211@think>
 <a4423d670911120616k2538809erc006c26fe86eb14d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670911120616k2538809erc006c26fe86eb14d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 05:16:34PM +0300, Alexander Beregalov wrote:
> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> > On Thu, Nov 12, 2009 at 05:08:53AM +0300, Alexander Beregalov wrote=
:
> >> # for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum verify
> >> failed";echo; done
> >> checksum verify failed on 31945617408 wanted 6607632D found 9CC3ED=
0
> >> checksum verify failed on 31945617408 wanted 6607632D found AFBBF4=
1
> >
> > Was your filesystem mounted at the time? =A0It's strange that the c=
hecksum
> > keeps changing, that points to the data in the block changing.
>=20
> It was not.
> Any tips how I can try to find a root cause?
> It is raid0 of two disks.

Well, I'd start by looking for anything else that could be touching the
=46S or the devices.  You shouldn't see more than two different csums i=
n this
configuration (one from each disk).

Somehow the disk is giving us different answers each time, which points
to a problem in the storage stack.

Otherwise it is possible that block 31945617408 is multiply linked and
is actually in use somehow else.  btrfsck is a readonly operation
though, it doesn't change the FS while it is running.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
