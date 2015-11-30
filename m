Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35754 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbbK3OvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 09:51:21 -0500
Received: by igl9 with SMTP id 9so65726091igl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 06:51:20 -0800 (PST)
Subject: Re: [RFC] Btrfs device and pool management (wip)
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <565C01F1.5030108@oracle.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565C625C.7060503@gmail.com>
Date: Mon, 30 Nov 2015 09:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <565C01F1.5030108@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030008040103070709090006"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030008040103070709090006
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-30 02:59, Anand Jain wrote:
>   Data center systems are generally aligned with the RAS (Reliability,
> Availability and Serviceability) attributes. When it comes to Storage,
> RAS applies even more because its matter of trust. In this context, one=

> of the primary area that a typical volume manager should be well tested=

> is, how well RAS attributes are maintained in the context of device
> failure, and its further reporting.
>
>   But, identifying a failed device is not a straight forward code. If
> you look at some statistics performed on failed and returned disks,
> most of the disks ends up being classified as NTF (No Trouble Found).
> That is, host failed-and-replaced a disk even before it has actually
> failed. This is not good for a cost effective setup who would want to
> stretch the life of an intermittently failing device to its maximum
> tenure and would want to replace only when it has confirmed dead.
>
>   Also on the other hand, some of the data center admins would like to
> mitigate the risk (of low performance at peak of their business
> productions) of a potential failure, and prefer to pro-actively replace=

> the disk at their low business/workload hours, or they may choose to
> replace a device even for read errors (mainly due to performance
> reasons).
>
>   In short a large variant of real MTF (Mean Time to Failure) for the
> devices across the industries/users.
>
>
> Consideration:
>
>   - Have user-tunable to support different context of usages, which
> should be applied on top of a set of disk IO errors, and its out come
> will be to know if the disk can be failed.
General thoughts on this:
1. If there's a write error, we fail unconditionally right now.  It=20
would be nice to have a configurable number of retries before failing.
2. Similar for read errors, possibly with the ability to ignore them=20
below some threshold.
3. Kernel initiated link resets should probably be treated differently=20
from regular read/write errors, they can indicate other potential=20
problems (usually an issue in either the disk electronics or the storage =

controller).
4. Almost all of this is policy, and really should be configurable from=20
userspace and have sane defaults (probably just keeping current behavior)=
=2E
5. Properly differentiating between a media error, a transport error, or =

some other error (such as in the disk electronics or storage controller) =

is not reliably possible with the current state of the block layer and=20
the ATA spec (it might be possible with SCSI, but I don't know enough=20
about SCSI to be certain).
>
>   - Distinguish real disk failure (failed state) VS IO errors due to
> intermittent transport errors (offline state). (I am not sure how to do=

> that yet, basically in some means, block layer could help?, RFC ?).
This gets really tricky.  Ideally, this is really something that needs=20
to be done at least partly in userspace, unless we want to teach the=20
kernel about SMART attributes and how to query the disk's own idea of=20
how healthy it is.  We should also take into consideration the=20
possibility of the storage controller failing.
>
>   - A sysfs offline interface, so as to udev update the kernel, when
> disk is pulled out.
This needs proper support in the block layer.  As of now, it assumes=20
that if something has an open reference to a block device, that device=20
will not be removed.  This simplifies things there, but has undesirable=20
implications for stuff like BTRFS or iSCSI/ATAoE/NBD.
>
>   - Because even to fail a device it depends on the user requirements,
> btrfs IO completion threads instead of directly reacting on an IO
> error, it will continue to just report the IO error into device error
> statistics, and a spooler up on errors will apply user/system
> criticalness as provided by the user on the top, which will decide if
> the device has to be marked as failed OR if it can continue to be in
> online.
This is debatably a policy decision, and while it would be wonderful to=20
have stuff in the kernel to help userspace with this, it probably=20
belongs in userspace.
>
>   - A FS load pattern (mostly outside of btrfs-kernel or with in btrfs-=

> kernel) may pick the right time to replace the failed device, or to run=

> other FS maintenance activities (balance, scrub) automatically.
This is entirely a policy decision, and as such does not belong in the=20
kernel.
>
>   - Sysfs will help user land scripts which may want to bring device to=

> offline or failed.
>
>
>
> Device State flow:
>
>    A device in the btrfs kernel can be in any one of following state:
>
>    Online
>       A normal healthy device
>
>    Missing
>       Device wasn't found that the time of mount OR device scan.
>
>    Offline (disappeared)
>       Device was present at some point in time after the FS was mounted=
,
>       however offlined by user or block layer or hot unplug or device
>       experienced transport error. Basically due to any error other tha=
n
>       media error.
>       The device in offline state are not candidate for the replace.
>       Since still there is a hope that device may be restored to online=

>       at some point in time, by user or transport-layer error recovery.=

>       For device pulled out, there will be udev script which will call
>       offline through sysfs. In the long run, we would also need to kno=
w
>       the block layer to distinguish from the transient write errors
>       like writes failing  due to transport error, vs write errors whic=
h
>       are confirmed as target-device/device-media failure.
It may be useful to have the ability to transition a device from offline =

