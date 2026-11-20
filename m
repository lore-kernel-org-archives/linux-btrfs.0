Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148650;
	b=QB65SzIKmdfQ0ngLEgi4QDakhuv+t1QETUBGRdQut3lUIDiRcSlMwqELv/COZQZT3mqi
	 MqmoCH5CjdW5xREB3sDk3fjLARyV4PYqNRa/s6amTmgzGvh0pLu9fyOyjYwzJbvTLntt9
	 Z5mWicaGGdyFau7MO2Qt9YjT8wVHsnKDWPZphKEWPcKlK8FN/7DFZ7pxeISXxilxAyBDZ
	 2YLEOtnPhVuNkrvMeAciPa8SM1PJsBtvJRyTIibAABSnsAcox9I5ZilrbiVHoXIwZr1NQ
	 rSTbN+wRPVQHJhllPCwP8ESiASXEQrFiFP0rj3sYNwNg4QlzWDaFo+tiqBLJAuI5DLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148650;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=d38xmghv3ut9MZ0khnfy3x3PN9z/KqCJkWxMKjBF0DI=;
	b=uMgehpDvfsc05NeQxFGYgnV5IE+0z23u8w80bie2zcqXsjOqh5+dtLZyeJrOXgWC8Q92
	 dofqmFigODjabRcKjlkdFZzRYn2HJYvUzE+FZsEdwT3EjD7VDEvVMxUoqauzIjkK8CRtB
	 9lxIqWbcZvlNuKvbuIPNwM/85/2h1FdR/ggsNiifakkyOHnMV2e1rYDwIEGt6QfLeShJb
	 9fLqIIjvjyk6/ymDByqCYEYXagn+ohOnpsrjlMrm5fi2avPtF4dXPv2zOzK2l3JM9eTta
	 axV5LLbyS7rqVeqlrNTPBxaZROVLmYd+mMbXFzIfotCEJZAgKIaVjTm8TYh1Kst7r3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=QLdysbzj;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61713606A320
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 04:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61713606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=QLdysbzj
DKIM2-Signature:  i=1; m=1; t=1795148647;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:Jq0jvZy4ibiq5lI0BO8TkmXgRoRZ
   Xbopg+mNyjlKpXRzMY6U64nXn2hk/C8oppS3g+J5/eA923y2VFvdi+e2A/G7yd01b+NFa7R5tQI
   vC31VnTIub6Bsqi25f/RVqNms9mwiSHLeSTuBPAlUURAQdu5VdE7Wv0TouO04Pi5jFLSrdSv0Y0
   WAeM8Cq+BwhRETRAxi8GScT1NH/6TFgFngodOsII1bzm/3+YsxDFi1Hy8s7/TrTRzCYHAxWWhOI
   AiyP2kDvy0ucZmY9uJ/o/jHMjFvtK5wuHwiFRWxzM18mjwrJfmvkvp/c8fJFE3dq84VZS8xa3ML
   ycPgHzBxGt+H7w==;
Message-Instance:  m=1;
 h=sha256:
   Tfz5aSJlQVh1QtaEpr8zuQT6hlbm4JNaV+gsLTeU/kc=:
   EybLmCP0mNSmESLsr/BQE3abNkcAlBF0SqD6J0ZwQd0=,
  sha512:
   KusnNwbpcG/R/lm1DVlSO1Ixlhnv50L2hivUnfxU8uJaUiZAi0/V4HiNq86Yb9sJgDj1XHHENPDh8Pj41yQMQw==:
   nACzaKzV4ZGu75l0XSnWMfOnb187RsHe/jTCyAxr5C4f1513HHQjNXeEz7C1KHqZezBW7CmDYwTAYVxvbGRRDA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795148647; x=1795753447; i=quwenruo.btrfs@gmx.com;
	bh=d38xmghv3ut9MZ0khnfy3x3PN9z/KqCJkWxMKjBF0DI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QLdysbzjq80Tt7JPAEnpK8AxYijIy8+FTbJRpWYSo6LKRbjWTC2okVShAys3Kzh2
	 TYeqLbKERovTBpvOkk+OdNWoBpj1KFKI8tfGEumP2/y40BOPOHmOHQsdjLKW2WOnf
	 tKldj+Ygh3lhOjMzuLLY4yHAC422/WMX8nKn8DPvCKZNRRErbLJkhynSUoLF6tfy4
	 x5mH6DGV27mS1uOZAXqPJDuOTpR/8M9z9V96d6vsABUkJ3Vqs+PlRD/zDGi9Tmjg5
	 wb/5IlH6L/iUvNSFsa9CFDbqSy7loH9z+/tzB+mRkpgcexsh8yULvVh+VPkfj3yI8
	 8n1lpvD2YAy+lk5C5g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mxm3K-1wV1D626Bi-00yIDp; Fri, 20
 Nov 2026 05:24:07 +0100
