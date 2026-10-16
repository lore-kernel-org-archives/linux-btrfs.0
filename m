Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C11135AC10
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792188935; cv=none; b=uoZImgUkjf4BMip69GhxswNZaolCq4qlefkbzgYkLGr7l2IiVWPwmr6ikU/+9/NZqEfI/bIzSMgP4JVwUt9qBLJfb0S4IeVSYmbz2azEa8X83L4LC5CT8RioKt94gTs+ZPq1PqSHEEzDIaY/eXWvultc9y8ouCb/4DlH6DikB7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792188935; c=relaxed/simple;
	bh=bqZ0tH2133C/W0TRD51MaBCJrdNwY1JeCB8TYHe08fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VPyb0Ip/T7pyUvYbsvtpLc7uRwDlUza30EjAVvUe+s+E4Siuj+0p3U/XIa0i08PYaHGBKTBVvdqPIk85KY0NRk8s6+5aqVfVonelggAGVAeSMLTK0JWbYFeiIXJWfdl0iTpb78Kc1c6CKzH9AV7jAR+wQ9PR0BOpX7X4QaFUwP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ixF3ddD3; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ixF3ddD3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792188928; x=1792793728; i=quwenruo.btrfs@gmx.com;
	bh=U+IDFo3c6LcaWZ1LssS/uRXvhylgrLS8lpInAEykx9M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ixF3ddD3OKCvkCtNX8vOA056ncvD3Ao2CKTja+Yzoq07rSabGlLJJXqO/3L5xbAz
	 wX0kv/9nBYogGx8cYh+vR9rOrwFLgFOGM+yO8ZFPVThXWHEc0JLimN92RS3ahDzu0
	 KPRvBCw0glM3qqhyjkqHJHestrqi8QiUBmIdcvDOeM9stuummQoNG2rv1VDBjhSf0
	 drY3waEHIER7vhWSYM137HyAE7tXgIjfqXYLMNvurlz6LoyG9HzannzriuyqGkRVn
	 hpguTV6LsU3LGU6+9TEXMBEEQeO9GPqpGV+EJgJbRaawII9bjoUaLpNSYddIgP4oq
	 vrCQe29TlYYZImhHmQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MzQg6-1wMaml1MlU-0146Fe; Sat, 17
 Oct 2026 00:15:28 +0200
