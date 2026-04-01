Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD6226299;
	Wed,  1 Apr 2026 21:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775079313; cv=none; b=N9GErXziVC+P44Nn20wWw0REfJfEB7jgpI54YKGfmLlktKBx/1Op2NHXM2oZMGEm6KPoh8esFzWzkGCo0AlASoRgkGrwyoS+3lkBP8nW8clFleozbyB8kteumBIpH29Wtq9AyDD9nNfa0NowABfr4TGWugRtVaPY/s8sh7i2Vs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775079313; c=relaxed/simple;
	bh=O0AZTLP+/ldjxFu6Gp4e3th55FPj48g3C/SclatIXA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZlQ75h3wcKXkUkV33O8R0/UXgFeJGG/OXfKVZy1JNM957kzXcYDr/MSnSvsn97xIVUlQX8VBAVreZl22XK18E0/CMUpQWTDLCNyaFpTLjA9eQ9CZjAjDV5dGCsraFVR8UXUM1MyoihIgPsU3lexT1C6qKQnNYy7Na1Ehb0JV40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hb87tfEC; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="hb87tfEC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1775079308; x=1775684108; i=quwenruo.btrfs@gmx.com;
	bh=q/i55ZVVscGHtBuCjbIOEuVQsyJArP0Ofz4kLkzwWbU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hb87tfECPmBe5CviwONbufU9h6DRBS/XtGi95ox5A5psHt2ZzEZrCfQDpmzD4W7S
	 5H+mOkW/EVEWkDI2491GZFbkWryGxSadFV/cBbBM0kpPSVCt7/6D5GuBdwvdKRLY5
	 Oxte9YKK3g9AHgGC+gInIJeoVKMnYyw4EqVDHSjRucvaBJQwZztILdwvzJHYiNi6x
	 21pUsWpTdNwLqa6IzaI+OYrDKzNwWTXSpvEmrmXb2MPZtS1rY3LAUxePMkQtUInut
	 aGY+jGeUJPnP4wlwp50igasG2VOkep6lKEytXOUALzYj3m/zJm2m/8mkio6lI5deO
	 4raKgTOdhyhMQ7VV5A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M7b6b-1w8sZ43bJ7-002q95; Wed, 01
 Apr 2026 23:35:08 +0200
Message-ID: <d74ec3c5-8e9c-45a2-862f-24fb083217fb@gmx.com>
Date: Thu, 2 Apr 2026 08:05:00 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: disk-io: reject misaligned tree blocks in
 btree_csum_one_bio
