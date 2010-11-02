From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC][PATCH] direct-io: btrfs: avoid splitting dio requests
	for non-btrfs filesystems
Date: Tue, 2 Nov 2010 10:57:18 -0400
Message-ID: <20101102145717.GA2531@localhost.localdomain>
References: <4CD001A2.4000408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Jeff Moyer <jmoyer@redhat.com>, Josef Bacik <jbacik@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CD001A2.4000408@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 02, 2010 at 01:18:42PM +0100, Christian Ehrhardt wrote:
> Hi,
> this is about an issue newer kernels show, bysplitting direct I/O req=
uests
> into 4k pieces to directly merge them in the Block Device Layer after=
wards.
>=20
> If anyone is interested in own tests just use a simple command like
> dd if=3D/mnt/test/test-dd1 of=3D/dev/null iflag=3Ddirect bs=3D64k cou=
nt=3D1
> in combination with blktrace.
>=20
> The following patch is more a proposal for discussion than a solution=
, well
> thats what RFC's are about right.
> I'm unsure about names, but also if the approach in general is the ri=
ght way.
> It should apply to every 2.6.36 and 2.6.37 kernel.
>=20
> I put everyone on CC who was involved in the patches leading to the c=
urrent
> behavior.
>=20
> Gr=FCsse / regards,
> Christian Ehrhardt
> IBM Linux Technology Center, System z Linux Performance=20
>=20
> --- cut here ---
>=20
> Subject: [RFC][PATCH] direct-io: btrfs: avoid splitting dio requests =
for non-btrfs filesystems
>=20
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>=20
> Commit c2c6ca41 by Josef Bacik <josef@redhat.com> caused all direct I=
/O's to
> be split into 4k requests before arriving in the block device layer.
> This was later on partially fixed by Jeff Moyer <jmoyer@redhat.com> i=
n
> 7a801ac6.
>=20
> Jeffs fix improved the situation a lot, but eventually it still split=
s I/Os
> for non-btrfs file systems as well were it wouldn't have to.
>=20
> Eventually in my example on a ext2 filesystem it splits it every 4Mb =
where
> dio->boundary is evaluated to true.
>=20
> In blktrace this looks like:
>               dd-910   [002]    38.762523:  94,8    A   R 131264 + 8 =
<- (94,9) 131072
>               dd-910   [002]    38.762531:  94,8    Q   R 131264 + 8 =
[dd]
>               dd-910   [002]    38.762535:  94,8    G   R 131264 + 8 =
[dd]
>               dd-910   [002]    38.762537:  94,8    P   N [dd]
>               dd-910   [002]    38.762539:  94,8    I   R 131264 + 8 =
[dd]
>               dd-910   [002]    38.762544:  94,8    A   R 131272 + 8 =
<- (94,9) 131080
>               dd-910   [002]    38.762544:  94,8    Q   R 131272 + 8 =
[dd]
>               dd-910   [002]    38.762546:  94,8    M   R 131272 + 8 =
[dd]
>               dd-910   [002]    38.762550:  94,8    A   R 131280 + 8 =
<- (94,9) 131088
>               dd-910   [002]    38.762551:  94,8    Q   R 131280 + 8 =
[dd]
>               dd-910   [002]    38.762551:  94,8    M   R 131280 + 8 =
[dd]
>               dd-910   [002]    38.762556:  94,8    A   R 131288 + 8 =
<- (94,9) 131096
>               dd-910   [002]    38.762557:  94,8    Q   R 131288 + 8 =
[dd]
>               dd-910   [002]    38.762557:  94,8    M   R 131288 + 8 =
[dd]
>               dd-910   [002]    38.762562:  94,8    A   R 131296 + 8 =
<- (94,9) 131104
>               dd-910   [002]    38.762563:  94,8    Q   R 131296 + 8 =
[dd]
>               dd-910   [002]    38.762564:  94,8    M   R 131296 + 8 =
[dd]
>               dd-910   [002]    38.762568:  94,8    A   R 131304 + 8 =
<- (94,9) 131112
>               dd-910   [002]    38.762569:  94,8    Q   R 131304 + 8 =
[dd]
>               dd-910   [002]    38.762570:  94,8    M   R 131304 + 8 =
[dd]
>               dd-910   [002]    38.762577:  94,8    A   R 131312 + 8 =
<- (94,9) 131120
>               dd-910   [002]    38.762578:  94,8    Q   R 131312 + 8 =
[dd]
>               dd-910   [002]    38.762579:  94,8    M   R 131312 + 8 =
[dd]
>               dd-910   [002]    38.762584:  94,8    A   R 131320 + 8 =
<- (94,9) 131128
>               dd-910   [002]    38.762584:  94,8    Q   R 131320 + 8 =
[dd]
>               dd-910   [002]    38.762585:  94,8    M   R 131320 + 8 =
[dd]
>               dd-910   [002]    38.762590:  94,8    A   R 131328 + 8 =
<- (94,9) 131136
>               dd-910   [002]    38.762590:  94,8    Q   R 131328 + 8 =
[dd]
>               dd-910   [002]    38.762591:  94,8    M   R 131328 + 8 =
[dd]
>               dd-910   [002]    38.762596:  94,8    A   R 131336 + 8 =
<- (94,9) 131144
>               dd-910   [002]    38.762597:  94,8    Q   R 131336 + 8 =
[dd]
>               dd-910   [002]    38.762598:  94,8    M   R 131336 + 8 =
[dd]
>               dd-910   [002]    38.762605:  94,8    A   R 131344 + 16=
 <- (94,9) 131152
