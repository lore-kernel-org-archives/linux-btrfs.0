Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120423EFD04
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 21:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792184553; cv=none; b=G2BDjgtzTRE4NduUJbKRRbIPQtvnzZ2kGJnA7qN//vnRQRj9UPhDxb7StqXlX2Z5KYjVX12NUnTUGqD4VGQtqoPyGtVKOKi97zTbfxg9SUPhX63ark7OVG/Hgj+jGja2kZc6yWQywJE42Lhch57O9mGE1dE54cEw6VvtxIi/a/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792184553; c=relaxed/simple;
	bh=PoTYlPyuiMVqoe7L+/hyhet0lFQqCECj/+1PYFahBk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q5yqJ9g9tUtkG3tGZ5vKxw9WmjelOkbhk+IpfSRfvyXUVNT52JtnPsNSytqx8YCdW6NpvNVulqA9K3SZxZ/w4O0JxdG2kQCPKrcCC9vG+wg0tGICsG6RPc4GPIa873ITRaJiRLagIkYV7iOrC0chTBlCTsayZQwFalATplL61xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rcdElsYZ; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rcdElsYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792184542; x=1792789342; i=quwenruo.btrfs@gmx.com;
	bh=IhdFfJh2nW23L4Me99TIujD37/6LaeLt+bj3j0Aw0ZA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rcdElsYZ3Ps5xg91X5JPnV8JLe78L6Qtbx3LewRPA7IQwXBflW+QG4WBt+iHoOJd
	 qCJP3omc8ubqdUeTONgZIqmVyf52PapEjIzxNtDGVr82TP8mEfubCKhfD89Qymndu
	 JHvX56DI9B5RNaVdK+3mvf8FDQmT2ozP9AnZ/jjKPCOpSay4WDhV4WO5LdnJhM6y5
	 lTWvVwyzd+OJ3OrjqA1H4piHe0QkFZ6ptiIBoUpTh0KiIw19oD9uyiYHXjqEcKhjg
	 36dDj2/PR4rTsjcASpinKr9G9VuCQaIjzj22xBIH0ARljTetpn8Eo/ZtmGmQCf1M7
	 NvAQoVCiv3JLJWB0/g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MLi8m-1x0IBR034y-00YfCn; Fri, 16
 Oct 2026 23:02:22 +0200
Message-ID: <cae42a9d-bb41-4ce4-8d71-84e7bbcb41a3@gmx.com>
Date: Sat, 17 Oct 2026 07:32:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] btrfs: add LOGICAL_INO_V2 flag for avoiding the tree
 modification log
To: Joanne Koong <joannelkoong@gmail.com>, dsterba@suse.com
Cc: boris@bur.io, loemra.dev@gmail.com, fdmanana@suse.com, wqu@suse.com,
 linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
References: <20260922201258.874070-1-joannelkoong@gmail.com>
 <CAJnrk1a4m-F0F=HbnaMT6+OFfTOv90Eu3JHwHe=EqEd+vO_SPw@mail.gmail.com>
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
In-Reply-To: <CAJnrk1a4m-F0F=HbnaMT6+OFfTOv90Eu3JHwHe=EqEd+vO_SPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RfKE08v765ben2/GpWQNHjWdCXMCJFiiFSTIlwLnPyvJmy/7bJP
 sCyb5LlRGCHLkz76ozjTnPOCkQnZDHbNL8VqA2RAJ40ZlNJJq/vpC+mkAtFf3a1nSBAs08q
 vqoCFqLx1uoZDobOf26unBc97ow4RI1ZmQA4o/y/6x8B1Iya7DdYv1V0ijLKIf67gQSdsQ0
 tnz8FddskoafmteQPAJww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:y0ic+K9inlY=;y/3NMYO88hQzWju4JTHMDvfgO8d
 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
 =



=E5=9C=A8 2026/10/17 03:39, Joanne Koong =E5=86=99=E9=81=93:
> On Tue, Sep 22, 2026 at 1:14=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
>>
>> At Meta, we use the LOGICAL_INO_V2 ioctl to estimate sharing-aware spac=
e
>> usage. We sample the logical address space and resolve each sample back
>> to the inodes which reference it. The measurement is statistical, so
>> with enough samples it gives good bounds on real usage.
>>
>> Currently in the LOGICAL_INO_V2 ioctl path, iterate_extent_inodes()
>> (which can walk backrefs either against the current trees or against th=
e
>> commit roots) acquires a tree modification log sequence number when
>> walking the current trees, since those trees are being modified while
>> the walk is in progress. The log is then enabled filesystem wide for as
>> long as any such walk is running, and is only disabled again once the
>> last walk has finished.
>>
>> While it is enabled the cost impacts the whole filesystem, not only the
>> caller. Modifications of interior nodes of the extent tree and of
>> subvolume trees have to be recorded, serialized on a single filesystem
>> wide lock. Delayed refs with a sequence number at or above the oldest
>> active one can not be run (the run path bails out with -EAGAIN in
>> btrfs_run_delayed_refs_for_head()), and metadata refs above it can not
>> be merged, so they accumulate and that work is deferred to transaction
>> commit.
>>
>> Currently, userspace has no way to ask for anything cheaper. Whenever a
>> transaction is running, the walk uses the tree modification log, even i=
f
>> the caller would tolerate results that could be up to one commit interv=
al
>> stale.
>>
>> Give userspace this option by adding BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT=
,
>> which makes the backref walk use the commit roots and therefore never
>> enables the tree modification log. Behavior is unchanged unless the fla=
g
>> gets explicitly passed by userspace. iterate_extent_inodes() already
>> takes a search_commit_root argument for this, which scrub, send and the
>> data relocation warning path all pass as true. The flag simply plumbs i=
t
>> through to userspace.
>>
>> Assisted-by: LLM
>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>> ---
>>   fs/btrfs/backref.c         |  6 ++++--
>>   fs/btrfs/backref.h         |  3 ++-
>>   fs/btrfs/ioctl.c           |  9 +++++++--
>>   include/uapi/linux/btrfs.h | 10 ++++++++++
>>   4 files changed, 23 insertions(+), 5 deletions(-)
>>
>=20
> Hi David,
>=20
> Just wanted to follow up on this patch. It has received a review from
> Qu, and I was wondering if there are any outstanding concerns or if it
> could be included in for-next or for-7.4.

My bad, I should have pushed this one to for-next.
I hallucinated that Boris had also reviewed it and he would do the push,=
=20
but that's not the fact.

Will push it for the next release very soon.

Thanks,
Qu>
> Thanks,
> Joanne

