Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D884C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 06:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A81FF20693
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 06:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SQDF6nTl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfDKGAJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 02:00:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:40569 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDKGAJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 02:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554962407;
        bh=zzOSV9esLRW9hUwYE1kI9UIcSZ/cDlTjQnDkRo6E0bM=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=SQDF6nTlYznURI7/ZE1IDh2AO3mNvyhD/uzu62ONcqyXKVqU5yGZAAiemr+9qo7sP
         CBRrRspPki9tmGaxczt/JvvlIWAu7TQ67qwkwZB6VAi4+2B4Wnm++3Q81+cDSrYPtZ
         anElkuEiL330hAkCIMrgrZ70iQslG+TpvY4GNSpE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MFuWk-1h8QG61SFi-00EyEr; Thu, 11
 Apr 2019 07:54:49 +0200
To:     David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [PULL REQUEST] btrfs-progs updates, the main part
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <48f7ce97-b1cb-b7f8-5b4d-33c8e3737fcf@gmx.com>
Date:   Thu, 11 Apr 2019 13:54:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8yQEzljtdxcGdiLy0QFfUUCInCBpjDwx1"
X-Provags-ID: V03:K1:icW7W4HjowGpKystQky2jEzlPPUzGmtmsbyOdjUJ0XiGy37Jhpv
 XKx3Z8R5KR1KaKLLU/HhXeZIiR88AFfCJGAgdk7q6yUhKoBJnpIPVVgb7Yy2EVp1vMdkJxg
 jmMTPWbkRxyAmWEfnR84ZGFhS9A9T94EGSc5yiyScOoJ5Qu88bFWQelMBuJZ7ViItvQmd0y
 chQTQAkjrRhYV8EjpK6jg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BcL9Aqv3KAE=:81qtZRRIkJQNm/PUHdHP3Y
 WbeaAlDTZdEKxEFyyW4u1EkLHJ3goDAEJsZWvLmHolayESZbmNRF821J1sjWnzOaiMc/rPBkC
 Wt4+m2PS2bWJ/Hx3sutYl37l/P1Igi8neJ+LOvDLrqCR+kdqmUm1591EI1uYX3qm48UZ1JrqS
 +XJS+zBYsPygsYW0+ORudfk1eIljD4Na4e+A+FSJl0LAolZaBFt9OeRhio+zF32I9S8YaVMmW
 Uitx/h6k0+PTBCyZZ1DMZlDqUI6jcjTQ+IWtyVijUVwD3QtdkSPhXHk4haleu5D8/9fJ7XSsC
 6tGNS7XCH8iQxoYFLZ3HIKfFOhFd5zsjiZf/zeckhsKwemmTp0BOw7E5wE0REK3fbl6idOvfR
 cLnqCw8iatj6h3mnO+6aLXVLWdnqn2xrN7E6SS1gsjFgcfngBjo9N3JgvTfD+OBRKT1UtcN1x
 WmX6y0Yh9jGYRayUTygQAJywh+bXkVpxBym4wlSXfhQwlXZA/5BL8zCrIDU/KtMO77xW7Chgz
 Iv4MausYJGdKroa1/X/tgklFkrX9uoRDp7rgCWXpbU66BfvbpkK/bRYbn/eMrg4yNl5kIQEuz
 cUsddVy9k7Bl17sd8TLQq2r7bjiIqL6Om/9UvfUY9O1Q2vd1vuUJbjbH9q18BZnObcmNyKFXW
 qZ2v/C1y5ZmRUzrsJWSE4+rSMD602AKmpBKBU/9BawILmBmvbQKDyxfbsj78FEXctufROYyHr
 Id6VSxaaNpDCVwUSiddySjHF8jzXPVKYe2Wvovd3hJky+JzC3WNgyhzyfk4vCfPVXkT9DN8zx
 CK7KdPxFAdQeN0LvYKvKXpaGuuS8qiU4Uf8y0h6zYBj580oA68VRYiW/1PITyXTvbzxga0KbT
 8XuyzMLMTMdwED6/NLfvSbd4Rq9MsNkpjV45XPgxMEfuuv+tm6qYy4p8wsyKho
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8yQEzljtdxcGdiLy0QFfUUCInCBpjDwx1
Content-Type: multipart/mixed; boundary="cJ9pnAVa6DAvuvj806AZHZ6ucezpSwJmL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.cz>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <48f7ce97-b1cb-b7f8-5b4d-33c8e3737fcf@gmx.com>
Subject: [PULL REQUEST] btrfs-progs updates, the main part

--cJ9pnAVa6DAvuvj806AZHZ6ucezpSwJmL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

Here is my pull request for the btrfs-progs:
https://github.com/adam900710/btrfs-progs/tree/for_devel

