Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374046;
	b=caa2IDzSf2+F9i3I1GQikoATje2bAByAxRNorEivcRWptM9kUH62VL/Rbvryzj5GZVo0
	 p36R/zqCsYwXukco4CQu7Oj+cLjB86lA0lF6TjSESV2av7Q/V8WUka0H/cGhdrDN/qMnx
	 uIDPN7vMoTTpw6W3UvPuxnfUBj/c1X7d8/EP7Gdi3uuFgFZXohN+/PBYXeOoMc/7dVXnV
	 tcpYePBTtCfower7/zkJZom3539jOfcLWf9aviAJOmCCy+HPFdh7j4MyoP4yT7V0c+WB8
	 4cuEEH29ydKWJUHsMwxyiXt806Nw8BC6smhkTlKbLwS9DvhA5JgyqZEbCMkwkuR6j9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374046;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Content-Type:Message-ID:Date:MIME-Version:
	 User-Agent:Content-Language:To:From:Subject:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=S5RZ9dXR9gFF14d2REimDlsZmB3w2244Qzno92tLrLs=;
	b=tzH5jfsfn87fiKyhntT+ypDFcfVJ640+V4OEkhKlKYnV1fSm0LGLa6pZX+zCzgWPiR04
	 ItjTUFEwQ41QusynKiHP8e2o+WynzZo1gEdP9/9pPpDsY3ktVJPdvv13pbEpdCed4l7ak
	 OHDbYhrbvI39vZumnAUp+4+el+minK2WViKUCPdgRVbelJLMYV78EHUXd+NZnrLvaigtS
	 TiCTfisDx8Lls7cK+3mKL7lykt/hlhmB0aRKo0JyYNIbSjH8qsDQj75OZWjd/zasKPXsQ
	 D6GYeZzh51p7ZWm6ZcxyZEIU3BSIyZP55Pk+86YgK1DyI14FVcNe7b/+tfaG3O6pwVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.at;
	spf=pass smtp.mailfrom=gmx.at;
	dkim=pass header.d=gmx.at header.i=markus.kern1@gmx.at header.a=rsa-sha256 header.s=s31663417 header.b="Xg/DBGH/";
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C615606A320
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 19:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C615606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.at header.i=markus.kern1@gmx.at header.a=rsa-sha256 header.s=s31663417 header.b=Xg/DBGH/
DKIM2-Signature:  i=1; m=1; t=1795374043;
 mf=PG1hcmt1cy5rZXJuMUBnbXguYXQ+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.at;
 s=s31663417:rsa-sha256:ikTuerDei2nBPD2FTrbMVjEyZZCh
   AdEPt5Bje0YdQfH6x7Z0MW551XecAOjxj5gFNONWyU9+jhNYxQnrvev7crPcYlfAH9AovJZlNUo
   ifWgXG3Jrk0He1QNFmjZuTARqolCuryZ/cLFGhj2nfDW5SECbaYpOZlwJy37InU2CYQmiK71doU
   JdkaMt40fA11qVAGwZXIcgZU1rck+6oITQEv4wCW98bC1bUG0bykJ+p7Am8zPWKgO+4mrbsayIP
   6+itnkwYo9n1jNxPDn7bmqpe5cSMN3SLzq1uPFHq8b4VA538ex2xkdia2X/D+75k+IrSBamhAhj
   ZbXWzkmI7fd9yA==;
