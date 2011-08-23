From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] [RFC] Btrfs-progs: restriper interface
Date: Tue, 23 Aug 2011 23:08:15 +0300
Message-ID: <1314130096-3723-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is a RFC, man pages are absent and just one big commit.  Here are
some specs for the new interface:

./btrfs fi restripe start [-d[filters]] [-m[filters]] [-s[filters]]
    [-vf] <path>

where 'filters' is comma-separated list of filters (comma == AND):

o profiles={profiles mask} - profiles filter

    profiles mask is '|'-separated list ('|' == OR) of profiles

o usage={percentage} - usage filter

o devid={devid} - devid filter

o drange={start..end} - devid subset filter, it's tied to devid filter:
we say balance out range [start..end) on a particular devid.  These are
also acceptable:

    drange=start.. - [start..end of device)
    drange=..end - [start of device..end)

o vrange={start..end} - virtual address space subset filter.  Same forms
as above are acceptable.

Convert (profile changing) is specified as follows:

o convert={profile},[soft]

    soft parameter makes sense only for convert option.  It turns on
"soft" mode for profile changing, see the kernel patch.

Each chunk type can be either balanced or converted to some new profile.
By specifying some filters w/o convert option we balance chunks that
passed all filters (remember, comma == AND).  If only convert parameter
is specified we convert all chunks of that type.  If both convert and
filters are specified restriper filters out chunks according to the
given filters and then converts everything that passed through all the
filters.

Some examples:

o ./btrfs fi restripe start <path>

will balance everything (what ./btrfs fi balance <path> would do)

o ./btrfs fi restripe start -d

will balance only data chunks

o ./btrfs fi restripe start -d -s

will balance all data and system chunks, won't touch meta chunks

o ./btrfs fi restripe start -dprofiles=raid1\|raid0

\ - shell escape, will balance only data chunks that have raid1 or
raid0 profile

o ./btrfs fi restripe start -mprofiles=raid1\|raid0,devid=2

will balance meta chunks that have raid1 or raid0 profile and at least
one stripe located on device with devid 2

o ./btrfs fi restripe start -s -musage=80,profiles=dup

will balance all system chunks and dup'ed metadata chunks which are less
than 80% full

o ./btrfs fi restripe start -s -mprofiles=dup,convert=raid1

will *balance* all system chunks and *convert* dup meta chunks to raid1

o ./btrfs fi restripe start -dvrange=100..803337011,convert=raid0,soft

will soft-convert chunks in that virtual address space range to raid0

Note that you can't put a space between e.g. -m and a list of filters
because of the way getopt(3) works.  There are also long options, if you
prefer (--data, --metadata, --system), e.g:

    ./btrfs fi restripe start --data=profiles=raid1\|raid0

All permutations are possible, restriper doesn't care about the order in
which options are given, all settings are per-chunk-type, and what you
do with one chunk type is completely independent of what you do with the
other.

The -f (--force) flag has to be given if you want to "downgrade" the
profile.  By downgrading I mean reducing the number of copies, so
raid10->raid1 can be done w/o this flag, while raid1->raid0 cannot.

And the management commands:

./btrfs fi restripe cancel <path>
./btrfs fi restripe pause <path>
./btrfs fi restripe resume <path>

Any suggestions on the interface are welcome.  Patch is on top of tmp
branch of cmason's repo, available at:

git://github.com/idryomov/btrfs-progs.git restriper-rfc

Thanks,

		Ilya


Ilya Dryomov (1):
  Btrfs-progs: add restriper commands

 btrfs.c      |   25 +++-
 btrfs_cmds.c |  508 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs_cmds.h |    5 +
 ctree.h      |    9 +
 ioctl.h      |   44 +++++
 print-tree.c |    3 +
 volumes.h    |   42 +++++
 7 files changed, 632 insertions(+), 4 deletions(-)

-- 
1.7.5.4

