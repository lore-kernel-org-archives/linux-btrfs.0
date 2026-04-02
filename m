Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA9336AB50
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 04:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775105471; cv=none; b=nuPqL1PCKnkVRTTT2sSbt7ivMUp28PgtUqUmWge6qMJx4ToziKT7/cCChsZGKxalIE8TKUjJ9fUAVZT+jsnOwbJ0T0AJ5Dbr32IEZFpHSfhC4Q5E9iyBEA8dbCBfuZ6Iv8OhVPutJ+dOBRqdOogIPa0JSoulXdJnx5afs73Ak/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775105471; c=relaxed/simple;
	bh=qa74VHlT5ojcFvxmBrBZGc38gILTgtjlP5o1oH8Bnd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqMydN4cx/PjyBpLs9NYZAcsiZMpNb7IhRR8mzzoNvADGgIW94ncV9+8n8xllE44wVLO2IrpsEQ+bk1URL8OCXD3ROc8ngaQY3tUa4MdGtEhd58wygEmWhfXByFAuiB3wUVrR7XQMbtvycbI2kD1B59mt5ImkvUVBdXbITanjpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=H7TOmvAH; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="H7TOmvAH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1775105468; x=1775710268; i=quwenruo.btrfs@gmx.com;
	bh=qa74VHlT5ojcFvxmBrBZGc38gILTgtjlP5o1oH8Bnd0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=H7TOmvAH0W+leFMTD6Dz+2v3hDr7EKwhWtIiyFQaXsEaWMqVxZuSr9dXXCbo28by
	 N7XQwBalONEnzqHhukgEUobczMJYZSUNGZ2g3vkycnCGMnrgc1w7kfU1eO+PomWYX
	 rW6SztkbzlUABubRbUalxKOELc8ImrDl4s4sEDszVX2vBFLXj5qU4d0hoJhM21JdO
	 Ues7ylUFMqxWfUBalpRCQ8IIUCeen+8guZQF2r8sGhrTE7zhqaH4MxxVw0haM/YtN
	 rWibI+JL3kVnKUovNZFhccETkR3TbhJfrB4S0muxOw34AlkSIe0FiUnnuYtfz53x6
	 aRci0yVGg9KEbGHgiA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N6KYb-1vRpzO2EWH-013eEu; Thu, 02
 Apr 2026 06:51:08 +0200
