Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A8E3EDAC1;
	Thu, 23 Jul 2026 22:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784846448; cv=none; b=C64zAXq8PBNqNFmHmBXonzxQ4WBGmdZM0/fPa+Jdiewu9c1YWJiEygICLocnWs7laTgEfLWgJHt2L06W3QN/TU3jVr/vfDlH0A8pBT9yQRBGls8xi/uwoOme9s1KKdqwVcfhAEcDtyhM64oGnuq39ERtmVfNYfbTxjvZTJm1emY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784846448; c=relaxed/simple;
	bh=b1OdjhJ9WAZcumhkwsLeXfo+OGC0rYhKCERbZXCy/CU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3B0Nupl7K35gXOvLecrbGujMo5/NqPSGCtJAYBi6KS6+4O7MhzXyW2w6rJH68sxy25/m9qu39cAAdVNbPSp0LOeWNbvU0SNQ8lHAMTF2A2y4iyZIxd+/I3dXmcR9of3oPI9/UVwnExX570x8jow6/X9Rcu8tNBiHJcM7DQJhUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=sSuhTYFw; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="sSuhTYFw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784846443; x=1785451243; i=quwenruo.btrfs@gmx.com;
	bh=SmmkkUT6ZOoNhviyrOXaNA8ebqCK1kSAzyjXers2mxk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sSuhTYFwSgxrF2lgEsE9AcD9XT0QA0YPoVp+s0lFXQ7ISGWeGcVVXij8HI//xeqg
	 4hD1nozXjyXJeUY6iHrr7/E+nZiZ0sZg/Xn1D6YKiVCCrhLWTv0EGmoW5mLO4hIaw
	 zXvb1hbyTlbZIpdGEKgCq018Z7gabNenOgreBZFgRyQOz3qqVbPwjfs6ybp/Ve6w0
	 f34AsAmAOX9k51aW30r+MXbs2wHzoC9756stcnXcunfQ7QJ9K+1cCMjo8G1vdgrlJ
	 Z4mAcJ5xhGVJTokjTtWN1DG5sAQvSGph6Qz+Bv3JliTkwYfNleSYj5yV+QSSj7gBx
	 K2LUSNfSnv01ySqc6g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MCKFu-1wdigb154U-00EtRn; Fri, 24
 Jul 2026 00:40:43 +0200
Message-ID: <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
Date: Fri, 24 Jul 2026 08:10:36 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
 <amICQYTK9Xu4KLtH@casper.infradead.org>
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
In-Reply-To: <amICQYTK9Xu4KLtH@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XC5GDk4iwsXjGAhKpDlXYRAMeD7GaIwIaetoEDd1XGhyntlDd6S
 PZsTI5M+8hkdAJCuGTdcMPZlv9lCZae9x+zLGgJQRbiM7gKUjD7yA2YhOVk3CuWKvkowaSq
 5hM7N/c7dykl9Vme/3fbmWCvqo7u/hMQUYW1hamwQlEwkZxinvDynf/44XztRPtQEKg/uE4
 cBqcZhK4rmOGlOdeD653A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:EBiqbos+NQ4=;puBP9/Ex8u1SXuoL4ta9bAYk/lI
 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
 7uTedMOCs=



=E5=9C=A8 2026/7/23 21:30, Matthew Wilcox =E5=86=99=E9=81=93:
> On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/7/22 22:27, Matthew Wilcox =E5=86=99=E9=81=93:
>>> On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
>>>>    *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target fi=
le.
>>>>    *      Whenever a full clean cycle (clear_page_dirty_for_io(),
>>>>    *      writeback, bits cleared) completes inside thread A's
>>>>    *      submission->completion window, the completion-time
>>>>    *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_f=
olio()
>>>>    *      sets only the folio flag and the xarray tag - no btrfs subp=
age
>>>>    *      dirty bit, no delalloc reservation.  See the 20-year-old co=
mment
>>>>    *      above bio_set_pages_dirty() in block/bio.c describing exact=
ly
>>>>    *      this ("other code (eg, flusher threads) could clean the pag=
es").
>>>
>>> There's your problem.  filemap_dirty_folio() documents that btrfs is
>>> doing it wrongly:
>>>
>>>    * Filesystems which do not use buffer heads should call this functi=
on
>>>    * from their dirty_folio address space operation.  It ignores the
>>>    * contents of folio_get_private(), so if the filesystem marks indiv=
idual
>>>    * blocks as dirty, the filesystem should handle that itself.
>>>
>>> fs/btrfs/inode.c:       .dirty_folio    =3D filemap_dirty_folio,
>>>
>>> so btrfs should have its own btrfs_dirty_folio() which does whatever
>>> metadata updates it needs to and then call filemap_dirty_folio() to
>>> take care of the page cache business.  See iomap_dirty_folio() as
>>> an example, but many other filesystems also do this.
>>
>> Thanks a lot for the advice.
>>
>> However it looks like the sub-folio dirty block tracking is a little
>> different between iomap and btrfs.
>=20
> My point is not that "you should do it the exact same way as iomap".
> Rather "the dirty_folio op is the entry point to tell the filesystem
> that a folio is being dirtied".
And since dirty_folio() is not allowed to sleep, we should introduce=20
some extra mechanism, e.g. page private 2/checked, to notify the fs that=
=20
the folio is marked dirty without proper preparation.

Then during writeback, detect such folio and do needed preparation for=20
it since at writeback we're allowed to sleep.

That sounds feasible, but I haven't seen anyone doing that (including=20
the older btrfs cow fixup).

Will explore that path. Thanks a lot again for the dirty_folio() help.

Thanks,
Qu