Message-Instance:  m=1;
 h=sha256:
   JqCoCYiMjQHQb3maTQxFyUBKmMBh1mR9am13Wad9Ki4=:
   YeKgqNqavd9v46dieZPdzLw1kvhUBohW5UR3lC7JOWI=,
  sha512:
   9QgvHYp2I/6v6WoAOiNstJUNhmo8OGBaWdJNM4wYHG9eFd39aT1VeLGpy6vNxi5ivMxurHkPeN5/mmEKe02oiQ==:
   JLC/IQ7I/nInsF88MtMzwcyO5UuRu2kGC/y/hqh3lbTaq7ClfdXaDdJ0mJppXM+T69uBBUxP1vxTGjJO23K4AQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.at;
	s=s31663417; t=1795374043; x=1795978843; i=markus.kern1@gmx.at;
	bh=S5RZ9dXR9gFF14d2REimDlsZmB3w2244Qzno92tLrLs=;
	h=X-UI-Sender-Class:Content-Type:Message-ID:Date:MIME-Version:To:
	 From:Subject:cc:content-transfer-encoding:content-type:date:from:
	 message-id:mime-version:reply-to:subject:to;
	b=Xg/DBGH/mprRSzSJ7K96mz4kUC0f01svPDYkmi/LJZfJto0xuxM5hzmr2AIF990x
	 y5Pg6cti+Q4HHwYC/9j0isVtjU63hwojdjdKQazZc3emKEHgufUDnoLtYJKdPtYrq
	 4GbyO8dZMDefwB5ZzN+26q5LXYrj9u7iEGVP1LrsMNKs/oaOaksNK61vBqppHQ7at
	 rJEHlpuIeZ3y0DKMH8S4/+bJqGRuzq7Kjm3yGGnzEQAggNX1NEu1KxwqxnfZXdqwL
	 P7i3GbBbDCqY4+g/4j/ceDO5DvejWgiHxTCos8BCLjkVKjAB9tLygUdBiuOi0ADcX
	 pPiGULXbdzInuXllgQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWASe-1y1exU3s30-00S7ty for
 <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 20:00:42 +0100
Content-Type: multipart/mixed; boundary="------------dRwWBhqhjnulOBJYtaQcAZy3"
Message-ID: <04c9933a-ec63-4d97-94b7-6b6e406b7328@gmx.at>
Date: Sun, 22 Nov 2026 20:00:42 +0100
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-AT
To: linux-btrfs@vger.kernel.org
From: Markus Kern <markus.kern1@gmx.at>
Subject: [BUG] btrfs: interrupted subvolume drop resets drop_progress to 0,
 next mount aborts with "has 0 references" (-117)
X-Provags-ID: V03:K1:3EXOVb3Tz3dma9+tf/Z3sW++4N0IhNONzBU1jmwqSwMUK0adIW9
 9CxUD9N8Cd/1q9SbnSz5QYb009FjQrRdm2xY3Bao7sH2DmreVMSfXPz2IMm2LvSCPvLQ5xG
 +MEAFviP9rESBqkYijpn8zFVPMJAq5Bdz9lakBr2VFZ2/hNgj+jPag8MRHSdOe8uCGTVDTj
 hUEkho9KSJOu98e3WpeSQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oZsx5p0i308=;RN417Ck/UVEenjcVeBmjgmYcMre
 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
 KJMtcc/SYeCRf9uB7Zet4+FKOI9Q==

This is a multi-part message in MIME format.
--------------dRwWBhqhjnulOBJYtaQcAZy3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello btrfs kernel team,

Impact:
after an interrupted drop of a deleted subvolume, every later rw mount=20
aborts the transaction (-117) and forces the fs read-only; it cannot be=20
used rw anymore and btrfs check reports ~1000 extent ref errors (all on=20
the deleted subvolume; remaining data readable ro). Hit twice in the=20
field by a bare-metal restore tool, i.e. a freshly restored system is=20
unusable.
Plain userspace sequence, no fault injection needed; current master is=20
affected.

Details:
A resumed snapshot/subvolume drop can write drop_progress =3D 0 /=20
drop_level =3D 0 back to the root item after earlier runs already dropped=
=20
the leftmost subtrees. If the snapshot sharing those subtrees COWs them=20
before the next resume, the drop restarts at slot 0, finds a block with=20
0 references and aborts the transaction (-EUCLEAN). Seen in the wild=20
after bare-metal restores (btrfs receive -> rw snapshot -> delete=20
received subvol -> short mount/umount cycles -> writes), reproduced on=20
6.12.100 (Debian), 6.19.10 and 7.2.13 (Fedora), code unchanged in=20
current master. Downstream report with forensics:=20
https://bugzilla.redhat.com/show_bug.cgi?id=3D2496404

Cause: in btrfs_drop_snapshot(), the resume branch (drop_progress !=3D 0)=
=20
only seeds wc->update_progress. wc->drop_progress / wc->drop_level stay=20
zero from kzalloc. The loop does

if (wc->stage =3D=3D DROP_REFERENCE) { set wc->drop_level / wc->drop_progr=
ess }
btrfs_cpu_key_to_disk(&root_item->drop_progress, &wc->drop_progress);
btrfs_set_root_drop_level(root_item, wc->drop_level);
if (btrfs_should_end_transaction(trans) ||=20
btrfs_need_cleaner_sleep(fs_info))
	btrfs_update_root(...);   /* and -EAGAIN when closing */

