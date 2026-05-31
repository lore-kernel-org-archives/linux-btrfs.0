Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01323A1CD
	for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 00:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780187878; cv=none; b=sFSr58yPQogtnrKJnJ70GI9FTvAJohO/ADqWdRy4dEU+mMCSAs9Kl0bNZAMUWtUQ51ymW9DmK49+YBq7uMDZPGHuFa31zDVWG/2bueEa6mrp7AQ1FcLMF8hBJLn/AAWqPtz/5+4Jp1M2l+vGhgWM9zzHUDqSBjtXMGgMzeVnays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780187878; c=relaxed/simple;
	bh=yLHRX9LzNnvoTmlUCtz9ug1I8ssQzktWpwLvb7e5QOM=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=cF9699w+aw8dpnuEF1uGJNA5pI+MfEqnZQWmHV8f6yqwMQ0pDju1uMtoGwmmp0L6kxOjnlY9tMuq/Y30GzdXk6WFJyt1Lggm+DXsmXMT9pIXYlRcGv6VsTlEUPAvz7u7RrVsOc/6fqQkPjwzaUiEb8xPBSZ86OFAiJKxjjkji94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=Hk4MUqmk; arc=none smtp.client-ip=81.19.149.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="Hk4MUqmk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=Message-Id:In-Reply-To:To:References:Date:Subject
	:Mime-Version:Content-Type:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LS/hc5x7ijfobRtVOmBZXH3i4Si2cPEKtwhOc+RgmoU=; b=Hk4MUqmkOuOmPEaWeH24DVXfMt
	Cld8z6/EGB2egiEXpTlqTANuibEgovAxtSWxmn82D9Kb3WrHMJ+pS/17n5hOLQWInM08CH7NojzOP
	Sf617q7mnz3DQj3K/q91dzZhrOoYvyTYLhhqkTyhuP8iHsP117hjDYZLL0XD4rTaHXrhdnYrIF009
	BorUR1rKrZ3HaOEhLm3/lleYT18mYXKpUiPIiC0pBe4KxJ3iLwkkvFFeqC2ITeM5n87EpOChKhGYc
	XkrZtNPtx/Y2/Lr/z4k1sSCU60ISUGI8qcnuH+++Qs/o6yYNx/AW86o5Wb24INdtTAKg0WO9OrEzz
	J09nZr+Q==;
Received: from [41.66.99.8] (helo=smtpclient.apple)
	by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wTTo9-000000007U1-1oIc
	for linux-btrfs@vger.kernel.org;
	Sun, 31 May 2026 02:13:37 +0200
From: Michael Zacherl <ubu@bluemole.com>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_4C9D3A23-7B23-46AF-9B18-F6FEAC4A8A73"
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.10\))
Subject: Re: scrub error & discrepancy
Date: Sun, 31 May 2026 02:13:26 +0200
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
Message-Id: <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes


--Apple-Mail=_4C9D3A23-7B23-46AF-9B18-F6FEAC4A8A73
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 30.05.2026, at 23:23, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
> Even with "ro,rescue=3Didatacsums" you still can not read that file?
> That file should be a human readable text configure file for =
getaddrinfo.

far from that. ( I=E2=80=99ve yet to re-check my rsync parameters =
because the original is not on the most recent backup. :/ )
however, an older backup shows me 65 lines of comments embedding =
(deactivated) network parameters which suggests the system relies on the =
default configuration.

> If you have not yet deleted that file, mind to take a copy of that =
file with "ro,rescue=3Didatacsums"?
> I'm interested in how the corruption looks like, normally it shouldn't =
be modified unless it's updated by the package manager.

PLS:=20=

--Apple-Mail=_4C9D3A23-7B23-46AF-9B18-F6FEAC4A8A73
Content-Disposition: attachment;
	filename=gai.conf.gz
Content-Type: application/x-gzip;
	x-unix-mode=0644;
	name="gai.conf.gz"
Content-Transfer-Encoding: base64

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
--Apple-Mail=_4C9D3A23-7B23-46AF-9B18-F6FEAC4A8A73
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



>> Is there a correlation to the scrub error?
>=20
> You can always use "btrfs logical-resolve -o 20316160 <mnt>" to =
resolve the logical bytenr to a file path, to confirm if that's the =
culprit.

I did =20
$ sudo btrfs inspect-internal logical-resolve -o 20316160 /mnt =20
which returned
ERROR: logical ino ioctl: No such file or directory

Is this related to https://github.com/kdave/btrfs-progs/issues/724 ?

Trying to read the file when rw-mounted throws an error stating the =
inode. Obviously this is easy to correlate:

May 30 23:46:38 EndeavourOS kernel: BTRFS warning (device dm-0): csum =
failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum =
0x70e27ee0 mirr
or 1
May 30 23:46:38 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5331, gen 0
May 30 23:46:38 EndeavourOS kernel: BTRFS warning (device dm-0): csum =
failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum =
0x70e27ee0 mirr
or 1
May 30 23:46:38 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5332, gen 0

Thanks, Michael.


--Apple-Mail=_4C9D3A23-7B23-46AF-9B18-F6FEAC4A8A73--
