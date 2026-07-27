Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7CF36DA03;
	Mon, 27 Jul 2026 08:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785141715; cv=none; b=SDpLuwvykRmhtWguKRTJ5AxICA9jSDjfimeB0OnIeFW1UQYRNoW9WJesqXhK6IVACJFHA9VfmBaIwRaxKYNZ4hCvnRTP/Ily/FmShfQChamXW1sLb6lSJYpCKxcfpjgtpMtaBKbt1pEJMvAW9TMhk6+EGmBZAU+hqRtgo3mr9xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785141715; c=relaxed/simple;
	bh=yz8q4ud4t5/b4a8hIV7xN1REz9OUXOr3fuwWSMNQWGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGhDBA82XC6dRlC+S7d6YmtgIs7y29y2EnJo7sH5A+kZDKAcRIxYYcvOjrhZuaQoPWl6ggVAuM+kVEqG9cuNaK17XAQ7/Cod4lSsqiC5JHV/cNZAeEM3LaK3BJMJjEdRXJHDS57efIycENz3X/7x2xeiv+TVquwgVILthz6D8Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=KcEZG2xL; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="KcEZG2xL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785141704; x=1785746504; i=quwenruo.btrfs@gmx.com;
	bh=yz8q4ud4t5/b4a8hIV7xN1REz9OUXOr3fuwWSMNQWGA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KcEZG2xLaPrdeUlRVIjY4wZo1D751NJOYnxltTYIT4PlI85haD7wsKbt0YE0tnqt
	 27H9tJZRgx/rnR3dIQwvhNQqRxWIYztpwh5K+WPO3s06baWuouR4d/U072XQ6PpDA
	 naT6DZzQh2vVuhUREriSDFEPe94CKFHdXERslpcCuQOqC0p2pStAlMbaB4pHe7FGc
	 hCi2HKbGaDrIJEYbI2y/WojwBNdov5AQh2qWvzmCEQV3AtpAU+V/YQ6NbmQZcspUA
	 FB0jqCaGDd8qltSrkvVeeme8Jn9Soa8J7dsOTiP1t3XK4uKEnzfcGeLV0xhfqOZoV
	 vMRc5BP75ulWKzundg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MRCKC-1wa1oJ1eRo-00OJuC; Mon, 27
 Jul 2026 10:41:43 +0200
Message-ID: <0b0dc988-61e5-4dd5-b2a1-52699fd4391c@gmx.com>
Date: Mon, 27 Jul 2026 18:11:34 +0930
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
 Boris Burkov <boris@bur.io>
Cc: Matthew Wilcox <willy@infradead.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>, Linux Memory Management List <linux-mm@kvack.org>,
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
 <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
 <20260725062614.GA2792359@zen.localdomain>
 <4f7b99e5-62b6-48ac-a141-24f25af125c1@linux.ibm.com>
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
In-Reply-To: <4f7b99e5-62b6-48ac-a141-24f25af125c1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xRjn7h5/Ox57ttqKDvfs41ToZ8zwfuRIS9fQuBXSLLycV6HDkH2
 g8GDORD1oQ8lEOFKESR8/69/Jmj/ALJf67MxCaOq/tsojH3T/+nIqrLCPrmwQnPene2ZH4e
 Yhi1XDzkc/BXo+nYv39bDVLhE/BQ/f/5P5XyqE9lzTQFshStDXOiNmisH6VcvAMVXA/1D1N
 chlNyuawXFt4+7quGGRMw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/ZDT30pmVDI=;HVywJ2bO0Tm6swwZkB2EDn3Qw0y
 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