When the resumed walk first descends into a shared node, the first=20
iteration ends in UPDATE_BACKREF, zeros are copied into the root item=20
and, if the fs is unmounted at that moment (btrfs_need_cleaner_sleep()=20
true while closing), committed. kprobe on btrfs_update_root after a=20
resume with saved progress (5421 INODE_ITEM 0) level 2:=20
btrfs_drop_snapshot rootid=3D256 (resume) btrfs_update_root rootid=3D256=
=20
dp=3D0 dlvl=3D0 <-- first write after resume btrfs_update_root rootid=3D25=
6=20
dp=3D16032 dlvl=3D2

On the next resume check_ref_exists() would skip already dropped blocks,=
=20
but if they were freed by COW from the sharing snapshot,=20
btrfs_lookup_extent_info() returns refs 0 and do_walk_down() returns=20
-EUCLEAN first.

Reproducer (btrfs-drop-resume-repro.sh attached, self-contained, two=20
loop images): mkfs.btrfs -n 4096; receive a large (~1.5M files)=20
subvolume; snapshot it rw; delete the received subvolume; umount mount=20
-o commit=3D1; sleep 3; umount # drop runs, progress saved (level 3)=20
mount; umount # resume interrupted -> drop_progress 0 on disk mount;=20
touch many files in the snapshot; umount mount # "bytenr X has 0=20
references, expect > 0", abort -117 Results: 7.2.13-200.fc44 (untainted,=
=20
QEMU): 3/3 drop_progress reset to 0, 0/3 aborts same, target behind=20
dm-delay 1 ms: 2/2 drop_progress reset to 0, 2/2 aborts 6.19.10-300.fc44=
=20
(SATA SSD, no delay): reset + abort in the first iteration same=20
sequence, fixed module: 4/4 clean, progress kept, drop completes Debian=20
6.12.100 in QEMU (throttled disk): stock aborts, fixed build 60 cycles=20
clean The reset happens reliably; the abort additionally needs the COW=20
in the snapshot to free the already dropped nodes before the resumed=20
drop skips past them, so slow storage makes it likely.

Splat (7.2.13, dm-delay run, trimmed): WARNING:=20
fs/btrfs/extent-tree.c:223 at btrfs_lookup_extent_info+0x505/0x530,=20
CPU#6: btrfs-cleaner/100182 CPU: 6 UID: 0 PID: 100182 Comm:=20
btrfs-cleaner Not tainted 7.2.13-200.fc44.x86_64 #1 PREEMPT(lazy) Call=20
Trace: do_walk_down+0x182/0x7d0 walk_down_tree+0xc5/0x170=20
btrfs_drop_snapshot+0x24d/0xdc0=20
btrfs_clean_one_deleted_snapshot+0xce/0x160 cleaner_kthread+0x91/0x1b0=20
kthread+0xe4/0x120 ret_from_fork+0x1a1/0x270 ret_from_fork_asm+0x1a/0x30=
=20
BTRFS error (device dm-0): bytenr 2293555200 has 0 references, expect >=20
0 WARNING: fs/btrfs/extent-tree.c:6385 at=20
btrfs_drop_snapshot+0x760/0xdc0, CPU#6: btrfs-cleaner/100182 BTRFS error=
=20
(device dm-0 state A): Transaction 25 aborted (error -117) BTRFS: error=20
(device dm-0 state A) in btrfs_drop_snapshot:6385: errno=3D-117 Filesystem=
=20
corrupted BTRFS info (device dm-0 state EA): forced readonly

Field validation: a vendor recovery image (Debian 6.12.100) with only=20
btrfs.ko rebuilt with the fix below was used for a real bare-metal=20
restore of the affected machine (~500 GB, same sequence, 6 mount/umount=20
cycles at the end). drop_progress stayed at (387120 INODE_ITEM 0) level=20
2 across those remounts, btrfs check was clean, the drop completed and=20
the system boots. With the stock module the same restore procedure=20
corrupted the filesystem twice.

Proposed fix (tested as above; also attached as=20
btrfs-seed-drop-progress-on-resume.patch, made against 6.19, code=20
identical in master):

