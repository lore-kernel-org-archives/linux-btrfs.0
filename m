From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
 requests
Date: Fri, 06 Aug 2010 12:50:03 +0200
Message-ID: <4C5BE8DB.5030503__15530.9443398894$1281091835$gmane$org@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Josef Bacik <josef@redhat.com>, hch@infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 21, 2010 at 15:37:45AM -0400, Josef Bacik wrote:
> On Fri, May 21, 2010 at 11:21:11AM -0400, Christoph Hellwig wrote:
>> On Wed, May 19, 2010 at 04:24:51PM -0400, Josef Bacik wrote:
>> > Btrfs cannot handle having logically non-contiguous requests submi=
tted.  For
>> > example if you have
>> >=20
>> > Logical:  [0-4095][HOLE][8192-12287]
>> > Physical: [0-4095]      [4096-8191]
>> >=20
>> > Normally the DIO code would put these into the same BIO's.  The pr=
oblem is we
>> > need to know exactly what offset is associated with what BIO so we=
 can do our
>> > checksumming and unlocking properly, so putting them in the same B=
IO doesn't
>> > work.  So add another check where we submit the current BIO if the=
 physical
>> > blocks are not contigous OR the logical blocks are not contiguous.
>>=20
>> This gets us slightly less optimal I/O patters for other filesystems=
 in
>> this case.  But it's probably corner case enough to not care and mak=
e it
>> the default.
>>=20
>> But please make the comment in the comment as verbose as the commit
>> message so that people understand why we're doing this when reading =
the
>> code in a few years.
>>=20
>
>So after I sent this I thought that maybe I could make that test _only=
_ if we
>provide submit_bio, that way it only affects btrfs and not everybody e=
lse, would
>you prefer I do something like that?  I will make the commit log a bit=
 more
>verbose.  Thanks,
>
>Josef

I guess was hit by those "slightly less optimal I/O patters for other
file-systems" while measuring performance with iozone sequential using
direct I/O with 64k requests.
=46irst I only saw increased cpu costs and a huge number of request
merges, analyzing that brought me to this patch (reverting fixes the
issue).

Therefore I'd like to come back to that suggested "that way it only
affects btrfs" solution.

What happens on my system is that all direct I/O requests from=20
userspace are broken up in 4k bio's and then re-merged
by the ioscheduler before reaching the device driver.
Eventually that means +30% cpu cost for 64k, probably much more for
larger request sizes - Throughput is only affected if there is no
cpu left to spare for this additional overhead.

A blktrace log is probably the best way to explain this in detail:
(sequential 64k requests using direct I/O reading a 2Gb file on a
ext2 file system)

Application summary for iozone :
BAD:                                      GOOD:
iozone (18572, ...)                       iozone (18482, ...)          =
        =20
 Reads Queued:     506,222,    2,024MiB    Reads Queued:      37,851, 2=
,040MiB=20
 Read Dispatches:   33,110,    2,024MiB    Read Dispatches:   33,368, 2=
,040MiB=20
 Reads Requeued:         0                 Reads Requeued:         0   =
        =20
 Reads Completed:   15,072,  911,112KiB    Reads Completed:    9,814, 5=
88,708KiB=20
 Read Merges:      473,111,    1,892MiB    Read Merges:        4,483, =20
17,936KiB=20
 IO unplugs:        32,108                 IO unplugs:        32,364   =
        =20
 Allocation wait:       32                 Allocation wait:       26   =
        =20
 Dispatch wait:        338                 Dispatch wait:        216   =
        =20
 Completion wait:    1,426                 Completion wait:    1,362=20

As a full stream of blktrace events it looks like that:
GOOD:
  8,0    3        3     0.002964189 18400  A   R 65960 + 128 <- (8,1) 6=
5928
  8,0    3        4     0.002964345 18400  Q   R 65960 + 128 [iozone]
  8,0    3        5     0.002964814 18400  G   R 65960 + 128 [iozone]
  8,0    3        6     0.002965533 18400  P   N [iozone]
  8,0    3        7     0.002965689 18400  I   R 65960 + 128 (     875)=
 [iozone]
  8,0    3        8     0.002966095 18400  U   N [iozone] 1
  8,0    3        9     0.002966501 18400  D   R 65960 + 128 (     812)=
 [iozone]
  8,0    3       11     0.003599064 18401  C   R 65960 + 128 (  632563)=
 [0]

BAD:
  8,0    1      226     0.002707250 18572  A   R 148008 + 8 <- (8,1) 14=
7976
  8,0    1      227     0.002707406 18572  Q   R 148008 + 8 [iozone]
  8,0    1      228     0.002707875 18572  G   R 148008 + 8 [iozone]
  8,0    1      229     0.002708563 18572  P   N [iozone]
  8,0    1      230     0.002708813 18572  I   R 148008 + 8 (     938) =
