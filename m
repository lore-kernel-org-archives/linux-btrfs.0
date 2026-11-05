Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915155;
	b=c8GZQ5ZWq4TwL9nfaM2vPx+IFTj3oX5iUX+cLyIDBzdDcCHJ7dkUt743VcR0s8J2FJJv
	 XxkC9ArY7ZB/bP6wNkJcFBT+f9aWusYBoC2SQ7Nv4oyna63E88zv3uRXFBrB07VsQWJn+
	 MoDe6ONlJaWiVyv5SFVx8VnEmvJBXAOH2/P/RHFImYaZkClnXmcZJJGJx+VgIlOH2O/c6
	 tvMZNsNUtojNGqigETwwWFhi+DLzBAL7LreAKK0rVxPl1L1s444i9d40mJ2pNMJrE5VYH
	 GuEtxaHbgEobjEVb1HF7A0dqtKcdzSYi0ih+/SiDbAGnO6UrgSmxzlWeoY3gY32oIRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915155;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=dbxjwrMPTubrXpaCB9WQvAIWHWN7qeqioXI6oBWTCk0=;
	b=OMSjEk2JTd7M2EWsY7E0eGoAm6pgIfuAt1loN25dvv4go2qYnVfneMM8TUp3aYeVlhY6
	 Yx2+TuOcEn8bGDLUoNcbxePsS9D1bHod6KiiuVtjvkfBKYKxjwgN8CbUwxpTKj00jOvi5
	 f3hixIAKquJFRhJHzIGZW7w7TxyXXmbqCcvFxdSryyHjdKeJZ2Xa6KT5r5N5RXd43ODYg
	 G0sdVMzJSxcUxM9qd1Zibzvf+0mDxXhIJQI5ZH4w5ejhrkOQaGALX2mKcWM7qWovBsp+4
	 qgHAWSJSkT9jWvXGRIn2rLixgAvwiOmyM+73kgjHZvR5h+dKyTXIGTBZK31l4wHuEHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=RY+tzd65;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6662F606A329;
	Thu,  5 Nov 2026 21:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6662F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=RY+tzd65
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793915130; x=1794519930; i=quwenruo.btrfs@gmx.com;
	bh=dbxjwrMPTubrXpaCB9WQvAIWHWN7qeqioXI6oBWTCk0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RY+tzd6573zvn+5obINTPsKA6pdkj7Bkc27KgRrsw2jUW/WumBHNwQUar8eESf4C
	 7/qSXIy0vduzNtws+OjLeHc8GxvZWBmLTCruHj/XBQvQhDiyLgv3lPxLhzol8uP2k
	 UPoOjrEM21OzFPNSFgNMkTml4yhHqKq6kOo9DUrDzAMr5VOh4iWzsGScQPQX8/s+2
	 zskE2de0lJ1L1On5I/iQoXFo/x4xG6dVaGo79XgIkNlOp9x3h3sU954Lbxi+u5QHW
	 e4v45lxoQUcDZElEtOXWnsP/D+HotCtORlC+1R0EDzywDNHvcrG2Svx7kOYyzGgJC
	 MMDur7Shf9RmffMDuA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M7K3Y-1xQA8D1YNA-00EK7p; Thu, 05
 Nov 2026 22:45:29 +0100
Message-ID: <c23d652d-4801-41e5-bdfc-ca8b91508647@gmx.com>
Date: Fri, 6 Nov 2026 08:15:23 +1030
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
Subject: Re: bug: btrfs: direct IO fallback racing with in-flight direct IO
 fails fsync
