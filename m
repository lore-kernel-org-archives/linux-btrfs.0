Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdKMXjg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 18:39:36 -0500
Subject: Re: [GIT PULL] Btrfs changes for 4.15
To: David Sterba <dsterba@suse.com>, torvalds@linux-foundation.org
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1510586794.git.dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <abc907f7-b4de-c999-95cd-b241589a5305@gmx.com>
Date: Tue, 14 Nov 2017 07:39:11 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1510586794.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d5DPJi0l6fCv8bWtHVDX7fSb7lAcpKosh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d5DPJi0l6fCv8bWtHVDX7fSb7lAcpKosh
Content-Type: multipart/mixed; boundary="wVFQ78wmDJEL6ctcgHPICVU0qd0Wsr1Rg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, torvalds@linux-foundation.org
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <abc907f7-b4de-c999-95cd-b241589a5305@gmx.com>
Subject: Re: [GIT PULL] Btrfs changes for 4.15
References: <cover.1510586794.git.dsterba@suse.com>
In-Reply-To: <cover.1510586794.git.dsterba@suse.com>

--wVFQ78wmDJEL6ctcgHPICVU0qd0Wsr1Rg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 23:35, David Sterba wrote:
> Hi,
>=20
> please pull the following btrfs changes. There are some new user featur=
es and
> the usual load of invisible enhancements or cleanups. The branch merges=

> cleanly, has been frozen in case rc7 was the last one, so I send out th=
e pull
> request early. Thanks.
>=20
>=20
> New features:
>=20
> - extend mount options to specify zlib compression level, -o compress=3D=
zlib:9

However the support for it has a big problem, it will cause wild memory
access for "-o compress" mount option.

Kernel ASAN can detect it easily and we already have user report about
it. Btrfs/026 could also easily trigger it.

The fixing patch is submitted some days ago:
https://patchwork.kernel.org/patch/10042553/

And the default compression level when not specified is zero, which
means no compression but directly memory copy.

Thanks,
Qu

>=20
> - v2 of ioctl "extent to inode mapping", addressing a usecase where we =
want to
>   retrieve more but inaccurate results and do the postprocessing in use=
rspace,
>   aiding defragmentation or deduplication tools
>=20
> - populate compression heuristics logic, do data sampling and try to gu=
ess
>   compressibility by: looking for repeated patterns, counting unique by=
te
>   values and distribution, calculating Shannon entropy;
>   this will need more benchmarking and possibly fine tuning, but the ba=
se
>   should be good enough
>=20
> - enable indexing for btrfs as lower filesystem in overlayfs
>=20
> - speedup page cache readahead during send on large files
>=20
>=20
> Internal enhancements:
>=20
> - more sanity checks of b-tree items when reading them from disk
>=20
> - more EINVAL/EUCLEAN fixups, missing BLK_STS_* conversion, other errno=
 or
>   error handling fixes
>=20
> - remove some homegrown IO-related logic, that's been obsoleted by core=
 block
>   layer changes (batching, plug/unplug, own counters)
>=20
> - add ref-verify, optional debugging feature to verify extent reference=

>   accounting
>=20
> - simplify code handling outstanding extents, make it more clear where =
and how
>   the accounting is done
>=20
> - make delalloc reservations per-inode, simplify the code and make the =
logic
>   more straightforward
>=20
> - extensive cleanup of delayed refs code
>=20
>=20
> Notable fixes:
>=20
> - fix send ioctl on 32bit with 64bit kernel
>=20
>=20
> The branch top commit matches the signed tag for-4.15-tag.
>=20
> ----------------------------------------------------------------
> The following changes since commit 0b07194bb55ed836c2cc7c22e866b87a1468=
1984:
>=20
>   Linux 4.14-rc7 (2017-10-29 13:58:38 -0700)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.1=
5
>=20
> for you to fetch changes up to d28e649a5c58b779b303c252c66ee84a0f2c3b32=
:
>=20
>   btrfs: Fix bug for misused dev_t when lookup in dev state hash table.=
 (2017-11-01 20:45:36 +0100)
