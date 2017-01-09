Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35556 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752816AbdAIBJk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Jan 2017 20:09:40 -0500
Date: Sun, 8 Jan 2017 20:09:39 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Peter Becker <floyd.net@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
Message-ID: <20170109010939.GB21290@hungrycats.org>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
 <CAEtw4r3mUA_4vcS-dbxagQn3NPRh8Cxcz0iF0L7jHwv5c9Ui+g@mail.gmail.com>
 <7b0c897f-844c-e7f4-0ce7-c9f888b95983@gmail.com>
 <CAEtw4r3rnKvBgz4BqiVYDz2Ru9RdXODyJOp0sYSiuNNh1Gbebg@mail.gmail.com>
 <dd94bb02-822b-2244-a326-c75a50c4429e@gmail.com>
 <CAEtw4r3+=TgehTqssEfb6WEU1Vu8DN6QHqJgOu5ik_bJG_dZ_A@mail.gmail.com>
 <e36f11c8-9a55-fc82-67df-b45bb6aefb8b@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7aLy7NWYeEog7w9O"
In-Reply-To: <e36f11c8-9a55-fc82-67df-b45bb6aefb8b@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7aLy7NWYeEog7w9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 04, 2017 at 07:58:55AM -0500, Austin S. Hemmelgarn wrote:
> On 2017-01-03 16:35, Peter Becker wrote:
> >As i understand the duperemove source-code right (i work on/ try to
> >improve this code since 5 or 6 weeks on multiple parts), duperemove
> >does hashing and calculation before they call extend_same.
> >Duperemove stores all in a hashfile and read this. after all files
> >hashed, and duplicates detected, the progress all in order without
> >reading new data form disk / hashfile. so the byte-by-byte comparison
> >of extend_same ioctl should consume the full possible bandwidth of the
> >disks.
> Not necessarily.  You've actually got a significant amount of processing
> between each disk operation.  General ordering inside the ioctl is:
> 1. Do generic ioctl setup.
> 2. Lock the extents.
> 3. Read the ranges into memory.
> 4. Compare the ranges.
> 5. If the ranges are identical, write out the changes needed to reflink
> them.
> 6. Unlock all the extents.
> 7. Do generic ioctl cleanup.
> 1 and 7 in particular are pretty heavy.  Ioctls were not intended to be
> called with this kind of frequency, and that fact really shows in the set=
up
> and teardown (overhead is way higher than a syscall).

Steps 1 and 7 are not heavy at all.  ioctl setup is an order of magnitude
higher than other system calls, but still up to 11 orders of magnitude
faster than the other steps.  The other steps are *slow*, and step 5
is orders of magnitude slower than all the others combined.

Most of the time in step 5 is spent deleting the dst extent refs
(or waiting for transaction commits, but everything waits for those).
It gets worse when you have big files (1G and larger), more extents,
and more extent references in the same inode.  On a 100G file the overhead
of manipulating shared extent refs is so large that the rest of the
extent-same ioctl is just noise by comparison (microseconds vs minutes).

The commit 1d57ee9 "btrfs: improve delayed refs iterations" (merged in
v4.10-rc1) helps a bit with this, but deleting shared refs is still
one of the most expensive things you can do in btrfs.

> The operation ended
> up being an ioctl instead of a syscall (or extension to another syscall)
> because:
> 1. Manipulating low-level filesystem state is part of what they're intend=
ed
> to be used for.
> 2. Introducing a new FS specific ioctl is a whole lot less controversial
> than introducing a new FS specific syscall.
> >
> >1. dbfile_load_hashes
> >2. find_all_dupes
> >3. dedupe_results
> >-> call the following in N threads:
> >>dedupe_extent_list
> >>>list_for_each_entry
> >>>>add_extent_to_dedupe #produce a simple list/queue
> >>>>dedupe_extents
> >>>>>btrfs_extent_same
> >>>>>>BTRFS_IOC_FILE_EXTENT_SAME
> >
> >So if this right, one of this thinks is realy slow:
> >
> >1. byte-per-byte comparison
> There's no way that this part can't be slow.  You need to load the data i=
nto
> the registers to do the comparison, you can't just point something at RAM
> and get an answer.  On x86, this in turn means that the comparison amounts
> to a loop of 2 loads followed by a compare and a branch for , repeated on=
ce
> for each range beyond the first, and that's assuming that the compiler
> optimizes it to the greatest degree possible.  On some other systems the
> compare and branch are one instruction, on others the second load might be
> eliminated, but overall it's not something that can be sped up all that
> much.

