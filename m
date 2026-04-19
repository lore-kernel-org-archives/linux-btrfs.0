Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7172622
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 22:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776637827; cv=none; b=s82axNJG5G2RqLY5Mr6DepOlAs7+VHJI0usek9+qdnQCzY/E++tn1QcY739gypINVMVjm9JJytCHA7LqBd+Jg/1TNcsgH+AxxmF9qW5R24Svaj1hfh9hFyHTwRiE7MeK7/jBvX8foXUt44dlVDnZnfOQ2ldgmb40k3qVIWsuqyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776637827; c=relaxed/simple;
	bh=ZhI6CAwlgmKmXt0PEKO3iyigKC3F5DMJln7wLuZPyqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDuhlUYcI/WzfGI8Oua5JChZCH+HKJ7s1dJkfjekXU9inPzUheC+BnoOJ4H1dm6X3HktEIY4XH4prauCw1TS7Zk2rEgmqpbxD3Vl3rEdKf3aqsNQM2RKsCDFlId3j+mb9TRa00TDY1ciRuW+EbCuq73NbJFXfVBi4+kxqsOKfFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cJc8kqS+; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cJc8kqS+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776637822; x=1777242622; i=quwenruo.btrfs@gmx.com;
	bh=itFzjBB30cLLDn6SaLFM7jTdYSiWiF1oRwlZXcDU448=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cJc8kqS+IAQfbMhKfEPfPfP37/lCVwkIHedZ2ryFvaRsHGuY1Js56tgtAD7tOTjB
	 d09MdSg0wGLi0opNv/e9dI7vXSMwowOguzb6Z3LMlO1hj5w3ur3nawxuq0SLEt2/c
	 t/27QLhsvERaigsfeCmOit1I45croeSuUAeqYbbaUAOPGZHZATMEw65h46flE1SLs
	 20rcafzrY+i6DjvZDDDH8kuU0/qoWFS2N52GqFjCNiOmB12TzkmUyeIFdPdFfZgkx
	 gtd8qLCNEepWn3o+Gkx0dqFUOhwne9UTqwBMtQAxAXJzw5GAcOZUgx6izC3/bW0Dr
	 oPlfoZ/Yk71uciWutg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MPXdC-1w1qvM1B0k-00Qno1; Mon, 20
 Apr 2026 00:30:22 +0200
Message-ID: <ff32d6db-77a3-4a9d-aa78-8dff8400a13b@gmx.com>
Date: Mon, 20 Apr 2026 08:00:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] btrfs: implement FALLOC_FL_COLLAPSE_RANGE and
 FALLOC_FL_INSERT_RANGE
To: Paul Richards <paul.richards@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <20260418143808.199603-1-paul.richards@gmail.com>
 <92c96052-6619-4c25-8add-a85a4b76c060@gmx.com>
 <412d6926-8613-4377-8f33-3cf0194f685b@gmx.com>
 <CAMoswehjDpHm7_jmTPV_vKkqJSNKu5pCEDxmwGzAghhEwTGHSA@mail.gmail.com>
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
In-Reply-To: <CAMoswehjDpHm7_jmTPV_vKkqJSNKu5pCEDxmwGzAghhEwTGHSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:o2VYzZpzH/XRRHXwGMMBI2pnozqWIgJ0/spsyvOoP/uE/5as/5r
 BrF9xObGODYNqSBKsUdfvfKLRtHihU61b3YIx/P77xX5aCRTSZVTjHdM3d7K1ZczQXsULN9
 FB04NMZZP/bBDTj2bMW5ds1/kWxYIVPlt4jyTX4AuQ6aAtuIV/DmtLQIAu+aIlZz3dN5o5h
 +yZSzmThHO7SDi1FW9Xkg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bzy6E4D5GBo=;n7+n7OPebFEGINbKA7aL4gXOTXm
 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



