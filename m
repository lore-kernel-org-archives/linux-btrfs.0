Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794605763;
	b=UtD89nSqhNZZz2ICBoxN50szOvZOZRzY+8jCaRNOzP6kf5UaySG/EIloAHc4j8mbHZHj
	 SyuWlNTmxpNxrWB8G6VcxCj5D4DT/GSsOxo0a/um28VWpa/yfw3pvaTsFYHsFH7sJiKu+
	 C3OIcB6iUJ1oid3aCSBkoZzObjGrCd3RcLviy7u6ptfp3RyjRNnwptAX0e48Ut3mD9i3z
	 OPkW07vuHTVyOKTKJXzMyhBhTJSBMa7RmY1UVicyfnM8R27Xz5W51xfT6qfUqm9eAFCpc
	 rRQ027zzzruhWYFVe4KYa6PYv8p5vNnMbG4Lf98Cs/1LVxT7trXpoH16mT375Pmdv1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794605763;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=mwFtB8TZUj3cwhrGqLfshCOrMIcfT5UqimrEbEv0SQY=;
	b=mxg+vI2L9AxA/L8uNNCeU5Lu3e99xcuYo2rsVYFnFtUw14O2UmiIDoeaNsA9mqTmJ6X1
	 3kp/dPsu9uzlh463XayuxJRGlPv7Xz+TJV385DZ2+2YDRa+ARVJAtOgqNMyO2LTAPbKlq
	 83C7IX/ggluTTO0ywNv1OWW32WuiizbVI7U8dIeBocduCSpjpGs2R066PbKUu6hQuEFh8
	 ox6mEig1/tt1qUbYO0G5FA73eLcgaqO8kb24dS1cL1lFTdCN0MkvNDuSFH8ZsObMW6LCW
	 RwGTpDyYcJaAw+3R561N4GAHnMdXKhOS7jo/ljxUApTy3V2NOjM3+xwWfz3MWRJLIug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="BeVsB/+a";
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7608D606A331
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7608D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=BeVsB/+a
DKIM2-Signature:  i=1; m=1; t=1794605758;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:M/x+1a+XtT7nWb7pK4RiiKxwi1+J
   HkulpSZ2lc7Vb/0ZM0pTdsocEtyt1a/T+ToLx5QFON+kBHZIBf+RPSn0b3os+7AjtJ8Egu0nkhx
   /NekINt+z8c2Jde5GNFXtMseC1p7TM3AKzYBwxhIPHwycymqEolFKl2e14ay8Em8kcg1IkkWej7
   psIcMbEFZuHPR/WqoPMW8MRpRURtsysaNVOtkjunkX8K20JDwe8qBPsmpSEDtlA5rL4r0iuLiaf
   HUhF9h3HozSWc4PhyeQiJL9fPul6V0QL3RUV/UARkj5eNwCVv2BSziHeIuojkpoPp0YQ1HTKqe5
   mu639F5A66e8UQ==;
Message-Instance:  m=1;
 h=sha256:
   Wsce+u8kcaQocl6si0XN9FlxZZnUWPBRAvpLBQpFwV8=:
   BEU8KywfwKfr/NUkEfhj3tCe+9eHfkwxSYlYTjuez7Q=,
  sha512:
   jRqHIj+3tv/jq1OxmKdm+c47GxsoVkzG4aPJipMJ6zwx4ZUsrTKSW8GQQ5vFNrYGy7okptMxxCN+LNNFjnaBAg==:
   OQIPyDxNlCq4LfgYQsJff6FhYT4F7dTUuBRfrheZTbPHMEXl38ti3lk8RQLxvks23a6qexDSrbzRmpFAhvEtMg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794605755; x=1795210555; i=quwenruo.btrfs@gmx.com;
	bh=mwFtB8TZUj3cwhrGqLfshCOrMIcfT5UqimrEbEv0SQY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BeVsB/+awIjg9P8mX9yUhi3GvevNsSx4a4MTZp8KnGbnbgamv3VFiyyoQWnM0jii
	 5rh3dC9OJAx7L9oKnXeC7JEdBrJ5BBmNDghUUxWEFeV1LBnF9nW1nk8BKw/AGspfi
	 domBVwKtWF/DtcQAVuhHoagmCdeBVZZwjsv9wUXRqOAlfkZU3rV0Ewd9TOLdjlf3T
	 ktvP7ieizCv6G05hpovllWILmRWlmc1ID5wFITk/cDlok7n+Sb/NqMpbjIPz99GfO
	 72B6y+oVgAXrNDkLBIJfb2RCYKiePLiWDj9TG3f+SN/tfdyOq9byv8ZuKczPXqp88
	 zC/+nm20L0ueEoGjuA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MFbRs-1xFOXE29sM-00AHE2; Fri, 13
 Nov 2026 22:35:55 +0100
Message-ID: <700e302d-c85e-4bd8-84b1-0e6eb8565740@gmx.com>
Date: Sat, 14 Nov 2026 08:05:47 +1030
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
Subject: Re: [PATCH] btrfs: fix bytes_may_use underflow after a failed tree
 block allocation
To: Vlad Poenaru <vlad.wing@gmail.com>, dsterba@suse.com,
 linux-btrfs@vger.kernel.org
Cc: mason@kernel.org, osandov@osandov.com, josef@toxicpanda.com,
 fdmanana@suse.com, boris@bur.io, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org
References: <20261113170926.1468850-1-vlad.wing@gmail.com>
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
In-Reply-To: <20261113170926.1468850-1-vlad.wing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0clgWBEQ2nLDr566Zy7Nlvwbq1wwHeLRTpDpcs5pnjEthkGLORH
 mUCqPB7iQ4pa/MuBWJm/N5Og+ZMRmInfxZrvSRquf1xszQQraqkfS76dmKRvQs/1YhwvH0S
 6uH7m/5UxwL18rmGHTlXd3fHmjjOtj97Dc3Q9Zm/5oaSvY/LGYrFTftDA/DkKnnh4qKLspT
 9I9OTfQ0qcnOGgTt3vBIA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VPEycHK0gLU=;FwtOASrhN+BuClygRd5Cd1pDMOY
 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
 9K3zS5IbXSfsmWjE07chVc=



=E5=9C=A8 2026/11/14 03:39, Vlad Poenaru =E5=86=99=E9=81=93:
[...]
>=20
> Fixes: 67b7859e9bfa ("btrfs: handle ENOMEM in btrfs_alloc_tree_block")
> Cc: stable@vger.kernel.org # 6.16+
> Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>

Can you simplify the commit message, not only by a little but by a ton?

I'm not against LLM generated commit message/code, but the end result=20
should still be human reader friendly.
This looks very ChatGPT, which I hate a lot as chatGPT commit messages=20
are a pain in the backend.

This over 100 lines commit message is definitely not human-friendly. I=20
hate if I need to use LLM to just summarize the commit message.

To be honest, most (if not all) of your commit message can be extracted=20
into a single call trace graph:

     btrfs_alloc_tree_block()
     |- btrfs_use_block_rsv()
     |- btrfs_reserve_extent()
     |  \- btrfs_add_reserved_bytes()  <- bytes_may_use -=3D blocksize
     |
     |- btrfs_init_new_buffer()
     |  \- alloc_extent_buffer()       <- fails with -ENOMEM
     |
     |- btrfs_free_reserved_extent()   <- bytes_reserved -=3D blocksize
     \- btrfs_unuse_block_rsv()        <- block rsv +=3D blocksize again

I really hope you can update the memory file to let your agent not=20
generate too much words salads.
