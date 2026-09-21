Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074464FC346
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 21:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027183; cv=none; b=lkovofM61+hoaUmRk/h1koj9V4+tP3Dc6jNE1NFPnJXt1ZpOmwQUkssu4k/MGbewEfqrIHRRSDp7QzPa0Dfe7JGeLCLInd+szvUMExlUs+DCAIUXZsxNfyNv4WhEkE357x3k4fJmEm681kCQBBzFiYrVySBLlrPgDX8UBOCDz6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027183; c=relaxed/simple;
	bh=imp/aAXlonqBSauYQTrozBOzTnWCO6KPEng+2X7+B5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DctcjhA+Zq8st5nSM7cd/lFDW93VWeS3ne2MkDOEWiHiGRBBhPZoSgXIyu2unUXuxz8YZklKbJCcqhq8pWOBJMLkB2ycLdBDoEnqkKLJ28XkcLbp7iSUONZy5Mi7L5LoR7Xah6q55hA+aNvafRJ8tcvaHZyNHTYvLfX9d5weSco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=gPh3pFfI; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="gPh3pFfI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790027179; x=1790631979; i=quwenruo.btrfs@gmx.com;
	bh=MS+kQy6mYp2AGtAVYJDxQvHCmSjDTTCEqA63e6hwxKo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gPh3pFfIgDMg1vBbsrQXZ9lyTrrDAw9jePHGTu7WgmBhVI7huAmFR/B/hhzwMYNF
	 019VzH6Er0g+vt35ekkh2sfvjE7X8lMBUOQ97czQUnX+g7G6y53j/b9Kkd7aGrw54
	 7DjB/BZHtGYHebQPRHBuE/ciT4zI0I6+hrQeEUqd2MBpHZD6Cto2pYz5O8DiAEAMM
	 x7GFjUK6jlwM+xg8RUQChztCRTubq7tdm6inFnpfDjIr7jJe3Um/QLJRG33HLrGk8
	 nw4oXrUN2kSveFWhcRdOQ148fUr4HIE45dDk6gylIFvfOmoCsgqI2vaH9oCF1crRO
	 d0pK7B39DoqZxzikRA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MzhnH-1wmRbM39mb-00wVCq; Mon, 21
 Sep 2026 23:46:18 +0200
