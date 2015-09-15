Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36513 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbIOSqd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 14:46:33 -0400
Received: by ioii196 with SMTP id i196so208913600ioi.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 11:46:32 -0700 (PDT)
Subject: Re: btrfs kernel warning
To: Tyler Williams <williams.tlr@gmail.com>
References: <CALq_kZHBx8hR_6kfwYgJChdK2RKw1+up07pGGYe+RRGOb2rhKA@mail.gmail.com>
 <55F8643F.5070701@gmail.com>
 <CALq_kZGHM2D7-XhrMbkhik2Hn=CWJGPBjbGrJWqS32k7nQEZ3g@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F86784.6060707@gmail.com>
Date: Tue, 15 Sep 2015 14:46:28 -0400
MIME-Version: 1.0
In-Reply-To: <CALq_kZGHM2D7-XhrMbkhik2Hn=CWJGPBjbGrJWqS32k7nQEZ3g@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080805010401060500090402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080805010401060500090402
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-15 14:42, Tyler Williams wrote:
> So I only had qgroups enabled because at some point it seemed like it
> gave me the size of individual snapshots. Would it be likely that if I
> just removed qgroups from that volume that would prevent that message
> in the future?
>
Maybe, I'm not entirely certain if disabling qgroups on a volume removes =

the qgroup metadata, and if the metadata is still there, it might still=20
cause issues.  It's worth trying though because it shouldn't make=20
anything worse than it already is.
> On Tue, Sep 15, 2015 at 12:32 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-09-15 14:13, Tyler Williams wrote:
>>>
>>> I've received several kernel warnings over the last few weeks. I
>>> checked on the #BTRFS irc channel and it was suggested that I post th=
e
>>> relevant information here to see if this was something that I should
>>> be worried about.
>>>
>>>
>>> [root@tawilliams ~]# uname -a
>>> Linux tawilliams.williamstlr.net 4.1.6-201.fc22.x86_64 #1 SMP Fri Sep=

>>> 4 17:49:24 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>>
>>> [root@tawilliams ~]# btrfs --version
>>> btrfs-progs v4.1
>>>
>>>
>>> [root@tawilliams ~]# btrfs fi sh
>>> Label: 'fedora'  uuid: 1e37c117-d493-4d3e-a585-46b90de16569
>>>           Total devices 1 FS bytes used 3.70GiB
>>>           devid    1 size 47.31GiB used 6.04GiB path /dev/sda4
>>>
>>> Label: none  uuid: f9b38a56-44d4-4974-9640-95341bd8ae6a
>>>           Total devices 1 FS bytes used 424.23GiB
>>>           devid    1 size 931.51GiB used 428.04GiB path /dev/sdc1
>>>
>>> Label: none  uuid: 5266d71b-1d75-4b28-accc-95187f2d65a4
>>>           Total devices 1 FS bytes used 889.09GiB
>>>           devid    1 size 931.50GiB used 892.03GiB path /dev/sdb2
>>>
>>> Label: 'tawilliams'  uuid: 142b1866-f5e1-48b0-acd3-401e8eb4d219
>>>           Total devices 2 FS bytes used 1.10TiB
>>>           devid    1 size 1.82TiB used 1.16TiB path /dev/sdb1
>>>           devid    2 size 1.82TiB used 1.16TiB path /dev/sde
>>>
>>> Label: 'fedora-server'  uuid: a5a82150-7ff3-43d4-a86b-a7f9d2df3737
>>>           Total devices 1 FS bytes used 27.09GiB
>>>           devid    1 size 47.51GiB used 38.81GiB path /dev/sdd3
>>>
>>> btrfs-progs v4.1
>>>
>>> [root@tawilliams ~]# btrfs fi df /media/btrfs-raid1/
>>> Data, RAID1: total=3D1.16TiB, used=3D1.10TiB
>>> System, RAID1: total=3D32.00MiB, used=3D208.00KiB
>>> Metadata, RAID1: total=3D5.00GiB, used=3D3.86GiB
>>> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>>>
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: ------------[ cut
>>> here ]------------
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: WARNING: CPU: 0
>>> PID: 544 at fs/btrfs/qgroup.c:1028
>>> __qgroup_excl_accounting+0x1cf/0x260 [btrfs]()
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: Modules linked in:=

