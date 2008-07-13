From: Daniel Phillips <phillips@phunq.net>
Subject: Fwd: [RFC] Improved versioned pointer algorithms
Date: Sun, 13 Jul 2008 10:24:29 -0700
Message-ID: <200807131024.29421.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reposted to the moved mailing list... would be nice if the subscribe at
the old mailman page were disabled.  Btrfs-specific material near the
end of the mail.  Attachment omitted, available from the lkml post.

----------  Forwarded Message  ----------

Subject: [RFC] Improved versioned pointer algorithms
Date: Sunday 13 July 2008 01:55
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com, zfs-discuss@opensolaris.org

Greetings, filesystem algorithm fans.

The recent, detailed description of the versioned pointer method for
volume versioning is here:

   http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-07/msg02663.html

I apologize humbly for the typo in the first sentence.  Today's revision
of the proof of concept code is cleaned up to remove some redundant
logic from the exception delete and origin write algorithms, and has
a number of small improvements.  The fuzzing test has run to 20 million
iterations without problems.  Some of the more complex logic has become
simple to the point where it can possibly be seen to be correct in
addition to merely running correctly.

The current efficiency scores for the six basic operations are:

   Origin write:         O(exceptions)
   Snapshot write:       O(versions)
   Snapshot delete:      O(versions)
   Snapshot read:        O(exceptions)
   Snapshot of origin:   O(versions)
   Snapshot of snapshot: O(versions)

This is mainly about CPU time rather than filesystem efficiency.  The
real time performance will be dominated by disk operations as usual.

Snapshot write is a frequent operation and snapshot delete is performed
on large amounts of metadata at a time, so it would be nice to improve
their performance to be independent of the number of versions created.

O(exceptions) orphan test
-------------------------

It is only the orphan searches that increase snapshot write and
snapshot delete running times from O(exceptions) to O(versions),
otherwise the main algorithm is already O(exceptions).

The orphan test is used in snapshot write and exception delete to
identify any new orphans created as a result of a write that creates an
exclusive exception for the only heir of the ghost exception, or a
delete that removes the only heir and does not promote a new heir.

The current method of determining whether a ghost exception is an
orphan is to recurse through the subtree below the ghost until a visible
version is found that inherits the exception.  This traversal runs in 
O(versions) time.

To perform this test in O(exceptions) time, we proceed as follows:

First, identify a subtree of the version tree consisting only of ghost
versions in interior nodes and visible versions at terminal nodes,
descending from the ghost ancestor of the victim version nearest the
root and having no visible versions or present exceptions between itself
and the victim.  Call each interior node of that subtree a "nexus",
which must have more than one child because it is a ghost.  This step
is done once, prior to a full-tree version delete pass.

The interesting question is whether a ghost exception is inherited
by any visible version that does not appear in the same exception list.
If not, then the ghost exception is an orphan that must be deleted.

This can be computed efficiently using a bottom up approach with a
single pass through the exception list.  At each nexus keep a count of
the children of the nexus that are known not to inherit from that
nexus.  Call that the blocked count.  Set the blocked counts to zero
and:

   For each exception in the exception list:
      If the version labeled by the exception is in the ghost
      tree then increment the blocked count of the nexus parent

      If the blocked count is now equal to the number of children
      of the nexus then repeat from the preceding step

At completion, if the blocked count of the ghost ancestor is equal to
its child count then the ghost exception is an orphan, otherwise not.

Example
-------

Below, ghost versions are marked with ~ and members of the ghost tree
are marked with *.

.
`-- A
    |-- B
    `-- *C~
        |-- *D
        |-- E <== victim to be deleted
        `-- *F~
            |-- *G
            `-- *H
                |-- I
                `-- J

Version C is the single ghost ancestor (there may be more than one) that
may contain an orphan exception.  D does not belong to the ghost tree
because it is to be deleted and has already been removed from the
version tree when the ghost tree is constructed.  The interior nexus
nodes are C and F while D, G and H are terminal, user visible nodes of
the ghost tree.

Overlaying the exception list [I, p1] [G, p2] [C, p3] [D, p4] on the
example tree:

.
`-- A
    |-- B
    `-- *C~ [p3]
        |-- *D [p4]
        |-- E <== deleted victim
        `-- *F~
            |-- *G [p2]
            `-- *H
                |-- I [p1]
                `-- J