Message-ID: <2c4c5be3-9382-472d-bfbc-b2b93e669144@gmx.com>
Date: Sat, 17 Oct 2026 08:45:24 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: scrub: fix lost wakeup and hang when cancelling a
 scrub that is finishing
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <81444a955b6914c2de9fe6c7c097cf27ef734cfa.1792168555.git.fdmanana@suse.com>
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
In-Reply-To: <81444a955b6914c2de9fe6c7c097cf27ef734cfa.1792168555.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:w9FQC1pXC16RdfrD3tEkxbxRUieKk9Ee4kk/9zHehVUvx6sCJTr
 wDY2unI/8KpWlVJ3dkZuEoYvZjoXLnpDIvn+SWtBl1zZnoBBg9pAYamxMWrhqbWhaDs+k7s
 e3JiTGou4SGi3tF7ynCSFEhp7o/4SD/7/tOnUY94oXHnm0fUwtxOVPDdze0VsiBwZXH2FAm
 wJ2yZJGfrvcL6dvVny2Hg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kJllzdnqRRU=;OoY+1mqTlOx3maqeu5Y0AqnQ4EF
 aNMVL7AQ8aUO41O4nYZ8R+NZe1VDjpYzF9OcbbRt676ndbciCqdyHL4zSbFIuDqF5Ki2CC6dV
 9d9Y8YsZ6fNOBEg0f5AV6eeB8iB4s7JIxTFRWYO+I2KiacLsicV137e4gaIArOPe2g5hka1Ep
 P7U1t1kFmCi1FoP1B6nHMWN64+6hNHhUKtvtom1Xvw3Mbpe8GpB5xAtzDXioqizY695DL/hBN
 P+li+m4tpDN24hGo5taKCkQDht3g7o1vq4cmp1GZ9TCeCE4vVIUJu3axBpayRqopzNs61YS1c
 ycB3xRzS4PkAAMsqMs8outaoJU8U/D3tdb5zBehVm5vUhdr3NxwKPSylY4Xplw1ll6jtM7hLa
 f7+xTwa/uJoOp89ieSpTsuoa5QSsYyxWkg4EeTLJelPs218R0X2/uqzOlkitXU8+t8f6FiNom
 509MaGkcrMn6vAQjzNjzS7LOq0WUXdHZBDH8GQmuIc4r6e4B3U9+GsWqplSMP8plpSx/zNAe9
 zhIgtgDisXVHiVRhFHfSXMljNhy4bR6XsSiUAEUJUtC1plcemmAhka1RHG8FMRe7nLfXAzNEp
 noTZv+3YprV85DMH1x4dSUk4jCm1mIdxtBFjkJwKDieqX3gREdTznLdU4c97lLl8aDxEHMU7/
 w8Rw0nzv7D9gjsUdEhKngrfvlorg1TFLXH+FcG2qTFbK5UMpfDhhAVTF2pLvHH7+WVslS9Ilx
 5Jql0nQyQ3XNb08XRfs44A4ZRh9qKuTN/2jCJ9nctzMs1+xjR11qjqO6C0AKU4FVcne3WqnbT
 /vNqqBu18THkSzCGAlRYOyv6747bmLMglh3O0i9xL+lm3QcXTF0tp49S3ZsbqSl8m4VyOJkxe
 q1li0B42DS8X1vI3izpD6h7rJbTYDjFzORBn+rtQHDOPvkzy0wXkOzBnPijUfGb2SJ15FfDIq
 9xaNPCMvVsQkneKEEMRg5ddMCd8cO+fe75+hE5l39dviQZ0l/s1ULzqInewUGbtTY2Zqu1kWn
 3I9GJQkhcW/4OTHyz6qk/4NJQjDyRujNJkU/Qh1HAiFan+FCUTqg5yihwMSoTydu9ThR7YoBy
 ZVqXAudmsuD5JAT7AS+MD9pkm1mHI3Cf+o9lUnVE3yiE1XZGQBSaYrIiLCLTSBak/5lMR4rGX
 RMBKKUN/x/6kfT5o29kBo8jsG1lEQYbV3unZgpPwzqWpTx3GOKh6hlMxgLDGIhb5pNewJYCf1
 KQtr1VsMeopRAASeWyWxrPPmlVZDVZslBgQcO7TSOlvtGvdn4pTJ7XCgJt0Yxk+0seZqY+V8u
 5zIgYp5FSVi7Ke2j/htfrWAo7T+pBhN73mxQABRUaKNKB9IFxATRAK+dwH5ZguabPFiJsHWZE
 0s+QmHqS0wu3wm1viAT2Bjoi9M5rt0zuj59VeG7N3kVHBbCJ9tfWPSnlOpSoLK4UT3N+/lXaE
 La14YqKghqn7H/QaY5BVOc74FvkIZwKCHqhng2BdoLvddITmqgQOsK2awKPbLoGbagqqgPveC
 rVQkbHgECkOzcd8HkLyeSengTpNp+b1OlX/RsulP7wziT4xXGgFQC+SwsfNfW6T/OFG/6Fl/A
 jrQJ9Y0hmSQYRrxNzymE/raNZdKmEG3YZIxiJkMf861wRRN4dERzuOCzc2cF5T7dE7AdGVcQk
 YRjHvxhRMblzeECxEB2yjiOGSrnqErcuOJfjr5C0BFGJTDdLpVUnewhlVCtM2VoVhCgQ4bD7N
 yrg4xyxOhhod0JUQiNFOEA+0vhByK/q6wQnyTVN9IUD6F0ZlHigzB2IdF/eyu50RkcLUl/MJS
 BZSY3ipLR7YBinEtMRd0CzGDCH+cMdwgH4hrjy2skksdgAWBRoPZYWutzOl8kstZz0Qzn57rn
 uEr7h6UZrTe8GSOKiqxdNtwp+OSD65Mw4fVX+BJd3LC3R3jKovKH3zdPxMqXzqHm3008prRKz
 oPs88ICIrLPLWKNVaQqfE19YDGqXVHm1/NIFQRRSBz/zUWps6I5VadhphcPfjvnWsF0qSPTsF
 mXFlPqQLa1inTOre7BkUh3JKUpQOHEQRr4vL13u4sCWofBacI9IZwjC8hAmFAxMuyJ3GNsDSK
 XULrggx6knAVwfQH1LEPvX6sfv4HBzMc4OXMFZgl4L829c+8QSJL9sQe2/njW/rBxw7fvC5TZ
 YB2yHkd9hncgbOgahOC9/D2rLaFDolTseWPZ1MJNnwxQwXvgIv3bAqhfpo68mgP/EwUGJohA8
 iHf4woR3hcEVQApHYbZC3DnOpTRENnpsPei5C3ZkGuDijYEFAUGrNfXMu9e0AvVc9WGDl08pv
 AgUecVt33J04JjVQDsyasZp37bc0wm1pRxPQcQBi5aqX5+X+P6tdhxaIDDOF7PK+clfHJHtJo
 u6M9iu/Xhlh6RkDRuqFUBl5iHX+JIGHo6ZERO08H7qkSzOkRKSLFgCgxareAx5rzHzja89MQa
 jOp+GWx7bA6eKiriCCJillcs1T1wkeVoOtDTlxXugdlQ98Ys6DisoyXijziIGnTyKXXihDZhT
 xuXPLcSDevb2gWIYg2o4BqRAYxFw10Pa6+Q6wdbQw9U82GBAQksztRXbVhk9GYtKb9Fn8PQbd
 QJ2uP8xr7YXn83Wxcky2Sr4To1YTmPK8wSYJu2KcR0ylsYV4DGlQaaEEWAcQK1CgSGt+lmGF8
 uvpxNZzksSGrqLD/ReUzORnAsQyiG7qkNRGPvo/7zMGFlTPoiQkHhRPYwBFDGYXC8tNVpSwq7
 9munvddbw68coc82o5/4oDcSuRnYbtDndTKOirgtz87B9KNNctvV8P159pskbigXSdcjgTGSQ
 u4gHbYLUIkyLBITvYY4cuEhWBoLljWNZt796tu9qkktb18E7qMDNdEo7136j5z6L8edYHI/16
 q1xBhq2c8U5wOzU4yDlpjA6O2GGbdsg9YBV4uAL90P5hEKCOF8LqwVeGDLKNABSwkoTxCwAGe
 HlxOdtOAljYbBhqqCImHpTPBNFJu25ckGzwhdVL345dQscW0eoGhadjY9abDKK9lHdgzJLQxH
 Iy17HcKok0Gta4Hq/kquFKjmo5O6U/q+6Vc0D5tF4VLwGhMwa+ZNcDA8KJQ5ARi0MOPGR/yRj
 /h/qEdyF4iMHAmZK7u/WJTCfK/5+ZIbxdHtn5idBI66PYJ+8V5rPFEGnKaiRD/tnxkzr/7/6L
 HOKWGKWBwJ038ALpM4P3Rxp8C9ggbJrqrg8ojdGHNaJApp5uRaMoATpM52di5fDRrnnCikRVU
 B59cJCEa2uF63aoHVlkwTJgcZFW/WrswxtWHFxhPsAST0m5n76KZkBUopEKsVbp3bjFs6vfMs
 nFaQtIWZjKdf21rXS0oNdx6+tGW2a+5c99GHV8ej7us65bL4ZdCafG+9Z7nakHHKsAvDhuBaQ
 iWbW0xAaA2M9S0uZ+bUUwh2S36DDdJppRm7U2yuDlXia3YooR2N8i6NmQCoX0UE5WHJf6yuAT
 RG5Kcrt7dhgrwLmc2F4+X308Aeem8OQ0CFtH6xjYqqPKn+fziQGaGGgdF0ow1ez8zw9ilX3E1
 pR4NDJzmEAWVSBYP2Jiiwp0GQf6nFGBfLlnTLvOpIxRpPl6RSGpe6SkIzLYLFs0aNjEw9Hveb
 a3UmczHGnE2ppHyG2qGeYkf8PwFbTsoxRFvLZIH9taXvACwzgx8/Y5Wfh7S87Z5AL6PiOpOS7
 ZonCzbsFJ8bYoyuLmphFTI8GkwYBAE+D3cU92mGl1pgCbWdSC7OPqHFYNkswP/9AOmTY2HHj5
 zW09tAn/5VqmszjglUDPQQegfK0g+bUDcSzTWaMyVzyWXvnQRslW0NbMx8fBkv1h+pXhW6xN0
 07iO0o7CNPJlk7wFSTBw1ffg9wpiLB82NAMD1ZWrPquALGMYg3oder+sTfQFI2EcseUGlVZrV
 j6Q8LjkQSXIxGJ65ti63RybV4n3UE0QhuF6+pYNBZAgPA6xUEn2FWOKiCV/YFNUBI8LCIbfmc
 6/9DB/sVI99zlXu4Amt5C/00w6y4p8IK/c7d7Ja9pvaaBqUVzTtKfA3vPLZBnYULr/6DICBAW
 PhoEoZEdrOD9qC6wmp4gikhXe1twd/2jf+ONXCvZsIwWFRa7MhOZcbfm7yOddDMitM6AsjCcn
 H1Bxqa2HfKu80naEKDJMwCLP7keqIrYKgmh6Ihj0n7LVIvuSXu24+FQHB430y9THP8C7+F5sb
 XUX7HYYxSRzxV8CAYayJ4R2RSUJi8igqboURNvhxDQHgXkx6hrnuFR1in2tsugSw1IP0wvjJt
 U7Ki8cU3XAvjtWmswwv2kz6e9FFfcMbDZo3gvLU2tZMQYSRqY32+TFXOkivfTO3rBlbC5LGW6
 iUaw0J7hMP4YOY7ltTf9UGA2PG5gLrFnnAuEMnW281bD3G86lHho6RxKDN4D9c/eVUFtFb+JA
 iYMwxJgjEsDJ0EDRuDUXvBDt4R7mDo8GwxHfmYWiUsD/QRwmq9MUZZ9ZhVhJxD5afmcNkFw7v
 WTGV3R2ILLFK7hjNHDSL/sLUjS9snk/JiVpZXwl1QC9clzBRNk6H/UpOztLDys6BGun7mZCe3
 ArBIiTYnBQakaW5nozW3RBSTajZIbcS6rOJDhUeaazsXKMOwtRCuiULOz/PBtlatNquLJiarN
 KO/3BM2wBtanqHybfzupj2PE1klg9v2kOZteoA0/1fI+YwxuLD62B8tMTf31ezZBodOEj/WfO
 PUp/BTjXqG21GV4RMHywHJK/XjfcFQzl+5YarCw1Kkrpamdu5KiU2qJFu9yi64JW7amhB1kjK
 TEhhsAPBiaz42r+ZvsvUFY8bF70rMe0HZmgAlhrtzivvfH+1X1FLE2Q+KQOhU3o+oP/6Ls8ov
 6RFFN2eGP3LTq6pvziF3tSyjL+oehKvizCvOgxdowTDVOGDpDchXePJyw1AMV6KIJ6mgXEB/s
 VWkwIJuINpgmsSGdb4tLurtWzLdsa8hnH7bckVlz9IFtscrrOQZLSn0UGVpBcdvp87rXnChwp
 JpXdQYXjmrXuWPBoyCtTFHrUFhTnvNZLXrVEIo3SuHpMJ6rTWenRPIVAunvvUVCIifA49w+Sh
 FQCZj0o5eWMfzxTvRlSlncTNxx+tLZrdW89oxOAnPnxEtXx9atKCIHW5SgMQwfuNfQrOJhDOC
 /vryYlhpYeIvVOB0/ALhYz5wN63rwptScsFrKrTprCOvEe3QVZMrNz8+915YsNlPPYwwkSzWk
 AtJkfTCiiZEdKqSj3PBnD9ixpak/+Z8ydmBSah1skDCsnlQX+06TWLOzDUaMfntCAPoHVJFYI
 TVnD8S31OBdYgD/q/tPD3qsU7EIX+RhCghT1pKM/drxDDNmeNtMuGubJAAdn6eup91oscrncJ
 ycRUPORXqbRGVDy8PVsasyAq1zGjzHI5RLEql6M8or4m/rLpCiUe9kBH3p9NPzf8yM8d+J80x
 xd4/j6F11X+mjPwjitnWqJGkqIq9NvEvby1nAc077WFsscxtY8RlyX8bW4iiQoWiPwWngmP2M
 ROr7RFMBUWU8E3mP6VyEeBNz7EbDcpKoe6PEghjiXbKWO/fVpS+X49imgNzpbY6niLZXFENaX
 6vrXMFdixBlQoFZf6MK6IHM8q8F1UzgAFeaYzwyRF/DM4dMTTGC5DOk18WxkziKUs4rg7mTbx
 2je5VKBMBAVvrRBMe4g0t6+/6EL2oYocUz5MWJQc4CNrYSv622iST0aJtwuB2Ap5iiy0/QgZn
 Pf4XBZnxfe5PD9Lk4tBkTsi2aY0AE7VZf4SyBimpCCjYuhG2YRj/hGQUx+bYq0qL+cozN+NiL
 ZEXd8KzMmOoJHK5m8j4++ohWeresjPvdm2qweLP4qN6ms3F2L7+KaGBCwGPP7Bi67+2ilaEHQ
 0PbEIm0lehaTyhO+AFRqJl8P8gG6pmkxVK3vws5SK/EHaH1dulkEgrd3FxWH2cht86s//1GlM
 P9YHcFNDpB4AVA0Um9G93wyvms5KzFv0Blgnirlx3tbWKLSQ9WHQYEHVs1qjGpYB7m+E+XsWA
 jbIVSlAyrBOjCY6knR1cny4D5eD4LfJ9/jF77V+A9Cm4s4qU0NE1WeBF5/XLJY5mmj+s2J9WF
 dZ7pYF+c/7MYEYSW1jUT4h9nSYlNdgY6CGSchFMSFiThVuF8Cf3PnPUl0cmQnZdJExaGSyCcS
 IIynsT3Guxl3S/zRbRvGyu5BntMVA21CQDWX2bhSJ/z63qVdLArIWaRKNkAj9J5X9TNDhQvrP
 CMBNT9ziZ8hQOPeoXzf2ycjgm8+v4nh3R8SFFfaiW2q3ZQVf4BUv2zh/hFbhxj4ORbiMTn2ad
 rzrs1BDQYLCoD1MwOiWLN76iXlB0rLmZ7LfuojkQ9RbsNpI3oXhjlQuqgyL7toMQifylF+yQV
 ORjkQi6TnYXnNyhey0i8wW/R9IyiNGoRYNcrRpiqmDUjfur2iaSFTMDKR5e4tAtNCZoIz02kg
 VWLzP+2AOH+hQ+FGe9SO4Wha8dTqGOqlwlW/mfJ1rEPanaaB5zgHBUCcki0oihLFTV3+pGwUy
 NVmA6UTbffxR+6Zb3CKtksz8PhzrlG3+CgFvcatDa7EuqIHO3zzGEjbzlYInWD4wjMs9yMV0U
 e6A0ii9aYlg0eHMQQoCDScMZZHDobn4FxFkiOwh41joIk9bacF4L9d0FJ00XnRfn+1gfNAibF
 n9mecpdCANz+uEbfPqx9w/Z8tQI07llgcV+ICrzJi