Message-ID: <991136de-fa41-4847-b81e-af45b6f7d1ea@gmx.com>
Date: Thu, 2 Apr 2026 15:21:04 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] btrfs: delay compression to bbio submission time
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1773953307.git.wqu@suse.com>
 <20260401225257.GA826348@zen.localdomain>
 <987d1e01-50d7-4877-b55c-62191b12754d@suse.com>
 <5f86e25a-00f9-4d48-b046-8ae93965f07d@suse.com>
 <20260402005108.GA916963@zen.localdomain>
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
In-Reply-To: <20260402005108.GA916963@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3WIGFXXo98IW/VvCQ9r5rm3Yn+RFveQmQ+VZ4JR7DvytFI73kKU
 swrBReXFmtOVX3lKyHJFhpgI2XRrqwcb/0OS2b1gqUsZbHi+vSCtDxVNLJs9RXIx2kPJxSW
 C3+yRb0G4YFuBqog4ho6P5d4hYN5ZsY8dYS0QCFvRcPif7gQlM8itLcOl7JtCAlhbpk82ju
 zzRFedYFIx1mAbo6Rq5uQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ovy2U9sNgPU=;4TN7c9bfWi2qLRBepWB2c6H4td7
 679b2XMHb7SEV2IQ+N2M4vMb0/Vw1/Lef3lACg9vsfQossxAYjrFSnjkBHmN4nGEwXTjJURah
 mW9UEGlEiRB1REGfRSqLbZAWZ8vBscpV+GPQppYrlvdzKKWmbVPBl5bV/rvY0yT0o16DtlL9f
 srQQy6vqCTMRbAktFhrXOTSsUNbVenTRrO69eMz68ou3cLZg3NmUwUVjYIjQzIxXj0dx0kZuQ
 k+04Am0Aev6sZPInptqJsGUgriYHH9OpE8fT0f0HyUs1RiB5O3XwDtPP87ZLPpbkWUVpxlDPW
 VJUW+m5XI51SzyMS4ikpu8HsRI8XHyJwhj9iroRLAFD2N0gSfMkHz8ng9u2YLH2BHj6qqfTOj
 pyIVF0NQaZDvOKOrjC0ENWHFYj68co7y9TWMQf94MCUNSQl2id0pmwMiwtx4S9w5jHXAO4A6u
 +Y3FyoqgefIGDavOZik85FHRCR5V11F5iDJA5Lga2zmuT58OnB+xfuMQxWffGaAINEFHTrwXF
 gxGm1WzNO7hMC27L3lLlaRlkGH4Q6QGsOUzYmM0aIkx2AjJd7g4quBaPlCdkBCCTNrJvTrAJe
 Iew/uMGPLp7JGQ8nDMndiyMV17MhG11OFGSn1/CsC5TGzdNovrkAgIyDZvhOFk/W2qRgYKlCd
 zU7GpY3wCWP2XkE355pnTbhHbUEqkGNksg15qcqtESo0Z4oiiWy7M3oVbJ8JmqAfVhck34fg+
 IXR43ZOLVPHXGaHXCIzyJI+qneRvJtrgrxuUZsftzy8XBdcWJpgo9ynQyyPsp4IVWTm+k6p1k
 jXJr8REEk8kHKdpXDhvZVpsCk3zrXcN+N/RsWwminPM4A4qjJtLWkcOZhw+K3NGGqPu6FTN82
 x1CdiAFFllP2Lm1lNwNB3ppO2ZZ8/JRPgX5ilVt1mtJwjZq+A61qohAoNkMOzMPTrFdDAVJWR
 8BeNVGmGo5TI0vqcudWKw2CZ48FAk7HEIFo5hpFMxW+W61kaSYEQeLf+XNttmTtEWD/ozL4yi
 rQbQUoW4LcVMU4DyKJCCrbY88qJETmL9Vo2LFaLTbyj9at8W8KOIUnq9AoTde/gm6S3EdDHWW
 sbyKeS2CNlFnR/llHV0n7wBbm2PX1OT03ggSZbw1olU91JyASUl1VvtsCbZBk7W/tDY8Hryic
 5IvWf2Hqqp56/XjrA4bZWJKhFbJ7kKaHdcZFXGtBjiq4478JOrGQFRetELE+6edHZMwLQC3kI
 uQHq57annxymvstYedGedY8zXq4c2JwGCLLMsMbp6c16o2CZPkCqS/arWwFE/RDdBTkz3DgY/
 yZ4EkoRgyQPbWJ1mEXS4WDn4+wDgax7anGElVhuR1NSWhToq4AHJC35w2Aay8X2tYMSJh0ViL
 GQkAnRmFr+bJFHfSfbZwk4kxXeJ9xj4L1yDLiymy33r5DqHH7DB4wAivNeM10lydycQlGWWYD
 KX+AkdMot9bquRRjWE300y7y+LxqQ4/9jN5yZ8yPZeire6xKQNODnbOeDQ6XYo7OvPpN7PnCk
 C9YBjwk8TGUXxkAvgAKx8hL5r+exVKFc4AtY++TmXIvYdKWjJURAsF9w1ko7g664JPh1ybZ+0
 fGjJFafs9Qg5G2L765s4l4yf38ccrVEl4APTwgE3W9wLSB3EZfZ5iH4KYKsiH8+A5hesw1tgv
 TJ0eLDrL6fvPaI6mh3kPTBh3bCrh6QjuwPIqqRBFhyWEChM0mrZwV9UN+laTcL8FzvrxFq7ZC
 KVXHngS83DMHLbTxF48ICu38AqogF1tGcIWZVb6csNjkl0UbrVTFgfnmCLpFsCftvIG4ocgJD
 wJxXumkNFP2YVklnm8ORoW6ktpAXrX5K9z1Sgz1TKm4xLFJaqZgOf03CZI1QyWi3Gd2CLLSia
 yct4IaDEy1Yss7i37rUCzbW3Gz5MqU7hb/n3uYGeV2bzGXzX2VOkzUN4Djgrcf4c6811LGkdz
 knZ/V4maHC+vxxg/fsCNVtn1FUmAvbAA686/p5a85oHJA2EWmKEpHPuftly2atIlzvYSzLfau
 jnHDWPkcK29OLngpTszMF9ODx5enlhrnKqgolHacsqEdFeKIM0f5H50c65vIEqnd5UB8E3PVp
 gCAbtHPh5agWtOH5upkAZYqTx3lk//2wOY1BKDpqHnlTvodw0YLwvXMSvzpsTTM3Xmg9bPs1f
 qQRfoFK0Dr16iAG42a1bws/kNnkJIjVyY+nCVAqVm4U2StllFS1D7TLM/WojhLukMCBLCEnT2
 W5W2dg2Fe2bTte3Y5cgkV95vPY8gi8URNpQjU167zKpTXMXqdK/8oDVf4UYK8jFQ7Hcs9agGD
 vVdKWePVV+59vqneKNZXQq7oxGH+Z2Lt1gD0ZSNo8vSD8BV/h5ukkrkaHsJA3Ti4MwiNWum1y
 68h08k+R3/LC+1/Pyrp0fbCHwGoghJW5S9GTxvmvTpeKXXVeQYhcyQmS2Wi2Xe31xfJtGjJHt
 X5MAUQClw040YUynN5XVkFAxgS5aSx0EoaO0Ga5BRmCGTumOpXwBFT5Ab67nUxXRORq8gysep
 nMAeMJfqWwSnj3i8VrCRLZim0UVynDtTXc9V7CHAJ4IA/AojbGS8alKhY79ALik1a3avz0u6x
 F9f/6rVaWeIC12t9LgyXEb5IzgoULIaRJkZsNY5wlSp6pBt3dn2KssoPxzMa7aiBVSj2Haki/
 X85/RCCvq2cbVCIGZSQ/hxH67B0eHhUnctl8MMyPsRMChldawt7UJByqSPxBNmqAEMMc+vaim
 1iD4vCjHhj4gSVdLqSlXzOk/vS6av8p5kTDYjhms/KeC3bzm7vtsfUC6zzomVHn8KPB0gEyN9
 jHZ/XEJrgZbvXrfwstLwMS6XVlIhvMNs2cZxGfkpV0H+IVxU+ZAYWyb08qsf4FOS8QV4jjtoA
 MA6paCj0auerHZ3ZgP3H7zlJKrjaFcEhVPMBgrGPxERdAFGfw4n/8B5D0sX+V8KWCWy4KZGoy
 IBE6C/HwfIqEHykoCjIgZS3FRbxdZNrcSCrinBYVKMhewwBee0V6Sx+OpGWZLompyBOpAnxlb
 smSIU8qKy3oH4yzZaICGzzRE232HkrW+2BSfCPWiWt/HhWGojfgfacyn3f1aLITVKQTSPPd8W
 X5fuqvpDg2JTZ3/uIloNvOIwem5995NumFw8f/BdN9jeFqNgl/LaNyJcrXjbHEDFArr4SAojX
 ClgCsaZmqz+YjT6Dr07SU4Zlq/OaXrQX5cqVkksJQ2U8pAUH0lybN4Gf4nwkMmJL4OMDER7NU
 J3KJH320x3wunsDsMsgN2Aip4plFUt+z7catH116BA13S4KbY0ifoxpPHJltT9Vz+O24tSaeQ
 g0+2soqIs/pZmijUhjwP8AmBYKODuui34j8qO4JpHEMcYUPGihuHN8u/fUJQYSZTeiZUjwXMt
 vfkcrePAdeqAz2P/R0A1INmsESPAiWcQPJWLUS0DxZ96qstnVqKs/0ul2bBTJsbrjNDqPoz4l
 s6AsP5gtEYuHqbbuvRrd1zfjYYp7Dj2iiTp334ZVZ+aVrK506ElfJFqfVJnMWiREKYGY4SCm7
 WBTSHQ2XAzr5GU9ACqDQS0M+ZwSGGT58s6+/rq1EwQrvcThadfUfgZi2SSWzWD2GVLVlrZXvN
 n/9/6vKmAU9nWmJVYQrA0a2M1lrZWcgYUwjP28Ngsdv9bd1SaGoETqfAaJ24V2iRWOGCLiu20
 Egz48VUqp9w/WrEcSb3/ixrmtijfmnhz58s4VboKlqORAsle4rKFfAubKusj5rhRq1nyOBHUe
 KTSmeFb2EpnCi7nQuFWrI0VxxwMIEv/GmwI0fPtNY6TlPn0YOe0EKjZ6O4JM8YfFab7chGves
 zXaOik7QNjnc69mA1QKAOixgetrGv0TnHjbN+oDWYnNdicrwNo+nW6m3ov7oxbk7eTvMECRRy
 Rhxe3GdWfMNdeeiu8ItBMWC6MPUHDqK4vTV2anBx0JSqKIjjrA+i2EJxZcyXZFjZqgILNjbY1
 cqsINqSn/tntnQZexL+9+qoQT1QC4wq7k8PNuEtCSrygnOFCAH1ijIA0jto7urkkE7uFrD4N6
 chG1f3ZJoBx/xizgcLq0fK12j2yMOzRqMn/shfmx71S5VP4AXuaMA+hXqyz7MVul+8N2QfU7y
 3Tvz/F5VnL3jYb+DbYXlLY3J95SOhnmtGgs7kFUr303iYG28VHHo0zwH/OV9jy1499G5h4ZNF
 VokwK7aAYUG9ynZP8zzgAbnhYOsKqUk9jCYWdwxcDKRjWRLHZroaurVSrAcUxmjxWXLR4ynVQ
 Ks0yyQ1XnMjAHK+N+FsP1mzG+PR7O3aKh57gQes+LcAmiIa8T63h6T2jrBfIOhmBOe7hHUJdW
 kwRcOyH4JvxoOzNfpAZ0Q1DDRDzjmg7P9hQvmH8MrKrrxaV/UM/YjXllo3+BTPB8iX4RVyu/h
 8+sYY+1OX26FZAImzue9LC9Y8Sd3rtEVE+LyD9kU06iABHrontAWjcTsviY4BeYf9XxotaKJ3
 Y3aBmeIAz7nwN/HxNDGO6/TIU4WkQ5PaHTahFlZZ4wNsjrG0A5DcfK6TdsyneJb6pLgjjwSi6
 8b+QLjBs5jQtKdwpUZaqCmG2XsD5mk7Anl19q98VEvRW6gBRFh8zJF+L+vVrosVMKEUEGhBKJ
 upaqfjKCCubVB4KwjDFLS2b6t3k9tz+ZGNzh15Cgh2Cdq+aYfZTyPvg6QYj4a41T2FdwYgJds
 /Qq+mp6VjZmZlkJ067TJWkN4IIQTeckGv0ObIZhC5gaA53mqfZTPXTGXFbtbs+yPIiRKvSmUL
 NC3vYKHGLOJ3i3TaFs4/nTxPCXZQ5dcv/HFogJa3KO1FaNDA7eIJ538SMDbHsB7W2MjBXyFy1
 jcAOcvEF6giYs8HJ63/4zM8sbj6LiLq3/jNIGXpXOVkSQkC4PGsqa2igsChrfhmmUN9pACppq
 Rer7XdXw0Z8JfL/GQjO7O6AmNzFXmsy9VSJoM0vnZhod039vkXfTdnBCE3SMHT6ZPPD5wuuhl
 IkURTTY1mZ9wOcXZVo1f1MeoFa/5DKHMLPamvyQnQQdH52TUoJuOuBqUavfy2tq/EgnH5+k9y
 uYQWdMjK3JoXv/y1sKw1PeYkARZ8kvXUNI7dFs+f+YDA8YFmWrAuVYzo3k6gr1nAZjfOcx2+B
 ZSZK3JwSMdPR4KtOlwbyH2aoOik2jzUg1JIWQMbCiq+fpPtvnKTky/XbbeJQbAMZo6SYbekal
 WQO9EisnvtmX5loYRFU09aTjd5CF86Ld/h6DjhIyfVzswlpAAtnN+X3W1tvIhqLeRsLeCW/kc
 lP5n81bAIMW9aBMHEZMJ



