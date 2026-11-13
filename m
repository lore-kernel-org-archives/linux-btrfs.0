Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794612841;
	b=E3Kf+bdo+I2OCnNEYboA2vgBPw7B991SlYPirQjDq4T3aneb5hAwYGGgh4PiXYFRumKi
	 4Z6uDcm6DI3Z8hKt2uh4f7ugY8yfxz/4jWPrmNPGlp6yKQpI2E9pmGIKmuo/YPlpzpKiS
	 4PRPNIDbE2uSkWnmx1e1jieEu8Vn6UCNdGxNvkMlA2i2M394ph/ahvgwy47B39e/klneI
	 pB2KWzm8hIVO29FWVerfGA5lqLOn7+B3ZcTgrjTUaDeO2fepXSFTEleItkMk/opr00HK4
	 7sNmAt6A5RXCPpvpLykuR9V6TVpZfCDg5EQhYfYCjCf7zW/9NxuVfcon9EL7tEpVMSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794612841;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=N8DIRTD/2rETVq3Z3s9gEUBbV94y0oBIsv6gNimizxI=;
	b=Rpbj8492gy72fuQvJO9rwkgeNcHQZ4c7/p1qsz1rW03yCqM//ZOybKIJnkCv/dkfoAmF
	 oepQ/DV7RL2EaTp4CBjmcVXl3DzW5B5g9ji7Ftn4atoeyDtj8KHSCae/DoyOtT8VtLhpW
	 Bn5otUilz3zm4B5yRrQ25yR2eKbj4I/T0nSZzKtzycApLHTf73T43M6Efv2w3xIzIn8zd
	 t7lVeTN2HlCuQemjRRvWwyWyOkxbA2K/uOLvCHXp+BGX1kBSKPcgTl26NIYkYUioybejR
	 mevv02kNhXzUbngRCsl01Hef+5MabRkjinD/LVzmZp72nkRdgJwir1Q2IBnJCvGAXRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=OrSkpSXP;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A88606A335
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 23:34:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99A88606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=OrSkpSXP
DKIM2-Signature:  i=1; m=1; t=1794612838;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:AABPl/ods7SVoDoMNRpP1hpcSlFR
   XQ47tjuZY7z7LYUw5HfaW5tkhYvYJaVtyatFGSxFxhpCeehxxQ1C+Gqv19NFp8VegvlBLusxVGl
   V0Xnk+1eFqsvWpnHleG0i3iXWSb13EEflUHOezNIPIbm2LK+zbigBkhemMgfy3zet9Knw1fBjsB
   bEosccSi3XS65Cd624kvhfap+wYBzUaAxj4Y2t+PJtfMeLM7OFTmbmXqQVGZr8kknR/rzx/oGo0
   URRxHOkAxTFFqzuDvk1fllv3KOXMMSkv1/54MsB2UXZEMVW9fYCwzNVr6Aowwai2gobVtXnu9TL
   UnEjHxiR5IJ5Hg==;
Message-Instance:  m=1;
 h=sha256:
   1DUFwEqpk4qV/zBcNKnaQQhbgJe4RpUmz2sxeZgtZLc=:
   W7AtE6GHDlpQEAsemXq5a60e6L4m5l7nX4eeW7IIfqc=,
  sha512:
   O5Ry5qiUAni1EsFBpjNvJlg+FVtVzdftRxl+UL55uRy2dtDhTP21QLjop9SUyHJWV/WAl9LRrcwQkkmKXe3l2Q==:
   G79UJNlBJDV988DwIS2NN8cXswIdZzb+tGRTuFTCQ0Ly2nKKrHw4+jf7+k/ws9TzGaQnamEBG0nGVKx5tcD0Ig==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794612838; x=1795217638; i=quwenruo.btrfs@gmx.com;
	bh=N8DIRTD/2rETVq3Z3s9gEUBbV94y0oBIsv6gNimizxI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OrSkpSXPaMphOLGGayY7Qk94H6MT5/aAo9R3YHk6VcQfPRISJUuREF4nKoRYorGD
	 s5wAFcQRS3AGNXQ348owO6I0pUjWGtAysNN7Sg9+sYUhp0Fqvp4109dEzV8Vnufk9
	 gF06+eVYOGRpIDLJuBTfHG+Y0s82C0ICCyg8+v5kTu6qG1Rv+mMZlLmrF4wFetnUC
	 C5IMcrwNdOO5GVcuBwvjX7qelh0gWtZQmI2ngqjmpy+6HaEBbBBnKP4hFIPW1Afiu
	 GqDxRNP5H8VWHtr5MPemguI1MKo5SmbMnGICd04YzT9FvfEMluMPv5+0BsLck5FiT
	 9w1/nl345l8c0A03GA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MDQiS-1xHadv230g-00FxxI; Sat, 14
 Nov 2026 00:33:58 +0100
Message-ID: <e3b11819-77e7-460c-9e87-06ae6af7cce9@gmx.com>
Date: Sat, 14 Nov 2026 10:03:52 +1030
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
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261101062539.1744605-1-teel4res@gmail.com>
 <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
 <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
 <20261109184712.GF4186782@twin.jikos.cz>
 <70aa1a4e-895b-416f-a3cb-195af489b55e@suse.com>
 <20261113163049.GA49432@suse.cz>
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
In-Reply-To: <20261113163049.GA49432@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Pbr2dpv3aM64bqYqfdwQtb8qaPj4aLLkF974PA4b80wXQwTu3L8
 hInV1zTw5QCgphYi67cyHgbzlsewrSadC9UCuo20ZxvYGJXdT/+a8et1UCpyPH40ngGmpsL
 oOReq9Ni5K799ebWqcA2teIrxeOsl2UIUlwq2vn4d32u3r9a5Ea6XxSMGTfFl0JwOgHV02s
 6iq2WIKUiIii1/TRGhS6g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2HVUBrMRNcY=;Uwb1qfRJE4G/efGy9zBc5kek4gB
 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



=E5=9C=A8 2026/11/14 03:00, David Sterba =E5=86=99=E9=81=93:
> On Tue, Nov 10, 2026 at 07:00:34AM +1030, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/11/10 05:17, David Sterba =E5=86=99=E9=81=93:
>>> On Sun, Nov 01, 2026 at 05:48:21PM +1030, Qu Wenruo wrote:
>>>> With that said, there are more problems with the ioctl.
>>>>
>>>> - No real user
>>>>      No one is utilizing BTRFS_SUBVOL_SYNC* flags. Btrfs-progs itself
>>>>      doesn't even bother it.
>>>>
>>>>      So all these fixes are very low priority, unless there are some =
wild
>>>>      programs utilizing this.
>>>>
>>>>      But even btrfs-progs doesn't utilize them, the possibility are v=
ery
>>>>      low.
>>>
>>> Obviously the ioctl was added so progs 'subvol sync' can use it for
>>> non-root users. I started working on it but there's a problem with the
>>> behaviour change between the user types. Root has full access and
>>> reports the progress while with this ioctl there were some problems I
>>> don't remember. The ioctl was designed to emulate all modes that root
>>> can do so it should be possible to get 1:1 output.
>>
>> Are you still planning to implement the full root-less subvolume wait i=
n
>> progs?
>=20
> Yes, but I don't have an ETA.
>=20
>> Or is this feature deprecated and we can eventually remove it to reduce
>> LLM bug reports?
>=20
> I don't understand what would need to be deprecated, it's a new ioctl
> missing the userspace counterpart to implement an unprivileged
> functionality where it makes sense.

Then at least hide it under experimental features until the user space=20
counter part is in a good shape, so that no random LLM report or syzbot=20
steps into this ioctl?
