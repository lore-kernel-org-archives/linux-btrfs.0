Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9B305674
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783463796; cv=none; b=eG/h5ewJ6Sc0iddQ678yDDaeAseWfgAI0GgO9B4hswPEvz3SHnGsnqPlunSOL8akLupubeZ9zZaYXwvM4L5+6FRESF1Gwh5qB0GpfPh8G8OtPyjlzLKlHe2TykAIC+ZMwrSpIJX2cXTImpinnrURzoOkB/nUNYxafwJeA09ShPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783463796; c=relaxed/simple;
	bh=+rZ/6+X+pDGTkXSrtUDQF2KM1Bu6n5tuyvVKIMrQp3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bd6V1sR3ABm4iVCwlVyMnMmk51KtMWXMP721Pacq1wxcaPD14I0FTJRvEmxYknPj/q1p3vFgW0BUHhM35TiXTiSEEth7SJb0WnPhF4wu1KwxSM4eOEvYkXVQg+1Fc86ZIt2TphWg1yiozzlQBpfSYOP8FuvdbCgtHpichoQltfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uQuZ8rBN; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uQuZ8rBN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783463789; x=1784068589; i=quwenruo.btrfs@gmx.com;
	bh=N99FT6CAPrv9kyS088HEn2nRDtRWbUe00C8g8fMjt50=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uQuZ8rBNbyfqyPr78i5TciKnq/ceYn1qAGYBRV42UTg1VDwhPwCRCSmamg1zJoV0
	 9yFvehnoPUbgH+SmYyddHgF6F/klL5sTWpkSFeiO66NOLLIalluCZ3YDvPPGe0Zjn
	 WXW4JqWUfx23lKMJiVor+jq4xE1w8B7OGexbbon1tG6qZK1ODBOHnbi0denGTtG7Y
	 84CwiNnqYF8G7AWcjfJ1G/7OhZ9V2evU/wI0wIohXgBRTHWaVYHc3wUYaZCTg8eAL
	 psvvF+vqGq3Q1M5wDJm7JI39yVnDEokfPrV3EX6hNhoY3mcGstp9TOdk0FJbgHga+
	 MlUAQel0w5V1/w7VNw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mel3t-1xFBdp3IYP-00gK9d; Wed, 08
 Jul 2026 00:36:29 +0200
Message-ID: <58a76be5-12b2-469e-a9a0-146bfeb55773@gmx.com>
Date: Wed, 8 Jul 2026 08:06:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
To: Boris Burkov <boris@bur.io>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20260707191208.GA516053@zen.localdomain>
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
In-Reply-To: <20260707191208.GA516053@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+7ZGN0wlS2vl9Be4R6L+yGAgqG4RU9xaQvuyWG0Ic/dZI9P7vY6
 GRyLY7f7h9EeWPyjc8u82lZScxZHzXgSwujiuxKuGtBZ8w8l5mJgevKgt98EMrn1snA4t3L
 inqvVKnOIO5d5qbS8zGUmPIqhNwrdZxQVPt/SBpeo6h2kcgdUyAJ1dvB+vIIZG+e8yJ8RoZ
 b+/BGxJmIPrWQc3RiN8hQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:32Nb56ai9Mo=;c7ICrGcGgClP57JBvH7i2B0354U
 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



=E5=9C=A8 2026/7/8 04:42, Boris Burkov =E5=86=99=E9=81=93:
> On Tue, Jul 07, 2026 at 03:10:20PM +0930, Qu Wenruo wrote:
[...]
>>
>>>
>>> Second, and worse, it results in a deadlock which should show on btrfs=
/062
>>> and btrfs/070, I believe. The problem is that clearing dirty at this p=
oint
>>> results in a truncate being allowed to clean pages past the end of the
>>> new file size without calling btrfs_mark_ordered_io_finished() so we
>>> leak that OE unfinished and get stuck.
>>
>> Mind to explain exactly where the missing btrfs_mark_ordered_io_finishe=
d()
>> is?
>>
>> The point here is, we always have the folio locked already, the differe=
nce
>> is just in the timing where the folio dirty flag is cleared.
>>
>> I didn't see a problem that the changed timing can cause problem relate=
d to
>> btrfs_mark_ordered_io_finished().
>=20
> Sorry, my explanation last night was rushed and clumsy, let me try to be
> much more clear and specific!
>=20
> The key change is your recent one, that went together with the removal
> of folio_clear_dirty_for_io():
>=20
> 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs=
 to be truncated")