To: Breno Leitao <leitao@debian.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@kernel.org>,
 Boris Burkov <boris@bur.io>, Atish Patra <atish.patra@linux.dev>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <auxv7Tg0xSq5yHmb@gmail.com>
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
In-Reply-To: <auxv7Tg0xSq5yHmb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HF9ROKkvlEgnEVncjP3Ndk23Zp41bS+RMdWbljPINg/QLGEaaq/
 izsIiRPzHRZtXXuNyPwU7E1g6v7XduLU12umnQG2xC0MR+mkOxRdCc3nb9gvWhM594Sw1p+
 wwf3+TkKBCT0rci1Clf5MMTBu4C1wqhwKWQTCH0iRb2D95T7qysgh6ECBbmwfwVI8geZ1Nz
 tK8iPtoEbJQR9lNSGTppg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:AWMtiQ7JV3w=;Jhvx98SVSbF73VpbZ1AQ2NrgK44
 htisHDhUlO+bqttAK4eejJttObw2qx7vMdW27LQE/QW2yiSlYozwOTr/chKovu096KRT/45Gc
 SVY3iyK6esoQuSwR/hzJnGF/71rkn9YZdgtWknOmZs/V0kIiwLIcohoGHw+0s1kAe1QQGGhZy
 rr4JjJh47wuFbpoKIzdPWWPsDW6G5aFgQVxdSHBw4h3brDdlUv7fBiAzXkeK52LSSW961wRHW
 EdX9cSjnJ6u2hvyovxup/9ylDPrPef8dPT3opRq+uyDcgTLB3e5FK7f4c4Bo4TiH1QPb5zNYx
 QDAnsQcGsDJaVF0bRoJpxFZSNrEla1a3y9cCQEzZwYYGgTwUAOqNqdQ7A6iw8vKfLDxiIApHY
 5bCcPukNqzcmFkCLsuzm9xIz0jIJ6UibFPaLBntXcm4qe7Su5J3Df6mpBOm719TIfEo0Ew6gO
 Avvu3E7WRDGou6Dz34qYxGyIlnO8n58A6y/M20/9Z6l4zKwpMgk+y390EIWrvSKhQNuzYCRNb
 JyEstaVnlYML4JWizVwH1r70SpFaw53xrsRmrIj+FPW72Eyq+U6/S1IPF+iWfgmkQyUCaFpf8
 L5CtKfoyYfUu5yPKOWI+Gk9pzycaHgP5JZF6gO8sZM1QOSpVtvu+H5hawHnPTrG4RgU78ePXP
 ecMwVfy149eu5YCAmazl+B9kuaB/O++GtwLUv2gsMH52GlNbnkYUPp508SmKC1PbdYA/9/25B
 FFRS9CEtlzjr89SUVpwCQ0suGdXRRbMkXR4kb8Y4VK3bM+1DJ0FJvlRtc02zfPi0t+VOxD3hU
 97sCOABkBFugHFj0HRr5a9AxIFgv8i9ad07tkR2LB+IxVg1i7JGj9ayaI7RyCVnOGvj3J1qJ2
 P0TW2a0ivAy5cJHbW8ZPfJjP5p6OdUS9eu6jy0q4o0QbCDhxVCNRkaLI2/is++VaPAuyJ/DST
 alfjUS9wE/CgmoMRfdsUkzYjtjdweWQVd8sEWKxISgY2PfP6IQ1VX9I8rymwH5WlqR1G2+sZN
 2caLZQbu5fp2l25KZZu4pB8zBNai1OsjG9nIymSpWhBuVdEtZbIE0uJZvEcGV8tdfGfdBxHHT
 MMQtfufqQIWIicAEyrvWSVLtXJwOBGEe/5FZYld+iKtNr61GgTE+L2W6HyFbdsExTVkuQvnrd
 80uU2b/MpDc17RLKZyeIBFuGq1FXVA1WuUBuYx7sjKnDeeCstI9R2KC/0Mb1xrl5MkKrqav8A
 9/pIQOjWH3hgqmbo5U/SFSGwvIIeC6KrMcnMy0DNQoOUb99Q9cQKOG27IUHCOz/fotT01ezpX
 8CENgKiQh+EHTRQKTyp53LgPLVCotBREf+i2TrIwiqpg/dO0ePrUthMUHxwB5GOVJAu49xY3M
 z8uFC1iu5qtCwXKzul1j6pI4CzrIOb2WCrcWggaMpZ1WL8V7zjP3t2ViRZ7BUIeF0cOdRMOA7
 Z38Wrzg60U724yfXuxMx84bx1yzBDyJPGTFJk3iUuNi9wNGDDZjGznyP8ZcYKkSiaYO0rBFJ7
 s+lXIozbWC8E4KxGuvtVhqoIPpIISSHpJkzs5kKetes035rWNIGK/SiVBzg2flfUWobBmGd2I
 mCWSrwlRgJysyeY9d8eH2526EZjvDpldR1/q16lQJP8hOaYKF8srJZiPotqFbmWxT1krBBnh3
 Bp2D6d0GmaA1It3Ibhm6LDrAOHX13TID0R2xZpAOpofJRuCHjsIzz1IywxQ6X0cECG2AG4MxE
 N3HwF6QrQu/TD0Kmpxh/1Hf31z4+quT2038+kDMiWVESOblsIwd+gaR2zBq1j94eMtSRmcRyL
 Tvp6ujdPnyNg246FthlIH7Qf0y19I8s9BDz/8AUJugJ9XXNyQ9hYs1FFDZc7EzDky0Ycg5qdT
 XcoR42Xxbhq6BbFvvyRu9UVvD1QnA6UfET9cM4iKmelaEzHYAEIhB/sfyezvXvtIpXdKXBCQy
 oqPPA7T8agJ+Bxa9kXo5qkBJ7Q+qtHeem7QXuxHaSRKxX/8hXexbmlsyK94IuQ9KgHK2d0orK
 S1SgMMyMgL6V8pPEISzgBHq5FF7SSOiZHq73eJppbvKOPBNByckNrLPgAItpwGPg4cE2SQMod
 XCZGLUHZd4dNpkmObNCZ13gAvibJG+m65SwK9d6ywurqYYP6ATYoMx6dUfvmX5DZDh/9aLBtE
 HWYygdWRrtyRG5/BClBdARn+w4kM1Xqtkr82qsZzV4oM/Qwxwv/UgfIjlzDDelo83KlTb1JtN
 pQgPNms8fNEh4G3/g7kXKtkVK9JdZP3HHpckz7ApRIlaoTis9L+fIReZrCtO/vqBvvUIBk/go
 mtaNJQPuA/r3wfBsURep6OjK+F7j+jhIXORlzHMyKkL6p6HSN3qbImRQbKcXHncNX29zlrpMJ
 xdMqa72/NYIugg2XmrZGZ9A+hAtIoEiAJA/SQ3npbGojIkjQfOBPwjpWaz/sfOrvDT5N9cj9R
 KNNYqSbeEPEn1I+KHmRMjhd1JfzP/Mr8OJKSMRssq4LJHYaOXqohvFXSaXx+hDGjTBXBkY7W/
 BSJW483Z5m6fiWOkRMGNf6G6/EjSUDFs3c/mZ/45ix7xOb5JaPVfnmqlnf2ZoEVSXSDh35fI6
 /W41CYE0WTGgOUNpUT5yMh4XAhatrvDt0NveIj8wtZ1l8g1p1BnNI6IviLCT/hEadqtHbVDjS
 B4lYhiKA/DqfOl5PcuiM/E3lWH1X64pGjzyGET7zFPsyn2ONXCi6gPJhJA5+qYra4s26z25Jd
 Q68uUH3Qv+7JaafyJ51EklA4p5BS0s+ZI05o8XwlmJPmXyXjt9kgPTBnU3o4MnyISsNxMujni
 vCWq/WNn/jhkO/p8LpMc9X3UUiaIjKvJQtm8qjxjKAxLmYK7Dgres4V12Ul9YxAPsApi7JuiF
 749A7xMbEicjCTTEuKflnIJaDKxRbznz14WbQ51xVhS/55fMRU7QjQkap39U2CCv8GBlMnByp
 BRFJthwY3hWIA7RDtmNYcLJgkwmBOfE2g3lduTZAMAJymlPDPQT9+vfGySDLjyuUYpFkjx6Mj
 Q+sLJk1dfXXKYkd01ZFW/DEEQVWFNEg201Ec+Jwv1bKAawDC/00vweWH2NIdfmuoJo7nNVUx8
 pwdM2CsGAWDcH3QumdtaS10roMJS79J775LJcpSpsgC2hvt6Epqf8Y/du9vc12i/pyQp41/Jg
 yzwGdaVBVvkWKecgaeymqV9/3Qw4LW1BlEPLQphicznG31WvjAF/GWpK3HMgXO38/sitf4Muh
 AAwhFzwESmERJ4WFSti7aM/OuCYPKxpIzO0FZglece5IMuAOElaVUa9XG2srCOwcN//aRMLyZ
 Hz3r8wQ2GKHGREV7XYwvaWVTGZs8r4MBX1P4v7BGusY+X4r/iqhdbiA7nCEfwQ5nmjzFXUrOE
 GhpbGYwnDA1gXacU5NTlH1dUdaXjrujaxbMYc2zDfuV1542DnOwWQt06hCcZya5ZSsbqCQhEp
 QX6lABkrpfm6uhgJVUNr8up2JlOOxirYOJM3bh9mAu+KEjsNq3k2tPGoOxd+XF+Nfxdv/i8Za
 CO9AXmiV4lv2OsWEJKrswT7wuRojNEXnpRvGJ/w+z5eFw2TXMTwW6fGn3O+G8UHQzQwRvtFef
 vYkbntXKk0MjwRemfD+eXuEQDpINiSBFXXbg2eLGZ+ukkqnxZJBClfAiGpQbHaX440bkqu92S
 xCi8ahF4bkt22Sp21JmRBYV3dlT2goU5+eUZ5bsERucBQ3jq4DDZJPdlzbd9egAg4oEO1mBK+
 FLA/wj1CxVuGtTFdYh5bPezjE16hUforhnuw5XNCvxx7Mus4SsZkVy0wvX4T8A+fcisr4ZX0F
 9X1FjmOZRPi7+apDvRPIulVMXPh56qRuRVqxP7qjBh8nZoMjrnJbNSWQ6tzD7oP5iKt0yJCY0
 AwMuQCyajxjNuc4ISrug36OHtIMNLo7MsMCp7wDURacrNWi1Zxw7iJSUuOvMA0jq8XR3QOcte
 ETQyBnFqjYMqG39WAK39ZVsv7Y3LJomXYZoMXQ9wmXnvByBPCVF/amuQ/ePQEZpy5sD1vtmgS
 ukeUXh09ZEBniL4xQau49jwMckLoIiRKrugJyHHigKok4vtWfRqeDGpMn+alJhe1DjqzWYSNS
 YQybippQ4BGlsT0HBmd6i9Ue7TpHZR8ACKHEjP1hvnA2wUcoFW7ZugfCJxa009eNjliia/u2V
 OgcHqfTESHVvmbFgwh3EP+hzZxfp3iIXjCbDkdsATqhc+D/iPPnEpt8WaBmU0nkn2QhTDHtFF
 +5AiqmOfQzGGDHL8KKb0ZPBsCLN1mqITQ83muAVUL2b60YJR23I/P05WSAT/Zzc1fR7tjxMY3
 vcg7w/Xg0iok0mpAJn00pvgMEz4yqXvMFZGiSEKmJQt6ntwE/Gc3o9P16U8W/MzXB6CL5Zv2k
 AdcWolrUgoVZGyb47yxeUC35VArblIXHAfC6mDdShYlGi25MUQTor5xDNAWMkSnDaKfJE+3s8
 MT+AV5ZfSLHWn+5V+xDgSpNgKyovNo6M/AQQD5rsmtezzEohJ3iBpfNBMe/QvbZTsx1Ilx9xV
 sX3p32AnzVNzZ4McFtF8LNDyaqczzYbQzC5HmkIeajfmJG1YOfBz7Aqd+TXueA2YNYqYfNw7h
 kUXtgNu3tWllwcn90zmgF0aUKBwy9vAz46Kd39u/npFa9PB6rx+e2+05h+SQx9eV9HzAdV7Ka
 rB7pQwFNuWJR9D6GSg+MUSrZCPpmBsUMl37Fbodn0fz2GsLETBZkhMsWMVNmJNQq0xC7lTb0b
 CeaIIq9KrUFFickkDXfUJtBi3AC9s/s6AhVyrKnK3yJw+TF5ys7MNyenBU8hgNC38129ZKzAe
 vxKCUD9cPYTzgTlIMLPfmx/PQjnivX1ZQAqcdsmyhpgCnCV9hMpDb6uzLqJ8lAAS2ckoDgCl1
 0If48BP8TN9Amxvg3sP1MzW7+gtiHByyiQj/IJZgppu2WGzppFJ7HQGbvdBDyrmawJJKMQd3u
 kb4iGqWj3F4u9lrZOBzYnDF4on02BJJfkFsiCQ+bcWZt2fFCMaSbPTMUEp+Esqsh3egavdkpV
 SEEH/DkeQLeHN7SbzFJtS7ZVbrKvItTbJ5BKaXYVWlDK75OLzof/Q4ua/WWuoBwrRYyCmKEZU
 jZC1+bYpcTWxAwmxEAtnjReUQcbkPapR1OnrBa+uLD/JmFsMhhnIZPNyBivjaxtLXIP0exfFe
 U9nFmV7gdj9SoqTPPsOVHpful9Eom5fnBCOJ0J6XXqp+nTN3i+22vJfZmST5s+c0mb06KpqtS
 5FE3+bMygpcl45bjmAaVTjtWbQTUqZSLHkhxX1gKWsLP4oqO3Rz8gBsphC3oD3Ct91CutemY8
 fQUmlzK+T1Yp7/A1YXB3f5MTMVn8TlsLYv/eeGU7wUWKijTbqdRyMcd5kEQqJUPL14Ccc2ajP
 XE2tBnvGI1BhdbAx29ZiRYiPeBPac6jSHbyy0GeXbu5i8YKIgs0eGza+/wbRuxBHS/u8vAWaC
 62CI947h49+uqJCBWjvUW2Zr+qOtRLeL1VO0yLw1mtOqRbwDBcPfb6RUl8F2Afi1MK3N4HfA2
 tjMv8T5jpehK10Mt4CeWUYxN8KQPRt1oRZHCaeJkAr0hPPaYhpCdthmc+qPxJ7M1JTWNn7qz7
 oJ862CFb9Av+yZM2XHh6Czahm+1tqzurznRJVI+UqSV9JVndBBGkkYXR2x5Z1fAXs57GFsOfT
 w4EA1s1VgBpk7lqHD6tCmxHKR0K+3PUrNWGKLDxsUkn4vv2U0DINWuaXXcg6Kbfcn0Px0m6Jd
 6yg65nro1lAW957VimVJWqo+0s13TtQG62WAGOCaAtqU7Mlyl1J/gi3/ppgp3ek24wk0HFphN
 LMYYh6lmVZJCX+whA95S1szfnvJTYdYO0IMflVba1LmVRA7/9M7kQ6qtpt9GjiKA2GBkl9kte
 zRqu1oc2+jVv4RzSjrES6LgWVj6bM2WqakljMqzTlWLlK5i87iqDOuU7d0hsBiPTbnLSCzAOp
 Erai+969fiA3BBLf1wzKKgA8n0g8f5QIb/LBsiRv7mScpcYUNFzu9LLs6280gsHxDeWGgnAPr
 6SyhyfYT8CKhadgMtrvRZ/zjA2EFj29ab8WsiVrfKQpSOwVsNYlSO5S53rexzXvfQUWgg8OuC
 wpuidmNstv3zTcRyZsBbM9/bLOFgNseSB9Wx0FxUtsH0E1aomYcIUSNOyCeOuiEzM3BElwMRy
 ArH29F43WbSCzN/IKEctvLib5uxd4/4OMr6c5KYgKa5BzZQJIuIwIUewi27mxFHM8E31KWUEM
 ZT02Ij8kLQjZqy5F/edRa7x4M6flX7+S7p/C48lNoLpT6YzWCW4ajYwbaoJ5JHBmQh/SeL+tw
 Q6hxxnTPSDJMzuQw9lPRmbBjAWY1TmoLTlMGi+vBWIR10bZbJ28nvvLwngEmhG/89BduOikMF
 a/rl9qNfigJkhUJtkDWdK5q7X0l2tHJJQ1kzgpelh8gj6QzOKEW1YJkHvEDm5ccNj64P79IrY
 RaxOPCKQG+YQg0PEpAJ5EzsYbWv7k8uKuQwnSlyTOqTyyal3hn+nehSvp+xK2Cx4usEzCGwx1
 ILxlT3iDGpylR/6RjIZilIaTgwmzFDQYQh/pRNSmRHVWaVsZDrAh7B7W/BjLYRCkZh9TL88jT
 Kha9tZaK/FAi4Gt1Qa9N1HEUzKCtYZtIc2D5D8zN83Mm6FSIuwEWoa/W9jLsCdNfFRIvyxt3P
 Y0dOSmEJcmSbGzXZNYOt21EQKlk6RtgnI+mfLJEz4PtOqJjNtCrLIrOZLu+z4TFmU4y1J3c9p
 QR95H5lj35fk6IdWLTtrOzN0O0/OKmuexEeUdVrtQWjR6hdIjpcJTa5yCQ8woLAO3hoKD4sxr
 5RZrSqRCaawpXCFyXfJ29EVWaLcWmRpnvP49og9ZgmCJHKUquPMGToIhAxuSCDXWeGlR6Ad01
 85DmhUjfFNZZ4Zo4Zzujau+w00TdtlqN9yHKNElUuiZDxivV/7V8ykcMJvEDTIWYWP3ntGEcl
 iuXz+ciDeekgmJU9TD4WRbRLzU6FokJlL21uOPVcbvfCtTARDpv+SdsNMEPzhabqmk/MrgOnI
 PHexQcKUTllbzjQNl5FP5wn7rYZH6xMMHJwjzY+xm/J0aTV/F3aiQvnbE4Jksy5ixzggQNjG8
 6cOLFZQAYJEcjXpPf+k2cikU0AYam16suSfOzwHWK7GggCV6/uqEeBoOUF0FEPpBhSmMFRu/c
 PphU7zR6ETX0xxgFODpDMuCXHmWA5RwfflMVYCK1kufRHQA2zcHBd3BJtd5s8yrc2lZFjOSns
 mnih4QE79r9BBBnyHMhzQb01YwMkISOrX3D0hC5Z/f5u5SM7wCkGmQwBSr63+vKlcEtwzBeZX
 6cwt29jgJ96Qt+3c1DC6HyD+vrIU+qAOLOuxBZerEqAksQMQMFeq9tTWvQHFulYFsKBYC9B57
 4lHqV4Ertw/LZqfkdR++M4DlOELjr9kDp6vEa2nUPKidAaxzWUGTXYLylP3dD6e0X3WQbzcsu
 imobWJNRNEjuUv5wA9IEIA+eeW6FPOgL6UEAyWgUNn4WxZP7DWJWYX8rEbPhFrHFxJZIpDZyg
 KylbP7Di6xqDnYRaNu7p/qIwyXupJbyDwyBNyX/xpWzh7UeGIEW6



