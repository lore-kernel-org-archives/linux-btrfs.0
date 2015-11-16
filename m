Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35145 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbbKPNlw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 08:41:52 -0500
Received: by ioc74 with SMTP id 74so159413324ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 05:41:51 -0800 (PST)
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5649DD1D.3090104@gmail.com>
Date: Mon, 16 Nov 2015 08:41:49 -0500
MIME-Version: 1.0
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040500050307080903080007"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040500050307080903080007
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-09 05:56, Anand Jain wrote:
> These set of patches provides btrfs hot spare and auto replace support
> for you review and comments.
>
> First, here below are the simple example steps to configure the same:
>
> Add a spare device:
>      btrfs spare add /dev/sde -f
>
> OR if there is a spare device which is already added before the, just
> run
>
>      btrfs dev scan [/dev/sde]
>
> this will register the spare device to the kernel.
>
>      btrfs fi show
>      Label: none  uuid: 52f170c1-725c-457d-8cfd-d57090460091
> 	Total devices 2 FS bytes used 112.00KiB
> 	devid    1 size 2.00GiB used 417.50MiB path /dev/sdc
> 	devid    2 size 2.00GiB used 417.50MiB path /dev/sdd
>
>      Global spare
> 	device size 3.00GiB path /dev/sde
>
> Thats it.
>
> Auto replace:
>   Replace happens automatically, that is when there is any write
>   failed or flush failed, the device will be marked as failed, which
>   will stop any further IO attempt to that device. And in the next comm=
it
>   thread cycle the auto replace will pick the spare device (/dev/sde is=

>   above example) to replace the failed device. And so the btrfs volume =
is
>   back to a healthy state.
>
>
> Its btrfs Global spare:
>   as of now only global hot spare is supported, that is hot spare(s)
>   are for all the btrfs FS in the system.
>
> No spare when device failed:
>   It would scan for spare device at the rate of transaction commit
>   and will trigger the auto replace when ever spare device is added.
>
> Priority:
>   In some future work there can be some chronological order to pick
>   a spare and the failed device.
>
>
> Patches:
>
> Kernel:
> First, it needs, Qu's per chunk missing device patchset,
> which is part of the set here and also there is a light optimization
> (patch 5/15) which was required as part of this enhancement.
>
> Next patches 7,8/15 brings in support, to manage the transition of
> devices from online (no state) to offline OR failed state dynamically.
> On top of static device state like the current "missing" state.
>
> Patch 9/15 fixes a bug where in we should have blocked the incompatible=

> feature at the device scan/add level instead/also at in the mount level=
=2E
> This is because we don't have to bring a device into the device list,
> if it is incompatible.
>
> Next patches 10,11,12,13/15 adds support for Spare device. For the
> details on how to add a spare device kindly see further below.
> For kernel with out spare feature supported the spare device
> is kept away. And when the kernel supports the spare device, it will
> inhibit from mounting it. Further these patch set provides helper
> function to pick a spare device and release a spare device back to
> the spare device pool.
>
> Patch 14/15 provides function for auto replace, this is mainly
> from the existing replace code, and in the long run I see opportunity
> to merge these code with the replace code that is triggered from
> the user spare.
>
> Last 15/15, uses all these facilities, picks a failed device and
> triggers a auto replace in a kthread (casualty_kthread())
>
>
> Progs:
> Would need 4 patches as listed below.
>
>
> Known Bug:
>
> As now I see below stale kmem cache during module unload. Which
> I am digging.
> ------
> BUG btrfs_path (Not tainted): Objects remaining in btrfs_path on kmem_c=
ache_close()
> ------
>
> Anand Jain (10):
>    btrfs: optimize btrfs_check_degradable() for calls outside of barrie=
r
>    btrfs: introduce device dynamic state transition to offline or faile=
d
>    btrfs: check device for critical errors and mark failed
>    btrfs: block incompatible optional features at scan
>    btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
>    btrfs: add check not to mount a spare device
>    btrfs: support btrfs dev scan for spare device
>    btrfs: provide framework to get and put a spare device
>    btrfs: introduce helper functions to perform hot replace
>    btrfs: check for failed device and hot replace
>
> Qu Wenruo (5):
>    btrfs: Introduce a new function to check if all chunks a OK for
>      degraded mount
>    btrfs: Do per-chunk check for mount time check
>    btrfs: Do per-chunk degraded check for remount
>    btrfs: Allow barrier_all_devices to do per-chunk device check
>    btrfs: Cleanup num_tolerated_disk_barrier_failures
>
>   fs/btrfs/ctree.h       |   7 +-
>   fs/btrfs/dev-replace.c | 116 ++++++++++++++++++++
>   fs/btrfs/dev-replace.h |   1 +
>   fs/btrfs/disk-io.c     | 211 +++++++++++++++++++++++-------------
>   fs/btrfs/disk-io.h     |   2 -
>   fs/btrfs/super.c       |  20 +++-
>   fs/btrfs/transaction.c |   3 +-
>   fs/btrfs/volumes.c     | 283 ++++++++++++++++++++++++++++++++++++++++=
++++++---
>   fs/btrfs/volumes.h     |  27 +++++
>   9 files changed, 571 insertions(+), 99 deletions(-)
>
I've thrown everything I can think of at this over the weekend, and=20
nothing broke (at least, nothing broke that had anything to do with=20
these patches, I ended up triggering a couple of known bugs that I had=20
completely forgotten about), so you can add:
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>


--------------ms040500050307080903080007
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE2MTM0MTQ5WjBPBgkq
hkiG9w0BCQQxQgRAT35FXnXg9i0kaitCTYNY6cVXOOCqf/osebXHEwn0PyfHg6cj9rdnE2Ey
hZt3VBsjiupxrWpq5A/YRmfizgRgCTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBZ0ewYACJsblSEgGdcqJw53RkVA08a+yfobaNMgdAZ7FbvXYKS
CcZgpypZHNuRpVYr9joGPVN2M4/QzUUQvaPMHXmy+m7iL9N4SQs8KJ2mJezRmBFyUrzQW7pU
EzrQgWWmawX02zgDAJfTWSrgG1Xlw3022JSOw845hEUY+v8e0OeH9k30qh8izI8IYgXnIxNN
VwDljldxhJUNesWuZQbVfeiK+HGUP8k0TtSnlkSq3lzXAdEz+QQVvyux9GgiPDzAG4+PyFnt
0dsuNfUeOBpheFIqC80j70pVyjD39s+7WqUp54mLWXXQQP0lkR6/fnfaLEpZ8ZYsutRv2dS0
kD5KNHUJBZ5kVrJnUQAwyTUejUL9NtUuXRIx5agNnPplDAdf1EU3VY0ydd+xt1uYYCNWTp1e
/dw1/30W0DZOUXxupcqRaVER2ReDjIfp8z0VdTV3VVCHRb5Lj2yi1f7Q07wjZEoXi+Au0ND/
1etKDirL9eSzNrCl4SHJdrbBKQDZ1VowVEmwfu4PgQ4dCW/chl9wS70cvZZan8Hn36G6z0Km
8rqUt50CCqdj8+mhNm7Y+DSTwqbfpL+ZWk86kCdHfr6H30vtnp1nV9vfrCUpL6Kef4nZXUUv
j7oq//3WzP9wBbFf3D8b3r96PE0EvLxkiMfJ2l6vtSWaxzCpOKWbC5vTqQAAAAAAAA==
--------------ms040500050307080903080007--
