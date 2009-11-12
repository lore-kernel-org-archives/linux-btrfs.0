From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck: checksum verify failed
Date: Thu, 12 Nov 2009 15:03:49 -0500
Message-ID: <20091112200349.GB2811@think>
References: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
 <20091112140233.GB5211@think>
 <a4423d670911120616k2538809erc006c26fe86eb14d@mail.gmail.com>
 <20091112145051.GB3196@think>
 <a4423d670911120743o3759d594v533bc6ff8cdedd9@mail.gmail.com>
 <20091112172502.GA2811@think>
 <a4423d670911120941x47ca35e7l661e13861dba750e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670911120941x47ca35e7l661e13861dba750e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 08:41:44PM +0300, Alexander Beregalov wrote:
> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> > On Thu, Nov 12, 2009 at 06:43:00PM +0300, Alexander Beregalov wrote=
:
> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> >> > On Thu, Nov 12, 2009 at 05:16:34PM +0300, Alexander Beregalov wr=
ote:
> >> >> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
> >> >> > On Thu, Nov 12, 2009 at 05:08:53AM +0300, Alexander Beregalov=
 wrote:
> >> >> >> # for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum ve=
rify
> >> >> >> failed";echo; done
> >> >> >> checksum verify failed on 31945617408 wanted 6607632D found =
9CC3ED0
> >> >> >> checksum verify failed on 31945617408 wanted 6607632D found =
AFBBF41
> >> >> >
> >> >> > Was your filesystem mounted at the time? =A0It's strange that=
 the checksum
> >> >> > keeps changing, that points to the data in the block changing=
=2E
> >> >>
> >> >> It was not.
> >> >> Any tips how I can try to find a root cause?
> >> >> It is raid0 of two disks.
> >> >
> >> > Well, I'd start by looking for anything else that could be touch=
ing the
> >> > FS or the devices. =A0You shouldn't see more than two different =
csums in this
> >> > configuration (one from each disk).
> >> I always see only these two blocks in output.
> >
> > The wanted is always the same but the found is always different?
>=20
> Yes, exactly. The bits marked as X look as random.

Ok, I've added a new tool to the btrfs-unstable-progs repo.  It is
called btrfs-map-logical and it will print the logical->physical mappin=
g
for any metadata or data block in the FS.  The FS should not be mounted
when you run this program...it'll mostly work mounted but the results
won't be 100% accurate.

=46or your case:

btrfs-map-logical -l 31945617408 -c 1 -o mirror1 /dev/sde
btrfs-map-logical -l 31945617408 -c 2 -o mirror2 /dev/sde

This will print to the screen the mappings for that block and also save
the contents of the first mirror of the block to a file called mirror1.
The second command will save the contents of the second mirror.

If the FS isn't mounted and isn't being changed by someone else, you
should get exactly the same mappings every time and exactly the same
contents in the files mirror1 and mirror2 every time.

Just let me know if you have any problems.  The most recent commit in
the btrfs-progs repo is:

commit ab8fb4c99516c186641bda1dbc0e788f68b4dc77
Author: Chris Mason <chris.mason@oracle.com>
Date:   Thu Nov 12 14:34:09 2009 -0500

    Add btrfs-map-logical program to map and read logical block numbers

If you check kernel.org and this commit isn't there, just try again ;)
The mirror takes a few minutes to update.  I'm pretty sure it goes
faster if you hit reload over and over again, but that's just a guess.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