=2D-- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@=20
btrfs_drop_snapshot btrfs_disk_key_to_cpu(&key,=20
&root_item->drop_progress); memcpy(&wc->update_progress, &key,=20
sizeof(wc->update_progress));

   memcpy(&wc->drop_progress, &key, sizeof(wc->drop_progress));

   wc->drop_level =3D btrfs_root_drop_level(root_item);

A sanitized btrfs-image (-w -s) of the affected filesystem is available.

Claude created the fix and did the testing.

Best Regards,
Markus Kern

--------------dRwWBhqhjnulOBJYtaQcAZy3
Content-Type: text/x-shellscript; charset=UTF-8;
 name="btrfs-drop-resume-repro.sh"
Content-Disposition: attachment; filename="btrfs-drop-resume-repro.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKIyBSZXByb2R1Y2VyOiBhIHJlc3VtZWQgYnRyZnNfZHJvcF9zbmFwc2hv
dCgpIGNhbiBwZXJzaXN0IGRyb3BfcHJvZ3Jlc3M9MCAvIGRyb3BfbGV2ZWw9MCwKIyB0aGUg
bmV4dCByZXN1bWUgdGhlbiBoaXRzIGEgYmxvY2sgYWxyZWFkeSBmcmVlZCBieSBDT1cgLT4g
ImhhcyAwIHJlZmVyZW5jZXMiLCBhYm9ydCAtMTE3LgojCiMgU2VxdWVuY2UgKGFzIGRvbmUg
YnkgYSBiYXJlLW1ldGFsIHJlc3RvcmUgdG9vbCk6CiMgICByZWNlaXZlIHN1YnZvbCAtPiBy
dyBzbmFwc2hvdCBvZiBpdCAtPiBkZWxldGUgdGhlIHJlY2VpdmVkIHN1YnZvbCAtPiB1bW91
bnQKIyAgIG1vdW50IChjb21taXQ9MSksIHdhaXQsIHVtb3VudCAgICAgICAgZHJvcCBydW5z
LCBwcm9ncmVzcyBQID4gMCBzYXZlZAojICAgbW91bnQsIHVtb3VudCBhdCBvbmNlICAgICAg
ICAgICAgICAgICByZXN1bWUgaW50ZXJydXB0ZWQgLT4gZHJvcF9wcm9ncmVzcyAwIG9uIGRp
c2sgKGJ1ZykKIyAgIG1vdW50LCB0b3VjaCBmaWxlcyBpbiB0aGUgc25hcHNob3QgICAgQ09X
IGZyZWVzIG5vZGVzIHRoZSBmaXJzdCBkcm9wIHJ1biBhbHJlYWR5IHJlbGVhc2VkCiMgICBt
b3VudCwgd2FpdCAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsZWFuZXIgcmVzdGFydHMg
YXQgc2xvdCAwIC0+IGFib3J0CiMKIyBVc2FnZSAocm9vdCk6IC4vYnRyZnMtZHJvcC1yZXN1
bWUtcmVwcm8uc2ggW1dPUktESVJdIFtJVEVSQVRJT05TXQojICAgRklMRVM9MTUwMDAwMCAg
ZmlsZXMgaW4gdGhlIHNvdXJjZSBzdWJ2b2x1bWUgKG1hbnkgc21hbGwgZmlsZXMgLT4gdGFs
bCB0cmVlcykKIyAgIFVzZXMgdHdvIHNwYXJzZSBsb29wIGltYWdlcyBpbiBXT1JLRElSICh+
MTAgR0IgcmVhbCBzcGFjZSkuIE5vZGVzaXplIDQwOTYgb24gdGhlIHRhcmdldAojICAgbWFr
ZXMgdGhlIHdpbmRvdyBsYXJnZTsgYSBzbG93L2J1c3kgZGlzayBtYWtlcyBpdCBsYXJnZXIu
CiMgICBERUxBWV9NUz1OICBwdXQgdGhlIHRhcmdldCBiZWhpbmQgZG0tZGVsYXkgKE4gbXMg
cGVyIEkvTykgdG8gZW11bGF0ZSBzbG93IHN0b3JhZ2U7IG9uIGZhc3QKIyAgICAgICAgICAg
ICAgIGRpc2tzIHRoZSBwcm9ncmVzcyByZXNldCBzaG93cyB1cCByZWxpYWJseSwgdGhlIGZp
bmFsIGFib3J0IG5lZWRzIHRoZSBDT1cgaW4KIyAgICAgICAgICAgICAgIHN0ZXAgNCB0byB3
aW4gdGhlIHJhY2UgYWdhaW5zdCB0aGUgcmVzdW1lZCBkcm9wLgpzZXQgLXUKVz0kezE6LS92
YXIvdG1wL2J0cmZzLWRyb3AtcmVwcm99OyBJVEVSPSR7MjotM307IEZJTEVTPSR7RklMRVM6
LTE1MDAwMDB9ClM9JFcvc3JjOyBUPSRXL3RndDsgbWtkaXIgLXAgJFMgJFQKZHAoKXsgYnRy
ZnMgaW5zcGVjdC1pbnRlcm5hbCBkdW1wLXRyZWUgLXQgcm9vdCAkTFQgMj4vZGV2L251bGwg
fAogICAgICBhd2sgJy9rZXkgXCgyNTYgUk9PVF9JVEVNL3tmPTF9IGYmJi9kcm9wX3Byb2dy
ZXNzL3tzdWIoL15bIFx0XSsvLCIiKTsgcHJpbnQ7IGV4aXR9JzsgfQpjbGVhbnVwKCl7IHVt
b3VudCAkVCAkUyAyPi9kZXYvbnVsbDsgZG1zZXR1cCByZW1vdmUgcmVwcm8tZGVsYXkgMj4v
ZGV2L251bGw7IGxvc2V0dXAgLWQgJExTICRMTCAyPi9kZXYvbnVsbDsgfTsgdHJhcCBjbGVh
bnVwIEVYSVQKCmlmIFsgISAtZiAkVy9zcmMucmVhZHkgXTsgdGhlbgogIHJtIC1mICRXL3Ny
Yy5pbWc7IHRydW5jYXRlIC1zIDQwRyAkVy9zcmMuaW1nOyBjaGF0dHIgK0MgJFcvc3JjLmlt
ZyAyPi9kZXYvbnVsbAogIExTPSQobG9zZXR1cCAtZiAtLXNob3cgJFcvc3JjLmltZyk7IG1r
ZnMuYnRyZnMgLXEgLWYgJExTOyBtb3VudCAkTFMgJFMKICBidHJmcyBzdWJ2b2x1bWUgY3Jl
YXRlICRTL3ZvbCA+L2Rldi9udWxsCiAgZWNobyAicG9wdWxhdGluZyAkRklMRVMgZmlsZXMg
Li4uIgogIHB5dGhvbjMgLWMgJwppbXBvcnQgb3Msc3lzCnIsbj1zeXMuYXJndlsxXSxpbnQo
c3lzLmFyZ3ZbMl0pCmZvciBkIGluIHJhbmdlKDAsbiwxMDAwKToKICAgIHA9ZiJ7cn0vZHtk
Ly8xMDAwOjA1ZH0iOyBvcy5ta2RpcihwKQogICAgZm9yIGkgaW4gcmFuZ2UobWluKDEwMDAs
bi1kKSk6CiAgICAgICAgd2l0aCBvcGVuKGYie3B9L2Z7aTowNGR9IiwidyIpIGFzIGY6IGYu
d3JpdGUoIngiKihpJTIwMCkpCicgJFMvdm9sICRGSUxFUwogIGJ0cmZzIHN1YnZvbHVtZSBz
bmFwc2hvdCAtciAkUy92b2wgJFMvc25hcCA+L2Rldi9udWxsOyBzeW5jOyB1bW91bnQgJFM7
IGxvc2V0dXAgLWQgJExTCiAgdG91Y2ggJFcvc3JjLnJlYWR5CmZpClsgLWYgJFcvdGd0Lmlt
ZyBdIHx8IHsgdHJ1bmNhdGUgLXMgNDBHICRXL3RndC5pbWc7IGNoYXR0ciArQyAkVy90Z3Qu
aW1nIDI+L2Rldi9udWxsOyB9CkxTPSQobG9zZXR1cCAtZiAtLXNob3cgLXIgJFcvc3JjLmlt
Zyk7IExMPSQobG9zZXR1cCAtZiAtLXNob3cgJFcvdGd0LmltZyk7IExUPSRMTAppZiBbIC1u
ICIke0RFTEFZX01TOi19IiBdOyB0aGVuCiAgbW9kcHJvYmUgZG0tZGVsYXk7IGVjaG8gIjAg
JChibG9ja2RldiAtLWdldHN6ICRMTCkgZGVsYXkgJExMIDAgJERFTEFZX01TIiB8IGRtc2V0
dXAgY3JlYXRlIHJlcHJvLWRlbGF5CiAgTFQ9L2Rldi9tYXBwZXIvcmVwcm8tZGVsYXkKZmkK
bW91bnQgLW8gcm8gJExTICRTCgpSRUc9MDsgQUJPUlQ9MApmb3IgaSBpbiAkKHNlcSAxICRJ
VEVSKTsgZG8KICBlY2hvICJidHJmcy1kcm9wLXJlcHJvIGl0ZXJhdGlvbiAkaSBzdGFydCIg
PiAvZGV2L2ttc2cKICBta2ZzLmJ0cmZzIC1xIC1mIC1uIDQwOTYgJExUOyBtb3VudCAkTFQg
JFQ7IG1rZGlyICRUL3JlY3YKICBidHJmcyBzZW5kIC1xICRTL3NuYXAgfCBidHJmcyByZWNl
aXZlIC1xICRUL3JlY3YvCiAgYnRyZnMgc3Vidm9sdW1lIHNuYXBzaG90ICRUL3JlY3Yvc25h
cCAkVC9AID4vZGV2L251bGwKICBidHJmcyBzdWJ2b2x1bWUgZGVsZXRlICRUL3JlY3Yvc25h
cCA+L2Rldi9udWxsCiAgdW1vdW50ICRUOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgUDE9JChkcCkKICBtb3VudCAtbyBjb21taXQ9MSAkTFQgJFQ7IHNsZWVwIDM7
IHVtb3VudCAkVDsgICBQMj0kKGRwKQogIG1vdW50ICRMVCAkVDsgdW1vdW50ICRUOyAgICAg
ICAgICAgICAgICAgICAgICAgIFAzPSQoZHApCiAgZWNobyAiaXRlcmF0aW9uICRpOiBhZnRl
ciBkZWxldGUrdW1vdW50OiBbJFAxXSIKICBlY2hvICIgICAgICAgICAgICAgIGFmdGVyIG1v
dW50LzNzL3Vtb3VudDogWyRQMl0iCiAgZWNobyAiICAgICAgICAgICAgICBhZnRlciBtb3Vu
dC91bW91bnQ6ICAgIFskUDNdIgogIGlmIFtbICIkUDIiID09ICoiZHJvcF9sZXZlbCAiWzEt
OV0qICYmICIkUDMiID09ICoiKDAgVU5LTk9XTi4wIDApIGRyb3BfbGV2ZWwgMCIqIF1dOyB0
aGVuCiAgICBSRUc9JCgoUkVHKzEpKTsgZWNobyAiaXRlcmF0aW9uICRpOiBkcm9wX3Byb2dy
ZXNzIHdlbnQgYmFjayB0byAwIChidWcgc3RhdGUgcGVyc2lzdGVkKSI7IGZpCiAgbW91bnQg
JExUICRUOyBmaW5kICRUL0AgLXR5cGUgZiB8IGF3ayAnTlIlMjU9PTAnIHwgaGVhZCAtMjAw
MDAgfCB4YXJncyAtciB0b3VjaDsgc3luYzsgdW1vdW50ICRUCiAgbW91bnQgJExUICRUOyBz
bGVlcCAzMDsgdW1vdW50ICRUIDI+L2Rldi9udWxsCiAgaWYgZG1lc2cgfCBzZWQgLW4gIi9i
dHJmcy1kcm9wLXJlcHJvIGl0ZXJhdGlvbiAkaSBzdGFydC8sXCRwIiB8IGdyZXAgLXFFICdU
cmFuc2FjdGlvbiBhYm9ydGVkfGhhcyAwIHJlZmVyZW5jZXMnOyB0aGVuCiAgICBBQk9SVD0k
KChBQk9SVCsxKSk7IGVjaG8gIml0ZXJhdGlvbiAkaTogQUJPUlQiCiAgICBkbWVzZyB8IHNl
ZCAtbiAiL2J0cmZzLWRyb3AtcmVwcm8gaXRlcmF0aW9uICRpIHN0YXJ0LyxcJHAiIHwgZ3Jl
cCAtaUUgJ2J0cmZzLioocmVmZXJlbmNlc3xhYm9ydHxlcnJvciknIHwgaGVhZCAtNQogIGZp
CmRvbmUKZWNobyAia2VybmVsICQodW5hbWUgLXIpOiAkUkVHLyRJVEVSIHByb2dyZXNzIHJl
c2V0IHRvIDAsICRBQk9SVC8kSVRFUiBhYm9ydHMiCg==
--------------dRwWBhqhjnulOBJYtaQcAZy3
Content-Type: text/x-patch; charset=UTF-8;
 name="btrfs-seed-drop-progress-on-resume.patch"