The basis is the following commit from your devel branch:
commit a8389337c5a0e7c3fb32ff91d557889c036da73a
Author: Adam Borowski <kilobyte@angband.pl>
Date:   Mon Feb 25 19:16:44 2019 +0100

    btrfs-progs: defrag: open files RO on new enough kernels

This branch drops the following commit in your devel branch:
commit 4e8eb31f048f3fe9a68aacb58e4c0714df25b5c4 (david/devel)
Author: Qu Wenruo <wqu@suse.com>
Date:   Fri Sep 14 15:49:44 2018 +0800

    btrfs-progs: Do metadata preallocation as long as we're not
modifying extent tree

Due to test failure on looping chunk allocation.

The branch passes all selftests, except misc/035 which is a known problem=
=2E

This pull request include the following features:

Core change:
- check --repair
  * Flush/FUA support to avoid breaking metadata CoW
      Now btrfs-progs crashing or transaction aborted won't cause
      new transid error.
- device scan:
  * Add the ability to forget a device

Fixes and Enhancement:
- generic
  * Try best copy when reading tree blocks.
  * Skip unnecessary retry when one tree block copy fails.
  * Avoid back tree block to populate tree block cache.
- check
  * File extents repair no longer relies data in extent tree.
  * New ability to check and repair free space cache invalid inode mode.
  * Update backup roots when commit transaction.
- mkfs:
  * Enlarge metadata chunk size to follow kernel size.
- defrag
  * open file in RO for newer kernel.
- gitignore
  * Ignore hidden files.
- qgroup report
  * Handle unrecognized sort string.
- receive
  * New quite mode.
- Misc
  * More cleanup for fs_info <-> root parameters.

Adam Borowski (2):
  btrfs-progs: fix kernel version parsing on some versions past 3.0
  btrfs-progs: defrag: open files RO on new enough kernels

Anand Jain (3):
  btrfs-progs: device scan: add new option to forget one or all scanned
    devices
  btrfs-progs: dev replace: check for no result before using results
  btrfs-progs: dev replace: gracefully handle the exclusive operation
    report

David Sterba (21):
  btrfs-progs: device scan: constify path argument
  btrfs-progs: device scan: update help text
  btrfs-progs: device scan: update help text
  btrfs-progs: docs: add scan --forget
  btrfs-progs: device scan: update error messages
  btrfs-progs: device: update help texts
  btrfs-progs: help: add helper for unrecognized option error message
  btrfs-progs: help: update messages of argc constraint checkers
  btrfs-progs: help: use unknown command option helper
  btrfs-progs: help: don't print usage on wrong argument counts
  btrfs-progs: prop: let parsing helper return error to the caller
  btrfs-progs: prop: don't print full usage on invalid arguments
  btrfs-progs: prop: return only common error values
  btrfs-progs: find-root: use common usage helper for uknown option
  btrfs-progs: find-root: don't dump usage on wrong argument count
  btrfs-progs: find-root: use the common help infrastructure
  btrfs-progs: qgroup: report unknown option
  btrfs-progs: qgroup: remove unused option handling
  btrfs-progs: qgroup show: report errors while parsing sort string
  btrfs-progs: qgroup show: report unrecognized format of sort string
  btrfs-progs: qgoup: propagate errors from
    btrfs_qgroup_parse_sort_string

Lu Fengqi (2):
  btrfs-progs: lowmem: fix false alert about the existence of gaps in
    the check_file_extent
  btrfs-progs: tests: add case for inode lose one file extent

Nikolay Borisov (1):
  btrfs-progs: Remove get_argv0_buf

Qu Wenruo (20):
  btrfs-progs: Port kernel fs_devices::total_rw_bytes
  btrfs-progs: Unify metadata chunk size with kernel
  btrfs-progs: check: Fix false alert about uninitialized variable
  btrfs-progs: gitignore: Ignore hidden files
  btrfs-progs: Update backup roots when writing super blocks
  btrfs-progs: Free bad extent buffer as soon as possible
  btrfs-progs: Use @fs_info to replace @root for btrfs_check_leaf/node()
  btrfs-progs: Use mirror_num start from 1 to avoid unnecessary retry
  btrfs-progs: Move btrfs_num_copies() call out of the loop in
    read_tree_block()
  btrfs-progs: disk-io: Try to find a best copy when reading tree blocks
  btrfs-progs: check/lowmem: Add inode mode check
  btrfs-progs: check/original: Add inode mode check
  btrfs-progs: check/lowmem: Repair invalid inode mode in root tree
  btrfs-progs: check/original: Repair invalid inode mode in root tree
  btrfs-progs: check/lowmem: Check and repair free space cache inode
    mode
  btrfs-progs: check/original: Check and repair free space cache inode
    item
  btrfs-progs: tests/fsck: Add test image for free space cache mode
    repair
  btrfs-progs: disk-io: Make super block write error easier to read
  btrfs-progs: disk-io: Flush to ensure super block write is FUA
  btrfs-progs: Don't BUG_ON() when write_dev_supers() fails