=E5=9C=A8 2026/4/2 11:21, Boris Burkov =E5=86=99=E9=81=93:
> On Thu, Apr 02, 2026 at 10:45:14AM +1030, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/4/2 09:59, Qu Wenruo =E5=86=99=E9=81=93:
>> [...]
>>>> So
>>>> we are breaking the contract "OE <=3D> allocated space" to allow this=
. I
>>>> think making the absolute core of the improvement more apparent in th=
e
>>>> descriptions would be helpful.
>>>>
>>>> I think one thing I still don't understand is the desire for the laye=
red
>>>> bios/OEs instead of creating the same delayed OE, but then as we do
>>>> the real
>>>> allocation/compression and discover the actual ranges doing
>>>> btrfs_split_ordered_extent() like short DIO writes, which seems quite
>>>> similar. Splitting/joining feels like a much more natural model for
>>>> ranges like OEs than layering into a tree. As we discover the sub ran=
ges
>>>> we actually use, we split off the real OE.
>>>
>>> I can definitely work towards that direction. Although my concern is t=
he
>>> OE waiting/start part and error handling.
>>>
>>> But so far those are only concerns, I need to implement the code to se=
e
>>> what can go wrong.
>>>
>>> And if no major problem is hit, you can see a v2 with the split soluti=
on.
>>
>> Finally I recall the challenge using btrfs_split_ordered_extent(), that=
 we
