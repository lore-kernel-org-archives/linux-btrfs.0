Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751343AbdFYVfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Jun 2017 17:35:02 -0400
Subject: Re: [PULL] Btrfs for 4.13, part 1
To: Wang Shilong <wangshilong1991@gmail.com>, David Sterba <dsterba@suse.com>
References: <cover.1498229425.git.dsterba@suse.com>
 <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <93c6aac1-dfc3-ba27-6607-2439e7b3748d@suse.com>
Date: Sun, 25 Jun 2017 17:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qEF6VW8ItpVNE6tcJBkrIwipqU9r4EDSP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qEF6VW8ItpVNE6tcJBkrIwipqU9r4EDSP
Content-Type: multipart/mixed; boundary="xQgRjg1sTkD7ejdu4Pukg6HlEXP79E2rH";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Wang Shilong <wangshilong1991@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <93c6aac1-dfc3-ba27-6607-2439e7b3748d@suse.com>
Subject: Re: [PULL] Btrfs for 4.13, part 1
References: <cover.1498229425.git.dsterba@suse.com>
 <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
In-Reply-To: <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>

--xQgRjg1sTkD7ejdu4Pukg6HlEXP79E2rH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/24/17 6:05 AM, Wang Shilong wrote:
> Sorry for bikeshedding.
>=20
> On Fri, Jun 23, 2017 at 11:16 PM, David Sterba <dsterba@suse.com> wrote=
:
>> Hi,
>>
>> this is the main batch for 4.13. There are some user visible changes, =
see
>> below. The core updates improve error handling (mostly related to bios=
), with
>> the usual incremental work on the GFP_NOFS (mis)use removal. All patch=
es have
>>
>> Fabian Frederick (1):
>>       btrfs: kmap() can't fail
>>
> <..SNIP..>
>>
>> Sargun Dhillon (2):
>>       btrfs: add quota override flag to enable quota override for CAP_=
SYS_RESOURCE
>>       btrfs: Add quota_override knob into sysfs
>>
>> Su Yue (9):
>>       btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond=
 boundary
>>       btrfs: Check name_len with boundary in verify dir_item
>>       btrfs: Check name_len on add_inode_ref call path
>>       btrfs: Verify dir_item in replay_xattr_deletes
>>       btrfs: Check name_len in btrfs_check_ref_name_override
>>       btrfs: Check name_len before read in iterate_dir_item
>>       btrfs: Check name_len before reading btrfs_get_name
>>       btrfs: Check name_len before in btrfs_del_root_ref
>>       btrfs: Verify dir_item in iterate_object_props
>=20
> Hmm..add those check might be expensive for metadata operations,
> especially in hot path, i could see similar behavior in Ext4 for ext4
> dentry check.
>=20
> Could we run some metadata tests to confirm=EF=BC=9Fit makes sense to
> add check but with min affects to performace.

Agreed.  XFS does this at read/write and results in invalid entries
never even making it to the consumer.  That's the approach I had
partially written up.  This approach has the advantage of being more
fine-grained so we don't end up dropping e.g. an entire node's worth of
entries but is more expensive to maintain and at runtime.

-Jeff

