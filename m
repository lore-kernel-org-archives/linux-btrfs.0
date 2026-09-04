Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDE0514775
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 22:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788560525; cv=none; b=m1Dt3CSiFG15BDFC8xhtMK9Y0YfJsF5Usb9jMobNCJiLh7yhnuhSrybRFgXQ6kss1yphqHuy2pmYFOlM7HRpXbnCAgnDYigGcyNNzkyOFqTxnWk+6XHJNebLgIyPKkv8D63bBdVvNFfmeldyt5KLmIBjeKQypCJJVQxBbh/btlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788560525; c=relaxed/simple;
	bh=PEbGvS4FUR4dcNe1JcfJvVnSdGjAswZaD/H6LcQ/tNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GY4LCwKNi6Qcb6yN37JeAY1w8HtyZr3KEi39UsFr7188McG0gEVxjLBbZ5G8gdEHLiOam0bbDRqZFLVJ+mm/txcwVKO1r9Dx7nVmKpR2HykTq9ID/S9FtiNgur/39J46cPSsTsZeFkTQYhiyVwItzr1y1AnNPVms3iZDq66RHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=lEIxN363; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="lEIxN363"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788560506; x=1789165306; i=quwenruo.btrfs@gmx.com;
	bh=Apv5aafVLOLAcBvPMcnzjY7Ehs9BCZOF5mNJtFUzuwM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lEIxN363QTexcSNzrOp2pkvCFWMZXKGu34xAfkCDLukWok4Am7B8wVDvZWkHQSl0
	 MbPlKNFxLhlwIkf3r5CYvDyEB4XTBXI8Xnwfn6ouVSDcCoG7kMNz5NyeeCeHppAkM
	 0OgJc2lM4/L8Cr43PQG6MJ3L9XWiGlrMWXpwRiWx/KnHaBMk+zs/ZyTOxLwkLZL8D
	 uUBXtX3soEj3DLx0xPdJR4TPY+KKX+tV00u8/NcoO8+QSWEPltNU2nedmsq6LuCTs
	 6b8bdvwS5ju1D7R4D17QuPNBvSNxZtGfPOYoPByb551RG844W+3lsqWwcW3vG4HUs
	 5T4cAiMBu2uJi93Zfw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZCb5-1xOK7s48IL-00XJWY; Sat, 05
 Sep 2026 00:21:46 +0200
Message-ID: <d79d06ab-721d-4fec-a2a3-823e9380c792@gmx.com>
Date: Sat, 5 Sep 2026 07:51:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Daniel Vacek <neelx@suse.com>
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <20260904170035.GN9053@twin.jikos.cz>
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
In-Reply-To: <20260904170035.GN9053@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PRJxEiplkqvorfVkBkeFnCHZ2FJ5jXJNu5xKIuIG4tX633POJUf
 PqvXX2VB5PfKald78tnkr7+Ve44TpOTGC488OOQA5VJ+2IIjUCl85Gbin3km058euozq7Pt
 9SRjlbLnFrQD+Nv3yGWfM1c3Jbb8TFtZj1rsU2tn9jz2nRyLxAVPCcIn1F2slHsijMJlyaN
 bcIY1fEGj3nH3fG0+pjIA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l8EqagoX0FE=;dx6egD3pVU4OV6HFQt4M8HgiPYj
 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



=E5=9C=A8 2026/9/5 02:30, David Sterba =E5=86=99=E9=81=93:
> On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs=
_info)
>>   	 */
>>   	btrfs_flush_workqueue(fs_info->delalloc_workers);
>>  =20
>> -	/*
>> -	 * We can have ordered extents getting their last reference dropped f=
rom
>> -	 * the fs_info->workers queue because for async writes for data bios =
we
>> -	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
>> -	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bi=
o
>> -	 * has an error, and that later function can do the final
>> -	 * btrfs_put_ordered_extent() on the ordered extent attached to the b=
io,
>> -	 * which adds a delayed iput for the inode. So we must flush the queu=
e
>> -	 * so that we don't have delayed iputs after committing the current
>> -	 * transaction below and stopping the cleaner and transaction kthread=
s.
>> -	 */
>> -	btrfs_flush_workqueue(fs_info->workers);
>=20
> In the final fs closing sequence there's always some possible
> interaction between the workers, but I don't think we need an explicit
> flush anymore. The work offloaded to the system workers will be done
> before we get here.

In fact, Daniel's commit ("btrfs: use bio::remaining for async=20
checksumming synchronization") changed the behavior back, and we may=20
need to be more cautious now.

Previously, the csum generation workload will never call endio in its=20
context, the only work it really bothers is just to wake the completion.

But now his commit changed to use bio_endio(), which means we can again=20
run the workload from csum generation workqueue.

In fact, I do not believe it's the proper timing to move async csum out=20
of experimental anymore, after his commit.

I'd prefer more the next merge window at least.

Thanks,
Qu