=E5=9C=A8 2026/7/27 17:41, Christian Borntraeger =E5=86=99=E9=81=93:
> Am 25.07.26 um 08:26 schrieb Boris Burkov:
>> On Fri, Jul 24, 2026 at 08:10:36AM +0930, Qu Wenruo wrote:
>>>
>>>
>>> =E5=9C=A8 2026/7/23 21:30, Matthew Wilcox =E5=86=99=E9=81=93:
>>>> On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> =E5=9C=A8 2026/7/22 22:27, Matthew Wilcox =E5=86=99=E9=81=93:
>>>>>> On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger=20
>>>>>> wrote:
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0 4. Thread B loops sync_file_range=
(WRITE|WAIT) on the=20
>>>>>>> target file.
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Whenever a full=
 clean cycle (clear_page_dirty_for_io(),
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writeback, bits=
 cleared) completes inside thread A's
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 submission->com=
pletion window, the completion-time
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_dirty_=
lock() hits a *clean* folio:=20
>>>>>>> filemap_dirty_folio()
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sets only the f=
olio flag and the xarray tag - no btrfs=20
>>>>>>> subpage
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dirty bit, no d=
elalloc reservation.=C2=A0 See the 20-year-=20
>>>>>>> old comment
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 above bio_set_p=
ages_dirty() in block/bio.c describing=20
>>>>>>> exactly
>>>>>>> =C2=A0=C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 this ("other co=
de (eg, flusher threads) could clean=20
>>>>>>> the pages").
>>>>>>
>>>>>> There's your problem.=C2=A0 filemap_dirty_folio() documents that bt=
rfs is
>>>>>> doing it wrongly:
>>>>>>
>>>>>> =C2=A0=C2=A0=C2=A0 * Filesystems which do not use buffer heads shou=
ld call this=20
>>>>>> function
>>>>>> =C2=A0=C2=A0=C2=A0 * from their dirty_folio address space operation=
.=C2=A0 It ignores the
>>>>>> =C2=A0=C2=A0=C2=A0 * contents of folio_get_private(), so if the fil=
esystem marks=20
>>>>>> individual
>>>>>> =C2=A0=C2=A0=C2=A0 * blocks as dirty, the filesystem should handle =
that itself.
>>>>>>
>>>>>> fs/btrfs/inode.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .dirty_folio=
=C2=A0=C2=A0=C2=A0 =3D filemap_dirty_folio,
>>>>>>
>>>>>> so btrfs should have its own btrfs_dirty_folio() which does whateve=
r
>>>>>> metadata updates it needs to and then call filemap_dirty_folio() to
>>>>>> take care of the page cache business.=C2=A0 See iomap_dirty_folio()=
 as
>>>>>> an example, but many other filesystems also do this.
>>>>>
>>>>> Thanks a lot for the advice.
>>>>>
>>>>> However it looks like the sub-folio dirty block tracking is a little
>>>>> different between iomap and btrfs.
>>>>
>>>> My point is not that "you should do it the exact same way as iomap".
>>>> Rather "the dirty_folio op is the entry point to tell the filesystem
>>>> that a folio is being dirtied".
>>> And since dirty_folio() is not allowed to sleep, we should introduce=
=20
>>> some
>>> extra mechanism, e.g. page private 2/checked, to notify the fs that th=
e
>>> folio is marked dirty without proper preparation.
>>>
>>> Then during writeback, detect such folio and do needed preparation=20
>>> for it
>>> since at writeback we're allowed to sleep.
>>>
>>> That sounds feasible, but I haven't seen anyone doing that (including=
=20
>>> the
>>> older btrfs cow fixup).
>>>
>>> Will explore that path. Thanks a lot again for the dirty_folio() help.
>>>
>>> Thanks,
>>> Qu
>>
>> Here is my proposal for a candidate fix. It passes the reproducer in
>> this thread as well as several more intense reproducers (alluded to but
>> not yet included)
>>
>> https://lore.kernel.org/linux-=20
>> btrfs/6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur=
.io/T/#u
> I am willing to give it a try, but that does not seem to apply on 7.2-rc=
4
>=20

The latest version is out:

https://lore.kernel.org/linux-btrfs/9f7a81cdd022d9e3f69d347a17c0a25438ccec=
14.1785131713.git.boris@bur.io/

And you can apply it on the latest btrfs for-next branch without any=20
conflict:

https://github.com/btrfs/linux.git for-next
