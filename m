Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34860 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbKIN0E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 08:26:04 -0500
Received: by igl9 with SMTP id 9so30129748igl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 05:26:02 -0800 (PST)
Subject: Re: Process is blocked for more than 120 seconds
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56374C7D.5080609@mail.ru> <563DECF0.8080901@mail.ru>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56409EE4.6070605@gmail.com>
Date: Mon, 9 Nov 2015 08:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <563DECF0.8080901@mail.ru>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080102040301000505060401"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080102040301000505060401
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-07 07:22, Dmitry Katsubo wrote:
> Hi everyone,
>
> I have noticed the following in the log. The system continues to run,
> but I am not sure for how long it will be stable. Should I start
> worrying? Thanks in advance for the opinion.
>
This just means that a process was stuck in the D state (uninterruptible =

I/O sleep) for more than 120 seconds.  Depending on a number of factors, =

this happening could mean:
1. Absolutely nothing (if you have low-powered or older hardware, for=20
example, I get these regularly on a first generation Raspberry Pi if I=20
don't increase the timeout significantly)
2. The program is doing a very large chunk of I/O (usually with the=20
O_DIRECT flag, although this probably isn't the case here)
3. There's a bug in the blocked program (this is rarely the case when=20
this type of thing happens)
4. There's a bug in the kernel (which is why this dumps a stack trace)
5. The filesystem itself is messed up somehow, and the kernel isn't=20
handling it properly (technically a bug, but a more specific case of it).=

6. You're hardware is misbehaving, failing, or experienced a transient=20
error.

Assuming you can rule out possibilities 1 and 6, I think that 4 is the=20
most likely cause, as all of the listed programs (I'm assuming that=20
'master' is from postfix) are relatively well audited, and all of them=20
hit this at the same time.

For what it's worth, if you want you can do:
echo 0 > /proc/sys/kernel/hung_task_timeout_secs
like the message says to stop these from appearing in the future, or use =

some arbitrary number to change the timeout before these messages appear =

(I usually use at least 150 on production systems, and more often 300,=20
although on something like a Raspberry Pi I often use timeouts as high=20
as 1800 seconds).
>> [Mon Nov  2 06:35:57 2015] INFO: task nscd:859 blocked for more than 1=
20 seconds.
>> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
>> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
>> [Mon Nov  2 06:35:57 2015] nscd            D f1c7dd20     0   859     =
 1 0x00000000
>> [Mon Nov  2 06:35:57 2015]  f1c7dd40 00200082 f79de900 f1c7dd20 c10bc1=
19 ffffffe0 f3aec740 00200246
>> [Mon Nov  2 06:35:57 2015]  f74ea800 f79e3f40 f77fb800 f1c7e000 f6b381=
dc f6b38000 f1c7dd4c c14f1fdb
>> [Mon Nov  2 06:35:57 2015]  d5553960 f1c7dd70 f867672f 00000000 f77fb8=
00 c1099250 d0a4be08 d9755e68
>> [Mon Nov  2 06:35:57 2015] Call Trace:
>> [Mon Nov  2 06:35:57 2015]  [<c10bc119>] ? del_timer_sync+0x49/0x50
>> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f867672f>] ? wait_current_trans.isra.21+=
0x8f/0xf0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f86782b0>] ? start_transaction+0x3d0/0x5=
d0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f866483d>] ? btrfs_delalloc_reserve_meta=
data+0x32d/0x580 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0=
 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f8678533>] ? btrfs_join_transaction+0x23=
/0x30 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f867e409>] ? btrfs_dirty_inode+0x39/0xb0=
 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0=
 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c11aaa6e>] ? file_update_time+0x7e/0xc0
>> [Mon Nov  2 06:35:57 2015]  [<f8689aa0>] ? btrfs_page_mkwrite+0x80/0x3=
c0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c10bec89>] ? hrtimer_cancel+0x19/0x20
>> [Mon Nov  2 06:35:57 2015]  [<c10d0871>] ? futex_wait+0x1e1/0x270
>> [Mon Nov  2 06:35:57 2015]  [<c115d098>] ? do_page_mkwrite+0x38/0x90
>> [Mon Nov  2 06:35:57 2015]  [<c115ecd2>] ? do_wp_page+0x2e2/0x6d0
>> [Mon Nov  2 06:35:57 2015]  [<c10cf491>] ? futex_wake+0x71/0x140
>> [Mon Nov  2 06:35:57 2015]  [<c105c717>] ? kmap_atomic_prot+0xe7/0x110=

>> [Mon Nov  2 06:35:57 2015]  [<c1160a89>] ? handle_mm_fault+0xd59/0x14d=
0
>> [Mon Nov  2 06:35:57 2015]  [<c1054bcc>] ? __do_page_fault+0x18c/0x480=

>> [Mon Nov  2 06:35:57 2015]  [<c1054ec0>] ? __do_page_fault+0x480/0x480=

