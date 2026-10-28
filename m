Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793219137;
	b=Lljm/MKGQ5u2R+jm/rRBE/uRixdGbVzMuo2XksV/ijTkEdv2ECp58PV1CvjXRwF2Z9D8
	 +gvdEtExL2XOG/ezgM7Gmq1wh+J33/+DQLgTbQ83huDEsRRuP1lihBHN3UEMJyXmgkPoa
	 dLmdipy5Loif0a8zufAKhxh1Y7apdlsPwG7USNNq5ChEHU8uLW81RKyZBYIanhPyvo9xW
	 UEE8sB/NGs0/kWA9M2Jq2yJBQaJaoVV8WwIeAr3OBkEqUPy3hSJWjmOyGdVZPrNEbc9y4
	 ro6L54zRLnKXPz/AyjWkLx91GviF9SzmzoyFUD/Z4+LI7kcZonHVj2NrTZwct1un3kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793219137;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=GSNVatbAoAkOAWFv8jnoXKyuOJPrsi+8TSg2NzV3k3I=;
	b=ic2sLQM7whbETB3/Bz4EEoJsTJjmMqGtEeKz6i6y2M45PIdClH1UQz5oSqFEBR83xswY
	 ztuVF0h+mZFsGHc+iwm3OvXURe0McpRHa4+Nap3arW15uMKCHIkGsiSN4OwPFbMHzxJJa
	 cRgaYVWJyYwTvyIdKoVq4abwQiJGBBkjZB9svbginbjGZXwT+0RuuiEjtIACZmFjSYTdq
	 CXz4rTVmfngLGdRMyCPMqS7/EVVLyDDRO8RYOU1EbGbDwNLYBvKOTieP1liJBafXxGBeK
	 1DD916nJfLOad9mD73MFubtxr3sXIyjTgt6VNQk91g0EWPnYovc6XUAsxyelc2XSw+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="Gsslz/QN";
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9839F606A31A;
	Wed, 28 Oct 2026 20:25:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9839F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Gsslz/QN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793219129; x=1793823929; i=quwenruo.btrfs@gmx.com;
	bh=GSNVatbAoAkOAWFv8jnoXKyuOJPrsi+8TSg2NzV3k3I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Gsslz/QND1R3jdYYFZcfLC4C4CNBjAXcwI0nehoSvV+ILevZ6x9f/2O18zKyk+n/
	 IfSlRY+Yuj1UsU8ALPrh4UTOTZBFFUys8ohX4zfDwfI/Qo1dO9FyJ9MLNYsi04ZZW
	 Ki1aJHrz03dcbAMS3mmFchKliOvS3HhHC1mKiqrYy59+I755YG/qYm99r+SuhtloQ
	 Y2aXDuuxM2V2Z3XhSqcOKNt96RTU17zl7jSNrhDdAiU57NaPc7nzSXi+Dv6QkYLNb
	 1jvmg90xwoS41Csd4Nmhm3QXDKb1NEC2uiaeALb44ObA75Y+Ro3iB2zVFeZAzJK+V
	 Svbb+NIyChLrku9W8w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M26r3-1xOdBQ0HNp-00954J; Wed, 28
 Oct 2026 21:25:29 +0100
Message-ID: <d7a63c1c-f178-4879-ae42-39e9e088b9dc@gmx.com>
Date: Thu, 29 Oct 2026 06:55:22 +1030
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
Subject: Re: [PATCH] btrfs: set the block size before starting a transaction
To: Qing Zhang <diasyzhangqing@gmail.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Qu Wenruo <wqu@suse.com>,
 syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com,
 linux-kernel@vger.kernel.org, diasyzhang@tencent.com