>=20
> and specifically the lines:
>=20
>    /*
>    * If the range is not dirty, the range has been submitted and
>    * since we have waited for the writeback, endio has been
>    * executed, thus we must skip the range to avoid double
>    * accounting for the ordered extent.
>    */
>    if (!btrfs_folio_test_dirty(fs_info, folio, cur, range_len))
>      goto next;
>=20
>=20
> and quoting from the changelog:
>=20
>    If the OE range is dirty, it means we have allocated an ordered exten=
t but
>    have not yet submitted the range. And that's exactly the case where w=
e need
>    to truncate the ordered extent.
>=20
> But with this new fix, which returns folio_clear_dirty_for_io before
> submission, the comment, skip, and changelog argument are no longer
> true.
>=20
> Suppose we dirty folios [F,F+K] at the end of a file and start writeback
> on them, creating a single OE for [F, F+K]. extent_writepage will keep
> looping through the folios submitting them.
>=20
> Now suppose a truncate races in and shrinks i_size (taking i_rwsem but
> no folio locks or blocking on OEs) via:
> btrfs_setsize
>    truncate_setsize
>      i_size_write // shrinks i_size to M <=3D F
>        truncate_pagecache
>          folio_wait_writeback (not yet marked writeback)
>          folio_invalidate
>            btrfs_invalidate_folio (folio clean, skipped, this is the bug=
)

Just a small nitpick, the problem is not from the truncate_setsize()=20
call site, as truncate_pagecache() is grabbing the folio with FGP_LOCK,=20
so it can not grab the folio locked by writeback.

>=20
> extent_writepage hits the code
>=20
>    if (folio->index > end_index ||
>      (folio->index =3D=3D end_index && !pg_offset)) {
>        folio_invalidate(folio, 0, folio_size(folio));
>        folio_unlock(folio);
>        return 0;
>    }
>=20
> which calls btrfs_folio_invalidate() which needs to mark the OE past
> isize finished but skips it because the folio is clean (same issue as in
> truncate above)

Thanks a lot! Now I understand how things are going wrong now.

But I still have a question, I thought we should have some kind of inode=
=20
lock or something else to prevent i_size_read() from getting stale results=
.

And digging deeper, for the btrfs_setsize(), the inode is already=20
locked. E.g. inside notify_change() there is a WARN_ON_ONCE() if the=20
inode is not locked.

Would the root cause of the problem is that we did not lock the inode=20
for writeback?

And if we do not have proper inode lock for writeback, then I think=20
write back should never bother the isize check, and always do the=20
writeback no matter isize.

