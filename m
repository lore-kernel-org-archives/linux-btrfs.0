Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34339 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbJBLsP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 07:48:15 -0400
Received: by qgez77 with SMTP id z77so91890686qge.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 04:48:15 -0700 (PDT)
Subject: Re: [PATCH v4 0/9] Btrfs: free space B-tree
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
References: <cover.1443583874.git.osandov@osandov.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <560E6ED2.4050306@gmail.com>
Date: Fri, 2 Oct 2015 07:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060305040602090503000901"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060305040602090503000901
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-29 23:50, Omar Sandoval wrote:
> Hi,
>
> Here's one more reroll of the free space B-tree patches, a more scalabl=
e
> alternative to the free space cache. Minimal changes this time around, =
I
> mainly wanted to resend this after Holger and I cleared up his bug
> report here: http://www.spinics.net/lists/linux-btrfs/msg47165.html. It=

> initially looked like it was a bug in a patch that Josef sent, then in
> this series, but finally Holger and I figured out that it was something=

> else in the queue of patches he carries around, we just don't know what=

> yet (I'm in the middle of looking into it). While trying to reproduce
> that bug, I ran xfstests about a trillion times and a bunch of stress
> tests, so this is fairly well tested now. Additionally, the last time
> around, Holger and Austin both bravely offered their Tested-bys on the
> series. I wasn't sure which patch(es) to tack them onto so here they
> are:
>
> Tested-by: Holger Hoffst=C3=A4tte <holger.hoffstaette@googlemail.com>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
I've re-run the same testing I did for the last iteration, and also=20
tested that the btrfs_end_transaction thing mentioned below works right=20
now (Ironically that's one of the few things I didn't think of testing=20
last time :)), so the Tested-by from me is current now.
>
> Thanks, everyone!
>
> Omar
>
> Changes from v3->v4:
>
> - Added a missing btrfs_end_transaction() to btrfs_create_free_space_tr=
ee() and
>    btrfs_clear_free_space_tree() in the error cases after we abort the
>    transaction (see http://www.spinics.net/lists/linux-btrfs/msg47545.h=
tml)
> - Rebased the kernel patches on v4.3-rc3
> - Rebased the progs patches on v4.2.1
>
> v3: http://www.spinics.net/lists/linux-btrfs/msg47095.html
>
> Changes from v2->v3:
>
> - Fixed a warning in the free space tree sanity tests caught by Zhao Le=
i.
> - Moved the addition of a block group to the free space tree to occur e=
ither on
>    the first attempt to modify the free space for the block group or in=

>    btrfs_create_pending_block_groups(), whichever happens first. This a=
voids a
>    deadlock (lock recursion) when modifying the free space tree require=
s
>    allocating a new block group. In order to do this, it was simpler to=
 change
>    the on-disk semantics: the superblock stripes will now appear to be =
free space
>    according to the free space tree, but load_free_space_tree() will st=
ill
>    exclude them when building the in-memory free space cache.
> - Changed the free_space_tree option to space_cache=3Dv2 and made clear=
_cache
>    clear the free space tree. If the free space tree has been created,
>    the mount will fail unless space_cache=3Dv2 or nospace_cache,clear_c=
ache
>    is given because we cannot allow the free space tree to get out of
>    date.
> - Did a once-over of the code and caught a couple of error handling typ=
os.
>
> v2: http://www.spinics.net/lists/linux-btrfs/msg46796.html
>
> Changes from v1->v2:
>
> - Cleaned up a bunch of unnecessary instances of "if (ret) goto out; re=
t =3D 0"
> - Added aborts in the free space tree code closer to the site the error=
 is
>    encountered: where we add or remove block groups, add or remove free=
 space,
>    and also when we convert formats
> - Moved loading of the free space tree into caching_thread() and added =
a new
>    patch 3 in preparation for it
> - Commented a bunch of stuff in the extent buffer bitmap operations and=