References: <20261028121458.23499-1-diasyzhangqing@gmail.com>
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
In-Reply-To: <20261028121458.23499-1-diasyzhangqing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OBBFIUZ/1nEjRSQSEOEWTPLsdUN5wKt32wtrlOkCzQeyDd8soW8
 AX8aDgui2rajHycRRcce+6AmMVAzKc9f+43aTU5yHy9dJDRSiF2y1LKwMYfbhldI5/hYf62
 eJPqNYel7YxlBOyMvhPdSAkrMyh9KJNtBDFUe60mvQagkIXmqifM6Lvkec1/vJVsKs+9rWB
 8Glmte1LyGZIk/Cu6adbQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jrzW21MqTFE=;5LgKWs47/JVF4PbDfFoB+6RF0bp
 GlGEWLazALLeTiRhtpOePq6Um/wkvoYRPJCfJqFk9MAEiowb5ZhmqDvr159aFrp0Uwrn9L8IO
 Uvc0WJqS0fZNX0yuG6UE9k/ux6KuuK+muIivbsd62MK+XKidG9xE+tL/GSXNc8ecLYukub5UK
 MpBTE7eY/VdNUkyE1AFz4WE7AvzoEl4S9gerVmyqsB04V9usDWHjPlFVvqUwcywz+/0+Vgpeq
 WdEXe3Xpd3sVBJxIvIkFF9H03e643FHgjgbgLMcZheOMysrrmXapbVTRKfFX4rJDaaB8S5xSo
 dzqqOfs+fRWiJwE492q4DXedbeKhEruIFroSbMcj/M6nOPrDtI7t3dr7SUlSgCLmgYzzCOL06
 Iyl4c0aqYRlZC+6EzEw76A10gap4n4PPpEtlMdzQvCLJnyb9kaABlwi+PLa3MpthrobBmPoa2
 ZL2KIYqel/RPezh4BumwB0NHawO6zjHHvVcRF23Ntxc9woTCpK7HIVCVWRWGBjGJzmshTOEWO
 KvSNdkpVdIu13IXyceIUTGPky7izSVM6CRQ3+tBQhfQ3MIRvnA2cJhLCN4j7tI8xvi+swuWKa
 ce9hSXpwzhwpnsBBcLC2ziq7+PTll3bqvbZhcnGsTmIVjHznhmhUK080Kgxpb6amqfDF3CxvA
 eodiw6rLtmNbmS9ym9kFLKyPYsVoZhYS8q3p2wIRfb6Tk8veJ0HjRCeVrW8d7xgTdOeTcJf06
 O58Z6dJG04Na4B33Qs9vqCRGz6jrYQySpCaHLgYmsRWr/g2cGNflw+ZEppIBAhdmdwg825kPg
 KJ9F8SbW9d9QnH4FukzHmQc5ZTpdK0GoBDWsAYEBuxnzDPYX0xfcCUg8aalrk7hlgfnB58h+U
 YcegjeYXiHMrtzTY4a/TJZEn6gtS5nAw/MqFcTt8UuVR4xm3ZSvoDYcOuv3zJiG2QB/+7Zb5o
 2pdh4EEZrSj8NU1ATTSIJGExEtpswt/GSnaUgvn1B6YaQe319HU8Pf+Qjd4fGmwV1EuEBg2I+
 KfOf3dGDGqnL2aK5QTyrZ5nwXQ9ZnqZPHAFEWydCTCs5Nszeqv56Wvq1rS1DxBSGfmG17eyA1
 FT5/97+l5Npg0D8KJs5f+pWljZ8BVkBuLMApNZwV1AFNOqLqdt0vKgDOAKq+ejDFPPRbj//SP
 YXzMijBA6FTGoSBmTh/IEV3LOqzgJoPRzjseL2HI2IP1Rlj68nZTPnQZ4QXh5du/YGcEfEdQW
 Gyc8hW22T00alzXjajp1eR0bbgq0KqKNqBqIy+xOl+9QQ4KlWFUijDvkTwFDc5vQkpJyXsdb+
 6hPhH73UWcnJWgmvzr4//7X2rC2oPsNZ76GIWly+38rewIgyGzLv0Abj1rI1yjF4jKVa46RXB
 agY5VkXFHQdxwg2o3SmRb1PxSbp+MY6Q0/hl+kurrrFrLIdEGvYcEA/0LrxccoWozrzCIueGv
 6eucBXc0O4dyEkflVasyYHavxkN5Bnk2elMhfKR/hwRsgj6U22KU4NK5U1UXLFUeTAXpzVQ6w
 I/EmaN+Bl3CIr2yq06vFBtc0VJqSYAp3tN5szXxGpT/qwQZtAan06AXGHw0a/vNqj4MhRXOcJ
 zYAsmz2Z/jcHZyzS6sTsY6YqM3+Yq8vAHWXI9ZyxCyLs3xZYcE/TId4cUNDpxnavnZ2VzBx/+
 6Ob/QvgHdTqKZMyIUCOJue8ofumyNQCAItwyYphB7cpU5bH7XG4x8GdLGT969woRhydWWqIEn
 OmFK+iZgEQDMOzxfbBzlTRrPfzW9KVVwqWEzL1ywlqiP60tRg45CeQF+9BopLexWoIL4xv52x
 bwE60QsoebAwOgSSoZKHhvag0+IBQBl+yZk5MUHJGXFJzpCct2brVKzYepWWICdUyGnGRnjY7
 28W3XNn/yKI78igfXT6hmwGLNkSBjnNL+O7+Av+U0IwihgU+hF2xR64LTo+5uZR+NpsPplTlh
 /GrHYwNTjb0+GijWhaHSCsLildVw5fVTnv5ViAcKz89Yy08yTkRLrvhpxeYLMjZx9v35xWlSE
 FFX1cm0Xc1r3/VJjhgkVD/YiXXDQHzYKOdxWPHzWstmJTrsei7vp5ngDeQJ2Cu8Octw5la6LT
 vl4WUAUgfWAJ7wtfxRhPiroldFgX2kkt/DBOM26vr1zteV6USE0QFwlUTYQOk0V7yUNgNCFoj
 esE8pPIO9pDTpmN3uv6fohzPaMC5opxmpA1VT42b3uxxvDXvQbxfoEfnyn9Jau5/4B2zZjrrJ
 PUmzoR84eBxn6maUx5aqQwzNqWtxxv9eT2q+rIBBzvS6sP0SBIzFZz7WpcjwWZ6sPkK4NQGpY
 wGcN0hjAJ8WHRTxIRT8jCt9VZCZ4lWVClwQqqrH2QmS/DIheYg5i6NDl5rmm6Q92Za/SNmJWL
 b9yYZ4adY30xh5LHPs/E2wrdSYqHwS21RPtofkQPIylwdvRE0oAjZe7/cREH7wL9JMzHpXj+0
 lxzmcB2TNXABouLYrQU399ZMEjxYIR3zY3EdhcjnlsMzxvc5SWzHo6QIjIGn4T7uxYQOwy3hr
 rxkg5376MpC+UyHocT2/r9GjavIfQkwfwfXkG2avjWk3uZK4eYCg3WZmZeT9Agh5+rUOwhqNR
 J2p1c8EXjiCvWFDF+AAHTpJ7WNWyTLLr4sio3JtyZ3tNgEsR9lNUXQsHyKkVmkz4T0YNj1ASx
 0uij2mdAwW3ieKAyDr/E5kE5d8NdPsPjGC0h5YBRjANxzhYG0Jb8xcuiISWaTDLlKYmBNWwAB
 VdnbdtMd0ZLFqCqQrZ27krKIKNJRpqXwclPawqTQVQj+k2LyM7ArwQt/8tct0jdtcWoOEWW9w
 gX7+VA5YRiIVrh8cKGA13JFom/Naqa21MRrtYqspcu68lWFi7kTE1CSxAGHfX0aq+KhsQl33W
 n1QWcP4qeG9fOJPH+WfK/mBJjY5Pdha9179ZkDO2tLsgPB5wJYAQWgwXsPqTbgWVWLrWxOIuS
 wyZRtA4AH4RGTLoZoomY2XIHFF9bTNxAw3vh6VmefNYaDEDbAGGkI8kM5mVfCmMhqJOICp9MX
 6/nuY1+B4Kkxxo1RqV7oC6Izbrh1CeHznXWpqAC611o3CVPsmJblbUAs2G19d1fxXVhLh496q
 3yynJJ6AH6x0xsmDA5QBQNi5io/ufTcU0cnumYqvz/hP9+pGcQ6nWLwpILEesc20sdNtCoBDE
 yCLMlSJm3VNMYpde456U7I+EvC0Y4o4PEoZl+iGR/J/R7PzyVPq3eOClHmWU1NyIHT+eIOdB2
 b3TjHQZC3oxzWbJM23CcOZkuP1yt/Sgiaj9jRpkEYaR+CAAiiNuOS8xpOAi3JAe56Ns2LJw58
 XjCHZOM5/M3NksuGUr2q90M8c69ucY4IrC8Dv06Aj6eEFruZnNLPLU2ZaKIs0F85g8vLti1fb
 4YfPR1ky07oR60baendeirCz1aDTTxy50ZhKy/T04VMSFE/M5bPIjXHxzKTrMfd4qjhDjIw6m
 R/pH+9n0cx0J+Z8C/Inl6FL5FjBOBm28t692JjSx3ATQtcZm6JJPQsUcnQzRHERevCcVNuiri
 9XCEhNovSEkLogKs7JXjs94VFhIdTUVffWx+/VOD9tAO0/SDQ7kVQ07XKW7v78qO9VPDM4X1n
 tzxZtXXk8VSi+/h/ZrIgBOwKQJjLvd887z4TGewUmIV7YtOf+DsewIn96+UaD+F+gkbARG10C
 O4Z5ZVyXpfaOb4sa8QIbsuwU40rPBANdnxe08SP9pQJpQfbs5kd5L0u0OT0pq69bJh858AFja
 urLL5AE6LaGe65jmZMjV6Vhpi1gqmbhQV40AnHgqGS0JhNRsnLIDHmpqGjCYZrMcWj6xSIMzI
 mbfcmlCPtBg5/xuNmPAx/SE18x7wLZEI8YROJemhMSIuTEJHyQzjdWzx/k4O6XLbeYBfIRrGb
 ecrdazTKj/1CnyktzcNfx+gi/3+yAdXvSgo5wXDwFBRAqJ5yn7UkxSitu9+hyGbyxdCleZN8d
 tyHRWGjysMNuzWhRAwP3CrvUaz08DPnMIOsNBykXI+3bh3wFmOMrfXecu5oP+YhExRG7GcPRM
 C36Qoj6kPEOfNP7kNRRRxkoJ7EdFPwGL480+YsI7t6FDUcXdpq2uZrO7POVlsuXfe4qt9uiYH
 48cguwA5FJHzwkG8OQeW4zCVYn8JeWLKIkxuOpD24/1sOQgs/OQ7DZob6gdHRC3dbJhgFzu38
 AogtFQeNo6WUJKe5HSmQsP9rXyIdw+p+nqj5X+gRTRUCbaRNfIWP4HJCJ/tOpVliXKjzMxVat
 fsymeRrdpI5KyZOAn2DyVEOBKgHhYcY2wT5jRyDBj+zlq3O5LBBODGcbJeQYh1h5pAdrRYpbX
 cl8mXlpaY9B4RQTGP9orDL5b9dxsIUdyX5kkgLQwyL/ym9EDL8nWJqaGd6MTR7WE3ZiEdcpEy
 QsTEE5DmAkM8Is14U1MQuz6Qz4EUMeiOxbTx21AP54M6nfl3IRlZSRE5MT4lRyXs7IRhGYiqV
 k9Kyz5iM2bThxvATtyTdRWHyN+xpGKcWfAc+o5S78JTcIFGcgL4K5HyEFBTrPdE6V5PjZUVQR
 b7ipbuDmTyqNj9zHZA/NBQmHwacxafq6/KFHeRIvHj4z6cNeDqOPhvLIy0rI6u7F1odC8Z5jk
 NNtTv8wTon8TBWaKely54SdNEzhxczSudO+uTFG1P+fnYcNCTnXbK9KKTgtEdqpBLTNnTbOcF
 hEqtprsjuN/z3LEu8gMSOTVqewKK2mmrQPmL2OJnpaadpKQpWw/eaYCPJuNR0mmkmxmfMqTzt
 U67kTyE/GZ0HGJgDsKDjfx2XQZeBfrNmAJ6poSSgQWjZVGqKy+KSdhS88Ae3Mug5kU9CBC+Xt
 xG4T5gunrEGgGnnAiMqtAUhu9E9rGK/7hhTaKLbTpdYzzXapSIGoYMBfnJ4UWDTBHkusauKks
 nGucTqDGooKKOGsxg9wq1QjCybdy+TVYxYsaifzsYi+dno79PtEKKCzP73kYs3jTQ+5LvzN/i
 I0dcqeSe5kjbK7zMPGuLwUOMkxWQq0rV100e/FOH5bWckBJptxvdk/MC6lacrNHC6vIWWtnoF
 sPMQjMk6O+9r7vqWojLkrOEIZ0O32/vLNVwBxCssOfjokhh/lRo7qmclRutm/jxBsSEsnMpJ7
 0gcQ8ehD08u65QHBM5UuBLKgfnlT44MsxiyOYPMZ9pwVqmE6rwb+E5gyAsMVmfZbAu5n7ktNP
 EvAzvwh/kzFelNTtB8iD7YRI0rlmrZMy8SvmwjNDKnTtYg8SHB8WtCH9Cs1zaShn2PT5QL1HB
 gkRFeIV5BHdrnjj98u+v67bupmTzGt7GGyokM+NzCnoCBfJTpUoKuz8j84SaCLYkkvZo873wr
 izfCnyN9G2CTC3GI+switzA+59NQdO7kBMUGPcoVrQJTX9ELay4AB/Bpy6yfMKkAS4QuB7LyN
 u4OygvX03WgzYOM7fMo0TAkxy10YRkWZnuTf8gv0KezfIu6hq2QRBjmqAhUf/lM1IgOfxUE9R
 gT1SEHf2xhvCATpVWVAhv1wpbnfGjXvz/g0kX3Q09y4fgX/ISkyf45ilv/0RJAql4caHXwZ9m
 zeHq0lgj57VFerqZ/cDXnPx0QZwZ4dl+MDciB8/e8C/8O+dp7nUD6GX1NmgMrXmcQPOTUhA2p
 zwD5wRMMjXkxEJmjLcOwfKJydhC5oj+R5bTafrJQSCvZeH1E8mXR16gOEh4B0gvE+aEEeG3Q8
 Ri+KlZL+ev9Fyh3cASmlPFZATlLLR8MX5xZ8BQkLP+3kZ6LS4szYajOTqsCOrvDrcmQsNBhE5
 yzsre/THnNVHxm7b+kzGDPk2V92ZpeFtKOWfmX1qDdb/0xrRvfoTyhr94j5ZS2ou0lvrHNibC
 WsjcJenKZ/yoOTdsQgiwgrw+klR2GWmSUg2mgNNLArn6McBSoG66Y9v8+LvP5yk/SAGuxf9oS
 kkl4QH3S82JSQW16CTtmvSnl2LzuquZ1Rjng1ZZzWN5xW3vYOc03i3+c6xNQjsFHZRiwbo6uy
 /YvwTYU5lvf3iIazHa+ZklgAC3ysxkiyDQqnyE23zYFqWtlAyX42IL8jPxh3e7pTn/umDrqSw
 9jyAmb6LPBwdycochbv3pewD89jw7B7pXxX/UUvvMJ/bBhUpLptY0qkVHdAmdZj9Tn/J0K6uZ
 wDfoXMjVUKWeA7g9axHTRaL0jbBN58AXVhERLfriVoNfzhqz5xJKjatPYcqkv/bVt5+sDwiiT
 s/AbOIDQ10hKWP3KYAILpa8XOkLm9HhRZrQkcHY2W3f9dGAfDoLUaFezApQnbraX88DbB1IXe
 5Bf2+eK8Dwq3/7+fEzBkOnMBwI/LtcORxbnFgxMR/SNOdWafmVvqesSrkhHrN0NkWqxPBiatR
 PSOCbC26F9DelN81gh9Q4UcQiitoHuUl9/tTzka6Q34Gprh8e2xT2FnzscJlJOmsPl2n7Chdx
 TMLKHqXHVTDAgMT6xXoP7U7mMYYZL9IWNCtzjeFJIteXKJBwdj3dFENk7Vq8H7mkpC5La4Hvv
 LwR0xJap6c+fYzU5XtUbl6hSKoRkePGccSkoV6XhWMTM9xoa/07rcuum9eqLF+jy3LhUGm4yM
 GY29OO3ctW849PTOSVxBI+CEUB3Tc9/n/6hZNmRs+uIldqPG97XpbaRoXDDSxUPb4Zci72yaB
 YF8xLEn8T7ltA6pcLzdaLafhRPrVAE0Ju2gMiD4UVn5bdKSXgOSkUZv1Ro3N1JEEQlZd3IiR1
 JiNnndxN7Owpbq9+HwsP1zKJDn7BwGY5IQ+SyHgbj6xRdgJEhZJlLp3gWP5Q+Lal2WbmLJITG
 qio+GgDkys7+MoPTMmlTOWflxYsQBimiJDcgKL7lZfeXCJWep4kTt3vP31sGSr0lLoCENB+2L
 dHyTSKQYZiKjCqlM6Eor0T3PC3oHu8VOgec57RjxU5yoSxTqqkrxV4zFVmLE3Z0Za33PPshHY
 ojw9s/KGvywT7ECIta2Rgwo11lAZXzSX+lIQT/ZcWIBPQQeyCnPwel6T2Dy/MNtSc94SM4FlP
 Lgkz/GWTj6tu9Tan+UPFSzo4QUSn1HqHbeWoCERX5z2a8QRz+4K2ECi8nKkEq1r2q0G86K0Cx
 ftlfXqMFLAhVdE168JSIFEh/+OgejzQYrMFXygvE4rBz/Se8MvtiUCiuJnQu3cSlqNm3KlEi2
 44faZyy8nujL0up/l4KrTLIqogoG8bEPMgPnEC22YIQLFff2+2IREmM91j2HZJPj7YxeSMPBU
 kUKfF9yEu93DExZzpnbnBhN2Qf2ABgxCuN5AwEYsmGE34tN8WTLrKOu4UHdjTpon6L9MlwwBu
 gtn+4T3HRYrozapBTUGoTtXxLM9qRaIvUgooXljICMhbIVM2FCBkRvxNvzhRa+dB7cONT5gmq
 Y8vM1wWsbm2f6MBNtHZj5IGnpEWj4pb1vAs/x26fShARgEjRNb2v2QYf5zPCiXovGhQdZ4lom
 Gd5DtyXzhBGGWsUAsyd3RzynglssR92U3Z2Ysv9IS2Y65MvA/1G2UdirkR97BpZ/VyIqib