To: dsterba@suse.cz, ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, anand.jain@oracle.com, wqu@suse.com,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260325100411.2483356-1-gality369@gmail.com>
 <20260401000556.GC5735@twin.jikos.cz>
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
In-Reply-To: <20260401000556.GC5735@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8G7Qgd1eLnSIXCxsWMWhlm/5B+3fBWZ8aWqCQnO5m2blYy8kDC7
 upMOM8WvhpbKbLcqVW4pwCFyySH6YgFQ8sNRT0Gm0nfxSdsDFSOZ3GhybovSaRFFvpbd2IK
 h4fECkaOQeAk73jLuD1mM4bmnYCKbTwufDu7OPLv7ryJBRMfa9o5Vl3YWbS2O8fKEv6/hs6
 1Rp2+/D+NvVhopsqTSYUw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:V9iEk3wMYXs=;ilTYA6wHgNnFh77ldPF/12tIdAs
 8cVHwzeyPTUzVcZTVZG8g/PpZ00SKkClOUio+FHmIx/UtRRe+Bao+s8UiaLe0y1Ii4Yvc2Sv+
 EFDuU6f3Qmiz8Hq4n4rtvkcvzsC1ED9Odn9BwuUlzPYM7fOnY1JSK9mL7sLzD6BtyhVLOwUV/
 debrIKPSnbpo+9+f1imVuXWHLI9mTtQ4AS1KRxSW29I27BDjUXRhGuH77foVCYS0VUnvQqWyB
 r7I4t5vSf6yT5QsEHmg4OBm65Z5OXc4WmuO7ji4pi5Hret+orED/XpWyTntrzDSvNrZHy3LfN
 s8yxOUX17kiQQgrwtdn+IaO9JAmfwxoUIr8MGFTNn3Xz1LlaNd4itoVdxTkJVxOfgIvyD20we
 qj7E2p/o6iJBgounAxLRZdRWi6/4HLmODocvSr7XlJNTMcKGTz9WGhXmc1T38h0JY+p15oDaa
 QipHWagGnJSExrb/4tDmrNXZrLpANxA2SdKSnn20cgqcjOBPGX2VjPUSakACCjAsN4b8aA0N0
 ZX1jt/3PHFmg0MzVZZ3WBAJR+Q/9zCEgStEYXdDYV5cGcuO/H02NwQ53FhKjGkRHV0uh514nj
 F063EN43x7fTEcwtmsH74Dgg5FoM7BwA5vcAnc3LI4qkkTD+jy0uGee3cZGQJAOCmQpKjc4wW
 to4ob1JaMWevcoRM7AL7/j+AGwkH6OzriHDAb+q35b9sxJvDJjt0jDo952WbBMXNfyZtXNCxM
 f8fDo+p4nJuK9XNFKUeGoA5Jr/Jx9QTaw0mPuyGn3b43fTmP9NYz1uHrWqaA265N43v97J8/D
 PVUK93kuhIR2qPExiiu9HzhUu5vZoR0kG4BfmuhnKwSD4eLiR8bKoWlbgnGJFqCcRvYVojTRb
 OcYtXqpxuTQ7tvGv+1S8rVLcCOaVNK9hcPPIlgcg8arndmMfpAsICR7YD+KeEPJpGuTCZPNXr
 zJ4KYH2fSHTycfi5WTgolt0kWAGIsZjl9Oaf6jSBeigv46x7n6EPsQAevlpF4yK+clm7yYbG2
 UzGDJSvfc27U3iiISJUXktYVjSsqHv9/+dIlKx5U/75I08WL/sRAbeJB/ey4PsTfgJgG3V8EG
 yoKvjNiJOyzBX8kAHpAbeFl0/KhU97t6T8+SV9Ctiuby7x5Q95p1Vd2Z2fZYqhYz3lHp0z2XJ
 52fKG/GChHSHypKYZFa0sptV5gyPkBc568W2y0WCNMERcAM/yOQd7U0aJOK3FUEg446aHz28y
 NdP5SiAZ8P7vtDXRKtKvL63NbUvP3t31U8IwtKEPzRJi0um7UvQRneStMpwVnaO+TTLBxd90c
 euz2hxGLE53SUZqIDerdhGcGbRKxY++Ia2Zr27PHVj7FXeqtD6opOmZwMgjcZhQkq5JZQhcEK
 BptYPF8MLlb/8F4b1GHDlVG1a2rMK2aDfE5vxDvIE+/K8SgObT3oPh1WWiMdumGMCK00j3DLG
 rk0+e1Et+HODOjxx+RYAWxiX6VFAmsUGjX8uqvdrq5LKiY+FpRYGFTVYcZQ6tMj8koVc+G3zg
 GLM7GjQ0PHKTJzGxu/jeGl3NgsLAPoO/OeAs//inOUEaZjKxXw7fR1A58KZ8SXNfSR8Npgoxk
 zpbMG7tGBvjpWHgLnEa1PIy32RnggNwlU04XoPuwhh//CNcgE1JuBlyvWomFppRmqcasdIxFc
 qXFi2z4q0JIhAgVdoYcxrqPq/qfJnx9wZA5PPdtcuEovfjyVNhyPmw5hK10hWQSUzyurx33iT
 Ksfqc7uo2hybzbUq6n2lCpqIzM1tVtf/K+LaU4zg/VfxZ4mIGvj8UbTIyUirUmA3Vq6XxFp6H
 GbPc/OYjBw9JiOHYMqxo6Y0EyoHl+jaXbRv4KAQNqc+Fts9A4TRBVzvxGrSBw5Iwg45TU7mkG
 VFK8qZs5818FrR/tdco1Pn8/ooTnO+/hN9Mv1nWY90Pb1Z5qUueDwmqChTykC2WkSldSqzF0s
 3JOhnp1ow/LZmZ3idW+xHKUrn7ZAgsdy6S5evcvg4lSqzgNKrIl6ZU+GyVlg/bZdY2uU9U0Oi
 LQF5mfy3/D2Ifu9kS6D0Di2ijg0fuGExMVb/hhiedRxjKizeK82BVBbjGth7H36PTB/r+PPxd
 cKmC5n7JffQBYz2IqybQGeXj/AKezcV0ol/n6tCUALKPKoR+RqIqsn1f7MfXK8Vb+FRa1X+2d
 lkZQYOh7aUPLXXTgFclcjXMpfHAuEMOac1iCg+7zKIM+xcoMja4haa3Z+rky1CxLZzSVjvR7C
 WdpXyJ/6tPcPtCvhqcjKWWv/kwcmKzAHfF0lnCGTkwibjqlbQw2EGD1P3Yo2wveeRHt48nJGM
 hC9cKR9xpSpw60l0jDvwafTPU9g60QduR9GVtYE+fMbi+G8YqBrNFFboWJkxu/dxd5n6UjkWu
 TkjhJfKhurZd87mlnZj10Biv0lF55H9HztTVlfl5nvAphmr7rdIGTuQjup3zSyE1kqoXv63nF
 vGOrGQDkb1xsQogMlfcC8fAF3D2vtMXlGalP8vDmFgfUEom8/lySrJdZP+KsmuBBASi8E/yV6
 CthH/XFCmnYO0D8L+1uQAW+9jN9sbP/NdHkZRUwipVQYyyq7yM/es6bDuHlXZs2ApgyM7x9yQ
 hUxRFvuFSv/Eg7gPpmL0Y08ZA9fNm4t1ENAPScabRv6PlSQPjB1kUa6sNlvLwH0TWBk5ErQxM
 ZEUxZOODmDkiOaoC5WtM33tFE0S5sAeQmeiSz9Nzcka+ihxpdtZsG9XkXWP9Qq9QWpMSzfQZt
 swlTPO4lFEFPU9R6LjzezpkoIEoO5imVSuJfFFCJQOFrLtG89Lyky2rZNq23Tzp7KUi+RPLvr
 fKgA8IpzjIIbXWzsyLUE2LMfYEdrP0yCNTzGmGrlp4eBD65CZRbX3VMGLH/U3KOotPBKaWXyd
 BX+zaa6HXpR7gBmuAxnRuR90csj1OlmEPJ1Axz9rgF4KH+zvbeB/U2vVEdOuYRAOS6il3zJMx
 ZE/ITekZYuE/UVWXrZh66nKw14y5MV8pyDxj19PRiC3cEXTNTAntyRFuxnB158dOosNzpDdoK
 5FLg+FreEoDLo+yhnqDRtddTcPXj3QfVq2SK/JOjmlQ8yOad0hR5NivnEUmaKKBeKBsJVf082
 EoCaFpRhoobfsNAqCo6Bx3w9cug8TTK3g+KVOnyjclzhFBU9X3Jhe5bqugFdrAn26YUtVXZN9
 E9iQPLrf+raoak3FrJBJrpwWEQ5s5FfScU991gNVDzD9Q7Lbc6CW3r+AdfeH51PaCDj/uy3sX
 tEJ8arb8IM6kftGRp3+FrptjycbGUUEHbYzmpBvJmmHvYLwsusHAVUFBHp1bqrE3d7LI0qVYR
 PgcxnWkLY9vvoHnreZRHmszhwbcx5fKv0EyaYP6dLURd6b3C6fm/8QjD5vBg0Ba1gX4y1QCg7
 c5us+TEkatEUuaeR3C2r+3pmUGyxg1rs31KLQb0K97eY9vkBl39fTSKt+CBEQ/bMamx+XeA/l
 OAJrABart+XGES/tk+eLJHYLFZ+KX2d1MnqJUrJUcStDamS1UXplqUMX5f5kXhrLL6oi4rzyh
 xav/h5QdiN0Cm4RihlD2T9iGa7LbM0v+FajcQ5svyjOLpz4CNGNBMTG12hrBAQW0gfap4vjSH
 EcLGmfFsiTas8nzDNtCX0rwDWGVdLPS0FRpBgD4dVbywOxTzg56RMNC7m2UbJ/ucStTfDKHWS
 wfgbl0J5Vj7Twi5kXzya/GqRXb0//NbEAPoXnhIx6v5Dt54rthD4ORskTnhMjPg5SE+CRoxJ1
 3H/DgWy5boeHMRIdLvzOyruFqSB+C70r8Lf/jIcidqdJCWpHGm7u0DELaBGoTrUzPrGL/w2td
 Im9ghtkYqRELgyCWfGg5njvDN2knlxzo9GZyBpBQbmsRyQ3wF3mvg9R2+/gG808qH/C5v/1aT
 DVGRGh/YB1ql9I6DcP5+SRF5yFxxBhZpRP+5PrUg7JrUCW4/+0+7sLYrMoDYJYM5b570LkbRb
 EwW4FP2KdSHcM7n7rHQnBQ60JDzR19up7Yr01tx6yJcurqjDyhMOJIbEqkjS6PU466HYan7IO
 2rIFyVI/twYI2ALiTVIJke2bkoOtPT2eN5cyAOr3LjqWoYYk2jB30Chas3MC+Xh2XTJDiY0Cs
 AIE42+WONweNBADtiWWmsRKwCtL7AdfOygh5MfedIy3rCTiKMOzysHMjya2OZlBx57oqw1jwr
 lHXHS0mv2PbhObjlIjJ1wbUG5jG6nJYuCKmI+ppNPwENsNSCv2cA1HDlie2M1iPDoZ4W1g0nk
 iIPTYJtTqu5J04+pHosHspLky3Gzuthcp61XxdxTiqVX8VItrmUfJWCgFWgj7MoU7min8NInO
 bb4mxvFzxeTEFNvynRj+dbNxV3J64AlWRoMpUDpeKh6YQXvVojym9MpjUaIiKvfWGS75Kx+p7
 6Ba892LhpKf2PrWBrUVH3LjsBov5BRzN1U1veWuOGQ++8GlXUyLrxL3gqV95QPFDJzjZWzUo1
 fvvMqEtuRLQLDdM8Gh0AOIgHgjx7oYaamBF8uG4uSWzz1A8VR9IGtCi33WOI2lEPpxCAyq4Bo
 MPOZozzg7QSkvywfir98SkJlj9Dy5YBONoNZNx4B7vbvbPbQJpvDG4ZaT0c5peJVGk6nCmZac
 GohAYEsdxMsGYo3j+ht0r4DMdXH/0ilp0dq8dId228rwGzBHhZQidaIP0v9DWN56MiS5qhtmH
 B30uO1xcQoAO1ojAZUWm01q1VcOlbqYaaVgIp0F2x5s019qeFkh2mbO13jEUVvj+GAOZfnbuS
 kN5YkG10tnei/O7N7P9Gari631rHimlB+QsxGof+zft64ZzCSXSWZSA4hrGaMPtFdV8Ni9jiQ
 sYpQZR+8wvxovCA7FMzZoUVL6OkBvMX9FCtfZb4k0/zSPyxeCFVM+7Le4WRihyyqtWtqWbCYV
 7RHQpGqc59Pgdt4QgcxCrIQsMpkh9ikUeWpWQusk/yyOTXYIiVQXxB7xs5F692qT8RNs4Z+f5
 rUPwn/yjbQyVNvRbJ3cMsihiP0igVRBl9aDbzZXmDgZa249VSiLGy+6XSyw28EHR3LXPxIE8A
 2TU5XR8tvRYd5YpDKb6sz5SOEyeBdcCkt4bY3U0IgUWFQWK9P+FDCpdR8G7X48OOHEEhAk1eP
 WlvOtCrdF5I2I4xkyWQKRH0Elv2+6MVa4raembxhAeLOTwabzDgArgKJwkR1HwV8OyScGTYY6
 rrbI7LNArYWrg3MzCa7iCpCBDJ2+rV+0Smi6IVA+gA9nj1nA0d39gtsZmtLWa6oy8tIVdKt8I
 K4SztdCf868sF9I0XavmVH/2U3ig5brRIzug7dcbL20Yuc3lSnmU7puvQdM7HizcWOOKXKrOj
 B/BBOf91WP+BdhJRS61F4iSz6TGGmagSg==



