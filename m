Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427224;
	b=aq26LWB0W6cVYI9ppqH6V7ulqZxTCiL7rlbp0uocvh4IGb21mRWFIn49glPeLA2C67eh
	 zbw6J+14XbXM+qcFL34oS949DULEm75IAr7VItzvY3xCIxj6F5ytNeyE/Bg/dvq1OoCXQ
	 E7ykfXKTDff04m4Xu0zFdgWPs9So2AaaNu8+awkj0721Prfp9v1I1u1zyLWCaM2htBO0O
	 xBMyxNrxZ5s4eOfnWyHLPG5fIYkv/0dPFamTqkuTJOh0obZj25irF5xkFhXcQJwgQXgW+
	 ORwcyxGtGv2Z3ewv2XLnFzr8F1GL7bdxPR97Fe5o/zBJuZ1FVXARG3tse4U7qvnIj2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Message-ID:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Correlation-ID;
	bh=QKKddyB/3LPaj9XpOHrjBXWO+kDb0/gFR60jM/AbPd4=;
	b=4oBDdNATvsJbWiVxN1lw+ByR9fX6guT71mXFIHpmQmPs0cOMFOXmQ+S5nvcrZ/JP7ANC
	 wcJ2Qjdrxjm/vWmWquLxcCMntKK3/BKREjSRM2I7WWOGd3kXpP0BD2VK7677M0VD8B0w/
	 1ZrMgNWiEZapG6QpqaFqhB2rCYkk8PPJ3Wd85FA6hHBmEkY/SU4gljqb1/Qu0R9o66fK4
	 Yzga4xZfH1DPc3LhLic8miGlVS7w/K+6dCWVRH0dj+CHpxXI5VJynRacGgbecxRQl8VTE
	 nriCPXpRTexjXXGEYidQWbBrzhl0XIQWVYjl4JFgYPsvMy5mXju8ulDzeNuhrGzEa1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdCvjcAk;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DF9606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 09:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1DF9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdCvjcAk
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a32576da88so1733575f8f.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 01:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795427222; x=1796032022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:cc:to:from:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QKKddyB/3LPaj9XpOHrjBXWO+kDb0/gFR60jM/AbPd4=;
        b=pdCvjcAkJ2E00UCwpa7+LPm7mJhdFhZv0YY1gUModOPz523F3Vz15xzSVhB6smm2zp
         APO084YMVolenYo2pepPeuVT7pEXr0D46nG2JZVQpPSxR7XW8Jkkiz4oxKQxwMvQ7vG0
         kKYdjMey45l2eFoUsSLkYm4yVXM++IWycnif+CUXsZDs6ZdcothzqTEoYggTa65h636J
         pajzxIsehl/AtEuwdzBEFdAZJhyt9b1FH4BgVNdfZwOHROJ8hTAg7DXIsFe2u2Xj7g/U
         t2TR8N3DBMyfvDekGUHDBoEutbc++8v8EKbQpXxCZwnY2qc9+bd3VMuBH0lsM/A0q7yc
         BAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795427222; x=1796032022;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QKKddyB/3LPaj9XpOHrjBXWO+kDb0/gFR60jM/AbPd4=;
        b=0dy9uvTr4CdWiLxDbZXRjr87XdZ6fQmbG4ULI9yn6uXGgWKI09hsAucD+D0k1vfElR
         65Mv2MC/fXSF7T2qzkMbEzxeg9Mxwrhb1nPPHrpYzvwfxKB0LCJLQknX7sYAkZNZmSlF
         +AmuhXqbIzFmcDwrKBmI5nMGy6OTt2rBocb3BmPK6iMqe+nXj17Pux7a4G/elEF5+pBG
         a/bjJyNkOEcvIB/LoKYSETonYcrb5Gwm4kx0JEDizzvNAgx1zZSas1a2hsGnzHrqxAaA
         0wyVHgAUsfaCX69ghaRIqWW327ZuuwrbBWPTmPT937D7ZwIiPMX2w2Z30MWxlc7CzRii
         msJQ==
X-Gm-Message-State: APuU4Z8SNOuUfUVITjMNr2vjJU7MUIp7GY1hmUCYKaqjTSZBG97+s2/c
	060OgOUj8wXYcgtwO07SozOjtJ5lX6/xyjql05SlEmbq6/dS4EakmSi0UHkLiecP