On cheap amd64 machines this can be done at gigabytes per second.  Not much
gain from optimizing this.

> >2. sets up the reflinks
> This actually is not as efficient as it sounds like it should be, adding
> reflinks means updating metadata, which means that there is some unavoida=
ble
> overhead here.  I doubt that it's where the issue is, but I may be wrong.

Most of the time spent here is spent waiting for IO.  extent-same seems to
imply fsync() with all the performance cost thereof.

> >3. unlocks the new extent
> There's one other aspect not listed here, locking the original extents,
> which can actually add quite a lot of overhead if the files are actually
> being used.
> >
> >If i'm not wrong with my understanding of the duperemove source code,
> >this behaivor should also affected the online dedupe feature on with
> >Qu Wenruo works.
> AFAIK, that uses a different code path from the batch deduplication ioctl.
> It also doesn't have the context switches and other overhead from an ioctl
> involved, because it's done in kernel code.

No difference there--the extent-same ioctl is all kernel code too.

> >2017-01-03 21:40 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> >>On 2017-01-03 15:20, Peter Becker wrote:
> >>>
> >>>I think i understand. The resulting keyquestion is, how i can improve
> >>>the performance of extend_same ioctl.
> >>>I tested it with following results:
> >>>
> >>>enviorment:
> >>>2 files, called "file", size each 100GB, duperemove nofiemap-options
> >>>set, 1MB extend size.
> >>>
> >>>duperemove output:
> >>>[0x1908590] (13889/72654) Try to dedupe extents with id d1c672db
> >>>[0x1908590] Add extent for file "/mnt/new/file" at offset 66.7G (6)
> >>>[0x1908590] Add extent for file "/mnt/old/file" at offset 66.9G (7)
> >>>[0x1908590] Dedupe 1 extents (id: d1c672db) with target: (66.7G,
> >>>1.0M), "/mnt/new/file"
> >>>
> >>>iotop output for a 30 sec. sample
> >>>
> >>>avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >>>               22,31    0,00   13,83        33,81    0,00       30,05
> >>>
> >>>Device:         rrqm/s   wrqm/s     r/s            w/s    rkB/s
> >>>wkB/s    avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> >>>sdd               0,00     1,70          1149,93    0,73  4600,53
> >>>139,60    8,24       0,23          0,20    0,19   13,64      0,19
> >>>21,84
> >>>sde               0,00     0,00          1149,33    0,53  4597,33
> >>>23,87     8,04       0,20          0,18    0,18    1,75       0,18
> >>>20,47
> >>>sdf                0,00     1,70          1149,60    0,63  4598,40
> >>>139,60    8,24       0,21          0,18    0,18    4,63       0,18
> >>>20,63
> >>>sdh               0,00     0,00          1149,33    0,53  4597,33
> >>>23,87     8,04       0,21          0,18    0,18    4,25       0,18
> >>>20,85
> >>>
> >>>resulting in less then 18MB/s read. realy slow.
> >>>
> >>>Querstion 1: why, so slow?
> >>
> >>For a couple of reasons.  First, you have to understand that duperemove
> >>itself actually does a pretty large amount of processing outside of the=
 call