=E5=9C=A8 2026/10/17 03:06, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When scrub finishes, it does a wakeup on the fs_info->scrub_pause_wait
> wait queue and then sets dev->scrub_sctx to NULL. On the other hand the
> scrub cancel code (btrfs_scrub_cancel_dev()) waits on that wait queue
> for dev->scrub_sctx to be NULL. So this means if btrfs_scrub_cancel_dev(=
)
> is called right when scrub is finishing and sees the wakeup before the
> NULL is assigned to dev->scrub_sctx by btrfs_scrub_dev(), it hangs.
>=20
> Fix this by doing the wakeup in btrfs_scrub_dev() after setting
> dev->scrub_sctx to NULL.
>=20
> Fixes: a2de733c78fa ("btrfs: scrub")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 8c7404bb9636..05768e28fd95 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3171,7 +3171,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info,=
 u64 devid, u64 start,
>   	memalloc_nofs_restore(nofs_flag);
>  =20
>   	atomic_dec(&fs_info->scrubs_running);
> -	wake_up(&fs_info->scrub_pause_wait);
>  =20
>   	if (progress)
>   		memcpy(progress, &sctx->stat, sizeof(*progress));
> @@ -3184,6 +3183,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info=
, u64 devid, u64 start,
>   	dev->scrub_ctx =3D NULL;
>   	mutex_unlock(&fs_info->scrub_lock);
>  =20
> +	/*
> +	 * We have set dev->scrub_ctx to NULL, now do the wakeup as a concurre=
nt
> +	 * scrub cancel (btrfs_scrub_cancel_dev()) waits for dev->scrub_ctx to
> +	 * be set to NULL.
> +	 */
> +	wake_up(&fs_info->scrub_pause_wait);
> +
>   	scrub_workers_put(fs_info);
>   	scrub_put_ctx(sctx);
>  =20

