From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [RFC] btrfs send and receive
Date: Mon, 01 Aug 2011 14:22:24 +0200
Message-ID: <4E369A80.9030307@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'd like btrfs to support full featured send and receive in the future.
If nobody is currently working on it, I'll grab the send/receive lock.
Now that I own the lock, I'm opening several discussions on this topic.
If you are in a hurry, it would be great if you could at least read and
comment on the KEY PROPERTIES section.

In short, the purpose of this mail is to
- acquire the send/receive lock
- find a name for a new feature
- define key properties and achieve consensus about them
- find a suitable streaming format


0) REMARK

First discussion point is not for discussion. Proof reading the email
showed that I'm using the term "file system" for implementations such as
ext3 and btrfs as well as a file system image. It should be clear from
the context everywhere.

I furthermore realized that the term "subvolume" is omitted in favor of
the term "snapshot". This is because I tend to think of snapshots being
read-only (though I very much appreciate they are not). Just replace the
term wherever you feel appropriate.


1) NAMING

Personally, I like "send" and "receive" as they convey the purpose and
do not leave much room to swap their meaning unintentionally.

I'll call the file system you use "send" on the source file system, and
(drum roll) the file system you use "receive" on the destination file
system.


2) USE CASES

I see two related use cases:

- backup of a file system
- migration of a file system to another disk / machine / ...


3) KEY PROPERTIES

I wrote down key features that are must haves for me, please add to the
list if you have anything on top:

- "send" must generate a stream that can either be "receive"d
  immediately or stored in a file for asynchronous "receive"
- streams must obviously be byte order safe
- a stream must contain a complete fs (full stream) or an incremental
  update to a file system
- a stream must not be restricted in size
- an incremental stream must contain the information which version it
  is based on
- "receive" of an incremental stream must check whether the base is
  the current state of the file system
    - YES => "receive"
    - NO, but is previous version
      => abort; should offer --force for rollback and "receive"
    - NO, does not match any previous version => abort
- a stream must be taken from a consistent state of the file system
- the source file system must remain read-writable during a "send"
- the destination file system must at least remain readable during a
  "receive"
- btrfs as a destination file system should reflect all features of
  the source file system
- other destination file systems must be supported (although some
  features will not map to all file systems)


4) EXISTING SOLUTIONS

Currently, some people use rsync for the aforementioned tasks. It solves
some of the key properties quite well, others not. Depending on how you
use rsync, you might not sync snapshots very well. You might have
problems with reflinks or sparse files. And rsync knows nothing about
when your latest sync was.

Some problems can be solved with the utility function "btrfs find-new",
but it does not provide any kind of consistency and has several other
drawbacks.


5) STREAMING FORMAT

An ideal streaming format can contain a complete file system or
incremental updates to a file system. It must transport meta information
(such as snapshots, reflinks, base of the file system, etc.) and file
information (such as holes, extended attributes, atime, ctime, mtime,
user, group, hardlinks, softlinks, device nodes, etc.). It should have a
feature to (optionally) store only parts of a modified file.

It would help if we could use tools already widely available to
encapsulate our backup streams. Imagine an existing streaming format
that is flexible enough to encode all the information needed for our key
properties. I like to put my backups in a different file system (like,
ext3 or zfs) on another machine, hence I'd love to do so without the
need of having btrfs or btrfs tools for this machine.

Currently, what I have in mind is a solution where "send --compatible"
produces a stream that can easily be unpacked by an unmodified version
of a standard tool (e.g. tar). This would likely include each file
completely that was modified since the reference point - it would never
contain a file partially. In contrast, "send --minimal" produces a
stream that might need a patched tool to be received and which contains
parts of files to save space. Meta information should be included in
both streams.

I haven't decided yet whether I'd like compression to be an integral
part of the stream. I currently tend to dislike that, but to be honest,
I have no good reason to do so. For now, I did some quick research and
looked at cpio, tar, ustar, pax and dar:

* cpio and tar have several drawbacks, I'll just mention that they
  can't go over 8GB in file size, making them unusable here.

