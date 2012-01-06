From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: restriper interface
Date: Fri,  6 Jan 2012 16:37:59 +0200
Message-ID: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is an update of userspace restriper interface.  The main change is
that restriper commands have been moved under balance prefix.  So now we
have:

btrfs fi balance start
btrfs fi balance pause
btrfs fi balance cancel
btrfs fi balance resume
btrfs fi balance status

This breaks btrfs-progs backwards compatibility: to get the old
balancing behaviour you have to call 'btrfs fi balance start' instead of
'btrfs fi balance'.  This is caused by stupidity of the core sub-command
matcher.  There are also some other problems with that parser and I'll
fix them all in one commit shortly.  After that the "start" will be
optional:

btrfs fi balance [options]
btrfs fi balance start [options]

Apart from some minor error handling fixes went in.

Here are some specs:

./btrfs fi balance start [-d[filters]] [-m[filters]] [-s[filters]]
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

By default system chunks are relocated along with meta chunks with the
same exact options.  To operate explicitly on system chunks -f (--force)
flag has to be specified.

Examples (somewhat contrived, but they demonstrate the flexibility of
the interface):

o ./btrfs fi balance start <path>

will balance everything (what ./btrfs fi balance <path> did)

o ./btrfs fi balance start -d

will balance only data chunks

o ./btrfs fi balance start -d -m

will balance everything (because -m by default applies to system chunks
too, see above)

o ./btrfs fi balance start -d -s -f

will balance all data and system chunks, won't touch meta chunks (note
that the force is used to operate explicitly on system chunks)

o ./btrfs fi balance start -dprofiles=raid1\|raid0

will balance only data chunks that have raid1 or raid0 profile
(\ - shell escape)

o ./btrfs fi balance start -mprofiles=raid1\|raid0,devid=2

will balance meta and sys chunks that have raid1 or raid0 profile and at
least one stripe located on device with devid 2

o ./btrfs fi balance start -s -musage=80,profiles=dup -f

will balance all system chunks and dup'ed metadata chunks which are less
than 80% full

o ./btrfs fi balance start -s -mprofiles=dup,convert=raid1 -f

will *balance* all system chunks and *convert* dup meta chunks to raid1

o ./btrfs fi balance start -dvrange=100..803337011,convert=raid0,soft

will soft-convert data chunks in that virtual address space range to
raid0

Note that you can't put a space between e.g. -m and a list of filters
because of the way getopt(3) works.  There are also long options, if you
prefer (--data, --metadata, --system), e.g:

    ./btrfs fi balance start --data=profiles=raid1\|raid0

All permutations are possible, restriper doesn't care about the order in
which options are given, all settings are per-chunk-type, and what you
do with one chunk type is completely independent of what you do with the
other.

The force flag also has to be given if you want to "downgrade" the
profile.  By downgrading I mean reducing the number of copies, so
raid10->raid1 can be done w/o this flag, while raid1->raid0 cannot.

And the management commands:

./btrfs fi balance cancel <path>
./btrfs fi balance pause <path>
./btrfs fi balance resume <path>

./btrfs fi balance status [-v] <path>

Patch is on top of master branch of btrfs-progs repo, available at:

git://github.com/idryomov/btrfs-progs.git restriper

Thanks,

		Ilya


Ilya Dryomov (1):
  Btrfs-progs: add restriper commands

 btrfs.c      |   27 +++-
 btrfs_cmds.c |  577 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 btrfs_cmds.h |    8 +-
 ctree.h      |   23 ++-
 ioctl.h      |   53 ++++++
 print-tree.c |    6 +
 volumes.h    |   30 +++
 7 files changed, 687 insertions(+), 37 deletions(-)

-- 
1.7.6.3