=E5=9C=A8 2026/4/20 04:10, Paul Richards =E5=86=99=E9=81=93:
> Thanks Qu for your feedback! I wasn't expecting such a thorough review o=
f
> this early RFC. I will reply to a few of your comments below.
>=20
> For the comments I don't reply to, please know that I have read them and
> agree with them. If I follow up with another revision then I will addres=
s them
> there.
>=20
>=20
> On Sun, 19 Apr 2026 at 06:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> =E5=9C=A8 2026/4/19 09:55, Qu Wenruo =E5=86=99=E9=81=93:
>>>
>>>
>>> =E5=9C=A8 2026/4/19 00:08, Paul Richards =E5=86=99=E9=81=93:
>>>> This series adds support for FALLOC_FL_COLLAPSE_RANGE and
>>>> FALLOC_FL_INSERT_RANGE to btrfs_fallocate(). Both operations are
>>>> already supported by ext4 and xfs. The userspace contract is
>>>> documented in fallocate(2).
>>>>
>>>> Patch 1 refactors btrfs_fallocate() to dispatch via a switch statemen=
t,
>>>> moving punch_hole into its own function and decoupling locking from t=
he
>>>> per-operation helpers. This is similar to the implementaitons for ext=
4
>>>> and xfs. The allocate-range and zero-range paths remain coupled since
>>>> they share some setup logic.
>>>>
>>>> Patches 2 and 3 add COLLAPSE_RANGE and INSERT_RANGE respectively.
>>>>
>>>> =3D=3D Implementation approach =3D=3D
>>>>
>>>> For COLLAPSE_RANGE:
>>>>    - The removed region [offset, offset+len) is punched out via
>>>>      btrfs_replace_file_extents(), which handles boundary splitting.
>>>>    - All EXTENT_DATA keys with key.offset >=3D offset+len are shifted
>>>>      leftward by len in forward order.
>>>>
>>>> For INSERT_RANGE:
>>>>    - All EXTENT_DATA keys with key.offset >=3D offset are shifted rig=
htward
>>>>      by len in reverse order (required to avoid key collisions).
>>>>    - No pre-splitting of straddling extents is needed: the left porti=
on
>>>>      of a straddling extent stays in place, the right portion is shif=
ted;
>>>>      both reference the same physical extent via their existing
>>>>      extent_offset fields.
>>>>
>>>> For each shifted key, the corresponding back-reference in the extent
>>>> tree is updated via a shared helper btrfs_shift_extent_backref().
>>
>> After looking into each patch, I do not think the low level direct file
>> item change is a good idea, especially with your current implement:
>>
>> - Can lock the inode for a very long time
>>     E.g. inserting a hole into the beginning of a very large file.
>>     We will lock the inode until all file items are iterated, which kil=
ls
>>     concurrency.

After more reference to reflink code, I think this comment is a little=20
over-reaction, as reflink also locks the involved range in one go, thus=20
can lock the inode for a very long time too.

So long lock may not be a huge problem.

>>
>> - Possible problems with metadata reservation
>>
>> - Problems with ^no-holes collapse
>>     Will cause duplicated file offsets with hole file items.

This is still true, even if we only support the insert/collapse range=20
for no-holes feature.

The bigger problem is that, even if a fs has no-holes feature, it can=20
still have explicit hole extents. As the fs can be converted from=20
^no-holes, and the existing holes are not removed.

I guess the initial design is mostly to make converting existing fses=20
much easier, at the cost that kernel always has to handle explicit holes.


One idea is to introduce something like COMPAT_RO_STRICT_NO_HOLE to=20
prevent explicit holes, then it will make the low-level key modification=
=20
more feasible.
But that will need quite some time for such new feature to get adapted.

>>
>> On the other hand, with reflink the insert/collapse can even be
>> implemented in user space, with a proper step setting, we can still
>> allow concurrent read/write out of the reflink ranges.
>>
>> This makes me wonder, is these features really that necessary?
>>
>> If you know some programs actively utilize these features for real worl=
d
>> benefits, but can not be done through reflink, please provide them.
>>
>=20
> There is a proprietary tool at my $dayjob which uses insert and collapse=
 range.
> This works great on ext4 and xfs, and I am personally interested in havi=
ng it
> work on btrfs.
>=20
> Emulating in userspace is entirely possible using FICLONERANGE ioclt.. b=
ut
> since ext4 doesn't support that operation this leaves userspace needing =
to
> use one solution for ext4 (fallocate insert/collapse) and another for bt=
rfs
> (FICLONERANGE). By filling the gap of btrfs fallocate modes I was hoping
> to simplify userspace and reduce friction in supporting btrfs.
>=20
> However, on balance I agree with your opinion that emulating in userspac=
e
> is the best approach here. So for now I will pause my work on this patch=
 series.

I think you may be interested in utilizing btrfs_clone() to implement=20
the insert/collapse range ioctl.

The benefit is you do not need to bother the low-level file item=20
changes, nor the metadata reservation part (already done in btrfs_clone())=
.

