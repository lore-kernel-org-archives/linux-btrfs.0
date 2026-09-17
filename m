Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8037379C3E;
	Thu, 17 Sep 2026 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789681555; cv=none; b=WGZipH4KEXm+uVi22g6221HraPePBxpc3Bc3TuoOPMhZTX6ulsTZA6uIROwdotk2Wrsi+DR/5cbnJc+eDm2ZYZDONNeKvnXN17CDhJUclEIQQrroU+2R2Wa1IcYRFzF34fyWl+EtAy+GTskxlZAArOahdH/rVw64dOVF2WEaHCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789681555; c=relaxed/simple;
	bh=f/RJmPp4l0PA3m26Xir2R1buH5MNhLLD0vbOsHaP3J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxK0PQAFwhq2gTP9N5ai4HjgbynG9zcail1k5AP10HU6X7g3mDd4n2M/ET+Vy7AM+jVQgh2oPWwIeYX4nnedhJGlMdJXjta+Uf4LkcbqCvzJV4WKgvl691n3pt4BKmPQB1iMNjhVWRj+8QBMHNTBmBD5Cn6ru2QCP5ky4lrZ5K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=m447/RDF; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="m447/RDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789681550; x=1790286350; i=quwenruo.btrfs@gmx.com;
	bh=DHpXJxpoqoH4rAiA+f/AeJTAdGTJZiLJakx7QUYEXu0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=m447/RDFn1ZFXlq66P5Cr5kJdoD9+jqU/r2wh4hr7aJwsix1EJQTzTFiz69Q9N4a
	 KEQsZdTBaZ9r6t2Tv8TwPDC44YwDW6ao/NUkXf3IKRkuuiYZalTMekHqQLdGIoa4K
	 xJdrcF1ehOPpbcTtpYlwedwe0KqXw3FwdvWojq14H6zGcLNGw+NxtD3a79l2aavl+
	 bINXc6YyD4VD3bqD1PzkKAOk0Dz+pTSjA47erDHKmwS8UvuSeFIT0IOyenrgufGzp
	 QQFIPzXmCiWqSxlSX9mL4XCkd76GxkwqQq5o/aH4dDFTH58XgScjKKT7RDB6cELze
	 yfgoZEVBU8F/4vxuvw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MORAU-1xQT6h2wZC-00I81G; Thu, 17
 Sep 2026 23:45:50 +0200