=E5=9C=A8 2026/11/5 22:37, Breno Leitao =E5=86=99=E9=81=93:
> Hi,
>=20
> Atish reported that arm64 production hosts (64K pages, 4K blocks) that
> keep VM disk images as NOCOW files on btrfs, opened with O_DIRECT, on
> 7.x based kernels, and it still reproduces in linux-next as of
> next-20261104:
>=20
>    Page cache invalidation failure on direct I/O.  Possible data corrupt=
ion due to collision with buffered I/O!
>=20
> Besides the message, dio_warn_stale_pagecache() records -EIO in the
> mapping, so the next fsync() on the image fails. The message blames the
> application for mixing buffered and direct IO, but every write here is
> O_DIRECT: the buffered writes come from btrfs itself, when it falls back
> for writes that are not 4K aligned.
>=20
> It does not look like a regression, since the fallback never waited for
> in-flight direct IO. 64K pages make it easy to hit, as a folio then hold=
s
> 16 blocks. Since e9b7b9d9e78e5b ("btrfs: use IOMAP_DIO_BOUNCE flag
> instead of falling back to buffered IO"), COW files are exposed too.
>=20
> I was able to come up with a reproducer that hits the issue within
> seconds with 64K pages. With XFS on a loop device backed by such a file,
> standing in for the VM, XFS shuts down on "log I/O error -5":
>=20
>          https://github.com/leitao/btrfs-dio-fallback
>=20
> My robot identified this as the root cause:
>=20
> 1. Task A has an async O_DIRECT write in flight to one 4K block of a 64K
>     folio. iomap invalidated the page cache before submitting it, and th=
e
>     inode lock was dropped.
> 2. Task B issues an O_DIRECT write whose offset, length or buffer is not
>     4K aligned. btrfs_direct_write() falls back to btrfs_buffered_write(=
),
>     which does not wait for in-flight direct IO, and dirties another blo=
ck
>     of the same folio.
> 3. Task A's write completes. kiocb_invalidate_post_direct_write() finds
>     the folio dirty, so invalidate_inode_pages2_range() fails with -EBUS=
Y
>     and dio_warn_stale_pagecache() records -EIO. The next fsync() fails.
>=20
> ext4 fixed the same race in 15cdefd0c052 ("ext4: drain in-flight DIO
> before buffered write fallback"), and ext2, ntfs and exfat are getting
> the same fix. Doing the same in btrfs_buffered_write() for the fallback
> case makes the reproducer clean, and I can send that patch if it looks
> like the right direction.
>=20
> This patch is a copy of the fixes above (from other FS) and make the
> reproducer happy.
>=20
> commit 16cd17d1e8205f9f86b8da0a9b1ccefdb2665764
> Author: Breno Leitao <leitao@debian.org>
> Date:   Thu Nov 5 02:59:39 2026 -0800
>=20
>      btrfs: drain in-flight direct IO before buffered write fallback
>     =20
>      When btrfs_direct_write() cannot do a write as direct IO, because t=
he
>      offset, the length or the user buffer is not aligned to the sectors=
ize,
>      or the range has compressed extents or page cache, it falls back to
>      btrfs_buffered_write(). That dirties the page cache without waiting=
 for
>      direct IO still in flight from other tasks:
>     =20
>      1) Task A submits an async direct write to block 1 of a folio. ioma=
p
>         invalidates the page cache in the range and submits the bio, and=
 the
>         inode lock is dropped.
>      2) Task B issues a 512 byte O_DIRECT write to block 0 of the same f=
olio.
>         btrfs_direct_write() falls back to btrfs_buffered_write(), which
>         dirties the folio.
>      3) Task A's write completes. kiocb_invalidate_post_direct_write() f=
inds
>         the folio dirty, invalidate_inode_pages2_range() fails with -EBU=
SY,
>         and dio_warn_stale_pagecache() logs:
>     =20
>         [    2.048568] Page cache invalidation failure on direct I/O.  P=
ossible data corruption due to collision with buffered I/O!
>         [    2.048574] File: /tmp/diorepro.JTCKpJ/block.img PID: 260 Com=
m: kworker/11:1
>     =20
>         It also records -EIO in the mapping, so the next fsync() fails.
>     =20
>      The two writes do not touch the same bytes, they only share a folio=
.
>      With 4K blocks on 64K pages a folio holds 16 blocks, so this is eas=
y to
>      hit there. Meta's arm64 hosts with 64K pages hit it with VM disk im=
ages
>      that are NOCOW files on btrfs, opened with O_DIRECT. In a test, XFS=
 on a
