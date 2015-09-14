Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35734 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbbINPSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 11:18:50 -0400
Received: by ioiz6 with SMTP id z6so168834331ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 08:18:49 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] Btrfs: free space B-tree
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
References: <cover.1442209006.git.osandov@osandov.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F6E54C.8040404@gmail.com>
Date: Mon, 14 Sep 2015 11:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070204080605030900050108"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070204080605030900050108
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-14 02:04, Omar Sandoval wrote:
> Hi, everyone,
>
> I went back and fixed the issues that came up since v2. Changes below. =
I
> removed Josef's Reviewed-by on patch 9 because it was completely
> rewritten to change the mount options like Dave suggested. These are
> still based on 4.2
>
> Thanks!
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
>   fs/btrfs/free-space-tree.c             | 1581 +++++++++++++++++++++++=
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
>   16 files changed, 2922 insertions(+), 107 deletions(-)
>   create mode 100644 fs/btrfs/free-space-tree.c
>   create mode 100644 fs/btrfs/free-space-tree.h
>   create mode 100644 fs/btrfs/tests/free-space-tree-tests.c
>
I've tested this in a couple of different VM's and got noticeable=20
performance improvements in both general usage and mount times.  I also=20
threw everything I can think of at it (short of attempting to craft=20
filesystem images specifically to break it), and nothing broke, so:

Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>


--------------ms070204080605030900050108
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMQblUwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwMzI1MTkzNDM4WhcNMTUwOTIxMTkzNDM4WjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
ZXIxIzAhBgkqhkiG9w0BCQEWFGFoZmVycm9pbjdAZ21haWwuY29tMSIwIAYJKoZIhvcNAQkB
FhNhaGVtbWVsZ0BvaGlvZ3QuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
nQ/81tq0QBQi5w316VsVNfjg6kVVIMx760TuwA1MUaNQgQ3NyUl+UyFtjhpkNwwChjgAqfGd
LIMTHAdObcwGfzO5uI2o1a8MHVQna8FRsU3QGouysIOGQlX8jFYXMKPEdnlt0GoQcd+BtESr
pivbGWUEkPs1CwM6WOrs+09bAJP3qzKIr0VxervFrzrC5Dg9Rf18r9WXHElBuWHg4GYHNJ2V
Ab8iKc10h44FnqxZK8RDN8ts/xX93i9bIBmHnFfyNRfiOUtNVeynJbf6kVtdHP+CRBkXCNRZ
qyQT7gbTGD24P92PS2UTmDfplSBcWcTn65o3xWfesbf02jF6PL3BCrVnDRI4RgYxG3zFBJuG
qvMoEODLhHKSXPAyQhwZINigZNdw5G1NqjXqUw+lIqdQvoPijK9J3eijiakh9u2bjWOMaleI
SMRR6XsdM2O5qun1dqOrCgRkM0XSNtBQ2JjY7CycIx+qifJWsRaYWZz0aQU4ZrtAI7gVhO9h
pyNaAGjvm7PdjEBiXq57e4QcgpwzvNlv8pG1c/hnt0msfDWNJtl3b6elhQ2Pz4w/QnWifZ8E
BrFEmjeeJa2dqjE3giPVWrsH+lOvQQONsYJOuVb8b0zao4vrWeGmW2q2e3pdv0Axzm/60cJQ
haZUv8+JdX9ZzqxOm5w5eUQSclt84u+D+hsCAwEAAaOCAVkwggFVMAwGA1UdEwEB/wQCMAAw
VgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBo
ZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB/wQEAwIDqDBABgNV
HSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCG
SAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2Vy
dC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQub3JnL3Jldm9rZS5j
cmwwNAYDVR0RBC0wK4EUYWhmZXJyb2luN0BnbWFpbC5jb22BE2FoZW1tZWxnQG9oaW9ndC5j
b20wDQYJKoZIhvcNAQENBQADggIBABr5e8W+NiTER+Q/7wiA2LxWN3UdhT3eZJjqqSlP370P
KL5iWqeTfxQ67Ai/mHbJcT2PgAJ+/D2Ji+aRR03UWnU/vtOwzyDLUMstqnfl0Zs+sz/CJe7x
nBA5jlpjC2DKuMVfbPze7eySaen7XSGFHKE1QoVIIpQ2kVjC4nbbJQnUbAVX1Iz29WxeVGt9
XYigz3tDPf3tglN+q23E7YjQl4abTIoM7i98yV1H9gfY8lFfKZ6jREB9+n6ie2EwS3Kat2mG
tl2wBx4MfRnoSQSKsLKQ5oTwhWf0JqlFwpLfl374p0Njcykej9/jnWG8Ks1V/AXTHqI4eyIP
Mf5yMZkPv7n7LS9WWKdG4Nd38iv4T2EiAaWsmgu+r81qL5CJu9AyA0SBS4ttKf6k3e63w2Mv
N9R45vpQ3QhAhfWyFxFhZN95APe3YECDG3+XIRJpRYPEtHuIsOyzI70ajF93gg/BidvqKsmV
MM2ccktDMfqwZXea6zey7F8Geu9R7BqjXmG2HlNuXu7e/xnHOgXf5D3wPmnRLlBhXL1Ch97a
w2KjaupjpAHfFjv5kGnZXN87UvvlwzIZiKXwa3vTDwK+rrKn/sHPkfDZPSiyt/ZBIK6lX83P
34H/CzGg+Kx57rHYOIHGumIvpDa5vfWp8O0sGgawb1C2Aae4sTUVIWmIjVuGI062MYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE0MTUxODM2WjBPBgkq
hkiG9w0BCQQxQgRA3o3i5+mzW8BC55weF76Aae8lkfSEBVgy6NBoEms/iOVluwpaPu6gUT/E
oumbklsj7NRgQa//T6JeyMgsuHuLyDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgA4i6vBfW0XSvr+lQGw78dU6olNJLJWqTPF4aOOdZKjFub+MYIn
MTocgBDRZ5qdObN7wH/Foby77DlsiTjF90XjCVsLiGQLdvOdbC+TULcYzM/pJ3zUUr7r9pcW
GhIiXMEPiQ9PrrQrnOhpn8z5G4oU5geWt0mHEBNsQ7J7iT8ncXWzXEPYHfWozFaNt1X5gpme
zrOYDgI3E1e+vHKxUK8gIMWPBELj/zgSJAaQnP1IPSjx69BanOQTp4xEcuYki3yIwcBCcO0I
qrlfXkwwC+IDr8YWfIb1wi9kt1Sx6L5XLjGHs7+SMcxgPfizSzug+W2NWvIsq2NtVY+kFN5y
ARk+9MO2uZ8up1pgSPcCMYaMDxxLgeRxkwwuZbeFs6AuXDUlDTiAFA/I5lveydghGgacPMLP
XO64/dWx24UoDgIGnC8xTv8fbHX+GhPT1jwCLgU8AuqMYgDmP1eUSvt4d8EHKbQOLFRoaCLK
GRvNaVv8sH/Zq29OyFABtTgHVx21pkfJQBu/Nx5gYZikOdrwXPm4bsDns4vT+5reBvVeGOnv
D30jl+rt3I0SztFeR1IeLUmg+e2AdVNyA96/D4C9B/Sf8fR5Hzgk1APiV8iPnHm3KquQRtgT
heYQasfWU/ZT+JyD8sNwZV2C2LVF8/c1ADNcwUhNBpa1aClz0COktKAiQQAAAAAAAA==
--------------ms070204080605030900050108--
