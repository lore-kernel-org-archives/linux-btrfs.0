From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 15:30:20 +0100
Message-ID: <20110106143019.GB14674@mother>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
 <4D24AD92.4070107@bobich.net>
 <20110105194645.GC2562@localhost.localdomain>
 <4D24D8BC.90808@bobich.net>
 <4D251888.7060508@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D251888.7060508@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 06, 2011 at 02:19:04AM +0100, Spelic wrote:
> >CPU can handle considerably more than 250 block hashings per
> >second. You could argue that this changes in cases of sequential
> >I/O on big files, but a 1.86GHz GHz Core2 can churn through
> >111MB/s of SHA256, which even SSDs will struggle to keep up with.
>=20
> A normal 1TB disk with platters can do 130MB/sec sequential, no probl=
ems.
> A SSD can do more like 200MB/sec write 280MB/sec read sequential or
> random and is actually limited only by the SATA 3.0gbit/sec but soon
> enough they will have SATA/SAS 6.0gbit/sec.

  By =E2=80=9Csoon enough=E2=80=9D you really meant =E2=80=9Ca year ago=
=E2=80=9D, I think:
http://www.anandtech.com/show/3812/the-ssd-diaries-crucials-realssd-c30=
0
Current 6Gbps SSD are doing 415 MB/s sequential:
http://www.anandtech.com/show/4086/microns-realssd-c400-uses-25nm-nand-=
at-161gb-offers-415mbs-reads
or even claim 550MB/s:
http://www.anandtech.com/show/4100/ocz-vertex-pro-3-demo-worlds-first-s=
andforce-sf2000
(funny bit: Sandforce SSD controllers dedup internally).=20

  Anyway, 6Gbps is not a future tale, but something long available.
And not the fastest kids on the block:  currently build filesystems
must deal storage providing many gigabytes per second.  Think
of massive disk arrays or stuff like Oracle F5100, claiming
12.8GB/sec read and ~10GB/s write (in one rack unit).

--=20
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