>      loop device with direct IO on such a file gets EIO on a log write a=
nd
>      shuts down within seconds.
>     =20
>      Wait for in-flight direct IO before the fallback dirties the page c=
ache,
>      as ext4 does since commit 15cdefd0c052 ("ext4: drain in-flight DIO
>      before buffered write fallback"). btrfs_buffered_write() holds the =
inode
>      lock exclusively there, so no new direct IO can start until the wri=
te is
>      done. NOWAIT writes never get there, as btrfs_direct_write() return=
s
>      -EAGAIN for them before falling back.
>     =20
>      A reproducer that keeps 4K libaio O_DIRECT writes in flight while o=
ther
>      threads issue 512 byte O_DIRECT writes to the same folios of a NOCO=
W
>      file got 1123 fdatasync() EIOs in 10 seconds on a 64K page VM, and =
none
>      with this patch.
>     =20
>      Fixes: f85781fb505e ("btrfs: switch to iomap for direct IO")
>      Reported-by: Atish Patra <atish.patra@linux.dev>
>      Signed-off-by: Breno Leitao <leitao@debian.org>
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f978c6524aa03f..2017a96814d857 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1334,6 +1334,14 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, =
struct iov_iter *iter)
>   	if (ret < 0)
>   		return ret;
>  =20
> +	/*
> +	 * A direct write that fell back to buffered IO must not dirty folios
> +	 * while direct IO is in flight: its completion fails to invalidate
> +	 * them and records -EIO in the mapping.
> +	 */
> +	if (iocb->ki_flags & IOCB_DIRECT)
> +		inode_dio_wait(inode);
> +

Sashiko exposed a problem that the inode can already be enlarged before:

https://sashiko.dev/#/patchset/auxv7Tg0xSq5yHmb%40gmail.com

>   	/*
>   	 * We can only trust the isize with inode lock held, or it can race w=
ith
>   	 * other buffered writes and cause incorrect call of

