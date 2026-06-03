Received: from mx15lb.world4you.com (mx15lb.world4you.com [81.19.149.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FCB17993
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 00:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445318; cv=none; b=RsLFPQvEKpcb7Pi7rJeMDWcRLE2dGrdrXw+eaD9X22f8AUI9QnquvgZuC2/c6oq+o6HH1UMZAVx5xsP/CxNbmp0ai/HwJg80C5q8FqWi/EN5aw29KfaQYw3CmBlmWjgOcRx4VlqiH2soJJ2H2ofKe37W/NeJRkJsNB6+Vo5C4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445318; c=relaxed/simple;
	bh=x1WGq7kmm+Ictw9blMoguCr4+CnHSwQfEeHNcKKdG1g=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=nSP3qcuT+feoSS+vIC/1fyW//3w/6I0u7fAlrKBrWj2JzVWNBMEssUz5OeTs7+YfaiQrZb8a9McjuFsJL3JztKU+4FiBCndw9KzkUKij5yjT1U2SNRrryMtQ5Gnu+H0ACMvU5bj2VP3tV9/HcIV/9f2NGoKJydzuEPfWuPCsgkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=knheOe9A; arc=none smtp.client-ip=81.19.149.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="knheOe9A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=Message-Id:In-Reply-To:To:References:Date:Subject
	:Mime-Version:Content-Transfer-Encoding:Content-Type:From:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TCi6OoIo+fz4PddOt9cbcwpB2ZfhE+isY/0pjI1qUms=; b=knheOe9Al1W/0szfUJkCDFi8Ip
	e7qKVm3sYpL6UCN5ynknW0SBHcjKhZTElbnePwDoH3XLDIrbnPOm6XUkVLfdSIRCb2eUGI34iu0WO
	LC/jGOWPL34wYMTEOXJYZ3QmyGg0px+KSXh+UfdxE+lB4O8JB66seZze5iTC/6jSCEWaR5t0HCGZT
	u7J6VdpZFVsQIoNw5kCBH2f8IMjjxQDa+a9jqQF0W9tmDeoaSHj1NBV+YPX6U2pUHzDVk8yvztFX5
	grxdIUZjJIrmFC2INv6ULPg5gLvKLhICMkXQUXh5dyi5t9E9dSt/Up0gbEeQNfpvLlIwcpOQNk3ZF
	TJjVQD7Q==;
Received: from [41.66.99.238] (helo=smtpclient.apple)
	by mx15lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wUZ9m-00000000054-0jc2
	for linux-btrfs@vger.kernel.org;
	Wed, 03 Jun 2026 02:08:26 +0200
From: Michael Zacherl <ubu@bluemole.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.10\))
Subject: Re: scrub error & discrepancy
Date: Wed, 3 Jun 2026 02:08:15 +0200
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
 <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
 <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
 <F68EA392-6360-4899-AF7E-3AD00B994FDC@bluemole.com>
 <abdefca9-5e72-4f63-bc7d-958b9ec50468@gmx.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <abdefca9-5e72-4f63-bc7d-958b9ec50468@gmx.com>
Message-Id: <F839ACDA-E61B-4E38-8188-9D431C3D669E@bluemole.com>
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes

On 01.06.2026, at 00:48, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
> In theory, as long as the ssd/firmware/controller properly respect =
FUA/FLUSH commands, it should not cause any corruption.
> But we live in the real world, sometimes bugs can sneak in between =
(and include) btrfs and lower storage stack.

I read multiple statements claiming =E2=80=98some=E2=80=99 nvme units =
have a =E2=80=98weak=E2=80=99 power management consequently causing =
problems.
Since this is the only mobile unit with an exchangeable mass storage =
device I can=E2=80=99t really speak of experience.=20


I switched back to using the laptop, renamed /etc/gai.conf to keep the =
broken file and reinstalled glibc.
Later I initiated a scrub:

$ sudo btrfs scrub start -B /  =20
Starting scrub on devid 1
scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
Scrub started:    Tue Jun  2 11:42:55 2026
Status:           finished
Duration:         0:20:44
Total to scrub:   891.70GiB
Rate:             734.01MiB/s
Error summary:    csum=3D1
  Corrected:      0
  Uncorrectable:  1
  Unverified:     0