Message-ID: <2c895064-f5bc-488b-8bbf-b6b9b7e842f6@gmx.com>
Date: Tue, 22 Sep 2026 07:16:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
To: dsterba@suse.cz, Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Richard Weinberger <richard@nod.at>
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
 <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io>
 <20260921131220.GE54722@twin.jikos.cz>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <20260921131220.GE54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oA9Sx/bxmAN5qZacq+FZIITHJkyEfArk9EQOw5+YKgFfXn4HnRQ
 kJnmPRejzzRdctk+NZ6ht9CeQmyj6rJFbTOuSNCuhS0jFmjSD1rY57rwEu/rqQqr9Q0aQrV
 5sO3XDNN6MvyHog1rPBJZP08sXnHeZTx4h08nLjm9xk4G1z78JhLGO9GD03PLRkkdLo8ZM2
 Ey2Kb0zDKbQAa3EhvrOOw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GMxJCbsnRfQ=;Jcl2H9BVz8mX08DWK596xZieGk8
 9HpmRGnx03deU2GwgyoRPpFLCskNXEg7cLiY5W+IYY1G9LYjxEVRHW3Acw7eK5jEUGwSrtajl
 kHRD6FRx7TI7GeDs+BUiptyG+m6fsZdAA7LttJyvHRC6GjRMAJQKfRC5V8P8Z1ijbDBAfCawe
 e1Jf4bozrVuIhTlLtAm/+sOFFICmx4mSenktSP2NCXOM2K8pmnm2Kglsy0QPPekFFQ46y0J+z
 n200ygtK1cOpu9iUjtxnLWjOypQeyoI9dQ+Pjk9rDiKF3z92pXWbOXq16kTcjpmSywiHhL4nL
 glmsp64zh66+nMxNmLOgZBkuxy5GB2F/IJbmOmtvikHjHXEuzknmC0mUbchnKBdyc6Qz2GQ8G
 M4kEH91kLXllXOT8DJlLGWeAvmfhZXBpgl/9PXDuREET+JvKBq9To5RZJg1nCysTQEJyu+cD3
 i9jnoaORBl1v1OD1XbmpiqifoK1sX7uI2KE8JTFI3QyWissK8+2Fmiw6hRxmzgpQAX0eseQ6g
 hcjRIcbrMLHPt71Gk0+wcLoTU/gxUR09//1wEHC3AhOcfKGNblUG6HQdqYd8PYU4FfPzZxqMc
 YONS5PCvk1WY/1NR4dndnKB8eyEfRMg2+nNQoAM1agJ2088r3oT0BKpEbmoBQUHq7M4QsM+i5
 qF8mcVLkbYAhr/rqOyZiotctphSyGV7Z7uJk6D4TOWTtO9fxyee7EXyKcylG1KhsXznLXHho3
 +v6mHxZfrixAkc97Got2bahIM/rsCMtofVTB5W47zSWMSW6lBXTRRlTfY2rJzGlzHx3DGBhJo
 0MgEf4Cic8GshJplYXcuImVZ//dzm68XVJ3zTOE+4z5ifRRqPYMyY4Py5rIkiwf+J6Sa3UVvG
 JBlY9Q0GFYfFNdKUkuUV0GrTcQwuY42N6jHNJvGxMKDOCPcBOGIRaWT2TCZaTTYjCHHASUAIq
 Zi2lJffDOQds4RSDMNJ9zfGKFpimzff+LIVrg+6TAnGcXQaQZJqJZUFmgY52XyxC72cfm5O/+
 jYMF71WqOtFIJNUynFaGzo2h7TaiyNHuOS6UKV+QiiFdgl5ot+CHBSrXTEAedFGFyatkO5Gl/
 wiMqqidqLJWPTZ6eqvoKatePXidvGmnaBF8FyJoqCu6t0bQOr4NusrkjhbtDDOOT0llbLD9i/
 R4AXV0eCuEdOqC7dCS/IsFZJMz9eQxG547Wez86OnDo3X/VpJrNpP7HJ7/XDBE+XuTjnxdPqQ
 4iYlMXRFAicNNc0Oi85D4HVsI7ZwV6fnD0jz5x9sAMi79uMPKZvyh0YHl2Uk/M2l36/jIYhOf
 SAFZadjXD02w7b+b6hKdTqvwn72ikGYFYKU2b5RRvmjJPSLxQEo3/qh9vCsdM0aurtg/h82X0
 OfMs2AHsnqsk6DN4aaHfGjV9DOtzOfHma5VxGy2pfuQEd/QceU4BAzRzlcj3ypynRPWC+Ld+U
 M+Qk0xBA9C+x0hD8xCc3/gSA/k7+4NlvO0ljyygFVDdQAEon6FvVBSI9vGT8SSpsnrpMLK0Hj
 D6xEMaLksaQx+sJ6WOm7cxUTW18e5SkwGa7YdIpYl70goERKdY22NJaPpGzd+h1KZe5m9DL/A
 ncr47S5BXDc6mio1zegHS8gSzuFe906zIcDfpw62+7WAuWVyfmWgxH7yOsLMF6IvjklC+FPrv
 PceKjH8XT6pCe89v4kvTzJpalqpoJEZLtEk6/lj20TnDySBJpHCo6gmZDESEcFKxRjQLXVWxG
 88IoZZYlm0HQ3G9BofbUkDCPLZxY4pqVbTT+9/PLQ+jUPL7aiSI90Dew+xxgtwxrtnPlsGFCG
 KINT0LA25hHM1b+MxwkhkxL+ax3O6oTVYm+vK6Q/C4EfcY9AoVundQyaFrtSUZep+lwUqUBt5
 dF1Id356Iq4R/GyyPepX1YacM2qxNMMx4bWZCFYTkH8DvWgV3YZqMx28au9RYZrkLucm7Q9U9
 zQ0Asyj3zxx6YmDiguiDAmN5QV8xjdfU5SfSW4t1FSByL0TTbQQrF8RZQkvBLsGwf3zvd28Qc
 m4KoZKCX4/C7BiLoyDN++bi4+qZ1UnaKVLrE3I2MsWn/ayHkZNfr9vSGJ/zaAsMR3CypRkDb5
 dR/TsHkoqD2SoOPA8jhWBr2ryN2pm5j4hg6BXfOn4ij8c67lT2LEEdlIgRM37GO8a6slaD4nC
 3qIae0o/kbLFbiSs/I8jrp5pU2gQJ8yJTWTAW8xgbYr1gdod5STnjfF4pSxmcruZWZsj+t1d9
 3RmjMfxhePaSlj09X0MdhbdaznA3oYX1qeAgPLdIFchWgh6/m4w3e8AB4kT1m7cnUVYv2xrgp
 1th+mwg8PmbyQlldP6mLK68JTUsXOmIJ3/iCMhyi3B9I39i82r4uy+AGCCZvkqJHXcxM1zz6M
 S9XQfnjOpzJ9pX4woT/0CL0ubyOjyo4bc24cj0D/g3FezshN+0Wl+Z97JYQcP9bUpT8unNcHn
 b0wwQQ/S/wxK+6MYnFFVmAI29xBSIfjAfr0T9H1C0PbWDA3z8zn3TMudSuho326LNCp/asTPl
 5KfogqeiwKXUb3Mw2nq6o+D7YRrosiaCqmGSNAu1uuu4GBZ4zL2m4jL4ywvNFKDdb8oWgdXSe
 usE33hkIhCJP81udHnrtLj9NzrcOdnzmYilrR6iVmX4RqSalPzSnkrTufIMFDH7ULiP3Pf+W7
 ze3GnYnTDXYSmtvdIbYTCJnjZXOpPhUWQmtPg0TgsxW1vqEMxxqMFzYJn+OWfyYBNk3xMkUmS
 RpyNDpu/B+Y1ye35zKiQmbx9fKQxESsFHVJos8txWoPhvz6nugQ3TlUtJS7156zqglExw+AeF
 YXSGp9QfV24tF/8rMWrRcLUPrR54y7x3wQMzhAxIupJY2fjANaC2BI32Th2Rn9E5Ykeg2+Bv1
 Iiwm6Sl4wKcOtRTtmXuwH///RLmNFUym4Oan27MSn5J8JWp4bk7Sq5Flz86OLrcYv3x3dSz2F
 5Ik1VBUo0ze8wvAkYV2v47/c5C2pjMtv4ODKWVuwowWPFIPMXFQQgirtcqXJCoXdQPMdzINqf
 9HAEl9l5WyWgi0mvNuJ8AotSetjjoZzX9AT2YViEQ9guoVeCo7OxWCO5rxuW1BEk1te6svKA2
 h3dNlzt+n1HA0EZfvN/El4ywr+usD1lEiuBnTGsTK85Fq6mt8ECJSrX4dPJrEEDyyDi8k14KB
 FK7TpFPoz+CGLpdcggJB0B+24m8FeOtZ8wmH+8mZOOjcL+8euL2CsMMggCuWDgNveUCfnoaRN
 +B6AGfv+9Y/qvQS00z9TJtZ+yGLhNWCTQ59yO9hBBSveIm2jx1r8boFdXn2fyJ3Qs3YbHp4E4
 ZbRRXqWAW7mjDfE+RUXAj/SezIoCmbeUbKxz7bhv6dHuYRuhxlJEVyGwuskn16193y3xIVqSp
 /mrMpcxR7qpdEu37yz38cRQDcelQgbS9mDeJliHMIfkA4hOUjsdw/EDlnW07kgmPkhY2lF3N1
 ctjVQa40zkqypkq7wizXR1Rfxt48Dt+wdNxo6oGjlBNbgU60K+thnCI26MhbDMa8YUWr7ahuZ
 3kYl4YOK/zPUqPGLH3TfdK62yLsSoqPEN0hTK/ecT+qyjpi+wDn4AhqEBiXgsbg8flBsL8gHD
 US9t4xnVSVTVvmv7T628h0paQUORHg1ShpoFDaXdinULkVzw3L7pzFzQF5Mm9xh9HF18MLR/+
 YD71O+ER0dsQ4kxnIEeCjV2MpwDNIFBPuBJ30g8VPKRc1ER7YFBZ8bdrketPmU9+CfxCL4AQI
 gOZckH7sMy87bunZC+BaqyhKuEvHbeMeto2maCCl523Vbx2Z3u2jcZJID4Q4D3pZknHdfso/q
 hL5bvfx99GeXQ4acxtS1czAae5haNa20SbQ132JFmmhO1xMZU5xQzaSpotGsQZNRnsbjl2VnC
 a8qMDWeLW6Rojs4LFbYpOjP4VgvjbUKyi1cuZrNagwHsY/Cef3Pmjd3vbnDkgrm4P294ypt1H
 GEnGnojQJCIiVH7oMtZi7yjzoeLTny7Q+B+QG1ZG0hXRkWfwjsd+Xg7HROOmEmQJ1PLr99MCU
 SVq4502EedY4Boh7UPUdyk05WqHP/QpexeqjHUuMP0X5D+gkZ1YVoMwfrN8vuLQzhKf8KCydE
 bXa59b8gHu1fZ0xXSuDTRAQ/8NoQIvF7E1XmyI2568OMH52PnJ2uZMPMm9ExU4vULN7n9awjJ
 3hZL1x3f1oTcv3Qn3DXGzys794d1x6UH4CDq1xXkzr0LSDkzvZz+REcEBtRiJ9H7ukaItcPTk
 P4n0etG5bGSC+KTg4qjBEV92jL7M4yJ6nB+hY2lfKmJowbhJMBqsTc0RQFJK6iHNRxfmoL166
 C8W0vjmwXm4rp6SmJZ2IZVyEbNjTCT8drtNsFCqvhWBlSTTPcTTw079yrrGmSp5eoAqSbj5Ml
 Y693et4DnTGTjozkKDFkPS1JEur/2Wt8apI2O13JhC0rUKBPDiXvUgOQFvOb7h075wIG9Tpfb
 fN30NfHzrJd1DS4A4bFELzS6BP2U4MUFNHM9U3EHBj1aBnk9GTIctbu5Uu0HMl4iSEoENkqlP
 Cu3afzLGLCS2xIYuRdjqTiNmnaoAan7/UzxNOzBiMvWy3T2JnHBrK6v+gfsuLNekHPosOWzEq
 FMywDIUYhj6U3L7FDu31DyW9YdbpbcJdXA0GdJSgfjdp3B0t68/e5dQWVfQaJVOxy+O5vtBY+
 p1b5SBlKMwvVseYZWV+oY32195RzOSHMbKhubnpdZF8Pl55P7wATOv1uGj2MO9Mswmuv8w3nh
 9jwDaBJTPgIYwjx5C4NSnDi95xFovmX1pXRGbJSLXJpIeDoSMzWcKq9nMlGh/yhIKeFIpxEQ+
 XHSbZDHxcaG+dJC+gzMoP2LrpUJ3hNlYMAKTKJaWqmOjJMf778NE0cczzm1odoNMTSY6wv9kD
 jh3BmynqysqFGUAgrWPAYuvOz515ob61SxwwZ5IcrI7/ElrsNQ70yxHzPDJD5GxfcuvwD40kn
 4I6kI12iSOiEm6s4Ht1ycZqXJRIzltP0h+JKVk62Pp0ujPGWoP5UUokM3+kOaKJH7sr8c/sjU
 58V/0F9lXCUSe5XdxVnGa6aJa2u3MansHGSGnM2hGmEL5OYwZa3jqFabA6bPJjYMdQ5ypEp7s
 cz4299UZB3+eE4v0XfB8oE2vYXhxB4wvKcSKMNUvgPwbBWQz1k5PuhKRfv0X9jBdhNaNAP2cF
 GUCytP2fAiT+Lb3UL7RcWueCzmhpsaZMloqqetvI+FPF0STNeLEcuLjdooVqxr9WXbRA2losH
 Qt79UkSBpPNivnO2UFgCMrF6oFzMr061X1w6lIgTVwob7LI8n1ecjtJyzTt5PJOENglu8QS+2
 PPbL/WFtNzDg1FdX0Oy5m96X67S3GGgU1oMAWjLtkOWV+e4IqwTNfrBVJ61CAhExTiY1W5dqm
 PMyGj+I/Idn4NamL32IY5a1WeIRpeenudFusOHfn3B9ZngR/h9ubMuavnCYqffJ5oXSE/QoCd
 6y8eyw+NLnysJDQziNnGHhx8JSOktsl0LD6JyZsGqDL6QAJ7+x6feBgNFy2AGETnGkhevJpk3
 NAf6IMHt++MmgxyB/Eh5YtYA9MrByow8/Wj9oZy2sO1UXq08HFxglApqPFp8C7baJWc9MNIk0
 hrREhWGzyJz/oTFjlRnC5YPFKB7whDib95tiO0DIjQsUKvNzghHtue+GECe3xZ7h4obg3OqO7
 skiIMrKct/xrQRMDknYBtoYYYIXmDHj3ZfXOUb4dsJB9M28u5f0dNg0nAfNm7jBt6Te7woqgi
 BXq1zTrTSNxz8iP0aZcCywsghLaPB/wIsvsIo4ngPLnwLiCFt6tVWuX4p1WYUc1zHgF3D6wsn
 jLO665pJTZnA0tDNZWdf4mZ9le6puq584itBCd/B4JI33JHM/yrquWEVDxTm0cQNxyqYb5HRj
 HdjmW4ZtN8zU8AtUFFtFzDuMe+r2o84nvJoY8k97w5uAYnBjJTauTfwwSn0rbx0nT0Sq4GCEv
 zkhUBWsFVw7vpAu0HSoIqzg76g2vLnEKwCRWuo51Ox2Sqb+w01lPH051/niaIUdaRnvygwN53
 i7J73qGYmjH7NvLxfQXRTshOUTbjf2OqhN3zgb0NTn5UmjPFOjJRLFJnD5ja4hslKSzzCM3ya
 09u8oqS6HZmZlFVD4bBCs2h1XGKLTZOeryZ2ZKg7



