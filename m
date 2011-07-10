From: Arne Jansen <sensille@gmx.net>
Subject: [RFC] Subvolume Quota on-disk structures and configuration
Date: Sun, 10 Jul 2011 10:21:49 +0200
Message-ID: <4E19611D.2090007@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Now that I've got a working prototype of subvolume quota, I'd like to
get some feedback on the on-disk structure and the commands I intend
to use.
As a short name, I propose qgroups, as the most distinguishing feature
of this implementation is that you can not only put a quota on sub-
volumes, but also on groups of subvolumes, and even on groups of
groups. You can build a hierarchy that can, but not necessarily have to,
reflect the filesystem hierarchy.
There are two main numbers where you can put a quota on, the
'referenced' and the 'exclusive' count. 'Referenced' means the full
amount of data a subvolume or group contains, no matter if it's also
shared with other subvolumes (e.g. snapshots) or not. 'Exclusive' on the
other hand means the amount of data for which _all_ references can be
reached from this subvolume or group. In case of a subvolume,
'exclusive' is just the amount of space that will be freed if you delete
the subvolume. I'll explain this in more detail when I send the patch.

But now to the on-disk structure. All quota related configuration go
into a separate tree, the quota tree:

#define BTRFS_QUOTA_TREE_OBJECTID 8ULL


4 new keys get introduced for that:

/*
  * Records the overall state of the qgroups.
  * There's only one instance of this key present,
  * (0, BTRFS_QGROUP_STATUS_KEY, 0)
  */
#define BTRFS_QGROUP_STATUS_KEY         240
/*
  * Records the currently used space of the qgroup.
  * One key per qgroup, (0, BTRFS_QGROUP_INFO_KEY, qgroupid).
  */
#define BTRFS_QGROUP_INFO_KEY           242
/*
  * Contains the user configured limits for the qgroup.
  * One key per qgroup, (0, BTRFS_QGROUP_LIMIT_KEY, qgroupid).
  */
#define BTRFS_QGROUP_LIMIT_KEY          244
/*
  * Records the child-parent relationship of qgroups. For
  * each relation, 2 keys are present:
  * (childid, BTRFS_QGROUP_RELATION_KEY, parentid)
  * (parentid, BTRFS_QGROUP_RELATION_KEY, childid)
  */
#define BTRFS_QGROUP_RELATION_KEY       246

The keys are chosen in a way that first comes the STATUS_KEY,
followed by all INFO_KEYs, followed by all LIMIT_KEYs.
After that, for each qgroup present all relations follow.
Only the INFO_KEYs and the STATUS_KEY get updated regularly.
The idea is that those keys stay close to each other, to
minimize writes. The RELATION_KEY is chosen in a way that by
a simple enumeration all children and parents for a given
qgroup can be found.
The qgroupid is composed of a 16 bit 'level' field, followed by
a 48 bit 'id' field. Currently, a qgroupid is represented as
level/id, e.g. 2/100, but that is subject to discussion. In the
case of a subvolume, the level is 0, and the 'id' is just the
internal tree objectid (5 or >= 256). On the command line, the
user will be able to use the subvolume-path as the identifier.

/*
  * is subvolume quota turned on?
  */
#define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
/*
  * SCANNING is set during the initialization phase
  */
#define BTRFS_QGROUP_STATUS_FLAG_SCANNING	(1ULL << 1)
/*
  * Some qgroup entries are known to be out of date,
  * either because the configuration has changed in a way that
  * makes a rescan necessary, or because the fs has been mounted
  * with a non-qgroup-aware version.
  * Turning qouta off and on again makes it inconsistent, too.
  */
#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT   (1ULL << 2)

#define BTRFS_QGROUP_STATUS_VERSION		1

struct btrfs_qgroup_status_item {
	__le64 version;
	/*
	 * the generation is updated during every commit. As older
	 * versions of btrfs are not aware of qgroups, it will be
	 * possible to detect inconsistencies by checking the
	 * generation on mount time
	 */
         __le64 generation;

