Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B61F3BA2
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 01:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780535794; cv=none; b=hanjQSIC2ouH90cZk8gy2GUULXVCBhMyF0vTem4RHHjIwQKikXVd7ptqx7t8w1EFe+6hJj3u8a8Om0x21kjG66DsXvgjAsX1jq7wCzriZkqwWnzReei0QUgSCenUcrUoJgam3kJsoHi52bzeuBePRezswTSFk7e8YWKNJdOmgwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780535794; c=relaxed/simple;
	bh=42ipP4YrEXMFHGI2jgia4EqCH5QGr7rdfPbNk1lACZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f9tCdQWqbSphYxRp6BjFq//1NxBcU3wI6+UcNuHHxCCy0i8sNCUhWeR+eUZ6j28Le0+naUjWgiAaPK8HP8KFANW6QU4X+6orV+KG38GLstk0wLmM36PxKI17KI/QsA67SXDUyxb4QXJRD+cjxZIrBdBSKnXbgCYWPNd3Imqgo7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=HwMG3NnV; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="HwMG3NnV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780535790; x=1781140590; i=quwenruo.btrfs@gmx.com;
	bh=bRb7rj3rK/zGzpQqZUvxZ8NClEqT7xvIVueIjSjFdLg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HwMG3NnVqA+oWFfYpccUYR87/Q29dSKibeN3aOpi3GwUnl//mWsPTBGxJDEdQStd
	 kuFPCOdvwN8qm7gvAdBD0BaL4/Wb4ghCBs4nWSTZ3GVSUpIiY8TIQcDv6olZxsWW+
	 x0RpDUpZd6lLwvcRUijZXXFHJJL0wyGZyznzrE7EslNKhRuOQLKfxNf0DS9IiKx3z
	 MWKLODSGtB89HbcjEsQZXK21+YR8HtkLmVSG7BP4fdU7FnJ3WPLg9B4/5Ne2OQ6nC
	 Dx/ee9dEluErHxH6M+nDNkUPA4TyvXXqtsnkVyzXZt9RQI56czG4CIt6lIzhrD93k
	 pNcLDXfJZl630RP8TQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MCbEf-1wN0T01E3v-00Gxjg; Thu, 04
 Jun 2026 03:16:30 +0200