>>> nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter
>>> ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ebtable_broute
>>> bridg
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: CPU: 0 PID: 544
>>> Comm: btrfs-cleaner Not tainted 4.1.6-201.fc22.x86_64 #1
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: Hardware name:
>>> Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V
>>> UEFI Release v1.0 11/26/2012
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:  0000000000000000
>>> 000000005a7148da ffff8800383f7b38 ffffffff81799a6d
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:  0000000000000000
>>> 0000000000000000 ffff8800383f7b78 ffffffff810a165a
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:  0000000000000000
>>> ffff880036e71048 ffff880022079960 ffffffffffffc000
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: Call Trace:
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff81799a6d>] dump_stack+0x45/0x57
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff810a165a>] warn_slowpath_common+0x8a/0xc0
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff810a178a>] warn_slowpath_null+0x1a/0x20
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa01341af>] __qgroup_excl_accounting+0x1cf/0x260 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa01372ec>] btrfs_delayed_qgroup_accounting+0x2dc/0xc70
>>> [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00b6a67>] ? walk_up_proc+0xd7/0x500 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00ba85f>] btrfs_run_delayed_refs.part.68+0x20f/0x280
>>> [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00ba8e5>] btrfs_run_delayed_refs+0x15/0x30 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00cb68a>] btrfs_should_end_transaction+0x5a/0x60 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00b8c85>] btrfs_drop_snapshot+0x455/0x8a0 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa01276cc>] ? btrfs_kill_all_delayed_nodes+0x5c/0x110 [btrfs=
]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00df11f>] ? btrfs_run_defrag_inodes+0x29f/0x360 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00cbb82>] btrfs_clean_one_deleted_snapshot+0xb2/0x110
>>> [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00c3dc5>] cleaner_kthread+0xb5/0x1b0 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffffa00c3d10>] ? check_leaf+0x380/0x380 [btrfs]
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff810c0bf8>] kthread+0xd8/0xf0
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff810c0b20>] ? kthread_worker_fn+0x180/0x180
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff817a0422>] ret_from_fork+0x42/0x70
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>> [<ffffffff810c0b20>] ? kthread_worker_fn+0x180/0x180
>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: ---[ end trace
>>> e8c2f252933902d6 ]---
>>
>> While I can't provide any advice as to whether this is something to be=

>> worried about or not, I would like to point out that even in recent ke=
rnel
>> versions, there are multiple known issues in the qgroup code.  I don't=
 think
>> there's anything currently known on 4.1.6 that has the possibility of =
eating
>> your data, but I am by no means an expert on this particular subject (=
I
>> don't use quotas on most of my systems, and for those that I do, I jus=
t use
>> separate thinly-provisioned partitions for the individual quota users =
(which
>> in turn makes things much easier for everyone involved)).
>>
>>



--------------ms080805010401060500090402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE1MTg0NjI4WjBPBgkq
hkiG9w0BCQQxQgRAvd+I/q0TzU8bsdBUMm/qDy3w9XnY6gZUjGlzNMfw4JZcf8snl8GOeYm4
VtwuZgKAqaIILg8ao1ULPiTCc84vpjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBmzoMDwGxS6TGp0CtljTJJDqpNvzpzCgf4g9B9FIJXgStz4CbB
aw+IUQmYu0rM1rhSeXvT7S3ibYAu0X43K2g2ZoRJAckUGb6g4BtuCzUi8HM+iwS8Ts4i/cKZ
6snWY6VhlXyjggKHSqolakm+Q9OzqMBmhNxJJg0E5hQztl3ASFR2fb+9sZfZObQWwKV7SfyF
WW6HqlwGyqxuL1Z+G30tp1s9Mm1ZPq9HkyEM7UG5AktLNPJ6ca89YwuOT6KoB1MPwnAfmRcG
si1TL3DONEZE4dq76SCLgSYqsKM/TuSM6IJe4HMRW/9kdJgukLa4ZkDfIQ/01TdpOnH1YR1a
lDHYb+QqILLtM3/LyYbbBN+BNM3kSmffetOlGALVpvuJPiAozRnT2+dWvH0yEuU+uyv6JN+E
F9a+aLU301bY6CPYelOO9zvckgT4uEyHJjVSJAB9qbeXp2lKP2GnVgyd1nP4JlqG5eXtD9A5
B/wrcVghwXk+Eh7CSDa/bjN8T3ZL9EZ++D34p9ZNNs48oipD5BKtRcSQTDBFDrUo3pZKl2XH
vzUhh4sd8JxPa5oWeMeh3dBOuQlntjY89to5XU9huoYkI23UUkNbeHDyusaNs8Pvcb6APFQb
gvAqKmGTCFD4lfOfYSlfMh4DglE1MladsPnOpE5hTcjPVp+k9PsNtmLTbAAAAAAAAA==
--------------ms080805010401060500090402--