>=20
> ----------------------------------------------------------------
> Adam Borowski (1):
>       btrfs: allow setting zlib compression level via :9
>=20
> Allen Pais (1):
>       btrfs: return -ENOMEM on allocation failure in btrfsic
>=20
> Anand Jain (13):
>       btrfs: declare TRACE_DEFINE_ENUM for each of show_flush_state enu=
m
>       btrfs: copy fsid to super_block s_uuid
>       btrfs: undo writable superblocke when sprouting fails
>       btrfs: fix BUG_ON in btrfs_init_new_device()
>       btrfs: error out if btrfs_attach_transaction() fails
>       btrfs: add_missing_dev() should return the actual error
>       btrfs: fix EIO misuse to report missing degraded option
>       btrfs: declare btrfs_report_missing_device() static
>       btrfs: fix use of error or warning for missing device
>       btrfs: use BLK_STS defines where needed
>       btrfs: use need_full_stripe() in __btrfs_map_block()
>       btrfs: fix false EIO for missing device
>       btrfs: remove BUG_ON in btrfs_rm_dev_replace_free_srcdev()
>=20
> Arnd Bergmann (1):
>       btrfs: tree-checker: use %zu format string for size_t
>=20
> Christophe JAILLET (1):
>       btrfs: tests: Fix a memory leak in error handling path in 'run_te=
st()'
>=20
> Christos Gkekas (2):
>       btrfs: Clean up dead code in root-tree
>       btrfs: Clean up unused variables in free-space-tree.c
>=20
> Colin Ian King (2):
>       btrfs: avoid null pointer dereference on fs_info when calling btr=
fs_crit
>       btrfs: make array types static const, reduces object code size
>=20
> David Sterba (4):
>       btrfs: scrub: get rid of sector_t
>       btrfs: rename page offset parameter in submit_extent_page
>       btrfs: get rid of sector_t and use u64 offset in submit_extent_pa=
ge
>       btrfs: allow to set compression level for zlib
>=20
> Goldwyn Rodrigues (1):
>       btrfs: cleanup extent locking sequence
>=20
> Gu JinXiang (2):
>       btrfs: Use bd_dev to generate index when dev_state_hashtable add =
items.
>       btrfs: Fix bug for misused dev_t when lookup in dev state hash ta=
ble.
>=20
> Hans van Kranenburg (1):
>       btrfs: prefix sysfs attribute struct names
>=20
> Josef Bacik (22):
>       btrfs: change how we decide to commit transactions during flushin=
g
>       btrfs: fix send ioctl on 32bit with 64bit kernel
>       btrfs: add ref-verify mount option
>       btrfs: pass root to various extent ref mod functions
>       Btrfs: add a extent ref verify tool
>       Btrfs: only check delayed ref usage in should_end_transaction
>       btrfs: add a helper to return a head ref
>       btrfs: move extent_op cleanup to a helper
>       btrfs: breakout empty head cleanup to a helper
>       btrfs: move ref_mod modification into the if (ref) logic
>       btrfs: move all ref head cleanup to the helper function
>       btrfs: remove delayed_ref_node from ref_head
>       btrfs: remove type argument from comp_tree_refs
>       btrfs: add assertions for releasing trans handle reservations
>       Btrfs: rework outstanding_extents
>       btrfs: add tracepoints for outstanding extents mods
>       btrfs: make the delalloc block rsv per inode
>       btrfs: switch args for comp_*_refs
>       btrfs: add a comp_refs() helper
>       btrfs: track refs in a rb_tree instead of a list
>       btrfs: don't call btrfs_start_delalloc_roots in flushoncommit
>       btrfs: move btrfs_truncate_block out of trans handle
>=20
> Kuanling Huang (1):
>       Btrfs: send, apply asynchronous page cache readahead to enhance p=
age read
>=20
> Liu Bo (13):
>       Btrfs: remove batch plug in run_scheduled_IO
>       Btrfs: move finish_wait out of the loop
>       Btrfs: use wait_event instead of a single function
>       Btrfs: protect conditions within root->log_mutex while waiting
>       Btrfs: search parity device wisely
>       Btrfs: do not async submit for nodatasum inodes
>       Btrfs: make plug in writing meta blocks really work
>       Btrfs: remove bio_flags which indicates a meta block of log-tree
>       Btrfs: fix confusing worker helper info in stacktrace
>       Btrfs: fix memory leak in raid56
>       Btrfs: remove nr_async_bios
>       Btrfs: do not make defrag wait on async_delalloc_pages
>       Btrfs: remove nr_async_submits and async_submit_draining
>=20
> Nikolay Borisov (11):
>       btrfs: Remove redundant forward declarations
>       btrfs: Remove unused variable
>       btrfs: Remove unused parameters from various functions
>       btrfs: Remove unused arguments from btrfs_changed_cb_t
>       btrfs: Remove unused parameter from check_direct_IO
>       btrfs: Rework error handling of add_extent_mapping in __btrfs_all=
oc_chunk
>       btrfs: Remove redundant argument of __link_block_group
>       btrfs: Explicitly handle btrfs_update_root failure
>       btrfs: Refactor transaction handling in received subvolume ioctl
>       btrfs: Replace opencoded sizes with their symbolic constants
>       btrfs: send: remove unused code
>=20
> Omar Sandoval (2):
>       Btrfs: make some volumes.c functions static
>       Btrfs: fix __user casting in ioctl.c
>=20
> Qu Wenruo (9):
>       btrfs: Refactor check_leaf function for later expansion
>       btrfs: Check if item pointer overlaps with the item itself
>       btrfs: Add sanity check for EXTENT_DATA when reading out leaf
>       btrfs: Add checker for EXTENT_CSUM
>       btrfs: Move leaf and node validation checker to tree-checker.c
>       btrfs: tree-checker: Enhance btrfs_check_node output
>       btrfs: tree-checker: Enhance output for btrfs_check_leaf
>       btrfs: tree-checker: Enhance output for check_csum_item
>       btrfs: tree-checker: Enhance output for check_extent_data_item
>=20
> Rakesh Pandit (1):
>       btrfs: use appropriate replacements for __sb_{start,end}_write ca=
lls
>=20
> Satoru Takeuchi (1):
>       btrfs: convert all mount option checking code to use btrfs_test_o=
pt
>=20
> Thomas Meyer (1):
>       btrfs: Fix bool initialization/comparison
>=20
> Timofey Titovets (9):
>       Btrfs: cleanup 'start' subtraction from try uncompressed inline e=
xtent
>       Btrfs: compress_file_range remove dead variable num_bytes
>       Btrfs: compression: separate heuristic/compression workspaces
>       Btrfs: heuristic: add bucket and sample counters and other define=
s
>       Btrfs: heuristic: implement sampling logic
>       Btrfs: heuristic: add detection of repeated data patterns
>       Btrfs: heuristic: add byte set calculation
>       Btrfs: heuristic: add byte core set calculation
>       Btrfs: heuristic: add Shannon entropy calculation
>=20
> Zygo Blaxell (3):
>       btrfs: add a flag to iterate_inodes_from_logical to find all exte=
nt refs for uncompressed extents
>       btrfs: add a flags argument to LOGICAL_INO and call it LOGICAL_IN=
O_V2
>       btrfs: increase output size for LOGICAL_INO_V2 ioctl
>=20
>  fs/btrfs/Kconfig                       |   11 +
>  fs/btrfs/Makefile                      |    3 +-
>  fs/btrfs/async-thread.c                |    2 +-
>  fs/btrfs/backref.c                     |   72 ++-
>  fs/btrfs/backref.h                     |    8 +-
>  fs/btrfs/btrfs_inode.h                 |   29 +-
>  fs/btrfs/check-integrity.c             |    8 +-
>  fs/btrfs/compression.c                 |  493 ++++++++++++++-
>  fs/btrfs/compression.h                 |    6 +-
>  fs/btrfs/ctree.c                       |   17 +-
>  fs/btrfs/ctree.h                       |   30 +-
>  fs/btrfs/delayed-inode.c               |   46 +-
>  fs/btrfs/delayed-ref.c                 |  296 +++++----
>  fs/btrfs/delayed-ref.h                 |   54 +-
>  fs/btrfs/disk-io.c                     |  227 ++-----
>  fs/btrfs/extent-tree.c                 |  829 ++++++++++++------------=
-
>  fs/btrfs/extent_io.c                   |   44 +-
>  fs/btrfs/extent_io.h                   |    1 -
>  fs/btrfs/file.c                        |   50 +-
>  fs/btrfs/free-space-tree.c             |    4 -
>  fs/btrfs/inode-map.c                   |    3 +-
>  fs/btrfs/inode.c                       |  327 ++++------
>  fs/btrfs/ioctl.c                       |  156 +++--
>  fs/btrfs/lzo.c                         |    5 +
>  fs/btrfs/ordered-data.c                |   21 +-
>  fs/btrfs/qgroup.c                      |    8 +-
>  fs/btrfs/raid56.c                      |   30 +-
>  fs/btrfs/ref-verify.c                  | 1031 ++++++++++++++++++++++++=
++++++++
>  fs/btrfs/ref-verify.h                  |   62 ++
>  fs/btrfs/relocation.c                  |   17 +-
>  fs/btrfs/root-tree.c                   |    4 -
>  fs/btrfs/scrub.c                       |   22 +-
>  fs/btrfs/send.c                        |   74 +--
>  fs/btrfs/send.h                        |    2 +-
>  fs/btrfs/super.c                       |   37 +-
>  fs/btrfs/sysfs.c                       |   63 +-
>  fs/btrfs/sysfs.h                       |   26 +-
>  fs/btrfs/tests/free-space-tree-tests.c |    3 +-
>  fs/btrfs/tests/inode-tests.c           |   20 +-
>  fs/btrfs/tests/qgroup-tests.c          |   30 +-
>  fs/btrfs/transaction.c                 |   16 +-
>  fs/btrfs/tree-checker.c                |  425 +++++++++++++
>  fs/btrfs/tree-checker.h                |   26 +
>  fs/btrfs/tree-log.c                    |   34 +-
>  fs/btrfs/volumes.c                     |  168 +++---
>  fs/btrfs/volumes.h                     |    2 -
>  fs/btrfs/zlib.c                        |   15 +-
>  fs/btrfs/zstd.c                        |    5 +
>  include/trace/events/btrfs.h           |   41 +-
>  include/uapi/linux/btrfs.h             |    8 +-
>  include/uapi/linux/btrfs_tree.h        |    1 +
>  51 files changed, 3356 insertions(+), 1556 deletions(-)
>  create mode 100644 fs/btrfs/ref-verify.c
>  create mode 100644 fs/btrfs/ref-verify.h
>  create mode 100644 fs/btrfs/tree-checker.c
>  create mode 100644 fs/btrfs/tree-checker.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--wVFQ78wmDJEL6ctcgHPICVU0qd0Wsr1Rg--

--d5DPJi0l6fCv8bWtHVDX7fSb7lAcpKosh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloKLR8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjHIQgAoSUGyinV69kce48zMmVO+gIL
EuCadVn2BfBnYAbQsKBu/OkSsEa5dOh9ch3vuRld4ywBj188Q0Kh5fEekHq1TMTZ
gSmBjoFjXEJousI0KCLhIJEEGTjA2Qk8s41eMphJ6Qtd83BNqB0NhBOHOL65dCFh
3HZmd9zq0zbuPt4CjCM1hV6BXnpbwZcPDT5Nl6SyrChUybKNF83WU5zyDug7bqpS
BusCdbE8Nd/Qe71N34TKXIeeeg849/ourXL8kvhg1A7KSah6zB3coRCxu4uwllEw
WGAC3fGFLLPD9k7uDt7ejgyYfkN9v99/5ER8L6Tqmo0viRjNIGof+0dsp39LrA==
=BTq7
-----END PGP SIGNATURE-----

--d5DPJi0l6fCv8bWtHVDX7fSb7lAcpKosh--