Message-ID: <9cdfc4b1-0f6c-48c7-9a17-3e2d76ec9180@gmx.com>
Date: Thu, 4 Jun 2026 10:46:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scrub error & discrepancy
To: Michael Zacherl <ubu@bluemole.com>, linux-btrfs@vger.kernel.org
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
 <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
 <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
 <F68EA392-6360-4899-AF7E-3AD00B994FDC@bluemole.com>
 <abdefca9-5e72-4f63-bc7d-958b9ec50468@gmx.com>
 <F839ACDA-E61B-4E38-8188-9D431C3D669E@bluemole.com>
 <9bbb5862-1d6c-4980-8979-a4cf635bf642@gmx.com>
 <E3AB6B05-6029-4C8E-A2CA-E7CFAFF14D34@bluemole.com>
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
In-Reply-To: <E3AB6B05-6029-4C8E-A2CA-E7CFAFF14D34@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AEaSWmW9JwWoyg7rJ3fQ1nK1GzjgR7Rf5EoOIpubd81VnaHnI/W
 1ype6ugoYTZPAC8j68A11Yt9Mcs9oMSBEPaE3Xr2z5g8M6RPm/DVZJEcYuwTm40T5hdUREg
 xoVE8Xv6QxcMVpI2CfghDb40IWtx+mBP7yZ+MMdCDr9wDeap8/2aruKDCH5XrQqkAzVwAV1
 eodcEfGkuWYpUtUhMGTmw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:EOrgNRg86Mw=;A9lwFwSv2m/5WiJlZ5BxQzq6cl0
 HMuIfXq57mobtniXq8c7GGeksanKozXvMx0gJuBqj2tIPXJJtfTPLs+Wdgqlog+ioGC3b/26e
 sAvOzJ86GOYn0sYeGLWVR9m5cJsTjQfF87UCzNUbHrMuF/Win+mYS2XYK2LqDdkrVyleIElk2
 Y+6Im043mqzIJNtIvu1P1WSY4yxqkjwRfu4Ul1Z48cnUYADr2f6TjCIRD4Fpm+PLf16Ueq4mt
 DBmv47bXGCEWHmjHX1+i3Ie7NAtBNvRCyvSIFoQOgB8KdUfenBq1uergmuMlKS69MXpXOMq44
 EmBQYsg2/T0GMZSq7AkX+UamvrF0Nj/Icxy6LNDpazWlFXRbFj9OY/0368bXiIhhqWQkmXLlD
 55zLOrqmhVcrPnKmP4RC/+9AFDBaJntKet0JIz33uMlh7dPjkRjN9nI/hR2NoCm80shCd0qrT
 vjl9Q7veXPk/9qoDirkDzFkKFaEmpdR8k5B5SIofe+wPVDJPABfACHRTURGN/uYbOfun4Om33
 eu/KyIUJfnlISpBW19P3zVPpu6fMh+pudwwVbpl9n6qhqTJGlbT/pC57J86AFScnVhQu7dfIL
 9Gb1awx2EMkD2j0v4c/8UslAOQx5qxj2zJlSE0VlEqIBHHmVxeO9dHinab1sYM288IJ2dunrb
 +tT+GHo2UQQCO4883zm+JEHkWrvWfSukG26UDui7u6emxrm7xQqyOPj8uDIpboLejEogYHFc6
 pFtOdQpF1l624m8VgA7aa8JERQkM7L5x3gpkBR4cXrj/uM8Xw7pduvAeZHXq8PLZ4xyT3ehW7
 UiNmlpHyT2/puovGLwbNyP4wsxWH5CaYWODLSpQ2XL+MUwLtNuRG8bB1uFhtiVCJ9zdijTmKm
 D0a4M8qJMJN3cnKy7sLfPThDctsy/T9+jAOxicPifM/Txcj6sfQRFLSz73lgGdZH4+S3xDtN2
 h/OnFK/y2R2LCHpZLrON5ED0bGNfcHU2HOMfnKPurqU1eW+ssaqb6MRHZUw6hrtOM3r7Iqbo5
 r6NYqZHMuMCkDyfUf2PDe/vF9cgAkwY90rfRBaj0+/PEfh5FkxyTNflGuSuW0num7ySXMfH4a
 QhkksfEDzWhRSk1GWgehb+RVuBXF7SO+Bz+LHgCJM6sny7i4Tla/t4DtXLEarHcYM70Hj+ZP8
 QQXC5kFicgBgf/Dk2qlyzYVvwzwamjSBhN01ain6DotnNWzOhgR/WvLBuvKVKq4Puw06gaYlY
 hGAr6GZJ0NlZN4HUM8CVqo7x0iKOEMh/tYJIaw3W6fCSd3jLBEtUcNUSVZJR+cDBIoSUCe34J
 1bR8AuPXDONnv2GVFIuFSaUSheSrLIYOnQwI9yGrQWiN3er9aFc74K7ov6sqikvGUPhvl5EC1
 U2Yc5eiUePWh3y5Vj9Qgb3Gy9JSI/yshaIGX3wly6e+0QAOBJeRO1ghJezlIq6RmId9leyUTq
 Ys5gU5/Qh/qp5S+oeHR9BtX4NtTPhplZjdfIuCgLBHvKl6CyWIhuY4UQvXhAqP0PFWvWvpAQl
 ty9kU2/5OT11eny5BcvjG/938yze8yS4wb20PvGf01xlvJjvOZ3yEKoEhxqWORAhQE32IU4sU
 9CQUNOWdlv+F7UhQU5uuASUdZQOwjHJbFwDTWO3B8g8Jlz1VwouDyPRpJ1LW0hnOhsebXzSGr
 cKVaoUWe7uSr68F7uLcvv4yM7xOz7QulG4RFU4+n9uKEmQrAvRvQhWwdcOYknAlZFi4OkcC06
 ZTG8mVZ6AhXRZloCNWxPUzk8TEksOivF9jKFIa5CZE1u9mXU+H6ANWT/kGn+5a+oyD943w9Oq
 0ivacoRFDT6i7NZ7GX5hG5Dk9cHpLATDWxj7EB7OirIL/wsArkC1zMxoUwbwhsqQ/kkm3KuCz
 c/9d+xAs4f6Qiu5z7CgiQoGh6xgR188Sun3VB7+drJmhxweQikXPiOZwXSeFLpqFcBaVh0TXs
 ejB4GQk0tkllK0lFkkVd/AqUHB5o4McO3RL7Ag1D2RmsW1YoRUzI8arhhizbihcGGGENmhrjv
 HNkvnsXfoLmp5pR6ae3DWUmr3SbHYNBarsvxWVneSbCW+PXnGiUlMa5f80FrT9G2Ezhucp7CE
 waLRO5yjdtcn+cESQR+xn/hqdgSW9eY5uN8C8uQkGPPtb6zlPlWrevHmXCJ+fO/3/YQ6yFN83
 8pbHd8owWfne4N2SXxDLpBbUt0/lw/yKWd+0ZCwbZrtL+ySFvsnwKSEL4maZBOB4AcS3zlsvc
 U1XOG92TMGzX64npMA45lDqMgfenEckhkTJcwl+ybMzMD07UWcH7j7uX+eAhFnEnEDAFKyc8l
 RR8bSPd8+mbIj+eEYLGh/jblkD1LlCiU41OhKnlsVfUcqQuEpaNmspQDYZY4RN2Pgsw4hrJXI
 xsDFHT5VZ87JblyXDNOqrSh2SSdXsjX4UTemIVh9qRLEzESTjHXgn9wdjhaFH7qT2wytN8sAD
 iURljUJnl8yT8aHbb7dJ3WBEUYiZlwwyvMJDGbFKFV7oTVoFNder6bXNfNOr5WczIZvfzcvtj
 xoFhhG00jCMazcf2FneBDjsU9yeAtAqOAX7AQh6DXvgaDAS2dfJjh0H67rks61LpD/7qPX/QE
 8fS+zJVEpIUp6QWXvGk1MkUt0SzMuN6un3RZaw58FMgiTHPNLZuYNSRSEG5vgDqmF3mxsmnYN
 xdZLat6bF/PmmckJWAEIL61wguacRAc6tSTG4/LhgrU9aqFbCtJLFqVTjkXMek/wSmBuOjVIs
 Oh9R+McJxVGtkiXwlWa1k7V2ZW7HZe70C6MyNVr8Jw0D6wtnlh5GB4OancML2oCaPdRUz1a7m
 0/7YNBQ2s0d+qrRasKu9YAJfpvsftYRKwPgktQV8b00p+RK0aa1gAqpnPfGpvvvkKe7fnw1/w
 YwypnTQtT8tvdTPgQRU3On7DRBEmESb6xLSZu9PnamaPlOCaeVbV2gh1CBKVjnee0qEoVEbuH
 gAD+tFI4ll8y7hX++HH3YsXvkJa+Iy6fJQAjC81Sv4taJHKqs8Ix4g2xnqhSTkcNpDnuQQBZ2
 zrJLpqbXMirGGbr/tLSOgBOcPatMUSGqT91At+HInyP9k0KGzRSjGDpNiEPe0a7QBBSFRTvVB
 PDG6c0I9VFb924wRv4UJ8dAeZJuFOvPiHwQMc6EcVWwXJj1FhOp6tP7Zg1N9yQeIFbOinBaLT
 +JxhYFw0CD+JXR6sO/3M/lOta9bSF9z9vYV4Rk1QCYiSNRsONt7p+1QreNaazEwK1rs8ooBbN
 OCU2WILgASXff76d1qDw0d1m/gyrTq+ubtEa/l4ntvdzcjdKkKmyPDhovKFq3AD55JAnYW76w
 lLPDLbLHwSpk375q0ZFmoZfEV629EblYRhw2Ziu3GUCN6VHU0q3IIN6sGgqnX1CngoYG4SBp/
 KCDKf84IZuGYCZ02o1ER2gTMc0LLBE9RKgK5wVCVnUaHNgi8J4jqxG8J8JljrPJaUXypglu/Y
 b+RrG+vFWraeaLG4fYVZV/SU1a/YBVEXLUr+3viHb1SPY/L+PI9npsr/TNGiRqjGrKvjzazhn
 ia3LzM2REVquFWcvpXnGFZgKdrqhhauGbPNU/MDgIC5Tu9U1oCdbIyIZRz3+3CSaGIXonETAt
 XRiozHU/JOH0kZSLWsoUBFPTh2AA/mZiExy+enUyoGR4AguqLxgg3mDxnDW9JXvyzIFV1xkh/
 RMTS9koBSAeoZwxZDPQjZzVw+ki6h1pSEs4DI59HJWa74/d1GMPUfTRVqusVrLVUMi3VJtPB0
 hDMI6wY+Ey0WUSrHqNmOzcdd+77YtWgpvOARX41Sh0wK0Tw19cmUVXAhCc5Ai+11NBYfyTbMD
 gx9mW7XpL1MPGXbqQx4ocsXNbnSY+36OXOpP7lpx2tnorn7UFlN+xoh7iUCAdQ5vTdWRGf8KJ
 1bHi9dD6IuUHqCYgNDXG4wHEI3YAYRQF3PGddfdD3pwLfP5sXVubsuvKWTin7En5QxPScEYh1
 G25hDElni/nTkNCBrSiKb5m6woV6UzsGtXspVI8cJtDIToCNuPpoFlbMyoRZgngTUWnzVKq9r
 K0OdTY9VOz7wqViSYlZ4qPIK5T7emkJ3s5G+Td9CAFQRYzJnK7jpRajYyVV3twkZMVpOIwuhp
 741hNt7L74B8oN3L4sMbZw1TmJRntgf1vMHy479+RP3cknL3Pdo3FO01/b7G54rBsGXNBM5Ee
 N7eA5ucPQJSZi1vfKS89Clgag/6yykDj8YJISjBineepgEJEyHJmxsZ24LvHekybjKAiYF+nV
 KRSvT/rfvg6Bjhp63/YgXACDLTlCfyCM16oYjpxeLXI+yJQHtcrLXhBbtopYbD8Bny/6sfgp+
 okK5abIccdrEowvMJDCBvVFQWxx6TaWmE7JPDELEQU4s8R5tyFIqpU5mueBfpKSXJt4a9VnKB
 V4SZjF88iZM7OYOlAlNqs/8uEcLqHQjULnKhOnBz5YDJzOGTImGULL4G8VbU4jFe+MLO+UwBQ
 7nydnHs2KoJXWcIGmRE1tqfjgO6A5uNzNJBaMuPAQraPZlGOUfyFhdvLhPPYLyu03E26otGAp
 rMKXT3mP3gZANszToSp9NNFesGlQspufGX+F56kAD0+cwWANlWnXP0MffHRD52Vt8in+hwUdh
 FaAJSMSXAsaJ7FawjZ4W9Oh87juq56B88BhUDqmCpxr+tXVKCvKIUyCrHPQxftbQVVzWhhW/W
 pGp4K8peGPq1Icre6i5aKg5WVL6xWilH6D9xT9XMl2dT4845T6iYZQjS7MzWY6JmvZIBsFhG4
 afqtdRT9bZFkNyweQcX1eCMGyMbuySFRZMy5tglL9IqIBBQ1HdmAnVW2HppdrGj/TzGdo/wZa
 dX6iacTBn8GMEWHHnJvL4bwjBSiJZpowt5PujasN+kmQ397hZqCK0rJFNEjNIbu+Vqg7OOrt+
 UG/afq/77bMRNz1fG4J3Iht9R0ptiAZ3MbjTjmI3Crtiz0QXB+ibvXIBRlntNov+zLJTu3q4y
 ZZ9Dj8aHu2+KB2EYwLAzey9GNVmZ+WZXudvf/qtBKYpmTd8Rj53ylQ6XZdQlrEuhgLUQo6aD8
 ztbCRh3Vm2DOxKnz6/UDsyRwTTmqlxoVyZkoDjMPtPt2lq568LcX/8JenEGvvI+Uj96a3if4s
 glwaKuYbF4sBCeSlX9w/F6584ZYvTiZ9MwcGyRfaXKeHtfxezk228FCEkvmNbYY+BhqtDCdvy
 i7/TilDkjM/uW7VwxIUo8CxaSVtRrQa092xqelXQGKk4NuTfeTmdNVSD7U8fl4DjWv4s5BCe7
 B+kyZkuOVLgwDq9daOaMtUDyAdnFblaHPbIiFmZLHlnyK2OyS2iLrgI4OgbALJV+F/mDNLbuv
 ZVyAzdFiIMLc6CIRJtPDh975vdwMoSaA2ylAZ+MtysXhaGIyd8jJnrszp1C+1iiyYNhSv80XF
 GCWJy2escB3ne5x4VzzN4W0KCrmWU8SgmBb5sGzLn+KuFBxBI1PMgnegqmoEF1XeIfyK2pADH
 E5O9lV2ioQeAWyfbvIIqNIWaYjZqtTW2GPoQbB6dis3h/0qxvrsCVTLJKM8F3TkHiBHu2dfbQ
 yJHNQQ==