Steven Davies (1):
  btrfs-progs: receive: add option for quiet mode

Su Yanjun (4):
  btrfs-progs: Revert "btrfs-progs: Add repair and report function for
    orphan file extent."
  btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to
    corresponding root."
  btrfs-progs: check: fix wrong @offset used in find_possible_backrefs()
  btrfs-progs: check: Delete file extent item with unaligned disk bytenr

Su Yue (7):
  btrfs-progs: lowmem: add argument path to punch_extent_hole()
  btrfs-progs: lowmem: move nbytes check before isize check
  btrfs-progs: lowmem: fix false alert if extent item has been repaired
  btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
  btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
  btrfs-progs: lowmem: delete unaligned bytes extent data under repair
  btrfs-progs: fsck-test: enable lowmem repair for case 001

 .gitignore                                    |   2 +-
 Documentation/btrfs-device.asciidoc           |  15 +-
 btrfs-corrupt-block.c                         |   2 +-
 btrfs-crc.c                                   |   4 +-
 btrfs-find-root.c                             |  35 +-
 btrfs-fragments.c                             |   2 +-
 btrfs-map-logical.c                           |   2 +-
 btrfs-select-super.c                          |   2 +-
 btrfstune.c                                   |   4 +-
 check/main.c                                  | 640 +++++++++++-------
 check/mode-common.c                           | 129 ++++
 check/mode-common.h                           |  29 +
 check/mode-lowmem.c                           | 323 +++++----
 check/mode-lowmem.h                           |   3 +
 check/mode-original.h                         |  31 +-
 cmds-balance.c                                |  14 +-
 cmds-device.c                                 | 112 ++-
 cmds-fi-du.c                                  |   4 +-
 cmds-fi-usage.c                               |   4 +-
 cmds-filesystem.c                             |  30 +-
 cmds-inspect-dump-super.c                     |   4 +-
 cmds-inspect-dump-tree.c                      |   4 +-
 cmds-inspect-tree-stats.c                     |   7 +-
 cmds-inspect.c                                |  19 +-
 cmds-property.c                               |  46 +-
 cmds-qgroup.c                                 |  42 +-
 cmds-quota.c                                  |   4 +-
 cmds-receive.c                                |  66 +-
 cmds-replace.c                                |  22 +-
 cmds-rescue.c                                 |  15 +-
 cmds-restore.c                                |   2 +-
 cmds-scrub.c                                  |  18 +-
 cmds-send.c                                   |   7 +-
 cmds-subvolume.c                              |  38 +-
 ctree.c                                       |  32 +-
 ctree.h                                       |  18 +-
 disk-io.c                                     | 181 ++++-
 fsfeatures.c                                  |   6 +-
 help.c                                        |  69 +-
 help.h                                        |   3 +
 ioctl.h                                       |   2 +
 qgroup.c                                      |  23 +-
 .../.lowmem_repairable                        |   0
 .../test.raw.xz                               | Bin 0 -> 159128 bytes
 .../.lowmem_repairable                        |   0
 .../default_case.img                          | Bin 0 -> 3072 bytes
 volumes.c                                     |  11 +-
 volumes.h                                     |   3 +
 48 files changed, 1359 insertions(+), 670 deletions(-)
 create mode 100644
tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable
 create mode 100644
tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.raw.xz
 create mode 100644
tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
 create mode 100644
tests/fsck-tests/038-missing-one-file-extent/default_case.img


Thanks,
Qu


--cJ9pnAVa6DAvuvj806AZHZ6ucezpSwJmL--

--8yQEzljtdxcGdiLy0QFfUUCInCBpjDwx1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyu1qQACgkQwj2R86El
/qjebAgAiphV12faN1C61tTImc6LzxYbFJ0R2/5m/nCDMcFfYI5pFRjS1ZlHth4y
nq0peOoc513ZI8YwcG/J/pb0EG9zhv1RHVOI8I81pLx/dCDWPi0ALyvojj+FY8Qp
c8An609K5bVWZHvFUc6t63X1T6R/cWMbeWcmyJpCw3Sv92cPxTYx4rblIpS2XOlt
n0okO7NuLbtSWRkaVKhDHImFjUwgtGFp+rvUVNqd/16uDTroOXXoLkXPs864bINq
aaiaX7p1F64NESJCXeBTETN5Dblk9uUoeqmXlNJvlgKTqSNrv5Fl13r3tWf5tToD
0ZystqovjEG9J6iIKb4McYlqR8mpQA==
=H4YX
-----END PGP SIGNATURE-----

--8yQEzljtdxcGdiLy0QFfUUCInCBpjDwx1--
