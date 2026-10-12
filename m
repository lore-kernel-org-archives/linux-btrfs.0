Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0E332E73E
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791843126; cv=none; b=gNbLyycTErKCfhP07pd1p4S6ce5qQXmrqzwwjZ1+EeLBGC5NC1UE0y4OlTGu2hrJa7cKABq61R4bCb51RQ3BN7BqCTOxcnjEb3/FY+5Dugn7O1t40sKmfVgcFV4aHl4GChCoSQ6yXaDW5pAlqsMaAomX812HMqB9h/AqtmWt+3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791843126; c=relaxed/simple;
	bh=k3012pJ5CG5Fwwj1h2OoO9j26d0c3KMsJehr/58FjJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2pK6HcXKwGpnlYpK2D9SfBRrhHzZFmE6DQPjOkfY89tFRTUxD2avgZSPCWoKj68Akcpi20rqKkClaR4MmuD4KBfJvljtcu6np0vGiglf5YaxQuaUTabryv4iuAidY4EGoH21ITMP9rPKOIiT60bNsbeYP2NGlfN5u3Z77VTEIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=KcUEyyWN; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="KcUEyyWN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791843116; x=1792447916; i=quwenruo.btrfs@gmx.com;
	bh=k3012pJ5CG5Fwwj1h2OoO9j26d0c3KMsJehr/58FjJo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KcUEyyWNJkxJhHQXFb5sRATFKAt4x9fDSjGqrbcMd33VppEZMYHzyPeoEROWH4VU
	 yfOKMc1TJAF5TyrtXJcfteWP9TxhbdWU0z1BlYwnslEjXvLkx0Bc9rQ08YkhnXXdh
	 SobdMLl+RG/hFM7+v00HHz3jr4TbQ5Oj65BJE57U++Mi0KGz4yme+PggnjHpeIM2x
	 ukR0JQRf0pMHEVUV8gBnk3TQJxPWYjKxCaIB2KTPYI338DjrfP6UG3ng4mEhJ5kR6
	 FvB0uYwhPZVg7nYEN2gxaJnz23kO2lRPPXeLmy7YtWRUv/+APg+irQabA/5eZWxSI
	 kSliB6XLiT5PW4bNhg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1My32L-1wR0su3nPb-013sEX; Tue, 13
 Oct 2026 00:11:56 +0200
Message-ID: <ea828775-1ecb-415b-b08a-aecc3303c965@gmx.com>
Date: Tue, 13 Oct 2026 08:41:52 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] btrfs: prevent use-after-free in
 btrfs_transaction::switch_commits
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
References: <cover.1791706855.git.wqu@suse.com>
 <e0dd7f862cab85c1961d6ed38ff130c3c58ae61a.1791706855.git.wqu@suse.com>
 <CAL3q7H59WmpF3Wu2CZRyGTFDTVz=L7EyJ6Td+1vfwppg9QEOCw@mail.gmail.com>
 <7e54be4a-0779-43fb-98a8-f9d2e06c7391@gmx.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <7e54be4a-0779-43fb-98a8-f9d2e06c7391@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qAqF6LcOZ25EqdXhFXjJEaa0VRQCFxPFN/CupF6Y0FMC389umt8
 86MDHeEmiOFXpxn5nH64ggbxyzDcAiqpjqPhsqRZIcrpn9OODS0pOz2pnIBqeEScp0tZQRe
 7U19AqcyYptsWqT2I03QjP6+grKXC3KtvYAN4io1eze3Od5jOqR5MTRxBGb9RV9q+jQ1fHY
 x9JBvQdDyKHc8FAyqElDg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:X7g75v4V5q0=;LJn4c1tO1KvFnodjWiilEpZS+mG
 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
 =



=E5=9C=A8 2026/10/13 07:43, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/10/12 21:11, Filipe Manana =E5=86=99=E9=81=93:
>> On Sun, Oct 11, 2026 at 9:22=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>>
>>> If a transaction is aborted during committing,
>>> btrfs_transaction::switch_commits can be non-empty, but the
>>> btrfs_transaction structure can be freed at the last
>>> btrfs_put_transaction() inside cleanup_transaction().
>>>
>>> The btrfs_root::dirty_list entry still linked into switch_commits will
>>> point to already released memory, causing use-after-free.
>>>
>>> Address this problem by manually deleting all entries inside
>>> btrfs_transaction::switch_commits.
>>>
>>> And since we're here, also release the dirty_log_pages and qgroup
>>> swapped blocks for that root, which are only released during a
>>> successful switch_commit_roots() call.
>>>
>>> Reviewed-by: Boris Burkov <boris@bur.io>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> =C2=A0 fs/btrfs/disk-io.c | 10 ++++++++++
>>> =C2=A0 1 file changed, 10 insertions(+)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 66b054eb98c6..02adda065097 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -4966,6 +4966,16 @@ void btrfs_cleanup_one_transaction(struct=20
>>> btrfs_transaction *cur_trans)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&dev->post_commit_list);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (!list_empty(&cur_trans->s=
witch_commits)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 struct btrfs_root *root;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 root =3D list_first_entry(&cur_trans->switch_commits,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 struct btrfs_root, dirty_list);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 list_del_init(&root->dirty_list);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_extent_io_tree_release(&root->dirty_log_pages);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_qgroup_clean_swapped_blocks(root);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> Sashiko has some comments which seem valid to me, roots still in the
>> dirty_cowonly_roots will get their dirty_log_pages and swapped blocks
>> leaked.
>=20
> That's in fact an existing problem.
>=20
> If the root is still in dirty_cowonly_roots list, it will be the same no=
=20
> matter if we have this patchset or not.
>=20
> In previous attempts I tried to address this in btrfs_put_root(), but=20
> that has extra problems like some call sites can end a trans then call=
=20
> btrfs_put_root(), which requires extra locking.
>=20
> I tend to address this problem in a dedicated patch at close_tree() time=
=20
> instead.

This is in fact not a big deal.

The truth is that after a transaction is aborted, no one will ever read=20
fs_info->dirty_cowonly_roots.

Even if some root is freed (only possible at unmount time though), as=20
long as no one is reading the list, everything is fine and there will be=
=20
no leaking memory.

But still, manually removing dirty_list from that list during=20
btrfs_free_fs_roots() would be more sane.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>>
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_destroy_delayed=
_refs(cur_trans);
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_trans->state =3D =
TRANS_STATE_COMMIT_START;
>>> --=20
>>> 2.56.0
>>>
>>>
>>
>=20

