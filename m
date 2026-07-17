Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E61D2356D9
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 22:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784328316; cv=none; b=IbmNF51mT9oHEbejXAmvaYyAZuF+sTu8M1c9/jTU1zPlojuGuqWYt2yGfUJoRePO0iCmkejHo1pnDgXxF7YkscuUnii9HhFWB3Gmo698xNyK7z1qp/2Eus5M0GhoWWLZ7DFJEU66LAvvi3R/02/9Y3UgG6GaQjBQvJ34GbCloSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784328316; c=relaxed/simple;
	bh=9QdesDb9LQxX6hVrdErYMBEdfv/OnSfCzMQNVzeh0A0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k1AVdZM+5IX0vwvEe/XjEVlT/+g0FA4flz0TTTzUBlK/tcaftS3OBTBjD/ULUrGjncv80VZktIzTa12LrA1NF4YpRZZRcLtduJMt/INBBu/EHec47PqzzzThdmGq4KUVMI+/YQdtVzjm+7Dmu6rJumeyzXJTAfjpd3dgpLIxJkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=N6nmZ5ME; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="N6nmZ5ME"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784328312; x=1784933112; i=quwenruo.btrfs@gmx.com;
	bh=9QdesDb9LQxX6hVrdErYMBEdfv/OnSfCzMQNVzeh0A0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=N6nmZ5ME8MynOangSh/0WBHOgOY3J5ZXoeQ1BPwW3BrOyEUROmrROZSruzZhjTpA
	 uGpmctK0UTPEcGeIz18nEXI2+ns1GNNsTyuO1snghhJbBW+hqnO0BHl9YvOGrIe2b
	 51Zv3U3sIlkOuZhvzbJr6kWLJckwcvpSrFEN1YIS1y7rVRhdi2rpVr89oDgJJSJbK
	 /Mq4/0QjCBPhw0wDzv+sAEXQ4bJd1Skh20NySXC1G5lVL91HqPi4Ek0H1+CpabsKH
	 KooHK9EguooEdk7Wr0Wp4umsNPaDX8pwyzkGXPE68OF0VXn2VhNremVP3o9FfnY9R
	 0OvYWWDwbPrAgQaxNg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MxDp4-1wvmTY0ckS-013gid; Sat, 18
 Jul 2026 00:45:12 +0200
Message-ID: <52e5795e-dd45-4a35-b13f-a53513ae3e7f@gmx.com>
Date: Sat, 18 Jul 2026 08:15:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] btrfs: zoned: drop stale dirty btree buffers at
 close_ctree()
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
 <20260716115656.1319295-3-johannes.thumshirn@wdc.com>
 <062d26d5-c340-4e3b-bf56-a38d1f98a546@suse.com>
 <f19d3f3c-f36c-4fff-a6db-e4b640f6b8e5@wdc.com>
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
In-Reply-To: <f19d3f3c-f36c-4fff-a6db-e4b640f6b8e5@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3Q1V4Q6ET1Bxu4yovgaEiy7ca/ZTyFmWidMYktbtPJzWOkEpvvZ
 XGQL1uljTUktDJ/3lse/+8bdAr7TmVwbsoAsk+HEUfg3vR8bJnSNl6evg4iOMLMiSE36Y4b
 tLnyI8VWj05K54PdkqvMYVK1k26ZlnBJ8nwnRk4iBf/j8ekis2/otDeBdzCSHeFmqQ6xuR/
 CwImjXV+4HKouK/bmZIdw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ldvqIg5Ap64=;LW7m5Z+9CmKPG+RSXwwLaVruNgD
 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
 w9HcJQlgXp2n/xtAQnwc++eQFJKUrxe33Osh8s9



=E5=9C=A8 2026/7/17 23:47, Johannes Thumshirn =E5=86=99=E9=81=93:
> On 17.07.26 00:49, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/7/16 21:26, Johannes Thumshirn =E5=86=99=E9=81=93:
>>> On a zoned filesystem btrfs_clear_buffer_dirty() keeps a freed-but-dir=
ty
>>> tree block dirty (EXTENT_BUFFER_ZONED_ZEROOUT) so its zero-out keeps t=
he
>>> zone write pointer moving. A block left ahead of the block group's
>>> meta_write_pointer (e.g. a tree-log block freed before being written)=
=20
>>> can
>>> never be written by btree_writepages() and survives to unmount.
>>>
>>> close_ctree() stops the endio workqueues before the final iput() of th=
e
>>> btree inode but frees the block groups only afterwards. Once the block
>>> group is gone btrfs_check_meta_write_pointer() no longer defers the=20
>>> buffer,
>>> so the iput() submits it for writeback; its completion can no longer b=
e
>>> queued on the destroyed endio_meta_workers and umount hangs on writeba=
ck
>>> that never finishes.
>>
>> Can we just trigger a btree inode write back for zoned cases?
>>
>> That sounds much simpler and less hacky.
> I tried freeing the stale ebs in btrfs_reset_unused_block_groups()=20
> before actually resetting the bg, but then the WARN() in=20
> invalidate_and_check_btree_folios() triggered again. So that doesn't=20
> work sorry.
>=20

Sorry I'm not familiar with zoned metadata writeback.
But it still doesn't sound correctly to me.

To me, this seems to be a problem that btrfs_check_meta_write_pointer()=20
can skip some ebs from being written back, and in that case those ebs=20
should be properly handled (e.g. clearing dirty etc) but that's not the=20
case.

Yes, btrfs_clear_buffer_dirty() will not clear the EXTENT_BUFFER_DIRTY=20
flag, but only set EXTENT_BUFFER_ZEROOUT flag.

But still that dirty eb will go through writeback, as they still have=20
the folio dirty flag and page cache tags, being properly submitted and=20
got its EXTENT_BUFFER_DIRTY cleared, in the regular=20
lock_extent_buffer_for_io() path, then go through the write_one_eb() to=20
be submitted.


However if btrfs_check_meta_write_pointer() returns non-zero values, we=20
skip the writeback for that eb completely, so that eb stays dirty forever.

Shouldn't we do something to clean up those ebs in the first place?

So to me, this seems to be a problem in the zoned metadata writeback=20
behavior, just being exposed by the newly introduced sanity checks.

Thanks,
Qu