However it won't work if the src/dst range overlaps, it can still be=20
worked around by shrinking the reflink length to the minimal so that the=
=20
ranges no longer overlaps, and at the cost of more fragments.

And you may still want to dig deeper into the extra locks and other=20
corner cases like the final truncation after collapse and the extra hole=
=20
insertion after insert.

I guess it may be a little easier to implement this time.

Thanks,
Qu

>=20
>>>>
>>>> =3D=3D Testing =3D=3D
>>>>
>>>> Tested with a Rust-based functional test suite covering:
>>>>    - Collapse and insert at the start, middle of a file
>>>>    - Multiple sequential operations on the same file
>>>>    - Files with multiple extents (fsync between writes to force separ=
ate
>>>>      extent items)
>>>>    - Files with holes (explicit punch_hole and implicit sparse writes=
)
>>>>    - Compressed extents (mount -o compress=3Dzstd)
>>>>    - Transaction cycling (interval reduced to 4 during testing, verif=
ied
>>>>      in dmesg logs)
>>>>    - Inline files, verified that -EOPNOTSUPP is returned.
>>>
>>> I guess that tool has never verify the contents, nor multi-thread stre=
ss
>>> tests, e.g. fsstress?
>>>
>=20
> My tests did read back and verify file contents. It was not multi thread=
ed or
> particularly stressy.
>=20
>>>>
>>>> The same tests pass on both btrfs and xfs (modulo the inline files).
>>>>
>>>> I have not run fstests which I know contains tests for INSERT_RANGE
>>>> and COLLAPSE_RANGE. I will do so.
>>>
>>> Thus I'd prefer a fstest run before whatever your local tool.
>>>
>=20
> 100% agree that fstests would be better. I started with my own tests
> only to keep
> things very simple while the code got off the ground. If I carry this wo=
rk on I
> will use fstests.
>=20
>>>> =3D=3D Notes =3D=3D
>>>>
>>>> This is my first kernel contribution. Development was significantly
>>>> assisted by an LLM (Amazon Q Developer). The implementation, testing,
>>>> and final review decisions are my own.
>>>
>>> I'm very interested in how the LLM is involved.
>>>
>>> You mentioned "implementation, testing, review" are on your own, this
>>> looks like everything is on your own.
>>>
>>> I don't think you're only using LLM to help understanding the code, th=
us
>>> it looks like implementation is contributed by the LLM.
>>>
>>> Please remember, you're the one explaining/defending the code.
>>> But as long as you can explain/defend the code, I'm fine with that.
>>>
>=20
> My workflow with the LLM was this:
>=20
> I provided a high level design, reference to the fallocate man page,
> pointers to the implementation of clone range in btrfs, and the existing
> fallocate implementations (for btrfs, ext4, and xfs). This was a couple
> of paragraphs and a handful of links.
>=20
> I prompted the LLM to produce a detailed design document for how
> I could go about implementing insert and collapse for btrfs. The
> document it produced is English text of around 2000 words. It
> contains references to internal btrfs functions I needed and a
> description of the logic I needed to implement. It has no code.
>=20
> I reviewed that doc, asked clarifications, and the doc was revised.
>=20
> I then crafted the code. I relied heavily on the design doc that the
> LLM had written but did not follow it to the letter. During this
> implementation work I asked the LLM to clarify a few points, and
> the design doc was revised by the LLM.
>=20
> During debugging most of the bugs I diagnosed myself. There was one
> bug which stumped me however, so I asked the LLM to provide
> hypotheses which I then worked through to solve the bug. I crafted
> the code for the fix. ( The specific bug was stale/incorrect data being
> read after the operation returned. The code was already invalidating
> the page cache, but I was not aware of the extent map cache that
> needed to be invalidated too. )
>=20
> I wrote the test code myself.
>=20
> Once the tests were passing the LLM was used to update the design
> doc to align with the code I actually wrote. I also asked the LLM to
> review my code prior to submitting it to the mailing list. I addressed
> some of that feedback. As an example piece of feedback it
> recommended I make use of unlikely() in "if" statements testing for
> errors.
>=20
>=20
>>> Still a newcomer with not a small code change will always attract more
>>> scrutiny, so please don't expect rapid review/merge/etc.
>>>
>=20
> I am not in a rush. This has been a low-priority side quest going back
> to 2023: https://lore.kernel.org/linux-btrfs/CAMosweitbAN5EPOgJCtrbkRAj1=
QSbsYt4uDGVMZ378YY7wjnRw@mail.gmail.com/
>=20
>=20

