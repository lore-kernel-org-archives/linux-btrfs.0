Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E3D3559DF
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 22:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777327318; cv=none; b=dqrC7ajUCeeLIUDiaZI1bNFFnG0fvnXDB8ftlXUVGMvmVovGlTvn0Tlx1ylXe1mpNvO6fkMi7hKjY9lno2Ox4yRDAvXiClEw+IV1JRIbJhyFJ3SR//oCeb2D/6qDDUu5TZP4Zw6qdUbYfz96RA/fDjSR3AOqamUaCs/+UNidrzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777327318; c=relaxed/simple;
	bh=5EQHiHo6acmeEl+STMIjwl2U5oczOxhg8uVLHw8A/Xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SjiDUMBnPQzv3t70VwhiwiC+sCoRRTj7YZywOU8VpCOy0FDteKQcOn7ogNizNcYB1ljdw4+6c9r9WA3lqxp24a2Xjt8h2+voamFwid+8k4uq+GRMPYMAPuOueZErADcZWDAo29So8zcveLfTwmPJAd54CixNgDMT4ubIOdCXk5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=DMtfB6gV; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="DMtfB6gV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777327313; x=1777932113; i=quwenruo.btrfs@gmx.com;
	bh=AfSScH1FSDHxR45Vc0KOF6MlaIX60UFJTPkG9rkHo4E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=DMtfB6gVFjSU1qom7s6dAA10NQytF3F9YWRMuA0AZq64v0fe/uB++TMmjhRlxLT6
	 9W+UYGoGdFpO5sOl0eeulbrW8U/+kPNYLTzTZqF624Inc4Pr3ZIdYrigpl1qUYFk1
	 csJl2sha00rDlsHH7SvhxbBx3wFdvyrOhulGswbnaXlFYlWHFxS9Dvb/4ij4z37gc
	 S30T2n9+MfDX9yo3ZlkilzXtDVu3e1vB+A+6aGgh8+2UHDFf0coaP93Ijs8V4w0xW
	 NrdXn8bRbwxmUrWeTlOUsKzJa3Vw1goFx7Aro7sVpuAibT8R7PJFhvuKO5QFnQkXg
	 WEVcblkaol5laMSMng==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MbzuB-1ve0sQ1Sk3-00nazd; Tue, 28
 Apr 2026 00:01:53 +0200
Message-ID: <f94d6fe3-e4a5-42ac-bf2b-47d126dbd46b@gmx.com>
Date: Tue, 28 Apr 2026 07:31:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: warn about extent buffer that can not be
 released
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>,
 Teng Liu <27rabbitlt@gmail.com>