>> Timofey Titovets (3):
>>       Btrfs: lzo: fix typo in error message after failed deflate
>>       Btrfs: lzo: compressed data size must be less then input size
>>       Btrfs: compression must free at least one sector size
>>
>> Yonghong Song (1):
>>       Btrfs: add statx support
>>
>>  fs/btrfs/backref.c               |  10 +-
>>  fs/btrfs/check-integrity.c       |  53 ++---
>>  fs/btrfs/compression.c           |  94 ++------
>>  fs/btrfs/compression.h           |  44 +++-
>>  fs/btrfs/ctree.c                 |  42 ++--
>>  fs/btrfs/ctree.h                 |  84 ++++---
>>  fs/btrfs/delayed-ref.c           |  29 ++-
>>  fs/btrfs/delayed-ref.h           |   6 +-
>>  fs/btrfs/dir-item.c              |  94 +++++++-
>>  fs/btrfs/disk-io.c               | 179 +++++++--------
>>  fs/btrfs/disk-io.h               |   8 +-
>>  fs/btrfs/export.c                |   5 +
>>  fs/btrfs/extent-tree.c           | 481 +++++++++++++++++++++---------=
---------
>>  fs/btrfs/extent_io.c             | 217 ++++++++----------
>>  fs/btrfs/extent_io.h             |  82 +++++--
>>  fs/btrfs/file-item.c             |  31 ++-
>>  fs/btrfs/file.c                  |  46 ++--
>>  fs/btrfs/free-space-tree.c       |  38 ++--
>>  fs/btrfs/inode-map.c             |   4 +-
>>  fs/btrfs/inode.c                 | 449 ++++++++++++++++++++----------=
------
>>  fs/btrfs/ioctl.c                 |  16 +-
>>  fs/btrfs/lzo.c                   |  33 +--
>>  fs/btrfs/print-tree.c            |   7 +-
>>  fs/btrfs/props.c                 |   7 +
>>  fs/btrfs/qgroup.c                | 223 +++++++++++++-----
>>  fs/btrfs/qgroup.h                |   9 +-
>>  fs/btrfs/raid56.c                |  16 +-
>>  fs/btrfs/reada.c                 |   1 -
>>  fs/btrfs/relocation.c            |  15 +-
>>  fs/btrfs/root-tree.c             |   7 +
>>  fs/btrfs/scrub.c                 | 209 +++++++----------
>>  fs/btrfs/send.c                  | 112 ++++++---
>>  fs/btrfs/super.c                 |  72 +-----
>>  fs/btrfs/sysfs.c                 |  41 ++++
>>  fs/btrfs/tests/extent-io-tests.c |   2 +-
>>  fs/btrfs/transaction.c           |  23 +-
>>  fs/btrfs/tree-log.c              |  44 +++-
>>  fs/btrfs/volumes.c               |  74 +++---
>>  fs/btrfs/volumes.h               |   7 +
>>  fs/btrfs/xattr.c                 |   2 +-
>>  fs/btrfs/zlib.c                  |  20 +-
>>  include/trace/events/btrfs.h     |  36 ---
>>  include/uapi/linux/btrfs.h       |  63 +++--
>>  43 files changed, 1682 insertions(+), 1353 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--xQgRjg1sTkD7ejdu4Pukg6HlEXP79E2rH--

--qEF6VW8ItpVNE6tcJBkrIwipqU9r4EDSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWVAsgh57S2MheeWyAQhnNxAAp9wTTOyCW4JGh6VBmlAAKgrRq7ozHJkI
RHg+IEfMzXKJgdhdFyCzacs83zFB/UgnvEhvNbMypqEMqHWifz5u3Rjcn6J7mFus
nDGbq9AMeV7+5mlV3sAQsgDLGXxxYBTUimkrXiRrUhMVOhP+RC55EC2RC8u0mMou
juiExv7mTHBely6v+OQcajDEcxbY6K98hgW+v4MG1jICbvoQgLBQWdqFSS8l24Rl
1F7HTbDk5GuWNUQaVJJHdVmKr01QHACX7O2yaTf+LmiUEkF2zNhGEPFmgpPhzxB/
OjCi8TJi3gEx3wTR6NdpOYKNo8L9t2lmO5CFcl1UxNHZcQAEBxj3C08a3YpsC/6Q
3I8gx/YkEw532EFP6qhh0j7YcMFflp62x30N+JQMe0VFX/oEUM3HZnIl5PuMHq1C
iyq3RwsTmoKEv70BH9r7zNreZbyIDIJR+x6crcsyD0GeL01/udPzG0UmO0aCf7YI
H6SAgNRxXsTbM+Umsnir0x3W+pH/vxyMtsd3MAb495IUYQVb0bdDoKCOyKhutzOF
J3oI8NpOdNg7JXUxBEDm0Keyj0QObRYk74kDWb88LAwDyF5BcSIb83FhrxC0tAwi
oMt+37DE8JEMZLNXgZk54iN42PBTXI5r5DJeO5FQX4Rmh9jporw02pqadIMjcjbB
UKk+EEjrY4w=
=yWhS
-----END PGP SIGNATURE-----

--qEF6VW8ItpVNE6tcJBkrIwipqU9r4EDSP--
