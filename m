Received: from mx02lb.world4you.com (mx02lb.world4you.com [81.19.149.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EFD33FE26
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157245; cv=none; b=PAxQ3T36hJ/nnmKGJBylt9s690WKv8dHXPeBa1TaVamAR1sBNslHCw2LAp+jFUVt1S7IfFUBhilx81t0pnsA3FNNtLEvbpSeTzBSrZQptGiskhMlSlZY2XYR/OQ3XFmO1EbdDbDJ57hEKXXDt3y4/LDBJ0cch+hWtITAl9eY0xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157245; c=relaxed/simple;
	bh=Hjrya1jxqmPrIS9ZAsuENNYDcIaKrbiDmGMYuARLXvk=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=IxbVuReP8Gyo8gFX+HcYvfHd2jwZuJwRev9vCA9421gRdRtVEvENH1H98vo9ck+8DZSa0FBAfwUu9PW2k/TuN3IOIJwod6uV4wvWz3KjzBOJcpMD1OgrlzieAe/iA7NbQI4C4WVQ69D6M6A3Ysg9oAc9B2f2gHxzTPg30gfg7bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=qAUIdQaS; arc=none smtp.client-ip=81.19.149.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="qAUIdQaS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=Message-Id:In-Reply-To:To:References:Date:Subject
	:Mime-Version:Content-Transfer-Encoding:Content-Type:From:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xdpY6AyibNQFAA2jgve5DGZ0sbzM6yE6nfXxhvAo8Wc=; b=qAUIdQaSB9zdxs27V9rI1mPr1F
	z/jNZ1sAji6DviZjF0Pw9bVsA1Qx1P9F3fdfe1Obz3YCu2fYvyraLpSomiW/hEYskdTAi6rI8F0lZ
	68CEm22cvraxjr54coim8fc1IEXZzMwqf3PoD0YbCeaeCCrKQ0KoTpzsPj8WtFPA7euZC2URmKM/A
	gxJIbE9pO4NHWRiDnYn2GmKa5AnVF9+sYDSk9veIgRDkTjXCmqlX2PqGWhoZNtUonhHXk3XK2cetD
	Duq81JP7Gp0blGKwec1+yQrmCr6zR5DJpUDl9TaRrQwOyZ4qloJ5ZLWVizkk4O8CxZ1tDypTjcY1u
	qdLNO45w==;
Received: from [41.66.99.8] (helo=smtpclient.apple)
	by mx02lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wTLVX-000000003vk-37uS
	for linux-btrfs@vger.kernel.org;
	Sat, 30 May 2026 17:21:52 +0200
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
Date: Sat, 30 May 2026 17:21:41 +0200
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
Message-Id: <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes

Thank you very much for your super-swift response and action!

I safely could remove two files which indeed decreased the error count.
However, there=E2=80=99s still one uncorrectable error left which I =
don=E2=80=99t know how to tackle.

Scrub=E2=80=99s output:

$ sudo btrfs scrub start -B /mnt
Starting scrub on devid 1
scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
Scrub started:    Sat May 30 12:42:56 2026
Status:           finished
Duration:         0:10:29
Total to scrub:   912.31GiB
Rate:             1.45GiB/s
Error summary:    csum=3D1
  Corrected:      0
  Uncorrectable:  1
  Unverified:     0
ERROR: there are 1 uncorrectable errors

Associated log output:

May 30 12:42:56 EndeavourOS kernel: BTRFS info (device dm-0): scrub: =
started on devid 1
May 30 12:42:56 EndeavourOS kernel: BTRFS error (device dm-0): scrub: =
unable to fixup (regular) error at logical 20316160 on dev =
/dev/mapper/cryptroot
 physical 20316160
May 30 12:42:56 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5327, gen 0
=E2=80=A6
May 30 12:53:25 EndeavourOS kernel: BTRFS info (device dm-0): scrub: =
finished on devid 1 with status: 0

Also, since the fs is not live I na=C3=AFvely ran a  cat file >/dev/null =
over all sub-volumes and a third file (/etc/gai.conf) threw an =
Input/Output error.
This seems to correlate with another log entry (inode matches):

May 30 15:10:04 EndeavourOS kernel: BTRFS warning (device dm-0): csum =
failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum =
0x70e27ee0 mirr
or 1
May 30 15:10:04 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5328, gen 0

This file is completely unreadable.
Is there a correlation to the scrub error?

Thanks again, Michael.

> On 30.05.2026, at 03:03, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
> =E5=9C=A8 2026/5/30 09:49, Michael Zacherl =E5=86=99=E9=81=93:
>> Hello, I did a routine scrub on the offline root fs of a notebook =
(EndeavourOS, Arch based).
>> This is the output:
>> $ sudo btrfs scrub start -B /mnt
>> Starting scrub on devid 1
>> scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
>> Scrub started:    Fri May 29 23:54:53 2026
>> Status:           finished
>> Duration:         0:10:23
>> Total to scrub:   911.45GiB
>> Rate:             1.46GiB/s
>> Error summary:    csum=3D18
>>   Corrected:      0
>>   Uncorrectable:  18
>>   Unverified:     0
>> ERROR: there are 1 uncorrectable errors
>> Last line vs. "Uncorrectable:  18=E2=80=9D ..
>=20
> Indeed it's confusing. Will update the message.
>=20
> In fact the "1" is only accounting for how many device(s) have =
uncorrectable errors.
>=20
> So the more correct one should be "there are 1 device(s) with =
uncorrectable errors".
>=20
>> How would I deal with that?
>=20
> Check the dmesg, it should contain the file path of the bad blocks =
where it belongs to.
>=20
> And if that file is not important, you can just delete it.
>=20
> If it's important, you can verify how bad the damage is, by going
> "ro,rescue=3Didatacsums" and read out the affected file, manually =
check
> how damaged they are.
>=20
> Thanks,
> Qu


