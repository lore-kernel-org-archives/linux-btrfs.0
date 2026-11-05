Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793914384;
	b=KeJuBFJ3pKMHNJnkQdYoomRzuCZ3u4fhSW8MSAmzsfVUxR+GdrAZv9uu9pkhlWrgC2o4
	 cvI8LKtgBKihpTa09RaD0oBazRrfUBzfFFXVevBK2InXSpt9UZmlXc30R3KqAsTqRvCWs
	 QAXwWeH5BjieRrUgnQDkNf0qxYdkTg7BqU2q4f5o2NMOsjIdyb7LBeAIjplsq02jv2bI5
	 LKMDUnP+BF3DU26p38YYa6jB0mI9x6otPHwFTwhpTBt19sqRG0e5Gwnyd4uH3Wo6AoRyg
	 EBSiq62d2+yWP6UnIh6/boWd4Ar7NexO0TKY0wjltFO/m+memXbTju6C7/8a5rBTJ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914384;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=mYWQMgmtAbrrOg+zxyPg6GK7jDDVD20JhuFz73fq5z8=;
	b=BeAXYoe6IJOOnPFSnIjwb+DZ+KyKk2rcRjM8gaY+PM+DU/qQaM6Wudt32bAXLDH3j04l
	 0YutYxxp2iPYDwny4xAMwDvMA1eyCdVkNe6B7cT6jS9cpw/0OGWi8ufhGmIGPrxnrp/FH
	 NLJa+14xe6nyxUy4kep2Gj/n//O1fVsQUu3E1cNFWAuEfvkzjzJOWNATD9rGwssBhkNgp
	 Qy1rI3kgk9WmHCaipAsek7AuxGZIkXq6jEndnSsx3c2EI/IN/Q2KTg3O6/FUCiNai+AmS
	 oDu58CoHl2P68w/ITLCRZ+x0IpIgSt3wg/NN0tofyqaGeC1K3dPCXdJWwLXn99kGzDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=lbFjtvVF;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00C3606A32D;
	Thu,  5 Nov 2026 21:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B00C3606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=lbFjtvVF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793914375; x=1794519175; i=quwenruo.btrfs@gmx.com;
	bh=mYWQMgmtAbrrOg+zxyPg6GK7jDDVD20JhuFz73fq5z8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lbFjtvVFQbCXZF7+uIAPymgA5CNYle1h150B7uNPxUCVtzyetascPLGWpyaLRjZ3
	 WPVu2wqzYmG/nAenoaPQnCxeDdPPb2GetvqPZGGirxfAJch/8jOvDYpdKDrxlT3lk
	 tw2rV+v5ZS3aEzJJzpEQVBAVuTTYltBhV+JkBo8yM5SuJktR3KAgoF43C3dqKSNV+
	 CcphfTJxE8I1ceQ3jfEGDcKIlKVuIqbxYtfdpLPTfw7Y5EbqzgNaIsfAQwkp+HfHq
	 C48FqTvZg83x5AYASlrqQkWsol53Rjbe+c+DBpmp4sy+mCdZADMUvTF/U2MCf/X8h
	 wWzJPke93uSKP4MR9Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MF3DM-1xIRFm0uM4-00Ao4s; Thu, 05
 Nov 2026 22:32:54 +0100
Message-ID: <c2166059-7964-4f1f-b87a-2798c96a2db9@gmx.com>
Date: Fri, 6 Nov 2026 08:02:48 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: tag all metadata I/O with REQ_META
To: Mark Korenberg <socketpair@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com>
 <9e2c808e-6edf-42b4-a70f-5fecc8f1eb69@suse.com>
 <35f7fdfe3efd8e949f9abfb1411de4db@gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <35f7fdfe3efd8e949f9abfb1411de4db@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Pe/pHCT2wUs1rPg75ChhVGl257iIoC6zUkk9uvzQEd7ND+irX/4
 GJImy7bowE+AYxY5EAFKWbVr+qGYe/OKxfL47t9tfqEO3/hLPGqOUY7psjwrjzMn7D8fVeo
 Z/6SFWGXOpMt9AKz4sefq6Bv8CK8rvrOPveWgFD3BKQy80CsHp9cy7fzR00YGxzVderQiHW
 n8kDpMhQulWD0ayCFJZYQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:C4BuR3+fz30=;oy46kO6+TPpHgHUtW4ZBpls+2W9
 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