> >>to the ioctl.  It first hashes the blocks for quicker comparison and
> >>matching, then figures out which blocks match, and finally calls the io=
ctl
> >>on the resulting matches.  The reason for this behavior is that the ioc=
tl is
> >>insanely slow.  It first locks the ranges passed in (so they don't get
> >>changed by anything else during the deduplication process), then does a
> >>byte-by-byte comparison to make sure they all actually do match (data
> >>safety, I've said at least once before that I think there should be a f=
lag
> >>for the ioctl (or a separate ioctl) to skip this and assume that usersp=
ace
> >>really knows what it's doing), then finally sets up the reflinks, and
> >>unlocks the new extent.

I've never found the ioctl's lock/read/compare operation taking any more
than 1.0% of the time.  A dedup agent may spend 20% of its time running
the extent-same ioctl (with the other 80% being metadata traversal
and block reads/hashes).  Within the extent-same ioctl the "set up the
reflinks" step is 99% of the time, often more.

The ioctl can read from the cache, so if userspace reads all
the data immediately before calling the extent-same ioctl then the
read/lock/compare component of the ioctl is negligible.

> >>All of this ties into why I keep telling people that efficient deduplic=
ation
> >>requires a tool that understands how the data being deduplicated is
> >>structured.  By avoiding the need to hash and compare every block of da=
ta,
> >>you can significantly improve the time that part takes, and quite often=
 this
> >>will mitigate the impact of getting a few false positives passed into t=
he
> >>ioctl.
> >>>
> >>>Questiont 2a: would be a higher extend-size perform better?

Most of the overhead of deleting shared extents depends on the number
of extents, so using larger extents is helpful up to the maximum extent
size; however, the extent-same ioctl cannot make extents larger.  If the
source file was fragmented to begin with then using larger sizes in the
extent-same ioctl will not have any effect.

Given a choice of extents to deduplicate, it helps to choose the larger
extents to keep if possible (i.e. delete/replace the smaller extents
with references to the larger ones); however, the tradeoff is that this
only allows dedup along existing extent boundaries (i.e. no files over
a few MB in size will ever be deduped).

> >>>Querstion 2b: or did i understand something wrong?
> >>
> >>No, a larger extent would probably not help much, and that's actually a
> >>really good performance sample you've created.
> >>
> >>The block size does end up being somewhat of a trade-off.  Ideally, you=
 want
> >>it matched to the smallest possible chunk of duplicate data greater tha=
n or
> >>equal to the filesystem block size for maximal space efficiency.  Doing=
 this
> >>however makes the extra processing done by duperemove take exponentially
> >>longer because it has to calculate hashes for more blocks (this has ver=
y low
> >>impact until you get to very small block sizes), and has to make
> >>exponentially more comparisons (this has a very big impact as you shrin=
k the
> >>block size, just halving the block size will roughly quadruple the time=
 it
> >>takes to make the comparisons).
> >>
> >>>
> >>>2017-01-03 20:37 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> >>>>
> >>>>On 2017-01-03 14:21, Peter Becker wrote:
> >>>>>
> >>>>>
> >>>>>All invocations are justified, but not relevant in (offline) backup
> >>>>>and archive scenarios.
> >>>>>
> >>>>>For example you have multiple version of append-only log-files or
> >>>>>append-only db-files (each more then 100GB in size), like this:
> >>>>>
> >>>>>>Snapshot_01_01_2017
> >>>>>
> >>>>>
> >>>>>-> file1.log .. 201 GB
> >>>>>
> >>>>>>Snapshot_02_01_2017
> >>>>>
> >>>>>
> >>>>>-> file1.log .. 205 GB
> >>>>>
> >>>>>>Snapshot_03_01_2017
> >>>>>
> >>>>>
> >>>>>-> file1.log .. 221 GB
> >>>>>
> >>>>>The first 201 GB would be every time the same.
> >>>>>Files a copied at night from windows, linux or bsd systems and
> >>>>>snapshoted after copy.
> >>>>>
> >>>>>So a fast way to dedupe this is needed. Using 128KB blocks would
> >>>>>result in 1646592 extends per Snapshot. 1MB blocksize results in
> >>>>>205.824 extends (not bad, but still terrible speed).
> >>>>>I will test it at night with a patched version of duperemove with
> >>>>>100MB blocksize, but I have no hope that the throughput increases
> >>>>>thereby.
> >>>>
> >>>>
> >>>>Deduplication is not a general purpose thing (usually you have very
> >>>>specifically structured data), but duperemove is supposed to be a gen=
eral
> >>>>purpose tool.  It works fine for two of the most common cases
> >>>>(deduplicating
> >>>>large numbers of small files or small numbers of large files), but it=
 is
> >>>>sub-optimal for those cases, and will be for almost any other case.  =
This
> >>>>is
> >>>>a canonical example though of a case where you can use a custom scrip=
t or
> >>>>program to figure out what's duplicated and then have that just call =
the
> >>>>ioctl as appropriate itself.  Most cases where you are storing some k=
ind
> >>>>of
> >>>>well structured data fall into this category.  In fact, both of the c=
ases
> >>>>where I use deduplication myself fall into such a category.  One case
> >>>>involves multiple directories that are partial copies of a larger tree
> >>>>which
> >>>>are kept in sync with the larger tree and each other.  In that partic=
ular
> >>>>case, I care about whole file deduplication, so I have a script that =
just
> >>>>matches on path relative to the roots of each copy and the master cop=
y,
> >>>>verifies that the mtime and size are the same, and if so calls the io=
ctl
> >>>>for
> >>>>deduplication (with some fancy processing to fit within the max size
> >>>>supported by the ioctl and prevent tiny tail extents).  The other cas=
e is
> >>>>a
> >>>>set of archives with a pretty solid fixed structure to them.  In that
> >>>>case,
> >>>>I have a different script that knows enough about the file structure =
to
> >>>>know
> >>>>where to look for duplicate blocks, thus avoiding having to hash the
> >>>>whole
> >>>>files.
> >>>>
> >>>>The append-only log/database case fits this type of thing perfectly, =
for
> >>>>each subsequent file, you know already that (most of) the file up to =
the
> >>>>length of the previous file is duplicated, so you can just split that
> >>>>however you want into chunks and pass those to the dedupe ioctl and f=
ree
> >>>>up
> >>>>most of the space that would be used by the new file.  You can then r=
un
> >>>>duperemove with a hash-file to process any new blocks beyond the point
> >>>>you
> >>>>deduplicated up to to reclaim any excess space (currently this will
> >>>>process
> >>>>the whole file, but it should see that most of it is deduplicated
> >>>>already).
> >>>>
> >>>>>
> >>>>>For backup and archive scenarios the checksum-feature and the
> >>>>>dub-data/metadata-feature of btrfs is realy nice. In particular if o=
ne
> >>>>>considers the 7 years legally prescribed storage time.
> >>>>>
> >>>>>2017-01-03 13:40 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.co=
m>:
> >>>>>>
> >>>>>>
> >>>>>>On 2016-12-30 15:28, Peter Becker wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>>Hello, i have a 8 TB volume with multiple files with hundreds of GB
> >>>>>>>each.
> >>>>>>>I try to dedupe this because the first hundred GB of many files are
> >>>>>>>identical.
> >>>>>>>With 128KB blocksize with nofiemap and lookup-extends=3Dno option,=
 will
> >>>>>>>take more then a week (only dedupe, previously hashed). So i tryed=
 -b
> >>>>>>>100M but this returned me an error: "Blocksize is bounded ...".
> >>>>>>>
> >>>>>>>The reason is that the blocksize is limit to
> >>>>>>>
> >>>>>>>#define MAX_BLOCKSIZE (1024U*1024)
> >>>>>>>
> >>>>>>>But i can't found any description why.
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>Beyond what Xin mentioned (namely that 1MB is a much larger block t=
han
> >>>>>>will
> >>>>>>be duplicated in most data-sets), there are a couple of other reaso=
ns:
> >>>>>>1. Smaller blocks will actually get you better deduplication on ave=
rage
> >>>>>>because they're more likely to match.  As an example, assume you ha=
ve 2
> >>>>>>files with the same 8 4k blocks in different orders:
> >>>>>>  FileA: 1 2 3 4 5 6 7 8
> >>>>>>  FileB: 7 8 5 6 3 4 1 2
> >>>>>>In such a case, deduplicating at any block size above 8k would resu=
lt
> >>>>>>in
> >>>>>>zero deduplication between these files, while 8k or less would
> >>>>>>completely
> >>>>>>deduplicate them.  This is of course a highly specific and somewhat
> >>>>>>contrived example (in most cases it will be scattered duplicate blo=
cks
> >>>>>>over
> >>>>>>dozens of files), but it does convey this specific point.
> >>>>>>2. The kernel will do a byte-wise comparison of all ranges you pass
> >>>>>>into
> >>>>>>the
> >>>>>>ioctl at the same time.  Larger block sizes here mean that:
> >>>>>>        a) The extents will be locked longer, which will prevent any
> >>>>>>I/O
> >>>>>>to
> >>>>>>the files being deduplicated for the duration of the comparison, wh=
ich
> >>>>>>may
> >>>>>>in turn cause other issues on the system.
> >>>>>>        b) The deduplication process will be stuck in uninterruptib=
le
> >>>>>>sleep
> >>>>>>longer, which on many systems will trigger hung task detection, whi=
ch
> >>>>>>will
> >>>>>>in turn either spam the system log or panic the system depending on=
 how
> >>>>>>it's
> >>>>>>configured.
> >>>>>>
> >>>>
> >>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7aLy7NWYeEog7w9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhy4tMACgkQgfmLGlazG5wwFQCeJYIMSOJlhZ3aPohMyke0AXyH
eCsAoNEBtgxfo+/vje1c6kpYfGWNjCvd
=yJDS
-----END PGP SIGNATURE-----

--7aLy7NWYeEog7w9O--