=E5=9C=A8 2026/9/21 22:42, David Sterba =E5=86=99=E9=81=93:
> On Mon, Sep 21, 2026 at 04:36:51PM +0800, Dongjiang Zhu wrote:
>> =E5=9C=A8 2026/9/21 15:03, Qu Wenruo =E5=86=99=E9=81=93:
>>> [BUG]
>>> There is a bug report that a running qgroup rescan can fail a pm
>>> suspension:
>>>
>>>    [ T278489] Freezing remaining freezable tasks
>>>    [ T278489] Freezing remaining freezable tasks failed after 20.003 s=
econds (0 tasks refusing to freeze, wq_busy=3D1):
>>>    [ T278489] Showing freezable workqueues that are still busy:
>>>    [...]
>>>    [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 active=3D1 re=
fcnt=3D16
>>>    [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
>>>
>>> [CAUSE]
>>> Btrfs qgroup rescan is running in a workqueue, and when the fs is
>>> frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
>>>
>>> But a sleeping workload still counts as active for the workqueue until
>>> the workload exits.
>>>
>>> So the qgroup rescan item will sleep on the frozen fs, and fail the pm
>>> suspension.
>>>
>>> [FIX]
>>> I strongly doubt whether we should even use a workqueue for the qgroup
>>> rescan workload, a kthread would be a more suitable choice and can han=
dle
>>> fs and process freezing way better.
>>> But that will be a long term solution.
>>
>> Hi Qu,
>>
>> Thanks for working on this.
>>
>> I recently posted an RFC series addressing qgroup rescan lifecycle
>> issues around quota disable/enable, error cleanup, and remounts [1].
>>
>>   From the recent discussion, I got the impression that full qgroups
>> might be phased out or substantially reworked. Is that a fair
>> understanding?
>=20
> Do you have link to the dicussion? Phasing out current qgroups in the
> full mode would be a functionality loss and we don't have a replacement.
> On the design level, the qgroups are general enough to cover the COW
> design, sharing. The compression was originally intended but IIRC we
> don't account compressed extents separately.

The biggest problem is the insolvable nature of tracking the owner of=20
every extent vs changing all extent owners in one snapshot=20
creation/deletion.

This means qgroup is only reliable with rigid subvolume layout, which is=
=20
never the common use case.

And all the current workarounds are killing qgroup limit functionality,=20
requiring endless rescans again and again.

>=20
> Reworking could happen, the performance hit of qgroups in full mode has
> been a problem since beginning, but I don't see any easy change there.
> If the sematics change we'd need to add another mode, like we have the
> simple quota mode.

For now the only major user of qgroup original mode is snapper (for=20
subvolume cleanup policy), and we're already pushing snapper to not=20
enable qgroup by default (although no good progress yet).

I'm open to new designs like simple-quota, or maybe "reference" only=20
accounting (making it almost the same as the quota files supported by=20
all other fses).

But I do not think full quota mode should be a feature that should be=20
enabled by default.