Content-Disposition: attachment;
 filename="btrfs-seed-drop-progress-on-resume.patch"
Content-Transfer-Encoding: base64

LS0tIGEvZnMvYnRyZnMvZXh0ZW50LXRyZWUuYworKysgYi9mcy9idHJmcy9leHRlbnQtdHJl
ZS5jCkBAIC02MzMzLDYgKzYzMzMsMTkgQEAKIAkJYnRyZnNfZGlza19rZXlfdG9fY3B1KCZr
ZXksICZyb290X2l0ZW0tPmRyb3BfcHJvZ3Jlc3MpOwogCQltZW1jcHkoJndjLT51cGRhdGVf
cHJvZ3Jlc3MsICZrZXksCiAJCSAgICAgICBzaXplb2Yod2MtPnVwZGF0ZV9wcm9ncmVzcykp
OworCQkvKgorCQkgKiBTZWVkIHRoZSBkcm9wIHByb2dyZXNzIHdpdGggdGhlIHNhdmVkIG9u
ZS4gT3RoZXJ3aXNlLCBpZiB0aGUKKwkJICogZmlyc3QgaXRlcmF0aW9uIG9mIHRoZSBsb29w
IGJlbG93IGVuZHMgaW4gdGhlIFVQREFURV9CQUNLUkVGCisJCSAqIHN0YWdlLCB3ZSBjb3B5
IGEgemVyb2VkIGRyb3BfcHJvZ3Jlc3MgYW5kIGRyb3BfbGV2ZWwgaW50byB0aGUKKwkJICog
cm9vdCBpdGVtLCBhbmQgaWYgdGhlIHRyYW5zYWN0aW9uIGVuZHMgcmlnaHQgdGhlbiAodW5t
b3VudCBvcgorCQkgKiBidHJmc19zaG91bGRfZW5kX3RyYW5zYWN0aW9uKCkpIHdlIHBlcnNp
c3QgYSBkcm9wX3Byb2dyZXNzIG9mIDAKKwkJICogYWx0aG91Z2ggdGhlIHN1YnRyZWVzIGxl
ZnQgb2YgdGhlIHNhdmVkIGtleSB3ZXJlIGFscmVhZHkKKwkJICogZHJvcHBlZC4gVGhlIG5l
eHQgcmVzdW1lIHRoZW4gc3RhcnRzIGZyb20gdGhlIGxlZnRtb3N0IHNsb3QKKwkJICogYW5k
IGNhbiBmaW5kIGJsb2NrcyB3aXRoIDAgcmVmZXJlbmNlcyAoZnJlZWQgbWVhbndoaWxlIGJ5
IENPVworCQkgKiBmcm9tIGEgc25hcHNob3Qgc2hhcmluZyB0aGVtKSBhbmQgYWJvcnQgdGhl
IHRyYW5zYWN0aW9uLgorCQkgKi8KKwkJbWVtY3B5KCZ3Yy0+ZHJvcF9wcm9ncmVzcywgJmtl
eSwgc2l6ZW9mKHdjLT5kcm9wX3Byb2dyZXNzKSk7CisJCXdjLT5kcm9wX2xldmVsID0gYnRy
ZnNfcm9vdF9kcm9wX2xldmVsKHJvb3RfaXRlbSk7CiAKIAkJbGV2ZWwgPSBidHJmc19yb290
X2Ryb3BfbGV2ZWwocm9vdF9pdGVtKTsKIAkJQlVHX09OKGxldmVsID09IDApOwo=

--------------dRwWBhqhjnulOBJYtaQcAZy3--