>               dd-910   [002]    38.762607:  94,8    Q   R 131344 + 16=
 [dd]
>               dd-910   [002]    38.762608:  94,8    M   R 131344 + 16=
 [dd]
>               dd-910   [002]    38.762611:  94,8    A   R 131368 + 32=
 <- (94,9) 131176
>               dd-910   [002]    38.762612:  94,8    Q   R 131368 + 32=
 [dd]
>               dd-910   [002]    38.762616:  94,8    G   R 131368 + 32=
 [dd]
>               dd-910   [002]    38.762617:  94,8    I   R 131368 + 32=
 [dd]
>               dd-910   [002]    38.762619:  94,8    U   N [dd] 2
>               dd-910   [002]    38.762621:  94,8    D   R 131264 + 96=
 [dd]
>               dd-910   [002]    38.762625:  94,8    D   R 131368 + 32=
 [dd]
>           <idle>-0     [012]    38.763363:  94,8    C   R 131264 + 96=
 [0]=20
>           <idle>-0     [015]    38.763797:  94,8    C   R 131368 + 32=
 [0]
>=20
> The usual behavior before both commits was:
>               dd-919   [002]    37.513685:  94,8    A   R 7824 + 96 <=
- (94,9) 7632
>               dd-919   [002]    37.513693:  94,8    Q   R 7824 + 96 [=
dd]
>               dd-919   [002]    37.513697:  94,8    G   R 7824 + 96 [=
dd]
>               dd-919   [002]    37.513700:  94,8    P   N [dd]
>               dd-919   [002]    37.513701:  94,8    I   R 7824 + 96 [=
dd]
>               dd-919   [002]    37.513794:  94,8    A   R 7928 + 32 <=
- (94,9) 7736
>               dd-919   [002]    37.513795:  94,8    Q   R 7928 + 32 [=
dd]
>               dd-919   [002]    37.513800:  94,8    G   R 7928 + 32 [=
dd]
>               dd-919   [002]    37.513802:  94,8    I   R 7928 + 32 [=
dd]
>               dd-919   [002]    37.513804:  94,8    U   N [dd] 2
>               dd-919   [002]    37.513806:  94,8    D   R 7824 + 96 [=
dd]
>               dd-919   [002]    37.513810:  94,8    D   R 7928 + 32 [=
dd]
>           <idle>-0     [011]    37.514362:  94,8    C   R 7824 + 96 [=
0]=20
>           <idle>-0     [014]    37.514728:  94,8    C   R 7928 + 32 [=
0]
>=20
> That remaining split is cause by the test for:
>  "dio->final_block_in_bio !=3D dio->cur_page_block".
> As this was in the code for a long time I just assume it is right.
>=20
> So eventually for the 64k request in the example this patch improves =
the
> effective submissions that get to the block device layer from:
> 10x4k, 1x8k, 1x16k to 1x48k & 1x16k which is much better.
>=20
> Througput impact is small, but in terms of cpu consumption this is vi=
sible
> by a single digit percentage depending on the incoming request size.
>=20
> The solution looking for comments or alternatives in this RFC patch a=
dds a new
> kiocb flag that let filesystems specify if they need these workaround=
 to
> separate meta data reads - if not, like all pre-btrfs filesystems the=
 dio code
> doesn't have to cause this extra work.
>=20

So this brings up an important question, which is how badly do we want =
to honor
buffer_boundary()?  The whole reason I added the logical offset check w=
as because
we ignore buffer_boundary() if there is no bio currently.  So for BTRFS=
 we would
do this

map extent
set buffer boundary

but if this is the first part of the IO and there isn't a bio already s=
etup,
dio_new_bio clears dio->boundary, so the next extent we would get may n=
ot be
logically contiguous and hilarity would ensue.  I chose not to fix the
dio->boundary clearing because I was worried I would affect other fs's =
workloads
(which I did anyway because of my bug).  So maybe the right idea is to =
rip out
my logical offset tests altogether and fix dio so we treat buffer_bound=
ary()
like gospel.  That way Btrfs can get what it needs without having this =
weird
special code, and then we can look at how other fs's set buffer_boundar=
y (I'm
pretty sure ext2/3 are the only ones) and make sure they are setting it=
 when
they really mean to.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
