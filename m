Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729514AbeIGRlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 13:41:24 -0400
Subject: Re: [PATCH RESEND] btrfs: fix error handling in free_log_tree
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20180906205933.7430-1-jeffm@suse.com>
 <20180907120030.GN24025@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <73f5fc0e-e425-91c5-7720-a3b853295282@suse.com>
Date: Fri, 7 Sep 2018 09:00:28 -0400
MIME-Version: 1.0
In-Reply-To: <20180907120030.GN24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TUi7FRQzcu1pW4yizgr2ghIlPATKWKvqz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TUi7FRQzcu1pW4yizgr2ghIlPATKWKvqz
Content-Type: multipart/mixed; boundary="PtJFv9dwWAjmcyIxWGlQnddRCxQ6NWrQ6";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <73f5fc0e-e425-91c5-7720-a3b853295282@suse.com>
Subject: Re: [PATCH RESEND] btrfs: fix error handling in free_log_tree
References: <20180906205933.7430-1-jeffm@suse.com>
 <20180907120030.GN24025@twin.jikos.cz>
In-Reply-To: <20180907120030.GN24025@twin.jikos.cz>

--PtJFv9dwWAjmcyIxWGlQnddRCxQ6NWrQ6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/7/18 8:00 AM, David Sterba wrote:
> On Thu, Sep 06, 2018 at 04:59:33PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>=20
> If this is a resend, I can't find the previous postings, same or simila=
r
> subject.

I had tagged it as submitted in March, but I can't find any posting of
it either.

>> When we hit an I/O error in free_log_tree->walk_log_tree during file s=
ystem
>> shutdown we can crash due to there not being a valid transaction handl=
e.
>>
>> Use btrfs_handle_fs_error when there's no transaction handle to use.
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000=
060
>> IP: free_log_tree+0xd2/0x140 [btrfs]
>> PGD 0 P4D 0
>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
>> Modules linked in: <modules>
>> CPU: 2 PID: 23544 Comm: umount Tainted: G        W        4.12.14-kvms=
mall #9 SLE15 (unreleased)
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-preb=
uilt.qemu-project.org 04/01/2014
>> task: ffff96bfd3478880 task.stack: ffffa7cf40d78000
>> RIP: 0010:free_log_tree+0xd2/0x140 [btrfs]
>> RSP: 0018:ffffa7cf40d7bd10 EFLAGS: 00010282
>> RAX: 00000000fffffffb RBX: 00000000fffffffb RCX: 0000000000000002
>> RDX: 0000000000000000 RSI: ffff96c02f07d4c8 RDI: 0000000000000282
>> RBP: ffff96c013cf1000 R08: ffff96c02f07d4c8 R09: ffff96c02f07d4d0
>> R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
>> R13: ffff96c005e800c0 R14: ffffa7cf40d7bdb8 R15: 0000000000000000
>> FS:  00007f17856bcfc0(0000) GS:ffff96c03f600000(0000) knlGS:0000000000=
000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000060 CR3: 0000000045ed6002 CR4: 00000000003606e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  ? wait_for_writer+0xb0/0xb0 [btrfs]
>>  btrfs_free_log+0x17/0x30 [btrfs]
>>  btrfs_drop_and_free_fs_root+0x9a/0xe0 [btrfs]
>>  btrfs_free_fs_roots+0xc0/0x130 [btrfs]
>>  ? wait_for_completion+0xf2/0x100
>>  close_ctree+0xea/0x2e0 [btrfs]
>>  ? kthread_stop+0x161/0x260
>>  generic_shutdown_super+0x6c/0x120
>>  kill_anon_super+0xe/0x20
>>  btrfs_kill_super+0x13/0x100 [btrfs]
>>  deactivate_locked_super+0x3f/0x70
>>  cleanup_mnt+0x3b/0x70
>>  task_work_run+0x78/0x90
>>  exit_to_usermode_loop+0x77/0xa6
>>  do_syscall_64+0x1c5/0x1e0
>>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
>> RIP: 0033:0x7f1784f90827
>> RSP: 002b:00007ffdeeb03118 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6=

