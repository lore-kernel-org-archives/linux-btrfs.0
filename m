Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795381094;
	b=qaK6udqC0vWjBc0LX8J4soT8m+37xkykx8R1rwTEEPSm2yQ3p1ZTRYWaupoN3JURE+nH
	 r90n5sj6wrp7GS2kdbzakD2y80H1E8g2125TJ79w0BRGKowTHWEl4fZiHTlQNQSDEidJC
	 BJ1JjgAg4MAHd1TE4jAN70dFSIrYlJb4Ubev688A05zObaitLZ7+K6MIJa0jIssawcMOL
	 URT1RYB/b6xx8FClwTHoUBT5Pq6OFm7BAnFG69ECAidLhWTPTe9vIaeI1raD2QL4Tqavq
	 lHYJd3zI2BkI3JtBZEehbzMAqGVg/DAKjuMLVMjHjZj96t9KIO6OVrDpuMnDs4dkRRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795381094;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=iBVif5LnijGMxtdalyNxkDz5IKsY4h2n+TKlHXQRU5U=;
	b=iOyuKKfgHjXZL7ZVgQgVCNnlBPxg46/yVSS2Vte5Xyl2mwmDBmYz9c6lG8CI6TPX3Rvw
	 MDGYP1K4M+KLfTXBNkJeOWy/X/eCKRa8W1tiox27zui8cFAmAFB+ZxXQGQb1H9a1FDLwT
	 WS6ZTLQMviD/Vl37gTHZ7DzyAv+7m3PuE+uSmdUxiq5+yOlnCgLdXCZHsAUJ1w/rfhZsf
	 vWLbMJ6Y03XNoUdjB4mm+Bg33rpOXMiSP/m3278EbDNPe5690tPDNGQQ/Pfmk5xcfBXIZ
	 hXhMFnu6zEBuC6X/djO6toRN6S8crElhDhQufskKIFZmGftywagAEY3FFwwbqbJKm/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=ALhw3+o4;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C72E606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 20:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C72E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=ALhw3+o4
DKIM2-Signature:  i=1; m=1; t=1795381091;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:VnzYJpUPEVplou+gTH1EbVkU6P8V
   FWfs+OtZwTm444HoxNaGWWv89itPv3X5/7+F8tdiw8SlAkopHvra4KVPLZ8Wv6sVwzPCPScIWx0
   QPteeQRDWsgAuEosnEIUgrQkGUKWaLDVPt+6ZkpNfjNh9wlXNL1wtuRu01e7tfBE02/V5QG0ewx
   c1nrtg2/g0+UxjB8S8Q3XGDMOrEJ9v5FKdIN+9MwAh6G0GhcPkr22GYeJOC+1tvMI/EenMLX5PV
   GXdAEIAfr3msu5Y4r8ZKXO+6lzHYfV697FoLXDeI3LB1KmVH/M5ChW4eZjM6LjvsKuV/Ci6B3Az
   4doPyZKfGhHoiw==;
Message-Instance:  m=1;
 h=sha256:
   zPPVg5ZSUL3gfQ0dz1opCSjX2VHBqKXkn6ErtQZETLw=:
   t/fvzH3nLilme5bYfyO6Av+nxvUkj2tiBlH1Ks1uZVw=,
  sha512:
   S+/I6RjFbdyTDJy6TdL8rEx20GNNAcHKxxXAZJiQ+hN2Aj1Krlk9SpBMN1dkOj3S9q3Cxp3ZuawRz3h1pQG/tQ==:
   ajBEJd1rh1ZSj27iYPzPu/QgFgUuVPCO/Pa5VLo9yjWa57sDebCspXcSrrjKKxqmr9kDLoz1QtUEconz8Ph/sQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795381091; x=1795985891; i=quwenruo.btrfs@gmx.com;
	bh=iBVif5LnijGMxtdalyNxkDz5IKsY4h2n+TKlHXQRU5U=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ALhw3+o40cgyIVoktS1DiPf9UMOYade/XBIxYsfSvbFaYidV1dLQb/SXo/2XAdO3
	 YD1r7BTHXBDX/AACDDkAhXX92evt8wixIzvf4s8umD+2THleF91+MuHQhWsS2X53r
	 JtDw3IuW58PRMxUSZGLBa+6DkYahKNz8gQZC5YccVuOfS1m7pn5K0qot64YoLpRq9
	 45Zr2Lsf/TA2MhjIqB1TcbWm8Iq06gsAJtTdKnaDETXnoMdhYn/jECFGVUaYH3jxe
	 E4MDojEr0AriVQjyLovkiBdzIByiTM4MCRhsClv2jb10/PIQI8ejTiaqpfwV+ZIP1
	 cMdkXrvA4cW9RuY/gg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N5G9t-1yVkoB2OdZ-00zjLs; Sun, 22
 Nov 2026 21:58:11 +0100