=E5=9C=A8 2026/11/6 01:17, Mark Korenberg =E5=86=99=E9=81=93:
> On 2026/11/5 19:37, Qu Wenruo wrote:
[...]
>>
>> E.g. a btrfs over a LVM/mdraid, and btrfs passes REQ_META for a tree
>> block read, then should the LVM/mdraid pass REQ_META to the underlying
>> devices?
>=20
> dm clones keep bi_opf, so LVM and dm-crypt pass REQ_META down.  md
> raid1/raid10 pass it too since e879a0d9cb08 ("md/raid1,raid10: don't
> ignore IO flags"), which names the priority inversion when REQ_META is
> cleared.  md raid5 drops it: ops_run_io() builds the per-device bios
> with FUA and SYNC only.  I see that as a gap in raid5 that the
> raid1/raid10 fix did not cover, not as something to follow.

I'd say, for all reads (RAID56 reads are no different from RAID0 with=20
rotation), keep the REQ_META as long as it's an extent buffer read.

For simple writes (everything but RAID56), keep the REQ_META too.

For raid56 writes/recovery, scrub/replace/reloaction, just don't bother.

LVM's pv move won't know if the data it's copying is metadata or data.

Although btrfs has some clue, it's not reliable clue, and furthermore,=20
it's not the usual metadata IO pattern.

Regular btrfs metadata IO has its size limited to nodesize, and never=20
merge the bios from btrfs.

Scrub/replace/relocation and RAID56 writes/recovery doesn't follow that,=
=20
thus I can always argue they are no different than data IO patterns.

>=20
>> If not, I see no particular reason to strictly follow that for
>> scrub/dev-replace/raid56 recovery.
>=20
> md resync cannot know what it copies, btrfs scrub and dev-replace do.

Scrub don't care. It's just reading out the full 64KiB in one go,=20
doesn't care what's in it unless there is some corruption and need to be=
=20
repaired.

And again, the pattern doesn't match metadata IO patterns.

>=20
>> I'm more interested in what you really want to archieve?
>>
>> Just to make the REQ_META more consistent?
>=20
> Not only.  The ublk zoned device I use sees REQ_META as
> UBLK_IO_F_META, and its server caches and places metadata differently
> from data.

That's to benefit regular metadata IOs.

Scrub/replace/balance doesn't follow that pattern, and I'd say doing=20
such metadata caching may not cause any benefit.

Furthermore, I'd say the optimization should be transparent, and should=20
only be an optimization.

Their optimization may even not be suitable for btrfs' dynamic chunk=20
allocation.

E.g. previously one chunk is metadata, but later the chunk is freed and=20
re-allocated with a data chunk.

I don't think it should be something to follow dogmatically.

>  A tree block read issued by scrub or by RAID56 recovery is
> still a metadata read for it.

In fact, the scrub case is exactly an anti-example.

Scrub should have lower priority, no matter if it's handling a metadata.

Scrub is always working on committed metadata/data, and it should not=20
compete with existing metadata priority.

>  The same holds for the in-kernel users:
> BFQ prefers REQ_META requests, blk-cgroup issues them as root to avoid
> priority inversion, and wbt does not throttle them.
>=20
>> At least I do not think it's a good idea to touch RAID56, unless you ca=
n
>> prove that mdraid is also passing those flags.
>>
>> I want to align btrfs to existing RAID56 implementation, not the opposi=
te.
>=20
> I'll move the RAID56 part to a separate patch in v2, so the rest does
> not wait on it.

No, I think it should not be done at all for RAID56/scrub/replace/balance.

>=20
> Still, I don't see what it can break: it changes no algorithm, only
> the hint.

The hint is already against what we expect for scrub.

> And within btrfs, metadata writes on DUP, RAID1, RAID1C3/4
> and RAID10 already carry REQ_META, because the per-mirror bios are
> clones of the original.

And that's the only part I agree.

>  RAID56 is the only profile that builds new
> per-device bios and loses it.  md raid1/raid10 pass it as well, see
> above.
>=20
>>> +static inline blk_opf_t btrfs_chunk_req_meta(u64 type)
>>> +{
>>> +	return (type & BTRFS_BLOCK_GROUP_DATA) ? 0 : REQ_META;
>>
>> Missing BLOCK_GROUP_METADATA_REMAP and also handling BLOCK_GROUP_SYSTEM=
.
>=20
> Both get REQ_META: the check is for the DATA bit, and tree-checker
> allows only five chunk types (DATA, METADATA, SYSTEM, METADATA_REMAP
> and DATA|METADATA), so METADATA, SYSTEM and METADATA_REMAP are all
> tagged.  The SYSTEM rows in my test show it, METADATA_REMAP I did not
> test on its own.
>=20
> That is clearly too implicit, and it leaves mixed chunks out.  In v2
> the helper returns 0 only for a pure data chunk:
>=20
> 	return (type & BTRFS_BLOCK_GROUP_TYPE_MASK) =3D=3D BTRFS_BLOCK_GROUP_DA=
TA ?
> 	       0 : REQ_META;
>=20
> and the comment lists what gets tagged: METADATA, SYSTEM,
> METADATA_REMAP and mixed chunks.