=E5=9C=A8 2026/4/1 10:35, David Sterba =E5=86=99=E9=81=93:
> On Wed, Mar 25, 2026 at 06:04:11PM +0800, ZhengYuan Huang wrote:
>> [BUG]
>> Running btrfs balance on a corrupt image can trigger a GPF, with KASAN
>> reporting a wild memory access:
>>
>>    BTRFS warning: tree block not nodesize aligned, start 6179131392 nod=
esize 16384, can be resolved by a full metadata balance
>>    Oops: general protection fault, probably for non-canonical address 0=
xe0009d1000000052: 0000 [#1] SMP KASAN NOPTI
>>    KASAN: maybe wild-memory-access in range [0x0005088000000290-0x00050=
88000000297]
>>    Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
>>    RIP: 0010:get_unaligned_le64 include/linux/unaligned.h:28 [inline]
>>    RIP: 0010:btrfs_header_bytenr fs/btrfs/accessors.h:647 [inline]
>>    RIP: 0010:btree_csum_one_bio+0x175/0xfe0 fs/btrfs/disk-io.c:263
>>    Call Trace:
>> 	<TASK>
>> 	btrfs_bio_csum fs/btrfs/bio.c:511 [inline]
>> 	btrfs_submit_chunk+0x138d/0x1750 fs/btrfs/bio.c:744
>> 	btrfs_submit_bbio+0x20/0x40 fs/btrfs/bio.c:814
>> 	write_one_eb+0x9ea/0xd30 fs/btrfs/extent_io.c:2239
>> 	btree_write_cache_pages+0x836/0xdc0 fs/btrfs/extent_io.c:2342
>> 	btree_writepages+0x163/0x1c0 fs/btrfs/disk-io.c:512
>> 	do_writepages+0x255/0x5c0 mm/page-writeback.c:2604
>> 	filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
>> 	filemap_fdatawrite_wbc+0xf2/0x150 mm/filemap.c:379
>> 	__filemap_fdatawrite_range+0xd2/0x120 mm/filemap.c:422
>> 	filemap_fdatawrite_range+0x2f/0x50 mm/filemap.c:440
>> 	btrfs_write_marked_extents+0x13c/0x2d0 fs/btrfs/transaction.c:1157
>> 	btrfs_write_and_wait_transaction+0xe5/0x250 fs/btrfs/transaction.c:126=
4
>> 	btrfs_commit_transaction+0x28af/0x3d90 fs/btrfs/transaction.c:2533
>> 	insert_balance_item.isra.0+0x392/0x3f0 fs/btrfs/volumes.c:3712
>> 	btrfs_balance+0x1021/0x42b0 fs/btrfs/volumes.c:4582
>> 	btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
>> 	btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
>> 	...
>>
>> [CAUSE]
>> The corrupt image contains a tree block whose start address (6179131392=
)
>> is page-aligned (4 KiB) but NOT nodesize-aligned (16 KiB):
>>
>>    6179131392 % 16384 =3D=3D 4096
>=20
> While you say it's a corrupted image it feels like it was crafted to
> have such offset. The warning is from 6d3a61945b0088 ("btrfs: warn on
> tree blocks which are not nodesize aligned") and it tries to catch
> problems of misaligned ebs.
>=20
> As we'll be moving to the large folios eventually such misaligned blocks
> will become a hard problem. So this should answer if this should be a
> warning or an error.
>=20
> As the commit and error message suggests to run balance to fix the
> alignment problem I see that this should be somehow fixed if the crash
> happens inside balance. On the other hand, the misalignment should not
> happen at all.
>=20
> As we try to be cautious about recognizing old filesystems with
> potential problems we also have to stop at some point if it blocks a new
> feature. The grace period is IMO long enough.
>=20
> If you have reprocued the problem by normal operations then we should
> look for the solution to prevent it. If it's from a crafted image that
> basically creates a valid image, shifts a block to be come misaligned
> and otherwise valid then I suggest to turn the warning to error and
> reject the filesystem as early as possible.
>=20
>> When alloc_extent_buffer() is called for such a block,
>> check_eb_alignment() detects the nodesize misalignment, but only emits
>> a one-time btrfs_warn() and returns false without failing the
>> allocation. This allows the extent buffer to be created with a
>> misaligned start.
>>
>> Later, during transaction commit triggered by balance, write_one_eb()
>> submits the dirty extent buffer for writeback, and
>> btree_csum_one_bio() is called to checksum it before I/O submission.
>> That path calls btrfs_header_bytenr(eb), which expands via
>> BTRFS_SETGET_HEADER_FUNCS to:
>>
>>    folio_address(eb->folios[0]) + offset_in_page(eb->start)
>>
>> With a nodesize-misaligned start, eb->folios[0] does not correspond to
>> a valid direct-mapped kernel address. folio_address() returns the
>> garbage value 0x0005088000000260, and dereferencing +0x30 (the bytenr
>> field offset in struct btrfs_header) triggers the GPF.
>>
>> [FIX]
>> Add a WARN_ON_ONCE() nodesize alignment check at the beginning of
>> btree_csum_one_bio() and return -EIO for misaligned tree blocks.
>>
>> btree_csum_one_bio() already guards against corrupted extent buffer
>> state on the checksum path, and it also revalidates metadata on the
>> write path. The alignment check follows that pattern and must happen
>> before the first access to eb->folios[] via btrfs_header_bytenr().
>>
>> Fixes: 6d3a61945b00 ("btrfs: warn on tree blocks which are not nodesize=
 aligned")
>> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
>> ---
>> An alternative fix of promoting check_eb_alignment() from warn to error
>> would prevent the misaligned eb from being created at all, but would
>> break mount and repair workflows: users need to be able to read and
>> inspect a filesystem containing legacy misaligned tree blocks in order
>> to run "btrfs balance -m" and correct the alignment.
>=20
> While I agree with that I think we should start rejecting such
> filesystems because of the large folio support and because we hopefully
> have spent the grace period without new reports and incidents.

I agree with the idea to reject such tree blocks, but I'm also concerned=
=20
about btrfs-convert.

The original cause of such unalianged tree blocks are btrfs-convert,=20
which can create unaligned chunk bytenr, thus resulting all tree blocks=20
inside it to be unaligned.

If we want to reject them, I'd prefer to start warning about unaligned=20
chunk start first, as btrfs check is already doing such warning.

Only after we haven't received any reports for a while we can change the=
=20
warning to rejection.

Thanks,
Qu

>=20
> If you have a crafted image, and possibly a minimal one, I can add it to
> the btrfs-progs fuzzed images so it can be verified as part of the test
> suite.
>=20