Message-ID: <7bc1911c-f800-4470-a942-c2b9e839f485@gmx.com>
Date: Fri, 20 Nov 2026 14:54:02 +1030
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
Subject: Re: [PATCH RFC v2 0/6] lib/crc: x86: convert the CRC assembly to C
 intrinsics
To: Eric Biggers <ebiggers@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
 ardb@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
References: <cover.1795137348.git.wqu@suse.com> <20261120034220.GA11532@sol>
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
In-Reply-To: <20261120034220.GA11532@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4lSLzLQwhy2c4b0CTitWPp8bSEZVBivaDDLZOxCZNpKpgu9eLB0
 mqD9TwtVgxcSfyiJdAUWpm/n6fGWkuXVWLGuU5iffEl+igA0zNcbH5WCdToU5P+eEycxjiy
 PwrNG6/x9Oaj8Uk6ftNiU1U9X7+MJZ6DU2lIKIYtiTmAwofYtMiC2MAaWxFbv34M8ZUv/0B
 IT8JzKzJOAjL9OE1UmvFg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:H96F7yQ3yxY=;urS1073B95dKThWOwE+Bz+dRZ+M
 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
 Q76/Wn



=E5=9C=A8 2026/11/20 14:12, Eric Biggers =E5=86=99=E9=81=93:
> [ +Cc x86@kernel.org ]
>=20
> Hi Qu,
>=20
> On Fri, Nov 20, 2026 at 11:48:58AM +1030, Qu Wenruo wrote:
[...]
>=20
> Thanks for exploring this.
>=20
> I think we should be honest: this would be a negative for
> maintainability at least in the short term.  We'd be replacing existing
> well-optimized and well-documented code with an experimental use of x86
> C intrinsics in the kernel, with many of the original comments stripped
> out or made inconsistent,

That's indeed a huge problem, thanks for pointing this out.

Sorry that I didn't manually compare the comment part before and after=20
the change, that's all my bad.

That's in fact the most important part for readability, and my focus on=20
the generated code blinded me on this important part.

> and signing up to fight with compiler issues
> (including inconsistent support between compilers, having to use
> error-prone hacks to use the x86 intrinsics in the kernel at all,

To be honest, to make kernel use intrinsics with current latest=20
gcc/clang is easier than my initial expectation.

And even for ancient ones, only GCC 8.1/8.2 are really problematic,=20
again better than my expectation, but still requires extra adhoc fixes=20
for certain compilers.

> and
> inefficient code generation which in some cases might not be solvable
> without contributing fixes to gcc/clang).
>=20
> I've used the x86 C intrinsics extensively in userspace projects.  So
> sure, some of these compiler issues (minus the ones specific to trying
> to use the intrinsics in the kernel) are things I'm used to already.
> It's just been nice to not have to deal with them in the kernel.
>=20
> Note that gcc can't even generate simple loops using vector intrinsics
> without emitting unnecessary move instructions.  I reported it years ago
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D107892) and it's still
> unfixed.  So realistically, we either need to simply tolerate bad
> codegen like that, or actually step up and actively contribute fixes to
> the compilers (as merely opening a bug report does not result in a fix).

Personally speaking I'd also prefer the compiler to do a lot of things=20
better, include not pulling in the memory allocation headers just for=20
x86 intrinsics.

>=20
> And as you mentioned in your cover letter, a lot of the code grew in
> size and became slower, especially for short inputs which are important
> for some in-kernel use cases.  So clearly there is some bad codegen
> going on compared to what was there before.
>=20
> I kind of feel this could only be a benefit in the long term if we
> actually go all in and commit to switching the crypto code over to this
> style of implementation as well.  But that area has a lot more code.
> And that code also has another thorny issue: when operating on secrets,
> it has to make sure to only use x86 instructions that are in the DOITM
> (Data Operand Independent Timing Mode) subset.  Yet there's no compiler
> support for restricting the used instructions to that subset, and no
> announced plans from anyone (Intel, AMD, or otherwise) to implement it.
>=20
> I'll also note that the hardest part to understand about this code (IMO)
> is actually the polynomial math, especially the Barrett reduction.  And
> yet this series deletes or greatly shortens many of the comments
> explaining it, leaving unexplained operations, factually wrong comments
> (especially for the Barrett reduction), and dangling references.  That's
> most of the negative diff, too.
>=20
> So if we're going to proceed, I'd at least like to see a version that
> compares a bit more favorably to the original.  But also I think before
> diving into this approach I'd like wider agreement in the Linux
> community (x86 maintainers, crypto, etc.) that the x86 intrinsics are
> the way to go, and for there to be a path forward for DOITM as well, and
> hopefully some interest in improving the compilers too.

Sure, that's a very reasonable argument, and I'm definitely stepping=20
beyond my ability and initial objective (just to use the same intrinsics=
=20
code in both kernel and progs).

I can definitely wait for more feedback on this topic before continue=20
any future work.

And to my initial objective, I'd check other user space CRC32C=20
implementation as a reference for now.

Thanks,
Qu

>=20
> - Eric