When exception [I, p1] is found it is ignored because it is not a member
of the ghost tree.  H has no exception, so [G, p2] cannot cause the
algorithm to iterate past node F.  Processing [D, p4] will raise the
nexus count at C to one, but C has two children after ignoring E (which
is deleted by this time) so [C, p3] is not an orphan.  Examining the
tree shows that visible version H continues to inherit the ghost
exception at C, which could now be relabeled to H if desired, but since
it will be detected and deleted in the fullness of time anyway there
is little point in doing that extra work here.

If any of versions F, H or J had an exception then [C, p3] would be an
orphan.

O(log(exceptions)) snapshot lookup
----------------------------------

An O(log(exceptions)) snapshot lookup is known to exist and is left as
an exercise for the interested reader.

Updated versioned pointers fuzztest attached
--------------------------------------------

   c99 fuzzversion.c && ./a.out

Request for comment from Btrfs and ZFS developers
-------------------------------------------------

I am considering the wisdom of developing a filesystem based on
versioned pointers.  The prospect of per-file and per-directory
versioning seems attractive, as does the elegant formulation of
snapshots-of-snapshots and the compact metadata.  I suspect that less
updating of metadata will be required for writes versus either Btrfs or
ZFS.  Mind you, there is no working filesystem code at the moment, only
ddsnap the snapshotting block device and the attached proof of concept
of versioned pointers, so some of this is speculation.

I described earlier how versioned pointers will be extended to versioned
extents but have not yet tried it.  This would be necessary in order to
operate in the same ballpark of efficiency as ZFS or Btrfs.

Versioned pointers have some advantages over versioning methods used in
ZFS and Btrfs, and also some potential drawbacks:

Advantages versus ZFS and Btrfs:

 * No per-write recursive copy on write of metadata blocks.  Creating a
   new copy of a data block normally only requires inserting a new
   versioned pointer to a btree leaf block.  Such inserts can be logged
   logically and added to the btree in large batches, which can be done
   atomically using standard methods (physical journal, log or copy on
   write).

Advantages versus Btrfs:

 * No reference count updates, which must be be durable and atomic,
   surely a painful overhead.  Instead, it can be determined entirely
   from the exception list whether a given block is referenced, so
   only exception lists need to be updated, and only by adding,
   removing, or in rare cases, relabeling physical pointers.

Advantages versus ZFS:

 * No need to maintain a dead list.  This information can be entirely
   determined from the combination of the versioned pointers and the
   version tree.

 * It would seem that ZFS is deeply wedded to the concept of a single,
   linear chain of snapshots.  No snapshots of snapshots, apparently.
   http://blogs.sun.com/ahrens/entry/is_it_magic

Drawbacks of versioned pointers:

 * All version info stored together for any given logical address.
   This will require reading more metadata blocks as the number of
   versions increases, and put more pressure on cache.  How to fix: with
   extents, metadata is tiny compared to data, even if expanded by a
   large factor, so it may not matter.  If it does, an in-memory version
   of accessed btree nodes for a particular snapshot can be cached and
   saved persistently to disk so that the full version btree only
   rarely needs to be accessed.

 * Delete is a full tree pass over the metadata.  But this can be done
   in the background for multiple deleted versions per pass.  Also can
   keep a persistent cache per version of which logical address ranges
   have exceptions for a given version to limit the search.

 * Limited number of versions.  This can be overcome mindlessly by
   extending the size of a physical pointer, or more elegantly by
   keeping a per-leaf "wide" translation table of versions referenced
   by the leaf, or both depending on which representation is smaller for
   a particular leaf.


-------------------------------------------------------