>    refactored some of the complicated logic
>
> v1: http://www.spinics.net/lists/linux-btrfs/msg46713.html
>
> Omar Sandoval (9):
>    Btrfs: add extent buffer bitmap operations
>    Btrfs: add extent buffer bitmap sanity tests
>    Btrfs: add helpers for read-only compat bits
>    Btrfs: refactor caching_thread()
>    Btrfs: introduce the free space B-tree on-disk format
>    Btrfs: implement the free space B-tree
>    Btrfs: add free space tree sanity tests
>    Btrfs: wire up the free space tree to the extent tree
>    Btrfs: add free space tree mount option
>
>   fs/btrfs/Makefile                      |    5 +-
>   fs/btrfs/ctree.h                       |  157 +++-
>   fs/btrfs/disk-io.c                     |   38 +
>   fs/btrfs/extent-tree.c                 |   98 +-
>   fs/btrfs/extent_io.c                   |  183 +++-
>   fs/btrfs/extent_io.h                   |   10 +-
>   fs/btrfs/free-space-tree.c             | 1584 +++++++++++++++++++++++=
+++++++++
>   fs/btrfs/free-space-tree.h             |   72 ++
>   fs/btrfs/super.c                       |   56 +-
>   fs/btrfs/tests/btrfs-tests.c           |   52 ++
>   fs/btrfs/tests/btrfs-tests.h           |   10 +
>   fs/btrfs/tests/extent-io-tests.c       |  138 ++-
>   fs/btrfs/tests/free-space-tests.c      |   35 +-
>   fs/btrfs/tests/free-space-tree-tests.c |  571 ++++++++++++
>   fs/btrfs/tests/qgroup-tests.c          |   20 +-
>   include/trace/events/btrfs.h           |    3 +-
>   16 files changed, 2925 insertions(+), 107 deletions(-)
>   create mode 100644 fs/btrfs/free-space-tree.c
>   create mode 100644 fs/btrfs/free-space-tree.h
>   create mode 100644 fs/btrfs/tests/free-space-tree-tests.c
>



--------------ms060305040602090503000901
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDAyMTE0NzMwWjBPBgkq
hkiG9w0BCQQxQgRA8x7INAovRPMX2guT8ZtAFYwiX9OSL7nNk4zLFssx89F7BnVGwpybnbCS
BY4O+z3Msnk4yQdlF/pK5yBMrV/AaTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAXp5ct7aPZqUpoEApPG8WeV/PWECGiri9MVryLWtCqxPags6H0
q45NYgwoRHQVW+Eaz5EEbox18O/g3xoKzIYm6pb0YjyITJQUi4iySYcrmh44OnLMkYZjmCPd
QakA+eSxJmUc1QnML6C/gM2+j0i6u4km6mibLG2FyZUGynfA4HjqoiGXJ0Lpc2Ge8JakTUPT
n5dCFm9IuvR/NlykX3lD80iXjPcJ3VDuIHF6dWqnMruQWRb2U6tQvfPtSFZ55ejBvrkxcqbk
B37h7WwhwUEo3YJqAh99VqngEX4ID5LSf6cnrGghvxs2496n/k8wyXW2Cun3IXCpTwuoE5WR
QUl1bmbmJa2pA425/qsd0/Hd074QOKMunQ6NgCum3B2rSwirOICepMKU3iPymQJuanjiEe0N
7gXiZwlCmCl1KGTeudszyZghvzbqY5EnUI9G0jmGPY/kGDpwQSTQktVz0JJiaUJDqLj/ye/8
DslL9CBrjoCreFG+Tg4S/7FotZfRekWVnU1e+AqmEYcmTUh2EiZPEQfzI0L4ml10itkkxAQr
/4891mabmMY0YfX+OGd7uJR/iAqbZqG8AnvyZZEZ0CoTgGWzLHlYRr9zUUFSCSOwoFzl/8fD
nNqkizciJl6I4ANFuI+Sw/DN4Yari7GSjUF0x+6JqW3Jzckia4CPrW6CaQAAAAAAAA==
--------------ms060305040602090503000901--