References: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
 <20260427154805.GQ12792@twin.jikos.cz>
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
In-Reply-To: <20260427154805.GQ12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CD1xmNA1R6mmnxbFlvaDPP1KeX9TnVmejkYnmJlP69I5IMQN6Yx
 rwCltHjYVOzYi+NyM8GTHigNZEeMxRXkShjT+uyqZDMOiMccKyub88+ct4HPvTlTMM5ghrf
 AJR1Sk8zoOO3csSwCop6JySTvqCn5UjDQQLhlEuoe9PnI6zu9ZrCxZ0mlNFalKYw4tAiCXd
 otja8PqA6Xkmol7+nC8mw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+TKRMSS7gE8=;EoDYZDHeS+t7xsYEIeP1TBRO7Bg
 dNohNneBkiT+5R1e6UcUnzx8G2o+EgBLgRw3cCLOqS7fENzT1H1qoNBq7sp57hFNkETTok4Gp
 qO0o6lTsydCKEVbxiFPqLL19sIXF0HQxfesfvpcsp/bJMvq7fQHXMq0e/zpVDuXvQmt2jAT6r
 /EUlWrbLkzlnewyVL+h4bDbBMwawetc3Yw/mr1riofZ5/w/PZkacmbgI1MXSG1A9d6HsospM8
 7+Y6+P1Bg/P0l40oDq+/i6nPcFMP6foV4Bl+WpEbVK61KjHE91fUB/ZS6wOtQDkSkgsPdPJnA
 sHJc+/GMr48McK+hi6Y5xKwcLrcL/Iz7qKzQvaTN7M41F/1BYSYP9p/5stAqPlO/xq9bfTY6s
 2HDGYvjYHI3b+y+5lcTbda0m0Q2oyBdqobZ3NsReyy+XLYp0MEIIRmKaunhNc5zQUQ+spBmd5
 0qUaYShQHDJTHucerpheVG8FxYootd6G5KaHyJBuvOxAeaKHXDuRs21jW9DhJ2tP739zAPCTB
 wXpzScXdO1u2m/+4dPb7VCSliqDkHp6wlbLaC2v3zRJIC7iTertW0sfcHacE2GWaen0E9XWK4
 4wezbYLT+dlSli6L88+l51+ZzHj2dgNoXTYZWCFtuOpZFG2tYTLiPG/zOTnNrhr2GRrtzHm0F
 jT14kbfUw4Bb3adumAx6sxcTGypbhSyVW6jFm9FiLbhRDXV8CYc7CnsUkwL+oHuew2VzC3eGr
 JJ7BIwa30laJYMkUattmnr9+AiZx8GXvp/sJDdxsQMapBJKicsq1YoHWFM0RSXemfv2bgFyme
 nczl+lipH+axKqjGNvR5AwNkboOgPiVU4zi1w37UBlufQkp4E35omn4VgPGn+PFGOeBdmbIEh
 VnwRw1ymZCDeew5n9IrWEs0vQkHM5qLHk1BHnc9ToLmjgTU5obVSz0G7XdIiAw7RLGhLqGNTP
 KZAXWfL2JD+u9u3GkBWsJ/C0FXBhErWMG8TLbo3I9f+s/4i1MyTh9pzWC650Q8kETH4U8XUFh
 olchi88ramPjzGZsGS1egrk/d1698ELGwcVd6Q00Idg2jIWYByicgYh8OBUXWlFzlTtwVmKw3
 59QhBB8wtVNvi4qne/V1JM9rkqMGZbXDWjR3dhu0o0IBx81DIEs9grbhWmRNjG6rKtkW3B8vP
 pA6TEtjWSWxaJWlfafieN6MDl28u4PWQkzYWnikHxoJHLYUwxfGozmzedYqcJLB8F8QQ///9N
 JH4itOISqX45+371cKbOfGyqAEm4dfeecUxREyIa9cdz5HM2iFNHzs4mdMoSL2xKNFFAOJ2l9
 XiheQMbUwB2Q6RMvhXadYlcs4NzKhkp8dT6Pug24egMTcRpi6KvCqtl3jnMKZeCyttnB2K4Gy
 khxQ9iQu6iZ6nQ2tQUMGmLNygTLckQ4JjSPolEDT7iv24eg8LXM8+Kabl6Ls5+ehbjLmFR2vz
 dLqvICX/L9ofYux3cBhK4V5t8xmKD3++oRFBoHUnTBJTbhAqqjx9ylbPVIkyvqucIe1uao4XC
 jMRtjRbkorew+D6PNHH9132KwVf18/xKuFQDw5HLpkB7CrCjFHEgKqRDLcmOBPctmplvyjmQ5
 8d4KEU1H5Be7QCjH3qw2DRRcF6GighyYzPLH74bhZrpGrZ3v0hiVHulYV+gfW4ubWU3JzDj1P
 RTzonexFdtAEo9zqP/kCvOowOUHoq1llI+Uyr15ZbBBS6+rpVnP6zVNRmdP1g3vrLTT9Z0XWI
 FTaHz+Kui5nIuqv0Ylt7BWg+N4cJ6zdPwQjd6/bEdDEfxY/WS7PNvsuBPBS3Gzlo8m3Uc0t0K
 YYljkBYIctawRS4c/uZ8GynQYPcGatuLs3M91kbn1umvxRRRrIUawwHCEssa6ZL20YMDoxccp
 tPEK8cIk0n4Nbaqnn0XIWg/2cjNoEX6McNT6f4YS5zGUgNx77FZYYMcGHEYlmpHsChVex5hRF
 CWFzjHho8Mc0BXjvqwIq2Rs3Wjt87DW7pgCIGUQLCpkrFKiBUXJVBOWMQmLYwHcCULiy4a8JF
 pY+Jjzbrd8ettAtlthIIQrk8gwydaTxXLWvzTStifSgHXCSm1bLJDXFMHmpERZcsCfAtO+40M
 hw5KuQgM+jdUkCEdnzutoCeNU7c0qy6WH79q5/0DOrbmrtidsiIpyDpsCZv1GfxZDardW+BgK
 eZi9LfOtHuVmH5gE7ZPwnrN04YCtkPtHInDLXkn3fTq+vLx2S4GfkhiPpw5xYrC50QojTIld0
 9xVlQJjqkD1uqM8OHLzIsyMVqecgtQC+msjZnruRotJN2GzLlGF2ookAXXEH5aMX7s2swLMmr
 C1rOYLmnyMV+mmAlrhtLvOEpf5dOXNvQNzuc5eDePE9a126n1NlY9eccskigp2qfRfOpiBRjH
 l+jniMUbudVDmLAA0py73cCoex1Dwm2lpIufLXwkiBTCiXRvTQCG5MYKzfy8IQgVsYfsetZF+
 k4GnUPfO9qv636U3cHzr+ntERgOCB1U/PD0JVZAS7iA5QMeQjV1DhqbdjGrKmBE4JU+2Qwy/D
 LoLZb603YCFRwOtKok62j4E5j6ABb/J52jKAbJp0+l6yDy1FZxhUJ1faPFCjSPAzM71KU3HT6
 b8ZBBIVaGNdMm5HbGc51Hz6CUpiANyAWFeKhomxdSt6ug28OCDI6yXURC7kD4LdglTVDESCSt
 FXpJSf3mD1aedlDXA0nm0a3TxtddzuMzpQF6vBjan3IZstFoXqph2Jca1bk1wBEYX2jY2Q/OY
 rraHcux5aTPaPOf81vC7Geh339fyi15mbOkchERM/BuZkScj0/PBKr5sXqqUUoJsqOrU4bhpq
 YMfnrp75ahqUE9hYxxeBy8zbud9GWamHOglzGCbqKUhEsGxTdOHP9IRuuKcRf3hmn7/S6q/Vf
 ZZ4VcGcTxpfyv4tBJPAShqHqD8L3DYcMECf7eQy9gn3+1BLiMwIRwe0p+i2dBOZszTW2U4l7F
 txDyfNwlo6InV2OxOtEkrfCxc6N0iVePSNY0mmFc6O68b20bOsoHmGhDD9mH5ljNLEc7Wh4NO
 cj5BxY0/U+1my50B2AX3bX+qBvMeAHOdNp9YL3OBsInT+mFaTlbYSDfrK0q7/v25Nr485+M3d
 6FFsHNm9IvHzUnNMFWLcBFLMbYylvlvPsSYib8bbkU2Zdzh4h+O4zAAbRl6YT0QS5whvXXp2x
 zk0RUfkQ19Y7HS9gOEFg+Suwvz1J9vZDwaqZ5Gmg9Q+viVxb89WiW00xoCl9t6cPocSjWH/RK
 ZIzGx00wp0LbOIrbMMlj8rnj2J7Tdh+6aqsDJqHw/8MDINE+y1O8JsZd0TspOLft7x+fd+R4s
 JAQAURP1ArrQTeZNqV6aSTxcw4H05RU2RpMKmaYnEW97KEmE6250iFWrLiNg3/x3Ba4aBny0M
 lecIsjSdan4zGBIK/9Eig+G6riXqjmV+qwxVPINHmzfRxTpehzbsSv77GdEZELRh8gbYkxl0+
 twrQ5x0y2umHT8umiEiBGY6e1duZPq0f5+yKWDoNvZK63lqGBkX5taqYF/kXhflHNprz21dB8
 ptU5RFkbCClnWjdRMNeOMtDEo/P0TtF10aRFiSLxCc1cgn1GPvZqb0iyPilYGVPiUiImveVyq
 pTAlXDLf9h3+STpuHt5r+HMg9fnl5PSrL9+7OQ+PsI2sTQ2XAfJ/8ppDbGtOAXTDQ4xxN332D
 X/ix0kl7yARqeIkefNgS0p4fDB2i97kP4KJlVFIk5A88GzxT5epkBIdO/0gX4FJbC6rHzWDEc
 ht+6OQP0iDnZ3RroUz3NJ7K1O8niau0NYOieJeTMHKXoDZ2Qy/SAir8iyNi6+IHDABdO4QIm1
 sk9Je8Rt/ZBzBD4uGX52F++GyVWtfziLvzkVMA6GPCmqaRc1M0xfoiuhPNJHRXmJGbVkk3hAn
 p8DSg8HlWgJ2b/pcPXCQ1hUmV5UXYZ4XIDROZcsDphiB5Ky4nfCLIsCU3vypIrKseNhxCWTA/
 HL8jwMyUnzHBQ2q3wI9XqSUTNvMErYzm07g2D20dnhkQOaDPUIJ+fHIv3jdHsVnahyRyaGd4/
 vQnvkkxE5uUtPd73u1u1rEaIs1iXT3maEW3AR7fOEEHiy9LXFeEfmIJ7WBpnYTYsXi41eMgrL
 GQjUDAwjWCBSQ97OaQAfvgJPtATXP6uxIQye2DgtosW40Hf7nYFAf5U5YkuvpYY/vMslLmFUM
 8nj+Ccd7UBef7n1OiMKAVaaKpgQ40zqvcNfdp5BJMfKrSVT4rQ6M4YYidbVsWN+0jfSxfP3gs
 9Qp5RklM8W224795fCC924tw11I5SyKPhwIj+WBpSdfYvH5b2yVrAwnDuVwH/4aosxkAvppHR
 ctKNDE0b+ljlQFlIeTc4COKQMb/HzZfXU6dAmxUXQ7XIhEVu/wWMm5RdlDfgP2R1fD9NCv91l
 d7J4aOy0AUzHQ5Wr2ID+nRHA6daO82UXQsZ2V7Qj2VncCf5rgkQ0nvBRgQcoWSlSUe7T53vIq
 kTmTnKz+J1fozYZqvESVSGx686ov357zCw+xAVqNXtjExtQXcufkvIogiIjECmlkde6znJYan
 cwUW/C95x/7qMF2QlZMoTmfjVFKaigsfVx9dcJA5Dls1SW7IKC0pxLEdq8RwcUkhVAzcgmvUi
 c1Ebx0UX1pIrkfF5ucxnhSgtk/x5H5en5Rk/sKaNkomxx5UY6C1yHnx0Off6xet7EAua/WJUm
 6X8+yFgFxTlVXGQwH6B2CpQtueenfk26dRso9j2KQnJMgOTJ0EaVTdxjAbDeQjn6j+J8QPlHY
 cVhQa+gSQBk3lmK2NMp+4qsvXpJ6T1j0rRmz3vSg5/jcJbw97HCED2HIJm3DJyT1fuiVfarIa
 BGuRg8SA4RFEIBuJhlufMFyxh38aeq3nWMjPS160CnjxIiKRaFdMH9M6deU5VdUQHB/lThMBt
 jNIibUFE30oJ+WDstGt4sNt0mkJSz/mtCLb4faKd1JlzsjZnY7qo+33Cu9Wp+QS4oQp+TF045
 gyNgO74HPG3Z8nQSkJgwQD9f2NYjrLK4ATX+tlcyLT/NrefPh8/jmcpCqB4MwDijjBhWFmdsB
 VDb9+HDVBHTgJRGNZunlN/9Gu9h4e38LFen9p+u0NQVidpcxBpFZg+sCQG8/LGVU1SEDEL0jg
 m5ZR5e0v3wWPVbysrbuHwfNPWY3drhM5H7i9xyyi/1P2yIyMggXraXyGub7PD27Iz8kPY4ia/
 cn5isZgkAnuA40r4OXABB3L5kF5qTF2mF4cXE9iih7CLe7FOBpTdt76kxst71b5+hJP1jM6HK
 lU38SpRbi0jtxSC6qR1l2ITUU5gsuJyYcl4TaI3lMebwy/AwfvHCRqnG5g4Vl+w12U5Etr6Ww
 ru97rE9KJ3FK2ku8EDkyJDSKZA+moeI6HeNyXew5TPIRILvrnPychwKHlp2jA7pQO4TjZEIl4
 jYpxG5Bi+9OeKzoeCTRfeVTrdEblNO+3PiyMTsgr7byYFVldgc2DwOT2R9FNZfxJbPcEL/OEv
 CJuvg/FPBAJkYUB5LsASAu8YiD83KOMVUWi0=