>> [Mon Nov  2 06:35:57 2015]  [<c14f67cf>] ? error_code+0x67/0x6c
>> [Mon Nov  2 06:35:57 2015] INFO: task nscd:864 blocked for more than 1=
20 seconds.
>> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
>> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
>> [Mon Nov  2 06:35:57 2015] nscd            D f1c87f5c     0   864     =
 1 0x00000000
>> [Mon Nov  2 06:35:57 2015]  f1c87ef4 00200082 f1c87f80 f1c87f5c 000003=
e7 f1c87ee4 f3aec740 ac76c560
>> [Mon Nov  2 06:35:57 2015]  f74ea800 f79e3f40 f3c7b040 f1c88000 f3c7b0=
40 ffff0001 f1c87f00 c14f1fdb
>> [Mon Nov  2 06:35:57 2015]  f3aec77c f1c87f38 c14f4265 f1c87f1c f3aec7=
80 f3aec788 00000000 00000125
>> [Mon Nov  2 06:35:57 2015] Call Trace:
>> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
>> [Mon Nov  2 06:35:57 2015]  [<c14f4265>] ? rwsem_down_write_failed+0x1=
85/0x280
>> [Mon Nov  2 06:35:57 2015]  [<c12964d2>] ? call_rwsem_down_write_faile=
d+0x6/0x8
>> [Mon Nov  2 06:35:57 2015]  [<c14f3b85>] ? down_write+0x25/0x40
>> [Mon Nov  2 06:35:57 2015]  [<c11505ba>] ? vm_mmap_pgoff+0x4a/0xa0
>> [Mon Nov  2 06:35:57 2015]  [<c1196d08>] ? SyS_fstat64+0x28/0x30
>> [Mon Nov  2 06:35:57 2015]  [<c1164e50>] ? SyS_mmap_pgoff+0x110/0x210
>> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12
>> [Mon Nov  2 06:35:57 2015] INFO: task nmbd:1330 blocked for more than =
120 seconds.
>> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
>> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
>> [Mon Nov  2 06:35:57 2015] nmbd            D 00000000     0  1330     =
 1 0x00000000
>> [Mon Nov  2 06:35:57 2015]  ef44bd74 00200086 00000000 00000000 000000=
00 00000000 f3984900 00000000
>> [Mon Nov  2 06:35:57 2015]  f69e1800 f79e3f40 f3a7a800 ef44c000 d17255=
a0 d17255a0 ef44bd80 c14f1fdb
>> [Mon Nov  2 06:35:57 2015]  d1725600 ef44bdc8 f86961b5 000d3fff 000000=
00 00001000 00000000 000d3000
>> [Mon Nov  2 06:35:57 2015] Call Trace:
>> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f86961b5>] ? btrfs_start_ordered_extent+=
0xd5/0x100 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f868b254>] ? lock_and_cleanup_extent_if_=
need+0x134/0x260 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f868bb46>] ? prepare_pages+0xc6/0x150 [b=
trfs]
>> [Mon Nov  2 06:35:57 2015]  [<f868c76a>] ? __btrfs_buffered_write+0x17=
a/0x5e0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c113e663>] ? __alloc_pages_nodemask+0x13=
3/0x880
>> [Mon Nov  2 06:35:57 2015]  [<f8690f85>] ? btrfs_file_write_iter+0x1e5=
/0x550 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c116980c>] ? page_add_new_anon_rmap+0x6c=
/0x90
>> [Mon Nov  2 06:35:57 2015]  [<c1191e29>] ? new_sync_write+0x79/0xb0
>> [Mon Nov  2 06:35:57 2015]  [<c1192433>] ? vfs_write+0x93/0x1a0
>> [Mon Nov  2 06:35:57 2015]  [<c1054be8>] ? __do_page_fault+0x1a8/0x480=

>> [Mon Nov  2 06:35:57 2015]  [<c14f3030>] ? mutex_lock+0x10/0x30
>> [Mon Nov  2 06:35:57 2015]  [<c1192d96>] ? SyS_write+0x46/0x90
>> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12
>> [Mon Nov  2 06:35:57 2015] INFO: task master:2321 blocked for more tha=
n 120 seconds.
>> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
>> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
>> [Mon Nov  2 06:35:57 2015] master          D f79e3f40     0  2321     =
 1 0x00000004
>> [Mon Nov  2 06:35:57 2015]  edcd9e18 00200082 cb7fd040 f79e3f40 cb7fd0=
40 ffffffe0 f3903c80 00200246
>> [Mon Nov  2 06:35:57 2015]  c167cb00 f79d1f40 eef44800 edcda000 f6b381=
dc f6b38000 edcd9e24 c14f1fdb
>> [Mon Nov  2 06:35:57 2015]  d5553960 edcd9e48 f867672f 00000000 eef448=
00 c1099250 f3309e68 c7a17d64
>> [Mon Nov  2 06:35:57 2015] Call Trace:
>> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f867672f>] ? wait_current_trans.isra.21+=
0x8f/0xf0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f86782b0>] ? start_transaction+0x3d0/0x5=
d0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0=
 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f8678533>] ? btrfs_join_transaction+0x23=
