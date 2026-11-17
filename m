Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794945643;
	b=JML7rb9Wl1jpzm0dyxwYM5mLHygX3LPAWofaH7lHfSwoGk2lxofhR4NubK3LZ/28b8x2
	 Qoupjd7oUYfljBGl11kixU+P71K2Xu3oq4b+P6ekYZbFlYy7iTHWm4afUnQXs/PIiZU6O
	 6yXkp0at92KoryIlkzisaZqYJPpIpTw3OMdjTmAIILCzzPk9ewIUSFnxMdG5mHFpc9lxO
	 cDfvvvpsDK6IYR5bcWnlTDtCedoqs+M8E0A/g/z0TylnmkuXiSBSsY6Eut4PAdbAgxOGr
	 90AyZCAemGUpDXCiAn/2bbcUq8mNJeO6JDREhx1FpT/KnYpHLY6dqZ8GMHPwXsGphqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794945643;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=t6CCrfnDrtyNMBJEsVR/rcLVnu6kStlpp2AMs7MDbrY=;
	b=TodvH36s9/XAh58g+2XPYN8EyUa6joT1heLedNaFjfBmnNg4bYuWHxEgKd8uC6/HYZgW
	 ZOjxOKvZgQPA8bLPngUJv9Z6g6A7Yk3D3Ao4R2xztueRuaMvPGdCtIiOMFl/qFE9nY5pj
	 SbXlp28E8d3WE36YXXYtTKPpmAXJER0N8hfp1OgAv6S/uYbv4Xv4IEpurTbUpmCI2Pxgn
	 XBEp9wYLH7TtKjmLMt++2emgOBIUapgkQMxzuPN4WgcfEj01ehQRhnYB8Ez9AgrEkpVEq
	 FJAwEe6URII4C36eXMCzJI4p8x0yZqRBJjWc7qp2wTHaFr1mxBaj3wB37+3NDxQ+Ziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=dQMQcRbB;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C09606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 20:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76C09606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=dQMQcRbB
DKIM2-Signature:  i=1; m=1; t=1794945640;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:I7yr9Fupci308ZevpBkbqAK20HZH
   0lfBidA9LM39WUBDEDViQ18eMveqaZsTgB9FjBcSfDgBSo0maT8NC7+0xbcN7m7jqfWwYnUWGQ4
   7zS7stM8R95ZvDCv/2T/cgnhBTUjNjyZhLAgK1L0VkjFaQiItveH82Fm3VF5lSDUOusOh0s/H9+
   F+kIugWoyY2rIYd6Y/y4a2MMmsDCQD9ovSYvpZ/8iEfRbfKM4u30gQ8DwjxmFiVMVmZ4RuEtcFd
   ZTgqhIdzme7gvfRHPLtSwDxdPXyhSQNxBGkEI3oqKqOXSmEWFiOQ0lZJa+hAtG+4l/B+WCG+kat
   nmt8r2vaKpyMFw==;
Message-Instance:  m=1;
 h=sha256:
   pkdVpqT4NW1eXpaksl1Bkr52jQs37ej5Wlu66PE9L+A=:
   t6CCrfnDrtyNMBJEsVR/rcLVnu6kStlpp2AMs7MDbrY=,
  sha512:
   rjogsenk9SqG6M+Db/LWYB7gKHz+v6Bd8NnIjeiBcJeAEB+yrXLCPSQ9nEqK0lTGFsHZPt7wzGsrghMyAYIeeg==:
   PQVWEwSI8Kv/aI7RGleXK2FEwoG30ipAnaY9nOa8b8QTw45jT2uiepDXANyyXH0ZEElBH4SMe/6wa+Uo9Dvffg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794945640; x=1795550440; i=quwenruo.btrfs@gmx.com;
	bh=t6CCrfnDrtyNMBJEsVR/rcLVnu6kStlpp2AMs7MDbrY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=dQMQcRbBMz/O0S5ZMESaIOptKuLgpA4o16YhQIeIxwHOPqsm5eRbKFr7cfGkAb7h
	 Z77+8bkfkCWTmfVRrLeQNHrhtp9XGw4Bl0GOYqt3bzXY7TTRE+s2VhoIIkAF/NPcs
	 8H10sSoD33Zc6re8TsNNWqDofW+imLiBy2RHdbG826wIDP4atd2OiFNr5Pv24l4sp
	 2V3xG+kHrEs5EwbdmP+tGGLspbLm2D4Fy4lge+Sr4Nj/ZPuGl6xgbLfwrKNqN9IYD
	 EndNRd05QdfdUK363zVozoNrJmIKib55NNnaBnlW+5hsxDwG9/s1jBsy/MotP5GYO
	 SaH65GGHPytveZZzzA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQvD5-1x7BmC3Vax-00TBBj; Tue, 17
 Nov 2026 21:00:40 +0100
Message-ID: <ce9f04e8-a5e6-478b-acf7-e2ad56e0c456@gmx.com>
Date: Wed, 18 Nov 2026 06:30:31 +1030
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
Subject: Re: [PATCH 0/8] btrfs: assemble a multi-device root filesystem
 without an initrd
To: Ismael Luceno <ismael@iodev.co.uk>, Qu Wenruo <wqu@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261116224316.11237-10-ismael@iodev.co.uk>
 <fc1f9f58-71ad-410e-bf03-8b27e607ab76@suse.com>
 <20261117183643.36afff2b@pirotess>
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
In-Reply-To: <20261117183643.36afff2b@pirotess>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RLPp9hS6hkhQd/IDDBFcpdRixob60IyaY7MDrGA4PG8TMq7YNgo
 ru6qGlUswGZGLl311NCVcgrHx0R2wmsIjgMCGP6I49PnHziXQJ5etuZgDjbcJQeiCQ1yxKs
 5vw7f6RYGnH0Sqy4AF7i8mVs7AZIJmSzwYvrxYucF3LeGh3tQx+AR0wpLqyrl9v76xM7pGi
 mNOTkQVQyr0y38TmXW+1A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Wk6bA21xBZc=;XqEqAU6Mm8kEOr4iraYvlgv+tTU
 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
 7pFs1+4zrge25aCu0o8+x8=



=E5=9C=A8 2026/11/18 04:06, Ismael Luceno =E5=86=99=E9=81=93:
> On Tue, 17 Nov 2026 10:11:46 +1030
> Qu Wenruo <wqu@suse.com> wrote:
>> =E5=9C=A8 2026/11/17 09:13, Ismael Luceno =E5=86=99=E9=81=93:
>>> A multi-device btrfs root filesystem is normally assembled by the
>>> device scanner that an initrd runs before mounting the root.
>>
>> What is the problem here?
>>
>> Is generating an initramfs really that complex?
>=20
> Why depend on an initramfs?

Why not? One should not put everything into kernel.

E.g. what if the customer has some custom udev rules for devices names?
Now they can not use the custom devices names during boot, which they=20
can before.

Shouldn't this count as a regression?