=E5=9C=A8 2026/4/28 01:18, David Sterba =E5=86=99=E9=81=93:
[...]
>>  =20
>> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
>=20
> This is too close to the generic invalidate_inode_pages2, please add
> btrfs_ prefix.

Sure, and I'll try to get a better name for it, as we also have=20
btree_invalidate_folio().

[...]
>> --- a/fs/btrfs/transaction.h
>> +++ b/fs/btrfs/transaction.h
>> @@ -255,13 +255,13 @@ do {								\
>>   		__first =3D true;					\
>>   		if (WARN(btrfs_abort_should_print_stack(error),	\
>>   			KERN_ERR				\
>> -			"BTRFS: Transaction aborted (error %d)\n",	\
>> -			(error))) {					\
>> +			"BTRFS: Transaction %llu aborted (error %d)\n",	\
>> +			(trans)->transid, (error))) {			\
>>   			/* Stack trace printed. */			\
>>   		} else {						\
>>   			btrfs_err((trans)->fs_info,			\
>> -				  "Transaction aborted (error %d)",	\
>> -				  (error));			\
>> +			"Transaction %llu aborted (error %d)",	\
>> +				  (trans)->transid, (error));	\
>=20
> Adding the transaction number adds like 4KiB of object code because the
> calls are inlined so we can have exact location and stack.
>=20
> It could be possibly moved to __btrfs_abort_transaction() but with some
> additinal shuffling of the code from macro to the handler.
>=20

I can remove the transid part, as it doesn't contribute to the final bug=
=20
that got pinned down.

It's mostly a precautious debug feature.

Thanks,
Qu