/0x30 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f867e409>] ? btrfs_dirty_inode+0x39/0xb0=
 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0=
 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c11aaa6e>] ? file_update_time+0x7e/0xc0
>> [Mon Nov  2 06:35:57 2015]  [<c11998ea>] ? pipe_write+0x32a/0x400
>> [Mon Nov  2 06:35:57 2015]  [<c1191e29>] ? new_sync_write+0x79/0xb0
>> [Mon Nov  2 06:35:57 2015]  [<c1192433>] ? vfs_write+0x93/0x1a0
>> [Mon Nov  2 06:35:57 2015]  [<c11a4d88>] ? poll_select_set_timeout+0x6=
8/0x80
>> [Mon Nov  2 06:35:57 2015]  [<c1192d96>] ? SyS_write+0x46/0x90
>> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12
>> [Mon Nov  2 06:35:57 2015] INFO: task xfce4-sensors-p:2611 blocked for=
 more than 120 seconds.
>> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
>> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
>> [Mon Nov  2 06:35:57 2015] xfce4-sensors-p D 00000000     0  2611   25=
60 0x00000000
>> [Mon Nov  2 06:35:57 2015]  e71f9e50 00200086 00000000 00000000 5ca900=
00 ffffffe0 eeec4ac0 00200246
>> [Mon Nov  2 06:35:57 2015]  c167cb00 f79d1f40 e7ea3040 e71fa000 f6f345=
dc f6f34400 e71f9e5c c14f1fdb
>> [Mon Nov  2 06:35:57 2015]  d5553960 e71f9e80 f867672f 00000000 e7ea30=
40 c1099250 c7a17d64 ea299e84
>> [Mon Nov  2 06:35:57 2015] Call Trace:
>> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f867672f>] ? wait_current_trans.isra.21+=
0x8f/0xf0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
>> [Mon Nov  2 06:35:57 2015]  [<f8678331>] ? start_transaction+0x451/0x5=
d0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f86784d4>] ? btrfs_start_transaction+0x2=
4/0x30 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<f86795a0>] ? __unlink_start_trans+0x20/0=
xb0 [btrfs]
>> [Mon Nov  2 06:35:57 2015]  [<c11a6e02>] ? d_rehash+0x42/0x50
>> [Mon Nov  2 06:35:57 2015]  [<f86829c8>] ? btrfs_unlink+0x28/0xb0 [btr=
fs]
>> [Mon Nov  2 06:35:57 2015]  [<c119e222>] ? vfs_unlink+0xf2/0x190
>> [Mon Nov  2 06:35:57 2015]  [<c11a0afb>] ? do_unlinkat+0x21b/0x280
>> [Mon Nov  2 06:35:57 2015]  [<c11a1505>] ? SyS_unlink+0x15/0x20
>> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12


--------------ms080102040301000505060401
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTA5MTMyNTU2WjBPBgkq
hkiG9w0BCQQxQgRAhawf/2UUJjA4aqyijQx1tojl9BsJrrhsi2SRQtA9nqrxju2B+Vb1hXi/
Sky4QFeTCogukHuLab/vkskysoGc/DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCD8abbZ+7JD/MBCF2g829Cl9ldFvnySUYVWzGm6hFI7oS+oIAx
G1gzmRXO1QB6rm+WO2Py4Kxe7JeR7WPwwAsfpbduEft+H6rgNu5XVrQP2wm61mstwWVwJM1E
whB6Bt/Gvf73w4WIgXUUmsfHVKRqE/Mn0JYjmvNuGKUSOsD+DQe2Vg0jxpL3b9ZvbdbyGOgd
BB3wXPEyDcixw2/RrWSMjzaUp1TL+lMTvHWaMcuZsXhsZp2xRxfNua/gExnJEuYe5FN1qi3X
sV2mpaf84Xcl7Ku1d+o7fk6ayTUr5eT98Sc88EqqjliKZXrcpPk1m6F0jxPraw0VNGesq2Ck
0N6J2sR1U+HJ4brtg4lrGLzN0qKkQ1GUEW/lr0hqN/aDavkdbMd1ygpQXEkxLYQ6JrfbaTXW
RP4wDZWTqpVyZD1aOZwoepCoGWysWGyEN1cKSlXF/IKQBrK1Gs/gKusNSLbeX9IyKxP33ikC
8WvP3C9X5rD0laspWPw+lDD6t3dVJzSWD+g/KrgWB+IGUHFND/3IjffXGDn4SZdRRs/xRvqN
Yw2R44ljulTvP6mHyia8W9Exgt4Fw9GmxJF+UEVHO6O1xZ+XeY30Q+yFis3JyL53EP2bM/C2
dtoM3v7iHtCWS0xscNN3S5gHyqIMJY+tXa0HnBG4NqeaofHjyLq70UXTsgAAAAAAAA==
--------------ms080102040301000505060401--
