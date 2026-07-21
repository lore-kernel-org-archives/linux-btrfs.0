Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649744470F;
	Tue, 21 Jul 2026 21:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668082; cv=none; b=VZEDBKbFnr13eyXrKqWZgEIXw7R0RjZA2th94bHYA09qn4WfZ6Xtr2sXS30v3J1BR8kLgkwOeQnhGrn6VVOen33tF+Ff4o4BM0zHw5OG374LnVvoVahupJ30u0W/MgWr+ouJjHzWmK21i4gUlYKJyfqIhQUevMZN62FzoBYgyzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668082; c=relaxed/simple;
	bh=YfOj5s9TLe15ZHf3C7YOuLLdeE6lhs/Gtx2Xan4pcV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fuU2Bf0hes32aVLEtvWf3WZRQOqLNkBlilTf0TA5wtYpsLAjd4yzuQwmV0/V8AH9oIA70dH1DlfD9R+MBmkkaa6Pi59UfGVjc3/Nja+oc7RsZg00alym28u2YNK1ohRGPzW1u5MaZlIXaeXJHTDE/GYpxLmOBBbjy3suXfMax+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cUA+e8JL; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cUA+e8JL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784668075; x=1785272875; i=quwenruo.btrfs@gmx.com;
	bh=HgCSK4SqpZnyCQaaNmGNYLnQ+U5ZOLqV8KlQhI56Bxk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cUA+e8JLWhfNmreDkLDqYXf4lL+LyUqOnF9ZMDct1jr9aKq1NRRc8lwR6cfetbzq
	 w3mY58iLS4/VZhodntWNCwqxYWL9RAC7hvBYZYgRRbLNF4WaP/v0ebEAxmWz4oh7R
	 NXQ4m5s07yBiCa0BbHgWPAUqu1aMQ8JmD5wd7T5VuDpUcGDLssejJfI6fcdtSmbi5
	 RycTRJjrTTdZlOCH0XEDQZ27N2l6rk+yicXwiVvpPnXQx5rjv1MF/bZ4qcFQqT/mQ
	 VwwcBkJUyeHfZlb0GVof/jPIOsHuB0PmGI/6925SLtWnnXO5ypSs7Yk0qDAmP8uLU
	 D07hstW+0Pw2N2p4Hg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MkHMP-1xRh2Z2SYD-00q91D; Tue, 21
 Jul 2026 23:07:55 +0200
Message-ID: <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
Date: Wed, 22 Jul 2026 06:37:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260721191152.101118-2-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CYjnRDhsnR6MLpfRqq6DscifsZQ4/ne16cQgR4wIHLd6xLGGB0m
 watArnBXvCqYRXI0PFVL0oxYkCmlaCxxs2QdDQN4QflKKi/tplv+9gEVaxsOKQh0/TVleH3
 F8Mr6l5UTiDa8wfqRy9aDZSDKCG9KKKP34iv6GxVJkfrSnZX6/FWfFFQxayXIQR9vmBVGCL
 NQmo/SPzCaL/674Vl6UQg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hN2nEhj9ATA=;Dhiz4ScuJpYpv7ZamU5WXhvwbWK
 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
 TUvY7N0oek3Zghfqg2fzzPPJ9LDKPkCmxpfEtY9



=E5=9C=A8 2026/7/22 04:41, Christian Borntraeger =E5=86=99=E9=81=93:
> A folio can carry the folio-level dirty flag while its btrfs subpage
> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
> so a generic folio_mark_dirty() call sets only the folio flag and the
> xarray tag, without setting any subpage dirty bit and without a
> delalloc reservation.  The typical source is set_page_dirty_lock() on
> a GUP pin,

Shouldn't such folio got its ->page_mkwrite() callback get called first?


> e.g. the s390 KVM irq adapter path
> (adapter_indicators_set()) which pins guest indicator pages living in
> a file-backed guest RAM file, sets a bit and marks the page dirty.

Thus I think this is a bigger problem for S390.

>=20
> When writeback then picks up such a folio, writepage_delalloc()
> copies the empty subpage dirty bitmap into
> bio_ctrl->submit_bitmap, sets up no range locks (nr_locked stays 0),
> finds no delalloc range, and finally hits
>=20
> 	if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
> 		wbc->nr_to_write -=3D delalloc_to_write;
> 		return 1;
> 	}
>=20
> which is meant for "all dirty ranges were submitted asynchronously,
> the async paths own the folio unlock".  But nothing was submitted at
> all, so extent_writepage() returns without anybody ever unlocking the
> folio.  The folio stays locked forever and every subsequent locker
> (page faults through btrfs_page_mkwrite(), other flushers, delalloc
> space reclaim which then parks holding fs_info->delalloc_root_mutex,
> syncfs, ...) blocks in D state.
>=20
> This was debugged from a crash dump of a hung s390 KVM host: a KVM
> guest with its RAM backed by a file on btrfs (zstd compression),
> where a 64-page (256K) large data folio of the guest RAM file was
> found locked and dirty, with an empty subpage dirty bitmap,
> nr_locked =3D=3D 0, no PG_writeback set and no outstanding block I/O,
> with two vCPU threads, the irqfd worker, two flusher workers,
> khugepaged and syncfs all queued behind it.
>=20
> Small folios are not affected because
> btrfs_copy_subpage_dirty_bitmap() unconditionally reports bit 0 set
> for single-block folios.

Unfortunately this means btrfs can get a dirty folio that is dirtied=20
without notifying the fs.

This will trigger a lot of other warnings, e.g. space reservation problems=
.

Furthermore, such dirtying folio without notifying the fs behavior can=20
also lead to problems in other fses.

IIRC ext4 will give warning for such cases too.

So I do not think this is the correct fix, but something went totally=20
wrong in the S390 GUP behavior that allows a fs folio to be marked dirty=
=20
without calling page_mkwrite().

Thanks,
Qu