to failed after some configurable amount of time.
>
>    Failed
>       Device has confirmed a write/flush failure for at least a block.
>       (In general the disk/storage FW will try to relocate the bad bloc=
k
>       on write, it happens automatically and transparent even to the
>       block layer. Further there might have been few retry from the blo=
ck
>       layer. And here btrfs assumes that such an attempt has also
>       failed). Or it might set device as failed for extensive read
>       errors if the user tuned profile demands it.
>
>
> A btrfs pool can be in one of the state:
>
> Online:
>    All the chunks are as configured.
>
> Degraded:
>    One or more logical-chunks does not meet the redundancy level that
>    user requested / configured.
>
> Failed:
>    One or more logical-chunk is incomplete. FS will be in a RO mode Or
>    panic -dump as configured.
>
>
> Flow diagram (also include pool states BTRFS_POOL_STATE_xx along with
> device state BTRFS_DEVICE_STATE_xx):
>
>
>                      [1]
>                      BTRFS_DEVICE_STATE_ONLINE,
>                       BTRFS_POOL_STATE_ONLINE
>                                  |
>                                  |
>                                  V
>                            new IO error
>                                  |
>                                  |
>                                  V
>                     check with block layer to know
>                    if confirmed media/target:- failed
>                  or fix-able transport issue:- offline.
>                        and apply user config.
>              can be ignored ?  --------------yes->[1]
>                                  |
>                                  |no
>          _______offline__________/\______failed________
>          |                                             |
>          |                                             |
>          V                                             V
> (eg: transport issue [*], disk is good)     (eg: write media error)
>          |                                             |
>          |                                             |
>          V                                             V
> BTRFS_DEVICE_STATE_OFFLINE                BTRFS_DEVICE_STATE_FAILED
>          |                                             |
>          |                                             |
>          |______________________  _____________________|
>                                 \/
>                                  |
>                          Missing chunk ? --NO--> goto [1]
>                                  |
>                                  |
>                           Tolerable? -NO-> FS ERROR. RO.
>                                       BTRFS_POOL_STATE_FAILED->remount?=

>                                  |
>                                  |yes
>                                  V
>                        BTRFS_POOL_STATE_DEGRADED --> rebalance -> [1]
>                                  |
>          ______offline___________|____failed_________
>          |                                           |
>          |                                      check priority
>          |                                           |
>          |                                           |
>          |                                      hot spare ?
>          |                                    replace --> goto [1]
>          |                                           |
>          |                                           | no
>          |                                           |
>          |                                       spare-add
> (user/sys notify issue is fixed,         (manual-replace/dev-delete)
>    trigger scrub/balance)                            |
>          |______________________  ___________________|
>                                 \/
>                                  |
>                                  V
>                                 [1]
>
>
> Code status:
>   Part-1: Provided device transitions from online to failed/offline,
>           hot spare and auto replace.
>           [PATCH 00/15] btrfs: Hot spare and Auto replace
>
>   Next,
>    . Add sysfs part on top of
>      [PATCH] btrfs: Introduce device pool sysfs attributes
>    . POOL_STATE flow and reporting
>    . Device transactions from Offline to Online
>    . Btrfs-progs mainly to show device and pool states
>    . Apply user tolerance level to the IO errors



--------------ms030008040103070709090006
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTMwMTQ1MTA4WjBPBgkq
hkiG9w0BCQQxQgRAfooijUQac9UIbhWPIPKKLSVGq8Cr2MhvKQkBICRZc6pmcOC7hPEIUJ/G
zal+rwCmZwnzSliJ3O6l6CA1b520hTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBofVY4FOkvuJJwi/+HRqGA5CoktRhrJR+AaBIiIozK0jDpBNTO
hTXIcuU4HKrkhT248FuiALr63EyeFq9sA16hpkcDqkCI6vOilFO5zI9LCd1Ljk8Z3gRiPq1n
CfnYzmBhQH1/HPUWAY8/7JPjr3z/amyhnU6KYZky+LfcNiNoVVgV8h4bHxroIpPr8oqnA9h5
s7CwuqRzXDt+RU5Pwok0i8vJDRqd1NYaf/fgexqYxLiYhvAXpKydBxqrEQhf3qCq87eqiN2K
Ziwg8HqhLLrssBEOCV6zl6r+1/GM7U7ng4Blho9u0X7eRyySxtTwPnBY+zZvWiaq53tCRqgE
BkWuEYd9OBCtzCJDt2JX7oCxFzLE/FUCYwzNnzgHaPt9EL9w4l5Krg1N51ZX4cF77V0IL2Ou
8nzYzm8FEI8gjYb0x2jik6V+p9IsLn6lHfpxgNsBEvuqMe7S3Pp9L0sSy+PuhoxGq5HYORmZ
fyqfrjzFpNGQjegGJkbF0cz3qnhs+tBuZ1q5dbiUAdXxxdOjEnIWYinWITpzDrZqEIwdpaxn
DfcNHnayWLf86PndVnERrv/l5aVo+5gouiqn13Mslr5rJg6cY3SI4QpcmlqCty77uSSkOrLU
cl1JE/ROq6O3nCOSXk2Ro7rk3G9FZn39EwwB1Gfp3AQIjsL5CuBbr8qbewAAAAAAAA==
--------------ms030008040103070709090006--
