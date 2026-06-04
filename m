Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210CE1B4224
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780534621; cv=none; b=AuTQ0fJ2POhxVskCq3sBCh4AwTZ0P3TxASFtxoxORDYjJ7lLDh7XaSzfqeyCywjkdUOp+0ijINuqzNXM3RRu8w6bOb/WG/CCS23un+imIELJDF/eRMsOfJGIOIXZboed2QzmUZQKXurhTmiINnxrXm5CnLt/TQOEZQE3skV5tmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780534621; c=relaxed/simple;
	bh=S7Gvnxf+l0c5wgBkV8OqYjvzp8BDbE75Vqq6oSpu0kA=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=k74aloo4oiHsc+dkJlQ1HbbtdQKQnXZGTEltBfJn78Dk4pkdmWL81OSV0fWOo47THqmbD/SUErPykJi6FZIlpPIydcMIXhARfkHvFLk7UjIyMJ7ObdoAvvwtaSPn5MlUkecOIIYzCTHSC2zmqGu3jXg+Pr010HDMs0CdEe0+Iy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=BPy3pRxu; arc=none smtp.client-ip=81.19.149.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="BPy3pRxu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=Message-Id:In-Reply-To:To:References:Date:Subject
	:Mime-Version:Content-Transfer-Encoding:Content-Type:From:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mE26u6jUIzDAWvFJ51kD8MC3qS5zFAU99LQ25G7GvXc=; b=BPy3pRxu6weEP6VGm5+27xXC79
	TNXivaf3nqFRCO+YtrQsZDrprfXU4KXI6e9/4NtK3sZoGWT3j7RDJvT5oZ9/fLtl0lob/yS8pKRPC
	QY4zqYsIY8msMKjEltHnX7GDVgLOPfuMexSZFAwmgZwdgnGeDzFKtTe9BZbEbFugenDU5di9KUOmo
	p0vFW4Zm72k9eGuwsEBmZi+xNGP+2nCfyVGz4oSjFU+gLx1SvcQEiJ4VeUzw+TqaeMO0xXMwpHruT
	axpeN6yWv4A2Zn/Irv7hKm4fXQTY+AL7yYagfYc91uy30XOPL1IEUjzBHDD1cYDYpWAVXwUoL2Swo
	MKyPR+Dw==;
Received: from [41.66.99.238] (helo=smtpclient.apple)
	by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wUwOB-000000000Gh-3BQZ
	for linux-btrfs@vger.kernel.org;
	Thu, 04 Jun 2026 02:56:52 +0200
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
Date: Thu, 4 Jun 2026 02:56:40 +0200
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
 <F839ACDA-E61B-4E38-8188-9D431C3D669E@bluemole.com>
 <9bbb5862-1d6c-4980-8979-a4cf635bf642@gmx.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <9bbb5862-1d6c-4980-8979-a4cf635bf642@gmx.com>
Message-Id: <E3AB6B05-6029-4C8E-A2CA-E7CFAFF14D34@bluemole.com>
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes

On 31.05.2026, at 04:10, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
> Indeed looks like some random binary data, but at the end there are a =
lot of padding zeros.
> This looks like some kind of compressed data.
> Does the fs has compression enabled?

I=E2=80=99m sorry, I stand corrected: apparently I managed to look at =
the wrong spot and during a regular boot I now can see
/dev/mapper/lukspart on / type btrfs =
(rw,noatime,compress=3Dzstd:3,ssd,space_cache=3Dv2,autodefrag,subvolid=3D2=
56,subvol=3D/@)

So your assessment about the file fragment is correct!

> On 03.06.2026, at 05:19, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
>> [35884.964320] BTRFS warning (device dm-0): scrub: skipping scrub of =
block group 26873954304 due to active swapfile
>=20
> BTW, swapfile on btrfs is not really recommended.

I completely missed that! :/

> It causes quite some burden for things like balance, and scrub.
> It doesn't only mean the swapfile itself can not be balanced/scrubbed, =
but also anything else inside the same block group.

Understood. Would it be some mitigation if the swapfile is in a =
dedicated subvolume? Which it was until now.

BTW, from the mkswap man-page:  Since version 2.41, mkswap --file sets =
the nocow attribute for newly created files to support swapfiles on =
Btrfs.
I guess this wouldn=E2=80=99t help much on the bottom line.

> This means even a very small swapfile can prevents tons of block =
groups from being scrubbed/balanced, which are all very important for =
btrfs maintenance.

I moved it away. Thanks for pointing out!

>> I was getting I/O errors when doing a cat on this file and I can=E2=80=99=
t see while my na=C3=AFve search using cat didn=E2=80=99t reveal this =
corrupt file the other day?
>> Also, the broken gai.conf file still doesn=E2=80=99t show up in the =
scrub log. Not sure if it should?
>=20
> It should, but I guess there is some bug in backref code.
> Will take a look when there is spare time.

would be great, thanks! I=E2=80=99ll keep the broken file for the time =
being for later evaluation.

>> Jun 02 13:50:06 EndeavourOS kernel: BTRFS error (device dm-0): bdev =
/dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5347, gen 0
>> Curiously enough after being back, booted from this fs, the =
ExternalASTMerger.h file looked fine! No more I/O error!
>=20
> Maybe even LUKS is involved?

meaning a dm-crypt bug?

> Unfortunately with another layer involved, it's not any easier to pin =
down exactly the problem is.

Sure, but encryption is mandatory on this work-laptop.

> So for now, my only recommendations are:
> - Disable swapfile on btrfs

done.

> - Delete any files reported by scrub
>  And since most of them are managed by package manager, just
>  reinstalling the package should restore the file.

Q: besides scrub reporting these files, would keeping the one cause any =
problem?

> - Keep an eye on the routine scrub result
>  To see if the errors suddenly change.

Ok, thanks a lot for your time!
Michael.