=E5=9C=A8 2026/6/4 10:26, Michael Zacherl =E5=86=99=E9=81=93:
> On 31.05.2026, at 04:10, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>> Indeed looks like some random binary data, but at the end there are a l=
ot of padding zeros.
>> This looks like some kind of compressed data.
>> Does the fs has compression enabled?
>=20
> I=E2=80=99m sorry, I stand corrected: apparently I managed to look at th=
e wrong spot and during a regular boot I now can see
> /dev/mapper/lukspart on / type btrfs (rw,noatime,compress=3Dzstd:3,ssd,s=
pace_cache=3Dv2,autodefrag,subvolid=3D256,subvol=3D/@)
>=20
> So your assessment about the file fragment is correct!

Still not 100% sure.

As that file is smaller than 4K, even the compressed size is smaller=20
than 2K, which means if it's really compressed it can only be inlined.
Extent at block size can not be compressed because it saves no space.

>=20
>> On 03.06.2026, at 05:19, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>> [35884.964320] BTRFS warning (device dm-0): scrub: skipping scrub of b=
lock group 26873954304 due to active swapfile
>>
>> BTW, swapfile on btrfs is not really recommended.
>=20
> I completely missed that! :/
>=20
>> It causes quite some burden for things like balance, and scrub.
>> It doesn't only mean the swapfile itself can not be balanced/scrubbed, =
but also anything else inside the same block group.
>=20
> Understood. Would it be some mitigation if the swapfile is in a dedicate=
d subvolume? Which it was until now.