X-Gm-Gg: AZFdTZd5WjKwdx2xr4TIdRNZTjQtVPMwujBsQmL3DN+/O6A/ySGueiOnO0rxewpUn0Z
	tFf7VpGJr0wyfIFNcTlGZ4wBhEeAgphHQPCib3iNs1mUc8AJQKhrEIh/v/lZE8Z70wwDOrsnGom
	vZTPq7R/hh3/1X2DHtFMN2OuOT/meEnI+R1V2q+6NRs1C36P+3z6j80doi4eDR7ZMHgIZrro5Ca
	TLfWEJjsDteBlRtG6uxvi+UfKXwVjV3F8eylYAncHwTyMgWy2HzR5sjOdk/CHY5O/L8xiTsSmj1
	0ku0BVmPykVyo0krz5UNfkfhPntXmNwjoIHCon3C39wP4J2fbD1h37XpM63U+sYlGahIkoCTRdK
	1ucdEd6ytoel9s7PdH4/ryC0l0ROI5Qr1GaG7tCxHiNKpiJmZIC6RgQ2cjuIwGJPPl7mDS/nzuS
	Jc2FJ8RHLyRJaKpVZ/DhZb9dvOQK9+Z6ZjZe4KQnBvuCIewoe32z9P0IcA1/smLME48cOrT2xIj
	DF2CF+kyI3tJjez2R+03KMsNJ13QPPCFGg4RZDvX6MuzWcvRh3YUMN5mQQs/Col+nzDJpQoJXrV
	Gis/wLQEf49bxiOYDd8kgRz4tRX8pR55tWP6jNLMEq9Wg17e0Q==
X-Received: by 2002:a05:6000:29c6:b0:4a9:b2f1:aac4 with SMTP id ffacd0b85a97d-4abb42ea141mr14220172f8f.22.1795427221995;
        Mon, 23 Nov 2026 01:47:01 -0800 (PST)
Received: from [127.0.0.1] ([187.40.49.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a68048esm21834603f8f.29.2026.11.23.01.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 01:47:01 -0800 (PST)
Date: Mon, 23 Nov 2026 10:46:58 +0100
From: Marcus Lell <marcus.lell@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: regressions@lists.linux.dev
Message-ID: <b8b122c5-87c7-4363-b3cc-c91d24ff4d2d@gmail.com>
Subject: btrfs corruption across different storage configurations. Both with
 free addressable free storage.
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <b8b122c5-87c7-4363-b3cc-c91d24ff4d2d@gmail.com>

[please CC me, as I'm off list]

I know it's a late report, but I thought, you may know about this one...

I experienced severe Btrfs corruption twice, on Linux 7.1.10 and 7.1.12, us=
ing substantially different storage configurations.

Incident 1 =E2=80=94 Linux 7.1.10

I was running Btrfs on LUKS/dm-crypt over md RAID5, using four SATA devices=
 with 64 KiB chunks. The incident occurred during or after a RAID5 reshape =
and enlargement of the encrypted device. After enlarging the crypt layer, I=
 tried mounting the filesystem, but "mount.btrfs" failed.

Subsequent diagnostics revealed metadata errors at offsets beyond Btrfs's r=
eported size:

"total_bytes =3D 20001389936640"

- Wanted bytenr "20015028908032", found "8567551700635656859"; checksum wan=
ted "0x836ea028", found "0x8db80d65".
- Wanted bytenr "20024023199744", found "12778909791338521120"; checksum wa=
nted "0xfd168e20", found "0x95744024".

These offsets were approximately 13.65 GB and 22.64 GB beyond the reported =
filesystem size, but within the underlying device's addressable capacity.

I did not touch the underlying filesystem during the enlargement. Just at t=
he end. I was surprised, that an untouched filesystem could go so messed up=
. I thought, it could be an mdadm grow failure.

I made extensive attempts to diagnose and recover the filesystem. I tried s=
uperblock recovery, "btrfs check --repair", "btrfs restore", "btrfs-find-ro=
ot", mounting with recovery options, and "dmsetup"-based approaches. I also=
 used a device-mapper snapshot to rule out concurrent changes during checki=
ng. Despite these efforts, I could not restore a usable filesystem. "btrfs =
restore" recovered some files but reported checksum errors.

Incident 2 =E2=80=94 Linux 7.1.12

I was running Btrfs on an approximately 1 TB root logical volume on LVM, on=
 a single 2 TB NVMe device, without md RAID. The root filesystem became unu=
sable. I recall seeing what appeared to be the same kind of "bytenr" failur=
e, although I no longer have the logs to confirm the exact error. I had not=
 observed unusually large writes before the failure.

I lost the logs of the first attempt, that I saved on the root partition. I=
 was like to be afraid to cope with the responses of you. (I'm shy)

Because the second incident occurred on a substantially different storage c=
onfiguration, I find it less likely that the problem was specific to the RA=
ID reshape or crypt-layer resizing in the first incident.

I want you to help make the btrfs filesystem more error prone. But I can on=
ly point into the direction. I cannot prove that such a write occurred or t=
hat both incidents shared the same root cause, but I believe the recurrence=
 and the first incident's specific offsets warrant investigation.

I don't know, how to help further, but I don't dare to trust Linux 7.1.x an=
d successors, with 7.0.x I believe, this is the last stable one. I need to =
upgrade sooner or later, so please find the root cause of this behavior...

Marcus Lell


--=20
Return to the point of no return._

--=20
Return to the point of no return._
