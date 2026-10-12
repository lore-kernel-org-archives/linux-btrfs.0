Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96D14F4D1F
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 21:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839628; cv=none; b=r0p1YsRKR5zKzS3IAxo8uYZcrQ2IK2u4WJsxs743CHAKv0PCu+zvhpKYna3l9YgFOy6z8iFg4SxL0G1oVRDdcZBdsdd9MdhwwlkTiltYUTnEW+wpKqk4MhKR5rKo1X1yFJlK7fTzmQhU/gUpKJTyMBOIyixJy7TLmhkkkKUyhzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839628; c=relaxed/simple;
	bh=0C6Ig7nEkqTBPlNdmk7R+QZ9sGunsbjOJInZRV6diRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQDPwFp+xV1vOjNkF3EhKrXzL1AGEO8GTIhGqPxj3HCVU7iWcBKU8ZgzjgEQ/pxdquZS2e4fbvYPG63xhPk3qI0K5VH0/ZswHTy6PYqsXluSdDXIIJvBz+BWF8pSVT4F5EQIejNzM9DybPLcyFlZQ4gkV73VQ8AlRtmgzOoAuQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=tQ+O9uS5; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="tQ+O9uS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791839618; x=1792444418; i=quwenruo.btrfs@gmx.com;
	bh=riJHyP4+gqoZDUSNN8uxPl2vrJredSv8p4VoEoLtKOQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tQ+O9uS5N1ESboqTIwzGKw7DdF6rx6PawZEH44YITQqL+4j7CSI60UNrQgTDibnt
	 Io1RdD8nFsJDCOf1JiJMXjLN6w/gGSO/N4MBYO/TPMOhtzbKFuICwyF2CEM1syldX
	 bKvcPzeBKHA41jOC1dpc+5vKRl/6cEjwH7iCR3/Gle83r0hnsyWlNrv61A4RjFaou
	 vCV2MrhPc2LkreNTd5aciWlNkigZaUBp/MiaLpeeaKtIv6J0tC9I4PMRuJnGh2FTe
	 749kzhzIM9JAk/bELeL7mMw4q2vTMhY5fCq3Qtmy7ZezP+G4qE0QyY2Ey2n2TkbGN
	 BZOgVwISoXODqY2Uhw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mf07E-1wk4jL1S0o-00oLSY; Mon, 12
 Oct 2026 23:13:38 +0200
Message-ID: <7e54be4a-0779-43fb-98a8-f9d2e06c7391@gmx.com>
Date: Tue, 13 Oct 2026 07:43:33 +1030
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
In-Reply-To: <CAL3q7H59WmpF3Wu2CZRyGTFDTVz=L7EyJ6Td+1vfwppg9QEOCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H+cDxYmVCFfrdbgPCrVMC0XEJCnlP9OcgFGhxHaxb3f3q36QQdB
 T555/YzBgcYGOAa9yq1BKIQBcmb7rBl9xtD28wAWCHY95dzH1w+zw+Q6KcoVPLiyekU5i3b
 e4AjLjKAeEQE6ju3HtRP574PZVA2RwMbkYh5GgWA26SCY0/krqkedo4AdJAu0D1zqbyRtWs
 8VWWC0b43H6U0OXXy0cVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:M8va4Da1Uy0=;EnmeB7FfqXoR8y7FG0Q+7IeAL8P
 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
 =



=E5=9C=A8 2026/10/12 21:11, Filipe Manana =E5=86=99=E9=81=93:
> On Sun, Oct 11, 2026 at 9:22=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>
>> If a transaction is aborted during committing,
>> btrfs_transaction::switch_commits can be non-empty, but the
>> btrfs_transaction structure can be freed at the last
>> btrfs_put_transaction() inside cleanup_transaction().
>>
>> The btrfs_root::dirty_list entry still linked into switch_commits will
>> point to already released memory, causing use-after-free.
>>
>> Address this problem by manually deleting all entries inside
>> btrfs_transaction::switch_commits.
>>
>> And since we're here, also release the dirty_log_pages and qgroup
>> swapped blocks for that root, which are only released during a
>> successful switch_commit_roots() call.
>>
>> Reviewed-by: Boris Burkov <boris@bur.io>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/disk-io.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 66b054eb98c6..02adda065097 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -4966,6 +4966,16 @@ void btrfs_cleanup_one_transaction(struct btrfs_=
transaction *cur_trans)
>>                  list_del_init(&dev->post_commit_list);
>>          }
>>
>> +       while (!list_empty(&cur_trans->switch_commits)) {
>> +               struct btrfs_root *root;
>> +
>> +               root =3D list_first_entry(&cur_trans->switch_commits,
>> +                                       struct btrfs_root, dirty_list);
>> +               list_del_init(&root->dirty_list);
>> +               btrfs_extent_io_tree_release(&root->dirty_log_pages);
>> +               btrfs_qgroup_clean_swapped_blocks(root);
>> +       }
>=20
> Sashiko has some comments which seem valid to me, roots still in the
> dirty_cowonly_roots will get their dirty_log_pages and swapped blocks
> leaked.

That's in fact an existing problem.

If the root is still in dirty_cowonly_roots list, it will be the same no=
=20
matter if we have this patchset or not.

In previous attempts I tried to address this in btrfs_put_root(), but=20
that has extra problems like some call sites can end a trans then call=20
btrfs_put_root(), which requires extra locking.

I tend to address this problem in a dedicated patch at close_tree() time=
=20
instead.

Thanks,
Qu

>=20
>> +
>>          btrfs_destroy_delayed_refs(cur_trans);
>>
>>          cur_trans->state =3D TRANS_STATE_COMMIT_START;
>> --
>> 2.56.0
>>
>>
>=20

