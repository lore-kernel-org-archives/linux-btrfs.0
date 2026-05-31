Received: from mx10lb.world4you.com (mx10lb.world4you.com [81.19.149.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140832F6586
	for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 04:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780201702; cv=none; b=KLqG5VeAihIFCPadVYzhF+3yBJNY5EhDmvQLNctx5C9eqrWE8c2AgxAFsFi0g2504usNTVM4kEFmsprSVbntAyIsMVmWRtsFh5rlktVcL5DKkcWdGoR1XQ0vjBsHU3SBs93WG2hTyhTKlCTcgrGUfCrpGtygBtQ5/aolxepUZ2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780201702; c=relaxed/simple;
	bh=xuM/LNslGT2EyOL7zJYk+UjkjnxRIJkHCn94CnWL8WQ=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=UzHYKbsxhQUTPC6lfHm6NLrYHLOyW1LNVe1g/WVd6dZgfhVYAjMVEJDreQs69XpQxPXJKEXqxt2ET2U6Ovj32VCJhO2RhH7aqOI/h59alfq0Ynhwd22WB7PY0u0DJR1suQ4Ubj8xVw9Ih++CQIBen7xWbhXAtqvOXG7pE+QnUlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=iZeOZH3p; arc=none smtp.client-ip=81.19.149.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="iZeOZH3p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=Message-Id:In-Reply-To:To:References:Date:Subject
	:Mime-Version:Content-Transfer-Encoding:Content-Type:From:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xuM/LNslGT2EyOL7zJYk+UjkjnxRIJkHCn94CnWL8WQ=; b=iZeOZH3p+xQ7kMv7rkVib1fYCK
	aLdY9dOlb6PyAAVN8v7GGgTak3Oa+9hBr6q4L4Gwa3VPm2DKmCdtK1tIEXGinIX+TSTZHfba0aVKm
	8dfnHYrVxsfCB62e2XxckZ6Kve4D4LaPH3KrnkdGc0S0jrBGRq4rl6TXuH7PYNkfp5i8s2J6qCvX4
	ms2qli26zQRaVkg09Gwd4rZ65Iz0GkYYlPcW4ubym6REsksMsT/tKWLL0kesXDenF5EV8VG81Xcce
	lAp/M+jEypwaH436JYUNSsInAmzzWjVRlTHZqD735+wsKVFIb94P2N9sgF+FK1bYdcQNlYKx/+ju1
	up44GLkw==;
Received: from [41.66.99.8] (helo=smtpclient.apple)
	by mx10lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wTXJ2-000000004Rz-2ZB8
	for linux-btrfs@vger.kernel.org;
	Sun, 31 May 2026 05:57:45 +0200
From: Michael Zacherl <ubu@bluemole.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.10\))
Subject: Re: scrub error & discrepancy
Date: Sun, 31 May 2026 05:57:33 +0200
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
Message-Id: <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes


> On 31.05.2026, at 04:10, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
> Indeed looks like some random binary data, but at the end there are a =
lot of padding zeros.
> This looks like some kind of compressed data.
> Does the fs has compression enabled?

no, but it sits on a LUKS partition:
/dev/mapper/cryptroot on /mnt type btrfs =
(rw,relatime,ssd,space_cache=3Dv2,subvolid=3D5,subvol=3D/)

But this should be entirely transparent.

>> $ sudo btrfs inspect-internal logical-resolve -o 20316160 /mnt
>> which returned
>> ERROR: logical ino ioctl: No such file or directory
>> Is this related to https://github.com/kdave/btrfs-progs/issues/724 ?
>> Trying to read the file when rw-mounted throws an error stating the =
inode. Obviously this is easy to correlate:
>> May 30 23:46:38 EndeavourOS kernel: BTRFS warning (device dm-0): csum =
failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum =
0x70e27ee0 mirror 1
>=20
> It looks like the backref walk is not doing its work, thus neither =
scrub nor logical-resolve works.
>=20
> Despite the csum mismatch, have you tried "btrfs check" on the fs?
>=20
> I think it will report some metadata problems.

yes, it did:

$ sudo btrfs check /dev/mapper/cryptroot
Opening filesystem to check...
Checking filesystem on /dev/mapper/cryptroot
UUID: 44cb181f-faf6-48c2-a462-904cfe493576
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
[4/8] checking free space tree
Space key logical 1048576 length 4194304 has no corresponding block =
group
Space key logical 5242880 length 8388608 has no corresponding block =
group
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
found 976759910400 bytes used, error(s) found
total csum bytes: 929500256
total tree bytes: 2828288000
total fs tree bytes: 1379106816
total extent tree bytes: 309182464
btree space waste bytes: 468318874
file data blocks allocated: 2798421090304
 referenced 1533778432000

Thank you, Michael.=