[iozone]
  8,0    1      231     0.002709469 18572  A   R 148016 + 8 <- (8,1) 14=
7984
  8,0    1      232     0.002709625 18572  Q   R 148016 + 8 [iozone]
  8,0    1      233     0.002709875 18572  M   R 148016 + 8 [iozone]
  8,0    1      234     0.002710594 18572  A   R 148024 + 8 <- (8,1) 14=
7992
  8,0    1      235     0.002710750 18572  Q   R 148024 + 8 [iozone]
  8,0    1      236     0.002710969 18572  M   R 148024 + 8 [iozone]
  8,0    1      237     0.002711563 18572  A   R 148032 + 8 <- (8,1) 14=
8000
  8,0    1      238     0.002711750 18572  Q   R 148032 + 8 [iozone]
  8,0    1      239     0.002712063 18572  M   R 148032 + 8 [iozone]
  8,0    1      240     0.002712625 18572  A   R 148040 + 8 <- (8,1) 14=
8008
  8,0    1      241     0.002712750 18572  Q   R 148040 + 8 [iozone]
  8,0    1      242     0.002713000 18572  M   R 148040 + 8 [iozone]
  8,0    1      243     0.002713531 18572  A   R 148048 + 8 <- (8,1) 14=
8016
  8,0    1      244     0.002713750 18572  Q   R 148048 + 8 [iozone]
  8,0    1      245     0.002713969 18572  M   R 148048 + 8 [iozone]
  8,0    1      246     0.002714531 18572  A   R 148056 + 8 <- (8,1) 14=
8024
  8,0    1      247     0.002714656 18572  Q   R 148056 + 8 [iozone]
  8,0    1      248     0.002714938 18572  M   R 148056 + 8 [iozone]
  8,0    1      249     0.002715500 18572  A   R 148064 + 8 <- (8,1) 14=
8032
  8,0    1      250     0.002715625 18572  Q   R 148064 + 8 [iozone]
  8,0    1      251     0.002715844 18572  M   R 148064 + 8 [iozone]
  8,0    1      252     0.002716438 18572  A   R 148072 + 8 <- (8,1) 14=
8040
  8,0    1      253     0.002716625 18572  Q   R 148072 + 8 [iozone]
  8,0    1      254     0.002716844 18572  M   R 148072 + 8 [iozone]
  8,0    1      255     0.002717375 18572  A   R 148080 + 8 <- (8,1) 14=
8048
  8,0    1      256     0.002717531 18572  Q   R 148080 + 8 [iozone]
  8,0    1      257     0.002717750 18572  M   R 148080 + 8 [iozone]
  8,0    1      258     0.002718344 18572  A   R 148088 + 8 <- (8,1) 14=
8056
  8,0    1      259     0.002718500 18572  Q   R 148088 + 8 [iozone]
  8,0    1      260     0.002718719 18572  M   R 148088 + 8 [iozone]
  8,0    1      261     0.002719250 18572  A   R 148096 + 8 <- (8,1) 14=
8064
  8,0    1      262     0.002719406 18572  Q   R 148096 + 8 [iozone]
  8,0    1      263     0.002719688 18572  M   R 148096 + 8 [iozone]
  8,0    1      264     0.002720156 18572  A   R 148104 + 8 <- (8,1) 14=
8072
  8,0    1      265     0.002720313 18572  Q   R 148104 + 8 [iozone]
  8,0    1      266     0.002720531 18572  M   R 148104 + 8 [iozone]
  8,0    1      267     0.002721031 18572  A   R 148112 + 8 <- (8,1) 14=
8080
  8,0    1      268     0.002721219 18572  Q   R 148112 + 8 [iozone]
  8,0    1      269     0.002721469 18572  M   R 148112 + 8 [iozone]
  8,0    1      270     0.002721938 18572  A   R 148120 + 8 <- (8,1) 14=
8088
  8,0    1      271     0.002722063 18572  Q   R 148120 + 8 [iozone]
  8,0    1      272     0.002722344 18572  M   R 148120 + 8 [iozone]
  8,0    1      273     0.002722813 18572  A   R 148128 + 8 <- (8,1) 14=
8096
  8,0    1      274     0.002722938 18572  Q   R 148128 + 8 [iozone]
  8,0    1      275     0.002723156 18572  M   R 148128 + 8 [iozone]
  8,0    1      276     0.002723406 18572  U   N [iozone] 1
  8,0    1      277     0.002724031 18572  D   R 148008 + 128 (   15218=
) [iozone]
  8,0    1      279     0.003318094     0  C   R 148008 + 128 (  594063=
) [0]


--=20

Gr=FCsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