* The successor of traditional tar, uniform standard tar (ustar) has
  only 255 characters (at max) per file in the archive and is not
  extendable.

* pax (portable archive exchange, do not confuse it with PaX) looks a
  lot better from a features perspective [1], and so does ...

* dar (disk archiver) [2].


5.A) Why it won't be dar

dar comes as a GPL program and a library (libdar), where the interesting
bits are encapsulated in the library. No formal or informal
specification of the file format exists, the library is the interface.
This can speed up implementation considerably, but it sucks in flexibility.

dar has a lot of useful features, one of which is built-in support for
creation of incremental archives, and even decremental archives [6]. It
has no built-in support for reflinks, though. Second no go for libdar:
it does all the work required to detect files that changed between two
backup runs, which is great for some file systems. However, we want to
make use of the fact that btrfs knows exactly what changed.


5.B) Confusing pax

I found a utility named pax at openbsd [3], which does not implement the
pax format. It has support for several formats, but the newest of them
is ustar. This implementation is at least used by Debian (and
derivatives), Gentoo, RedHat and MacOS.

OpenIndiana has a pax utility that implements the pax format, for which
I could not find source code. I found a Makefile which refers to pax as
"$(CLOSED)/cmd/pax" [4] which makes me think it's not open source.

I was already about to drop pax from my consideration completely, when I
accidentally realized that GNU tar has a --format=pax option (and has it
since 2004) [5]. Users of Solaris, OpenIndiana or similar will have to
use their pax utility, though, because their tar does not support pax
format. Kind of confusing...


5.C) The good in pax

The good thing about the pax format is that it is extendable at will.
You can use custom header records with key=value pairs of any length.
There are predefined keys and application specific ones can be added.

pax can be generated compatible with ustar, which means such an archive
could be unpacked almost everywhere. The general concept of pax is to
use the pax-specific headers in a way, that they will be ignored by a
tar utility that does understand ustar but not pax.


5.D) How pax could be used

(Knowledge of the format required for this paragraph, see [1]) This is
more like brain storming than something figured out carefully: btrfs
"send" could generate a stream beginning with a global pax header
(typeflag=g) for the name of the current snapshot. Then all the files
from this snapshot with custom pax headers (typeflag=x) as needed, to
encode reflinks, for example.

After the next global pax header we're in the next snapshot. This can
either contain any file that has changes completely (--compatible) or
the diffs for the file along with a custom header telling where the
diffs go (--minimal). The --compatible version could be extracted by any
tar from the shelf (provided file name length and such fit).

The result would be one file containing multiple snapshots for your file
system. Extraction of a single file would be possible, though listing
the files in the archive requires reading the whole file (with a lot of
large seeks over the data portions) as there is no central directory. As
an alternative, we could also start a new file for every snapshot we're
about to "send".

We can use more of the custom headers to encode reflinks in a way that
they will either be hard- or softlinks when extracted with a standard
tar. We can add inode numbers for each entry if we feel those should be
replicated to a destination btrfs and much more.


5.E) So it will be pax - will it?

To me it looks like pax is the most suitable, flexible and available
format to use. Unless somebody has serious objections or thoughts for a
better choice.


6) FINAL REMARK

I hope this longish introduction creates a lively discussion about the
advertised features - or at least silent acknowledgement and endorsement.

-Jan


[1] http://pubs.opengroup.org/onlinepubs/9699919799/utilities/pax.html
[2] http://dar.linux.free.fr/doc/man/dar.html
[3] http://www.openbsd.org/cgi-bin/cvsweb/src/bin/pax/
[4]
http://hg.openindiana.org/illumos-gate/raw-file/d3807abc6720/usr/src/cmd/Makefile
[5]
http://git.savannah.gnu.org/cgit/tar.git/commit/?id=ba08e339a6e05e2a0d1432efdadd67ff2c63f834
[6] http://dar.linux.free.fr/doc/usage_notes.html#Decremental_Backup