>=20
> Now a bunch of processes, including a later call in the truncate itself,
> will hang waiting on the OE which never finishes because these latter
> folios never get submitted, nor does an invalidate truncate and finish
> the lost OE.
>=20
> Here are some trace printks showing the buggy sequence:
> # btrfs_alloc_ordered_extent
> 91.901347  OE-CREATE      ino=3D306 oe_off=3D3637248 num_bytes=3D73728 i=
size=3D4587672
> # btrfs_setsize the file, changing memory isize to newsize < oe_off
> 91.901392  TRUNCATE       ino=3D306 oldsize=3D4587672 newsize=3D2573711
> # extent_writepage calls folio_invalidate for being past i_size (905 * 4=
096 =3D 3706880 > 2473711)
> 91.901528  WB-INVALIDATE  ino=3D306 folio_idx=3D905 isize=3D2573711 dirt=
y=3D0 writeback=3D0
> # btrfs_invalidate_folio does goto next and skips calling btrfs_mark_ord=
ered_extent_truncated()
> 91.901531  SKIP-OE-FINISH ino=3D306 oe_off=3D3637248 bytes_left=3D73728 =
isize=3D2573711 writeback=3D0
>=20
> I hope this is enough to figure out which one of us is missing
> something! Sorry again for being so unclear earlier.
>=20
>>> This is caused by the other
>>> patches which removed the Ordered bitmap tracking to reduce the bitmap
>>> size, I believe, as we now use dirty to track the existence of OEs.
>>>
>>> Can you confirm whether btrfs/062 and btrfs/070 finish for you every
>>> time under this patch? If not, something about my test setup and yours
>>> is different, or something is different on the branch I was working on=
.
>>> I will try to re-test with your patches and my patches on for-next as
>>> well.
>>
>> I have not yet experienced btrfs/062 nor btrfs/070 hang.
>>
>=20
> I have reproduced it on two systems with your patch (x86 4k pages for bo=
th)
> and also while working on my own version which was basically your patch =
with
> a hack to clean up the TOWRITE bit only in btrfs_subpage_set_writeback()=
.
>=20
> While working on the details of my explanation for this email, I was
> adding lots of printks and it did go away in one build, so I guess the
> race between truncate and writeback is finicky enough that you are
> getting unlucky? I played with some delays but haven't yet found a
> perfect place to make it 100% reliable.
>=20
>> [...]
>>>>    			if (folio_test_writeback(folio) ||
>>>> -			    !folio_test_dirty(folio)) {
>>>> +			    !folio_clear_dirty_for_io(folio)) {
>>>
>>>
>>> So far, the best solution I have come up with is to call a raw
>>> "folio_mkclean" here, as opposed to folio_clear_dirty_for_io().
>>
>> I believe the root cause is that we can not rely on folio_*_writeback()
>> calls to do the sub-folio level handling correctly.
>>
>> I think the long term solution would be the iomap solution by tracking =
how
>> many write bytes are still pending, and only call folio_end_writeback()
>> once.
>=20
> I was not aware of this design, I'll look into it, thanks for the tip.

That has a lot of extra requirements, and may have also change the=20
timing of a lot of beyond-isize handling.

And the biggest requirement is to get rid of the cursed async-submission=
=20
from compression.

So we're still quite away from that.

>=20
>>
>> But for now, I think a quicker fix is, to de-couple the
>> PAGECACHE_TAG_DIRTY/TOWRITE from folio_*_writeback().
>>
>> The idea is, we clear PAGECACHE_TAG_DIRTY when the last subblock dirty =
flag
>> is cleared.
>>
>> Then do the same for PAGECACHE_TAG_TOWRITE, this time do not rely on
>> __folio_end_writeback(), but manually do it inside
>> btrfs_subpage_set_writeback().
>=20
> I have been testing something hacky like this in
> btrfs_subpage_set_writeback(), and I believe it is correct for TOWRITE
> but still convincing myself about DIRTY.

Don't be too worry about that. Dirty tag can be cleared multiple times.

> Just putting code out to be
> more concrete. I think it's clearly hacky, but it's something we have
> thrown around before so it was easy to start with:
>=20
>   	keep_write =3D folio_test_dirty(folio);
>   	if (!folio_test_writeback(folio))
>   		__folio_start_writeback(folio, keep_write);
> +	if (!keep_write) {
> +		struct address_space *mapping =3D folio_mapping(folio);
> +		unsigned long xas_flags;
> +		XA_STATE(xas, &mapping->i_pages, folio->index);
> +
> +		xas_lock_irqsave(&xas, xas_flags);
> +		xas_load(&xas);
> +		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
> +		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
> +		xas_unlock_irqrestore(&xas, xas_flags);
> +	}

That's the version I have submitted as v2.

>   	spin_unlock_irqrestore(&bfs->lock, flags);
>=20
>>
>>
>> I think this would be much smaller, and completely free us from the spe=
cial
>> handling of folio_*_writeback().
>=20
> Under your proposal would we still be calling folio_clear_dirty_for_io()
> as in this current incomplete fix?

No, no folio_clear_dirty_for_io() call anymore, all changes are inside=20
subpage.c now, just the extra PAGECACHE_TAG_* clearing during=20
btrfs_subpage_set_writeback().

> You haven't commented yet either way
> on your view of the importance of getting to a folio_mkclean() *somehow*
> to write protect the folio, so I just wanted to make sure we were synced
> on that, as that is what got me debugging this in the first place, not
> the messed up PAGECACHE_TAG_DIRTY, which we obviously need to fix as
> well!

Mind to explain why folio_mkclean() is required? Is it for the same OE=20
hang or something else?

Thanks,
Qu

>=20
> Thanks,
> Boris
>=20
>>
>> Thanks,
>> Qu
>>