=E5=9C=A8 2026/10/28 22:44, Qing Zhang =E5=86=99=E9=81=93:
> From: Qing Zhang <diasyzhang@tencent.com>
>=20
> When adding a device, btrfs_init_new_device() calls set_blocksize()
> with a transaction handle held. If the block size changes, this takes
> the bdev inode's i_rwsem and triggers a lockdep dependency cycle:
>=20
>    bdev i_rwsem -> mmap_lock -> trans_num_writers
>                -> trans_num_extwriters -> bdev i_rwsem
>=20
> The buffered read path nests mmap_lock under the bdev i_rwsem, while
> mmapping a btrfs file can join a transaction through atime updates.
> Since commit c0e473a0d226 ("block: fix race between set_blocksize and
> read paths"), set_blocksize() takes the bdev inode's i_rwsem when
> changing the block size.
>=20
> Move set_blocksize() before btrfs_start_transaction() to break the
> cycle. Also check its return value to reject devices whose logical
> block size exceeds BTRFS_BDEV_BLOCKSIZE.
>=20
> Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read pat=
hs")
> Reported-by: syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D5c01398781fb51df783a

There is already a better solution by not calling the stupid=20
ste_blocksize() at all:

https://lore.kernel.org/linux-btrfs/3d98566e8aa2cd99a23ce89665f79281c614f0=
5e.1792885061.git.wqu@suse.com/


> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
> ---
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.=
git master
>   fs/btrfs/volumes.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d3e6a9b429dd..a7f0607a5b86 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3019,6 +3019,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
>   	if (ret)
>   		goto error_free_device;
>  =20
> +	ret =3D set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
> +	if (ret)
> +		goto error_free_zone;
> +
>   	trans =3D btrfs_start_transaction(root, 0);
>   	if (IS_ERR(trans)) {
>   		ret =3D PTR_ERR(trans);
> @@ -3043,7 +3047,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs=
_info, const char *device_path
>   	 */
>   	atomic_inc(&device->dev_stats_ccnt);
>   	device->dev_stats_valid =3D 1;
> -	set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
>  =20
>   	if (seeding_dev) {
>   		/* GFP_KERNEL allocation must not be under device_list_mutex */