>> can not split the OE in the middle.
>>
>> E.g. we have a delayed OE for range [0, 32K), then due to whatever reas=
ons
>> (e.g. memory pressure), we are forced to submit range [0, 16K) first, t=
hen
>> range [16K, 32K).
>>
>> Both go through delayed compression, but the range [16K, 32K) win the r=
ace
>> by failing the compression (bad ratio), and fallback to uncompressed
>> submission first, before range [0, 16K) even finishes its compression.
>>
>> Furthermore, for the range [16K, 32K) we do not have a large enough fre=
e
>> space to fill it in one go, but can only allocate several 8K sized exte=
nts.
>>
>> So we need to split the [16K, 32K) into two ranges, [16K, 24K) and [24K=
,
>> 32K).
>>
>> This means we have to split the original [0, 32K) extent into [0, 16K),
>> [16K, 24K) and [24K, 32K) ranges.
>> This is not supported by the current btrfs_split_ordered_extent(), whic=
h can
>> only split range from the beginning of an OE.
>>
>>
>> I'll try to implement a version of btrfs_split_ordered_extent() that ca=
n
>> split the range at any offset to see how things will work then.
>=20
> This was kinda buggy before with the extent maps, and I think Naohiro
> Christoph and I ended up doing a good amount of refactoring to get rid
> of it. I am confident you can implement it correctly, just a fair warnin=
g.
>=20
> Also, you could consider doing an iterative split? Like if you need 16k,
> then split [0,128k) into [0,16k)[16k,128k) then split [16k,128k) into
> [16k,24k)[24k,128k).

Yes, that's possible if we go the ordered workqueue, and as long as the=20
writeback is always happening sequentially.

But the sequential writeback may not always be true.

E.g. we are initially writebacking folio 0, which created the OE for=20
range [0, 128K), but by memory pressure or whatever in MM layer,=20
suddenly the MM chose also to trigger writeback for folio 64K, meanwhile=
=20
our initial writeback is still submitting folios for range [0, 32k).

In that case, we have to do the split for 64K, and the sequential nature=
=20
is broken no matter what.

And that's also why I believe we hold all folios locked in the existing=20
async submission path, to avoid such unexpected split caused by MM.

I will definitely try some aspects of the ideas mentioned here, like=20
using ordered workqueue (which also addresses the current out-of-order=20
OE disk bytenr problems).

But if the OE splits is too complex, I'll definitely give you some=20
feedback about the problems.

Thanks,
Qu

>=20
> Not sure if that is easier than the "true" 3 (or K) way split.
>=20
> If all this becomes a huge headache please feel don't feel obliged to
> carry on forever, I am happy to discuss again.
>=20
> Thanks,
> Boris
>=20
>>
>> Thanks,
>> Qu
>=20