>> RAX: 0000000000000000 RBX: 0000556a60c62970 RCX: 00007f1784f90827
>> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556a60c62b50
>> RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
>> R10: 0000556a60c63900 R11: 0000000000000246 R12: 0000556a60c62b50
>> R13: 00007f17854a81c4 R14: 0000000000000000 R15: 0000000000000000
>> Code: 65 a1 fd ff be 01 00 00 00 48 89 ef e8 58 a1 fd ff 48 8b 7d 00 e=
8 9f 33 fe ff 48 89 ef e8 17 6c d3 ed 48 83 c4 50 5b 5d 41 5c c3 <49> 8b =
44 24 60 f0 0f ba a8 80 65 01 00 02 72 23 83 fb fb 75 39
>> RIP: free_log_tree+0xd2/0x140 [btrfs] RSP: ffffa7cf40d7bd10
>> CR2: 0000000000000060
>> ---[ end trace 3bc199fbf8fb4977 ]---
>>
>> Cc: <stable@vger.kernel.org> # v3.13
>> Fixes: 681ae50917df9 (Btrfs: cleanup reserved space when freeing tree =
log on error)
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>=20
> Reviewed-by: David Sterba <dsterba@suse.com>
>=20
>> ---
>>  fs/btrfs/tree-log.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index f8220ec02036..a5f6971a125f 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -3143,9 +3143,12 @@ static void free_log_tree(struct btrfs_trans_ha=
ndle *trans,
>>  	};
>> =20
>>  	ret =3D walk_log_tree(trans, log, &wc);
>> -	/* I don't think this can happen but just in case */
>=20
> Example of a very useful comment :)

Heh, I think it was true when the comment was added. :)

-Jeff

--=20
Jeff Mahoney
SUSE Labs



--PtJFv9dwWAjmcyIxWGlQnddRCxQ6NWrQ6--

--TUi7FRQzcu1pW4yizgr2ghIlPATKWKvqz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAluSdm0ACgkQHntLYyF5
5bLWpg/+IkFWG6TrKEAnFl9xsox9wNqvY4CZTbrDAH0/R5D7fEVgbyS6cRoe4Ei5
oBEAfa+GUReT8JGvLzIW40NrS9nkfmUi4BE6wNkJQ/0zUS4RKCafsRRdRjh+3mmm
YQzan6awAMWT+Io1GRXiVFiwbUuY5MT1XjhSVc9LJEMvS716SZGdgasBuxAa3DHb
xdAgmtkaPFGFmkryOlsleaqG8rN9RpzAVUrK9oYZKs/LaLhHARG7nRVBHaG9CY26
CQoGqMRwedT9dW1+H6uZpS6L3OAfBsvjy0rKRR+4Vmb3TyYt/6satw+SvLhkwGIg
AmUJd3rq1RLxTUURpiRJq8Tog5yYE2xPrPMa9fICwhDDe+Sl1tRhqhrpXGGsBpzw
wX2DNe24quvfGokIVEp8gl5vG0uHVmveObvx/ds+ePhCCS19WdHUmxgeFrgn6Cfi
g1YpYwGjCtXZPBSWBJXX2Wm2epQRWWHieywDAvehNqB8sjKtp24B7qYTFVKVnryr
mIHkiV5V9nrYynsWppIC1e0N8SvDEvKsHRyj3TB2n4IAWm2wUW9xRjVznkzKos/t
ugTt7uLrlWeMTyicBlyp4uTFx2qoLRw+Ja8gJ+W3x7XANYuSFqkbnLtDq5tqkurP
bP3OETKlNTHsoe1hTy6iqAl+sO+Qt68N029+hYe+aX7ueenECgQ=
=fi5v
-----END PGP SIGNATURE-----

--TUi7FRQzcu1pW4yizgr2ghIlPATKWKvqz--
