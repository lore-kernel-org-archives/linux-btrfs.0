Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EE6318EE1
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 05:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402833; cv=none; b=CTv9XfmAUI8sAbbW59ouh2DxcMeCm5EEu1ZprUmt+bzEoK3QUolAu8iIkWu9m0DoDcZekVQFSdD8WP1ENVdr10LOyK2XE2uA4obuSsC5wXbn6Miq8buCQZ9hNNOfj0C5Djpb2OeP3qcjLtisa8KQXCTffSd7iek/cFcVtdN9nCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402833; c=relaxed/simple;
	bh=1PoSB2KYDAYmra43DvOPS5RcqYsvQFP3tUeuFlR6kOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OWGlrFOtiK/L1owRqCxqdoQKnWnNNN7BsNshCmGAAwOF3OqFSX6a1tHcfg2jfgX4mb6VHs/EbyckmK+oZWp8FOu8Q+sHSuC+TLsRcZxFI/U3+eijVpt+hkDjvb++hNu/YpwyklR7iyPhZS3p+iplQHn0+tsaHdhUek8Lc5PryiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=QQJ4D4Ux; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="QQJ4D4Ux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783402826; x=1784007626; i=quwenruo.btrfs@gmx.com;
	bh=aL8AY0fgpWbfEECyRtCma+fMm9H/rFjrge6IsgnFnC4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QQJ4D4Ux/vh6//RjoLsni6r+zl4aEOdp9Axk9j+WEOboiRkiqm/Yqb4Ty8ZdNvE8
	 DQHuuaAYtMuSSJcLEJ9st3TFyhiQz4qk/6Y+AWqMoO25qzaj1LdjFKabMBOQhbTaW
	 Uv6Wb9nslUy9ZAbiktM1oIDudSUeOZDVTIPi04mljTbEhQzGjlKdoM9dBfE1KfIEr
	 SdgcCWNiggpNzxb828jAEWxYwHIKSmBCSV1ubbFYYk518d8WBVaaLsHKe9P84DhUm
	 87+tX3CA4DTxD/1//q0YVe1P6ofz8xA2hRiQ3j4KhoKMDcH8D3+Z3+oQF4q+rcf6B
	 xUispekg3xitU5T2Xw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mr9G2-1xSi2Z3EVK-00ppZB; Tue, 07
 Jul 2026 07:40:26 +0200
Message-ID: <e5a0dbb8-27f5-4b7d-8923-54373622729d@gmx.com>
Date: Tue, 7 Jul 2026 15:10:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <02e6596cdba776b63528ead37324076dd664a11e.1783392018.git.wqu@suse.com>
 <20260707041451.GA153025@zen.localdomain>
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
In-Reply-To: <20260707041451.GA153025@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+mtj2/i076f/9prz474M0/ms8qBz5gSjTmr0yksxzIkqfcNtupy
 KmyucVCfkh7RBHexEfmF7+wsxr/w9Pr7Xlz0XeOJkiZBkkGGOkTrs0J2lkhvU+8jnndDx55
 HtxItIRmCCUobaX1KEka3g+Jq1hTRiq1gssFisRM7EJXoQM2zJYlUzqeHzi+vl/G9hgri/q
 7pvisp4fCUc3h/uBrG0sw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HVrjrv3DPew=;oRytbm9m3GdodTjpquvx3FeQv3f
 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
 PixyrEQKb9sWnMeMO8=



=E5=9C=A8 2026/7/7 13:44, Boris Burkov =E5=86=99=E9=81=93:
> On Tue, Jul 07, 2026 at 12:10:25PM +0930, Qu Wenruo wrote:
>> [BUG]
>> The following script (already submitted as generic/798) will report
>> incorrect dirty page numbers, with 64K page size systems and 4K fs bloc=
k
>> size:
>>
>>   # mkfs.btrfs -s 4k -f $dev
>>   # mount $dev $mnt
>>   # xfs_io -f -c "pwrite 0 64K" -c fsync -c "cachestat 0 64K" $mnt/foob=
ar
>>   Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0
>>
>> Note that the dirtied page number is still 1.
>>
>> [CAUSE]
>> The cachestat() go through the XArray of the page cache, but
>> instead of checking each folio's flag, it uses the
>> PAGECACHE_TAG_DIRTY tag to report dirty pages
>>
>> Since commit 095be159f3eb ("btrfs: unify folio dirty flag clearing"),
>> btrfs replaced a folio_clear_dirty_for_io() call inside
>> extent_write_cache_pages() with folio_test_dirty().
>=20
> This is an interesting coincidence. I have been debugging this exact
> change from a different, scarier perspective as well. Because we stopped
> calling folio_clear_dirty_for_io() we stopped calling folio_mkclean()
> which meant the folio remained writeable via mmap during writeback. We
> observed a significant uptick of csum errors with large folios, as a
> result. However, just this fix I think is not sufficient, and has two
> serious bugs of its own.
>=20
> First of all, now that your patch does clear dirty here, the keep_write
> check in btrfs_subpage_start_writeback() is not correct anymore, which w=
ill
> result in clearing TOWRITE on a non-sync writeback and losing it for
> other pages in the folio on a sync writeback. So if we do clear dirty,
> we need to also add a check for the subpage dirty bits for keep_write
> like we did for extent_buffers before moving to the eb xarray.
> Incidentally since that means not using __folio_start_writeback, it does
> fix this exact bug too.