Message-ID: <544755fd-8e78-48e0-992b-1ff9d8a06a2a@gmx.com>
Date: Mon, 23 Nov 2026 07:28:08 +1030
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
Subject: Re: [BUG] btrfs: interrupted subvolume drop resets drop_progress to
 0, next mount aborts with "has 0 references" (-117)
To: Markus Kern <markus.kern1@gmx.at>, linux-btrfs@vger.kernel.org
References: <04c9933a-ec63-4d97-94b7-6b6e406b7328@gmx.at>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <04c9933a-ec63-4d97-94b7-6b6e406b7328@gmx.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EwjAVMhBvXkAgABsN+fh2quWc087UXPhj+tk/W3r6rHzGsyCB+U
 PLAs0GB79UspBp36Nbj7AYzJCOzPt2T55Zi7rRHQshle3zkWsLFMFYRYAN0jmGDanbW3UHK
 csqQJoDgBZK58CBlQBlXumwCSuKy3JiQ35dHJl1sy1C4amZUtE+HGZAus1NlqCPfA+PC8tO
 0J9doWTJop2kejpaKB8SQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:AnunK1YLauU=;TV5vq9wmzgbob4RQ7vyn9zk5ic4
 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
 gtngSgQnSsMBMx4muUZ5pcjT1Z9A==



=E5=9C=A8 2026/11/23 05:30, Markus Kern =E5=86=99=E9=81=93:
> Hello btrfs kernel team,

https://lore.kernel.org/linux-btrfs/20261103-drop-progress-v1-1-16e3455651=
09@pelam.fi/