Message-ID: <772772ae-216b-411d-893c-ca06c3969a5b@gmx.com>
Date: Fri, 18 Sep 2026 07:15:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs/255: add _cleanup function to kill the balance
 stress process
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <a6bc4f66b0217153cb55ea987c26de70c50eba48.1789660025.git.fdmanana@suse.com>
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
In-Reply-To: <a6bc4f66b0217153cb55ea987c26de70c50eba48.1789660025.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FDecHXdCjM0zVq+EopL6kCWFT5Q31dt/WizD8hP+G/V7y5F3w/B
 xZjHwJeXgGJKPXnipS1I7JMdlddHv1gWJD62PUH8Hpk59QeSP7AZk1A+bWZBZ9n6LnAcfBg
 QiCTpTGlyEe8oJ8E+EU3VsZxH41qAdgqLOQ6JRkts4WO7+CuEVhskOMvqMEs8hM40tC6MpB
 yAzIy9bHmiOxU7W4nAWKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:a7wRhkdE714=;hYDM/2JZGrxUlHNs8KtO/Ic1E+x
 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
 k6QQbQakVzb6fCxhA7BPdy9Kye/6Jw5gXyRmranRp+tBdziNJJ9EyJgU9xguF1XYGtL6lpwNE
 7lRLGYbCt/vi6uODaVSHoiEbFCc8GCFyVfr0iPm6aga3XoUryzZApicMtpVciBMLiPzG0eKry
 UsBxEgYfbrMGtm/hzkpzgJsFY1OrZHqfLArCHKuCYpCeuAkNxXoIKMsClXT8H/t14D7I4rdHH
 7HLxLEIJZMCl6ls1XOCOk8NfgP7Z/eTzdNWVyZNyxJ/txuRmk/XxQf6SqOiX+2hmpmmo5TmIK
 pyvIbwyZR64EnJV1K0kz3PIzfAcdykzZ0+QC3Sv/tE89H1JrV3PA1RiaZZndyE26ZNJ7nrHA8
 jJkm5U95drPXQ20Cl6z95SsVJe+jTiZy09/nHj9yXjN6Uc9tPmY31d2x8CDC+3jNUsTC7Msdn
 wY4Vj8ZW2fft9fbJT/bFWbnQpxpgYggGiFOXoiq5OR2hZGN8/9AJy+pyJls2t3YOHiFMjVMmR
 P+bAgkcE/02yzo/j4ZHAVwRUEWODG0exWZwDlgGGy+9GfhyfwKlbhW6JAgXuk/2TRm8sVK7en
 AQ9D7WZAqlADpBDfCi83F/dAjt00JPbL1SvfrzbJSuR/inqEr1ZPxh6FsVdL3zhXP+THpNRgH
 GR22jRD623PhO2rWKyl6jETDx0t8NTIN7JlsM/DK2SFVra91ILTVpFakkU8b0i2KiihK6s0/3
 tMxdYvD5fx5d62IXeghhyaRzBUGNHnywkL4BCOPOEf7u2KxJCdd7wpWP8x2d6MYDagVlM3w48
 L0uA0C1megAN3VKfdwqf+VsniKXo/vCPN1fZRBHgpPMtPn2/dRXmgRKzWahgU4HkXQe22TwHv
 g2ZSdAX20SVpt2Po/vMSvddRfLJKEiNij8/QCmim0j3lrWw3oO8FO3Pbcuh+PSLqp0xe0jYEZ
 0JVok6DNW6DL6Nzp6OMiYnAYE9GKYXBGYPsP0pJF7aG8z+Bku6TyztnZwl22EhRnJQ3lLHCMH
 gItsng+4sSxQg3puzCcTl31sHz1Khd7K8laMzWyghLsjpCxdKFCOum3aOD53eVRAbCKyRVD/f
 10vSg4rFWGOAMn+pElZGsmWSVP7lNgnGAsxwYh/5jUSBhdC5iQ3rUi2xBYcA8s8TkDNlLAuBo
 eY8wIpjFdVSPgZWBwU092iI/UHV092CCdbuXpFlUX4WKsfeIt3Swk3jg0qx1VO8J9ofQ0Z/mw
 MLsQT82xjKbq2RR/+T6WAliCEunWG7J7SONsjJkxUvax4S2F2RdOX1IL7L/EbbKuu2tXhTPrq
 oKJ7VF8vbzUO5UqZAt5KUDJNF3s/SGOOcOLv1H6tI6INhU0dXo9OLepv/NPUqFNc9exmToGNX
 9FHiGh9NDlinxgiBU3+fZDwFKOZNZJ5Z9kjyTwj3D8Rg62+BQvhq8Fu3ciKwHnebcNYNK/k2j
 6Wu7ktzbc2VGio2AN+qRhq7Qm+l30zdaTee5wycrsBzy9BBdPMYH0fBZ35ZzNUc1NVcNbgIgA
 hXFxSWyxVdO9b04vRcdpBZapK+K5vYO418TVA7prC5i8ImrBvShqfwHsis3NJ7x30/4m9lZrD
 dbFrYsSxwzZzCzX7jxl+f2fVZIEwoIoRwB346ex0QcWdIqgw/G6sP5CkR11V9WXEzqeNv8aBA
 uBNJYraTviBZ0rYaO9Vb+MavEfGNNagWMg1ko6BWj6mIuxl4cHliCLblAZCym0showtVQTa5U
 K3lqY/y4+X+wRhE7mtGg0mEzrmNRxywh+UmMsNSgOZIDdxQ6tZr1TMMBjsJ0YlEVaxMDbRGZD
 Dq40NczY/H2bXOSjVast1isZCCV4QZm4GZbZefs4SSUY1tRBwsdtTHJ6nS3VZMIWPhXvuTDbX
 nCfz/M3w4vjbaHv3+Pi0xDHlNPYmD79uhJVkFI2xE4S7itHqY5i9ni/l6vhCSEC1pQBMeprfZ
 oEXYh3qTwW7QF6DwZHlf2Cse39SvV3eljsChZ4sNJUQm7zFwdq9Quk5l6tI5twJfSFV/09cBq
 yEq/i47tGR0NMNsOi+P01kXhrW5fhbajXr9ZGQO+0XQyNPhiKbdoRY1JCIwGW6VdESoopBE0J
 NCt8PliT2fJrr7RjxvCciwa0qJYgnl8+z7ik99VkF/PvgOWZ52UQx7C0MN1s1nQbeEew35snv
 PorgOONCRPARG1WRwOXVefW6Xo5+swqPYkwh8lP8U+L2VZ4MDQTkxUAi2sB9Az4QUK2QtX39/
 RosMiBEFEQF7hBtOspQF+xYfUg/PDQirOKwJ8h5p0/W8GMFWmJuUbl9uxrtBqReS3ipNCVjwQ
 kI434k/LQb7p9TmHdSiSxnZJekfbVO1h9ESS4XzGEU/tBDVR7h47ncSdCQl8/wczevmIQyheE
 +gmC+4V+b0t2yVU+mHxP6GHa649DsGrXqtUsMGl2FN41s2/Wla9430OpNwofBhfgjpOm1BrhG
 Cr2oYwmpEXMYw0FqeEyHkX0fM2tpemGWvZWBIdFaZvUTEr4xgrY/TOyB0flcFgy/gPKn5EEG0
 HIINyMCIoBrFBCJLfo8GzcSrk442tDgumlg/xKwRzy2kyAwhK7bSScWwm7elNZ9mLxHvC6QYH
 nri9Jzz5XyiLn0hD4bylPARq/+BWE1lFMGE5Vf2C+9fdy+G2mw4WyxxUeN5wbn2yo=



=E5=9C=A8 2026/9/18 01:22, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Currently if we interrupt the test and balance stress process is already
> running, it keeps running after the test is interrupted, requiring the
> user to manually kill the balance stress process before it can run any
> fstest that uses the scratch device. So add a _cleanup function that
> ensures the balance stress process is killed when the test is interrupte=
d.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   tests/btrfs/255 | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/tests/btrfs/255 b/tests/btrfs/255
> index 14c12904..fbcbf57c 100755
> --- a/tests/btrfs/255
> +++ b/tests/btrfs/255
> @@ -12,6 +12,15 @@
>   . ./common/preamble
>   _begin_fstest auto qgroup balance
>  =20
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +	if [ -n "$balance_pid" ]; then
> +		_btrfs_kill_stress_balance_pid $balance_pid
> +	fi
> +}
> +
>   _require_scratch
>  =20
>   _scratch_mkfs >> $seqres.full 2>&1
> @@ -40,8 +49,6 @@ for ((i =3D 0; i < 20; i++)); do
>   	$BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
>   done
>  =20
> -_btrfs_kill_stress_balance_pid $balance_pid
> -
>   echo "Silence is golden"
>   status=3D0
>   exit