You're right on this changed btrfs_subpage_start_writeback() change.

But there is a deeper problem, the timing of folio dirty and writeback=20
flags change is not synced anyway.

If we do not clear the folio dirty early, then the timing of folio dirty=
=20
clearing is always on the last dirty block clearing.
But at that time, we may have already called folio_start_writeback(),=20
thus for the last block we do not clear the TOWRITE tag.

If we do clear the folio dirty early, then it's exactly the problem=20
you're describing.

So I believe we should not rely on btrfs_start/end_writeback() to handle=
=20
the pagecache tags at all.

>=20
> Second, and worse, it results in a deadlock which should show on btrfs/0=
62
> and btrfs/070, I believe. The problem is that clearing dirty at this poi=
nt
> results in a truncate being allowed to clean pages past the end of the
> new file size without calling btrfs_mark_ordered_io_finished() so we
> leak that OE unfinished and get stuck.

Mind to explain exactly where the missing=20
btrfs_mark_ordered_io_finished() is?

The point here is, we always have the folio locked already, the=20
difference is just in the timing where the folio dirty flag is cleared.

I didn't see a problem that the changed timing can cause problem related=
=20
to btrfs_mark_ordered_io_finished().
> This is caused by the other
> patches which removed the Ordered bitmap tracking to reduce the bitmap
> size, I believe, as we now use dirty to track the existence of OEs.
>=20
> Can you confirm whether btrfs/062 and btrfs/070 finish for you every
> time under this patch? If not, something about my test setup and yours
> is different, or something is different on the branch I was working on.
> I will try to re-test with your patches and my patches on for-next as
> well.

I have not yet experienced btrfs/062 nor btrfs/070 hang.

[...]
>>   			if (folio_test_writeback(folio) ||
>> -			    !folio_test_dirty(folio)) {
>> +			    !folio_clear_dirty_for_io(folio)) {
>=20
>=20
> So far, the best solution I have come up with is to call a raw
> "folio_mkclean" here, as opposed to folio_clear_dirty_for_io().

I believe the root cause is that we can not rely on folio_*_writeback()=20
calls to do the sub-folio level handling correctly.

I think the long term solution would be the iomap solution by tracking=20
how many write bytes are still pending, and only call=20
folio_end_writeback() once.

But for now, I think a quicker fix is, to de-couple the=20
PAGECACHE_TAG_DIRTY/TOWRITE from folio_*_writeback().

The idea is, we clear PAGECACHE_TAG_DIRTY when the last subblock dirty=20
flag is cleared.

Then do the same for PAGECACHE_TAG_TOWRITE, this time do not rely on=20
__folio_end_writeback(), but manually do it inside=20
btrfs_subpage_set_writeback().


I think this would be much smaller, and completely free us from the=20
special handling of folio_*_writeback().

Thanks,
Qu
>=20
> a second place it is needed is in extent_range_clear_dirty_for_io()
> which also used to call folio_clear_dirty_for_io() and needs stable
> pages during the compression, for which we need to call folio_mkclean().
>=20
> Sorry to derail your fix with a whole different problem.. But unless I
> am missing something I think we will have to fix all of it to fix any of
> it.
> Either by fixing forward with folio_mkclean() or by reverting and/or
> rethinking all of the patches in the series:
> https://lore.kernel.org/linux-btrfs/cover.1778131118.git.wqu@suse.com/
>=20
> specifically:
> 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> and
> 7d97bdca4bcb ("btrfs: use dirty flag to check if an ordered extent needs=
 to be truncated")
>=20
> Thanks,
> Boris
>=20
>>   				folio_unlock(folio);
>>   				continue;
>>   			}
>> --=20
>> 2.54.0
>>
>=20