>=20
> Impact:
> after an interrupted drop of a deleted subvolume, every later rw mount=
=20
> aborts the transaction (-117) and forces the fs read-only; it cannot be=
=20
> used rw anymore and btrfs check reports ~1000 extent ref errors (all on=
=20
> the deleted subvolume; remaining data readable ro). Hit twice in the=20
> field by a bare-metal restore tool, i.e. a freshly restored system is=20
> unusable.
> Plain userspace sequence, no fault injection needed; current master is=
=20
> affected.
>=20
> Details:
> A resumed snapshot/subvolume drop can write drop_progress =3D 0 /=20
> drop_level =3D 0 back to the root item after earlier runs already droppe=
d=20
> the leftmost subtrees. If the snapshot sharing those subtrees COWs them=
=20
> before the next resume, the drop restarts at slot 0, finds a block with=
=20
> 0 references and aborts the transaction (-EUCLEAN). Seen in the wild=20
> after bare-metal restores (btrfs receive -> rw snapshot -> delete=20
> received subvol -> short mount/umount cycles -> writes), reproduced on=
=20
> 6.12.100 (Debian), 6.19.10 and 7.2.13 (Fedora), code unchanged in=20
> current master. Downstream report with forensics: https://=20
> bugzilla.redhat.com/show_bug.cgi?id=3D2496404
>=20
> Cause: in btrfs_drop_snapshot(), the resume branch (drop_progress !=3D 0=
)=20
> only seeds wc->update_progress. wc->drop_progress / wc->drop_level stay=
=20
> zero from kzalloc. The loop does
>=20
> if (wc->stage =3D=3D DROP_REFERENCE) { set wc->drop_level / wc->drop_pro=
gress }
> btrfs_cpu_key_to_disk(&root_item->drop_progress, &wc->drop_progress);
> btrfs_set_root_drop_level(root_item, wc->drop_level);
> if (btrfs_should_end_transaction(trans) ||=20
> btrfs_need_cleaner_sleep(fs_info))
>  =C2=A0=C2=A0=C2=A0=C2=A0btrfs_update_root(...);=C2=A0=C2=A0 /* and -EAG=
AIN when closing */
>=20
> When the resumed walk first descends into a shared node, the first=20
> iteration ends in UPDATE_BACKREF, zeros are copied into the root item=20
> and, if the fs is unmounted at that moment (btrfs_need_cleaner_sleep()=
=20
> true while closing), committed. kprobe on btrfs_update_root after a=20
> resume with saved progress (5421 INODE_ITEM 0) level 2:=20
> btrfs_drop_snapshot rootid=3D256 (resume) btrfs_update_root rootid=3D256=
=20
> dp=3D0 dlvl=3D0 <-- first write after resume btrfs_update_root rootid=3D=
256=20
> dp=3D16032 dlvl=3D2
>=20
> On the next resume check_ref_exists() would skip already dropped blocks,=
=20
> but if they were freed by COW from the sharing snapshot,=20
> btrfs_lookup_extent_info() returns refs 0 and do_walk_down() returns -=
=20
> EUCLEAN first.
>=20
> Reproducer (btrfs-drop-resume-repro.sh attached, self-contained, two=20
> loop images): mkfs.btrfs -n 4096; receive a large (~1.5M files)=20
> subvolume; snapshot it rw; delete the received subvolume; umount mount -=
=20
> o commit=3D1; sleep 3; umount # drop runs, progress saved (level 3) moun=
t;=20
> umount # resume interrupted -> drop_progress 0 on disk mount; touch many=
=20
> files in the snapshot; umount mount # "bytenr X has 0 references, expect=
=20
>  > 0", abort -117 Results: 7.2.13-200.fc44 (untainted, QEMU): 3/3=20
> drop_progress reset to 0, 0/3 aborts same, target behind dm-delay 1 ms:=
=20
> 2/2 drop_progress reset to 0, 2/2 aborts 6.19.10-300.fc44 (SATA SSD, no=
=20
> delay): reset + abort in the first iteration same sequence, fixed=20
> module: 4/4 clean, progress kept, drop completes Debian 6.12.100 in QEMU=
=20
> (throttled disk): stock aborts, fixed build 60 cycles clean The reset=20
> happens reliably; the abort additionally needs the COW in the snapshot=
=20
> to free the already dropped nodes before the resumed drop skips past=20
> them, so slow storage makes it likely.
>=20
> Splat (7.2.13, dm-delay run, trimmed): WARNING: fs/btrfs/extent-=20
> tree.c:223 at btrfs_lookup_extent_info+0x505/0x530, CPU#6: btrfs-=20
> cleaner/100182 CPU: 6 UID: 0 PID: 100182 Comm: btrfs-cleaner Not tainted=
=20
> 7.2.13-200.fc44.x86_64 #1 PREEMPT(lazy) Call Trace:=20
> do_walk_down+0x182/0x7d0 walk_down_tree+0xc5/0x170=20
> btrfs_drop_snapshot+0x24d/0xdc0=20
> btrfs_clean_one_deleted_snapshot+0xce/0x160 cleaner_kthread+0x91/0x1b0=
=20
> kthread+0xe4/0x120 ret_from_fork+0x1a1/0x270 ret_from_fork_asm+0x1a/0x30=
=20
> BTRFS error (device dm-0): bytenr 2293555200 has 0 references, expect >=
=20
> 0 WARNING: fs/btrfs/extent-tree.c:6385 at=20
> btrfs_drop_snapshot+0x760/0xdc0, CPU#6: btrfs-cleaner/100182 BTRFS error=
=20
> (device dm-0 state A): Transaction 25 aborted (error -117) BTRFS: error=
=20
> (device dm-0 state A) in btrfs_drop_snapshot:6385: errno=3D-117 Filesyst=
em=20
> corrupted BTRFS info (device dm-0 state EA): forced readonly
>=20
> Field validation: a vendor recovery image (Debian 6.12.100) with only=20
> btrfs.ko rebuilt with the fix below was used for a real bare-metal=20
> restore of the affected machine (~500 GB, same sequence, 6 mount/umount=
=20
> cycles at the end). drop_progress stayed at (387120 INODE_ITEM 0) level=
=20
> 2 across those remounts, btrfs check was clean, the drop completed and=
=20
> the system boots. With the stock module the same restore procedure=20
> corrupted the filesystem twice.
>=20
> Proposed fix (tested as above; also attached as btrfs-seed-drop-=20
> progress-on-resume.patch, made against 6.19, code identical in master):
>=20
> --- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@=20
> btrfs_drop_snapshot btrfs_disk_key_to_cpu(&key, &root_item-=20
>  >drop_progress); memcpy(&wc->update_progress, &key, sizeof(wc-=20
>  >update_progress));
>=20
>  =C2=A0 memcpy(&wc->drop_progress, &key, sizeof(wc->drop_progress));
>=20
>  =C2=A0 wc->drop_level =3D btrfs_root_drop_level(root_item);
>=20
> A sanitized btrfs-image (-w -s) of the affected filesystem is available.
>=20
> Claude created the fix and did the testing.
>=20
> Best Regards,
> Markus Kern