ERROR: there are 1 uncorrectable errors

Before, while being booted from the live-iso the other day, there was =
this one unresolvable logical 20316160.

[35844.925130] BTRFS info (device dm-0): scrub: started on devid 1
[35844.970219] BTRFS error (device dm-0): scrub: unable to fixup =
(regular) error at logical 20316160 on dev /dev/mapper/lukspart physical =
20316160
[35844.973565] BTRFS warning (device dm-0): scrub: checksum error at =
logical 20316160 on dev /dev/mapper/lukspart, physical 20316160 root 256 =
inode 20372640 offset 0 length 4096 links 1 (path: =
usr/include/clang/AST/ExternalASTMerger.h)
[35844.973606] BTRFS error (device dm-0): bdev /dev/mapper/lukspart =
errs: wr 0, rd 0, flush 0, corrupt 5342, gen 0
[35884.964320] BTRFS warning (device dm-0): scrub: skipping scrub of =
block group 26873954304 due to active swapfile
< .. snip .. >
[35884.964461] BTRFS warning (device dm-0): scrub: skipping scrub of =
block group 48348790784 due to active swapfile
[37088.403196] BTRFS info (device dm-0): scrub: finished on devid 1 with =
status: 0

Despite it being shown in the log anyway, I tried and I now could =
perform a=20
$ sudo btrfs inspect-internal logical-resolve -o 20316160 /
which revealed the file as=20
//usr/include/clang/AST/ExternalASTMerger.h

This didn=E2=80=99t work when the system was booted from the iso:

> On 31.05.2026, at 02:13, Michael Zacherl <ubu@bluemole.com> wrote:
>=20
> I did =20
> $ sudo btrfs inspect-internal logical-resolve -o 20316160 /mnt =20
> which returned
> ERROR: logical ino ioctl: No such file or directory


I was getting I/O errors when doing a cat on this file and I can=E2=80=99t=
 see while my na=C3=AFve search using cat didn=E2=80=99t reveal this =
corrupt file the other day?

Also, the broken gai.conf file still doesn=E2=80=99t show up in the =
scrub log. Not sure if it should?

So back to square one and testing from the live-iso, rw-mounted the fs =
on /mnt .

A scrub shows the same error and the filename but the file checks out =
fine!
I now can view it (cat) without errors!   What=E2=80=99s going on?

A new scrub didn=E2=80=99t show anything different than being booted =
from this fs before:

Jun 02 13:38:07 EndeavourOS kernel: BTRFS info (device dm-0): scrub: =
started on devid 1
Jun 02 13:38:07 EndeavourOS kernel: BTRFS error (device dm-0): scrub: =
unable to fixup (regular) error at logical 20316160 on dev =
/dev/mapper/cryptroot physical 20316160
Jun 02 13:38:07 EndeavourOS kernel: BTRFS warning (device dm-0): scrub: =
checksum error at logical 20316160 on dev /dev/mapper/cryptroot, =
physical 20316160 root 256 inode 20372640 offset 0 length 4096 links 1 =
(path: usr/include/clang/AST/ExternalASTMerger.h)
Jun 02 13:38:07 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5345, gen 0
Jun 02 13:48:41 EndeavourOS kernel: BTRFS info (device dm-0): scrub: =
finished on devid 1 with status: 0
Jun 02 13:50:06 EndeavourOS kernel: BTRFS warning (device dm-0): csum =
failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum =
0x70e27ee0 mirror 1
Jun 02 13:50:06 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5346, gen 0
Jun 02 13:50:06 EndeavourOS kernel: BTRFS warning (device dm-0): csum =
failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum =
0x70e27ee0 mirror 1
Jun 02 13:50:06 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5347, gen 0

Curiously enough after being back, booted from this fs, the =
ExternalASTMerger.h file looked fine! No more I/O error!

I can=E2=80=99t see any difference other than Kernel versions?
Then again on the iso the kernel is newer (6.19.14-arch1-1) than the its =
I=E2=80=99m running usually (6.19.14-arch1-1), so what gives?

Meanwhile I=E2=80=99m not sure if I=E2=80=99m reading too much into this =
details?

Thanks a lot, Michael.