Unfortunately no. No matter if it's inside a dedicated subvolume or not,=
=20
the only thing btrfs cares is the underlying file extents.
Which is not affected by the location/owner/whatever of the file.

>=20
> BTW, from the mkswap man-page:  Since version 2.41, mkswap --file sets t=
he nocow attribute for newly created files to support swapfiles on Btrfs.
> I guess this wouldn=E2=80=99t help much on the bottom line.

No, it won't help much.

In fact NOCOW is one of the requirement of swapfile on btrfs.

>=20
>> This means even a very small swapfile can prevents tons of block groups=
 from being scrubbed/balanced, which are all very important for btrfs main=
tenance.
>=20
> I moved it away. Thanks for pointing out!
>=20
>>> I was getting I/O errors when doing a cat on this file and I can=E2=80=
=99t see while my na=C3=AFve search using cat didn=E2=80=99t reveal this c=
orrupt file the other day?
>>> Also, the broken gai.conf file still doesn=E2=80=99t show up in the sc=
rub log. Not sure if it should?
>>
>> It should, but I guess there is some bug in backref code.
>> Will take a look when there is spare time.
>=20
> would be great, thanks! I=E2=80=99ll keep the broken file for the time b=
eing for later evaluation.
>=20
>>> Jun 02 13:50:06 EndeavourOS kernel: BTRFS error (device dm-0): bdev /d=
ev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5347, gen 0
>>> Curiously enough after being back, booted from this fs, the ExternalAS=
TMerger.h file looked fine! No more I/O error!
>>
>> Maybe even LUKS is involved?
>=20
> meaning a dm-crypt bug?

Not sure, I'm just guessing.

>=20
>> Unfortunately with another layer involved, it's not any easier to pin d=
own exactly the problem is.
>=20
> Sure, but encryption is mandatory on this work-laptop.
>=20
>> So for now, my only recommendations are:
>> - Disable swapfile on btrfs
>=20
> done.
>=20
>> - Delete any files reported by scrub
>>   And since most of them are managed by package manager, just
>>   reinstalling the package should restore the file.
>=20
> Q: besides scrub reporting these files, would keeping the one cause any =
problem?

No, but I believe it will be much harder to detect new errors from scrub.
Scrub will return an error if there is any unrepairable blocks, so if=20
that bad file is there, scrub will always return error, possibly masking=
=20
new errors until you check the scrub output manually.

Thanks,
Qu

>=20
>> - Keep an eye on the routine scrub result
>>   To see if the errors suddenly change.
>=20
> Ok, thanks a lot for your time!
> Michael.
>=20
>=20
>=20