	/* flag definitions see above */
         __le64 flags;

	/*
	 * only used during scanning to record the progress
	 * of the scan. It contains a logical address
	 */
         __le64 scan;
} __attribute__ ((__packed__));

Instead of hosting the scan cursor in the structure, one could
also make a separate key instead that is only present during
scanning.

struct btrfs_qgroup_info_item {
	/*
	 * only updated when any of the other values change
	 */
         __le64 generation;
         __le64 referenced;
         __le64 referenced_compressed;
         __le64 exclusive;
         __le64 exclusive_compressed;
} __attribute__ ((__packed__));

For all uncompressed data the same value will be recorded for
compressed and uncompressed. The *_compressed values represent
the amount of disk space used, the other values the amount of
space from a user perspective. Another way to name these members
might be *_ram and *_disk.
The uncompressed values are hard to get, so a first version
might not support them yet and just record the on-disk values
instead.

/* flags definition for qgroup limits */
#define BTRFS_QGROUP_LIMIT_MAX_REFERENCED        (1ULL << 0)
#define BTRFS_QGROUP_LIMIT_MAX_EXCLUSIVE         (1ULL << 1)
#define BTRFS_QGROUP_LIMIT_RSV_REFERENCED        (1ULL << 2)
#define BTRFS_QGROUP_LIMIT_RSV_EXCLUSIVE         (1ULL << 3)
#define BTRFS_QGROUP_LIMIT_REFERENCED_COMPRESSED (1ULL << 4)
#define BTRFS_QGROUP_LIMIT_EXCLUSIVE_COMPRESSED  (1ULL << 5)

struct btrfs_qgroup_limit_item {
         __le64 flags;
         __le64 max_referenced;
         __le64 max_exclusive;
         __le64 rsv_referenced;
         __le64 rsv_exclusive;
} __attribute__ ((__packed__));

The flags record which of the limits are to be enforced. The last
two flags indicate whether the compressed or the uncompressed value
is to limit.
This structure also contains reservations, though they might be hard to
implement, as btrfs has no clear understanding of how much free space
is left. A straightforward implementation might be very inaccurate and
the first version will probably not implement it. I nevertheless
included those values here as a means for future expansion.

As you can see some of the identifiers are quite lengthy, and it gets
worse when the corresponding set/get functions are defined. I'm
thinking about abbreviating all identifiers with:

qgrp - qgroup
rfer - referenced
excl - exclusive
cmpr - compressed


Now to the command line extension.

btrfs quota enable <path>

This enables the qgroup support and creates the quota tree. The quota
will be in an inconsistent state until a rescan is started (and com-
pleted).

btrfs quota disable [--cleanup] <path>

Disables quota support, but leaves the tree in place. An additional
--cleanup also deletes the tree, and with it the configuration info.

btrfs quota rescan <path>

Start a full rescan of the filesystem. This is necessary after some
configuration changes, after the initial creation and after the fs
has been mounted with an older version of btrfs.

btrfs qgroup show <path>

Shows the current configuration and used space info. Not sure on this
one yet, it will probably get split in multiple commands and get some
options to limit the output.

btrfs qgroup limit [--exclusive] <size>|none <qgroupid> <path>

This sets actual limits on a qgroup. If --exclusive is given, the
exclusive usage is limited instead of the referenced. I don't know
if there are use cases where both values need a (possibly different)
limit. <path> means the path to the root. Instead of "<qgroupid>
<path>", a path to a subvolume can be given instead.

btrfs qgroup create <qgroupid> <path>
btrfs qgroup destroy <qgroupid> <path>
btrfs qgroup assign <childid> <parentid> <path>
btrfs qgroup remove <childid> <parentid> <path>

These 4 commands are used to build hierarchical qgroups and are only
for advanced users. I'll explain more of the concepts in a later
paper.

The main point here is that in the simplest case, a user creates a
filesystem with initial quota support, creates his /var /usr /home
etc. subvolumes and limits them with commands like

btrfs qgroup limit 10g /usr

That should be simple enough for the common use case.

-Arne
