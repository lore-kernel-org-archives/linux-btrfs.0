Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E51313277
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579637; cv=none; b=oRmGmgkLWJMRks6bl27xEw6xI5i4cfrQd18KA4+ukQn2OpwPMRhodsnhSCmK4jUsbKGF6C0SgdOJMQo/WZ6tPipYWY1okq0MmixHyidtTA01O7EHha9blnoKMk+CDudIvBnHYVs4FeccSdw6UXe8Nf4Fe+CRTCmiewbFHcdVCDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579637; c=relaxed/simple;
	bh=pHWehTIGXofQDIZvScNOkWRZrGcph12E61l8Rp4BCts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCipWqXOpnK61zRdKE8OlmPXHjjZ8j8SbTjG+z6x8Eb2+jCzh6xppHLgKQrcj5htKkfeltmnocji9hxjq23IEnVCpHyl3GLINjraC3dcZeX8MJAKoqBioO6s/m2HZks9lB3Klezj+xg83gRMzEG1vMoR27+l7tyDzF8ItPod/DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Wsf8lIcb; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Wsf8lIcb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791579629; x=1792184429; i=quwenruo.btrfs@gmx.com;
	bh=MiY9d3Jlq96t0ttJrbG1GodivspBjkDj0yiTVULT/A4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Wsf8lIcbFbMvxiltBr5TPFlihoZwX74wsSvP3+lM7//vlDdDq4/9y/7rgqfSQKVi
	 q/wALsSYKqopF9aWeusCEyM3qDcWI0LBbjkcD6Z9ZwaAgmfV/5Zk450PyNHjhpxiI
	 Hd4Z7rIYjowHY5nGt1ZoFAqCnqWhOz0Q41muOXnUJR04llEY2blwoffePqirxJJfi
	 4IayDBlRR95DBVOA+8z3YTCoDYczK7996vcu+cUQf+6aKXPKEfGAFXE6cO4djfJBe
	 WffxUuMonan2/CLNVSM3oWAiu34V3/YH/FZ34jzpF9WdJgGE8Hh9uh7bfzCVGWAAR
	 DpfkTEuX2LXlFYdGGA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N4hzj-1wYlFz3jx1-013cEC; Fri, 09
 Oct 2026 23:00:29 +0200
Message-ID: <2754e520-ae09-4c1a-a5a7-c46cafffea73@gmx.com>
Date: Sat, 10 Oct 2026 07:30:25 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] btrfs: fix a UAF where btrfs_root::dirty_list is
 freed but still referred
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1791497576.git.wqu@suse.com>
 <20261009163051.GA2648158@zen.localdomain>
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
In-Reply-To: <20261009163051.GA2648158@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zsPwyncLsQru/B3iW7g8Xdi2h04qVCQayUdNh6YkfEAn8Fvtgur
 RLUVk2qO54UL6xKdJvK1QrejVWRFsh4LsznhQcgQB/U2Jwqa1SNzEYn1mWyJXIZaRqS0vPN
 ljtgLMWJHNEBNVmFtl7zdcG2ja8BWHP5T6BM4e7fnS6It7beDhVzXJp5MfnTC3yIwVNhiSy
 ZC+m3i6gXq11SYLTu+ybQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W3YU8PCh9Wg=;wVyfHbQGNDlhVnS3gPadIaXt7lU
 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



=E5=9C=A8 2026/10/10 03:00, Boris Burkov =E5=86=99=E9=81=93:
> On Fri, Oct 09, 2026 at 08:43:37AM +1030, Qu Wenruo wrote:
>> [CHANGELOG]
>> v4:
>> - Also cleanup qgroup swapped blocks and dirty_log_pages
>>    Which are only released during switch_commit_roots().
>>
>> v3:
>> - Use Yalagada's v2 fix as the final UAF fix
>>    The delayed list_del_init() call inside btrfs_put_root() is not
>>    safe as another racing ioctl can grab the quota root, extending
>>    its lifespan.
>>
>> v2:
>> - Add extra patches to address Sashiko's comment
>>    * Make all root->dirty_list users to hold trans_lock
>>    * Release root->dirty_list from cur_trans->switch_commits during
>>      transaction cleanup
>>
>> The first patch is to make lock consistent when accessing
>> btrfs_root::dirty_list, btrfs_fs_info::dirty_cowonly_roots and
>> btrfs_transaction::switch_commits.
>>
>> Normally it's not a big deal as the existing lock-holding callers are
>> also holding a trans handle, thus they can not race with transaction
>> committing.
>> But the last commit will change the cleanup timing, and Sashiko is not
>> happy with that, so make it more consistent and shut Sashiko up.
>=20
> As far as I can tell, it is possible but unlikely (rescan + squota?) for
> the new callsite to actually do the removal outside a trans handle. Is
> that your understanding?

That part (the first patch) is a little overkilled.

The main reason that patch is introduced is to prepare for calling=20
"list_del_init(&root->dirty_list);" during btrfs_put_root().

As we have some call sites that doesn't hold a trans handler.

But later I switched back to the v2 fix from Yalagada, which does the=20
manual list_del_init() call instead of relying on btrfs_put_root().

>=20
> I would prefer to have the bar for "shutting sashiko up" to be at real
> bugs, even if they are sort of unlikely. If I misunderstood and it's
> fully a false alarm, I would sort of rather not make changes to satisfy
> its misconceptions.

I'll remove the first patch from the series.

Thanks for the review,
Qu

>=20
> Fixes look good overall, thanks.
> Reviewed-by: Boris Burkov <boris@bur.io>
>=20
>>
>> The second patch is an existing bug exposed by Sashiko, which also
>> affects the last UAF fix.
>>
>> The last one is the final UAF fix for the bug reported by syzbot.
>>
>> Qu Wenruo (2):
>>    btrfs: protect dirty_cowonly_roots, switch_commits and
>>      root->dirty_list
>>    btrfs: prevent use-after-free in btrfs_transaction::switch_commits
>>
>> Yalagada Pavan Kumar (1):
>>    btrfs: fix use-after-free on quota enable allocation failure
>>
>>   fs/btrfs/disk-io.c     | 14 ++++++++++++++
>>   fs/btrfs/qgroup.c      |  7 +++++++
>>   fs/btrfs/transaction.c | 30 ++++++++++++++++++++++++++----
>>   3 files changed, 47 insertions(+), 4 deletions(-)
>>
>> --=20
>> 2.55.0
>>
>=20

