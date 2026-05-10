Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EE7284682;
	Sun, 10 May 2026 21:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778449738; cv=none; b=nS6MWgT0Ys2Tw+ftbVcmLbFfV8IVZG40TswhHgn1WHbKR8rMfzumH+s9JWYtmUTWy6uWq7MDqixEqAAAqGWin4c8ADY9RMYToDhSjiUK2l83/vVBwkZnsO9KK+t//ImvEQKC/FTEG2gotsnG8/2p+mkG8F9YydxTMMdvG9p3948=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778449738; c=relaxed/simple;
	bh=7gCIjy79LxhRqAOwSpj2GrPNI9wm45hbR31pWOctedw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XnaDSfO1WP4dl1V6tqL7MEnqvrQf92WbJG30arlKk/Q7rVzHZMyTNzULnzbeYdvozVMulC5ik25FBWtWN/eY0F2yYFvgNG+62cHkei+IgoXRDVmQ0RjQinXaNXQtam1H1yscHVSF90tsTKNWGnBp2wik2bVk/0CWTD3GBVA7bIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cW1GIzaB; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cW1GIzaB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1778449732; x=1779054532; i=quwenruo.btrfs@gmx.com;
	bh=vP4AHpDkSm180LiLREnXuB3HK7eiGDVwsu74zBd4L6E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cW1GIzaBdn2oRuT15RofKgLE98R140W1rZ/0IGtFkLWA0H9l7yYTA6XhRafXyUOV
	 PVA09L8NJT1933ueLht8QXViwbm8mv+re5y2A2mtAiHgGWARRldg0zqXPl5vJwBVq
	 JRoah6sau2MSgcGkLXQJbEHMeZc6hvhvB08kDj2TG9Itwo7vWFobYCz4bvahNggtd
	 XcvXYbXKOYMnjHxE8NejvbsyUzQiERcIQhUWQ1W4/Ur/ZijEHXG7nm1/7XyKg+Zly
	 IY+dM83hYehu2ryIyTD553PStroBFifEz9KlzpjNrx8NSfaoz6zXJcNA9vDy6ViLb
	 E6v0VMLXfNHwpmuyNA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mg6e4-1x3TWn0LYE-00pRbf; Sun, 10
 May 2026 23:48:52 +0200
Message-ID: <b66eb427-bc17-4463-ba3b-a5ef3fa4a317@gmx.com>
Date: Mon, 11 May 2026 07:18:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: support new mkfs.btrfs help string
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20260510001704.68396-1-wqu@suse.com>
 <agDVg6UXhP4DoKK_@zlang-mailbox>
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
In-Reply-To: <agDVg6UXhP4DoKK_@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/oSXv8qKWKg47waFLPdRlAt6yXRBBySTqCewGubqrsKtbMslJrG
 LTK84UAVKwf8UcVvwAnaRyaWjgw0RwIhCgAtPtaaMnYNAJLeOz9f98KpioWdUTbsyr+aKPv
 kApz+HtoOmPbY8uaL26UsIYCjcbesMoGY50DxMJP/ZTP4NP+woJkA+f1T4r+RsqaeBUnE9k
 NSEXv+hd8w82iQG7gqzFg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QDk5yB02Log=;FuEETonviVenMzYZACbFPCfCGdK
 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



=E5=9C=A8 2026/5/11 04:39, Zorro Lang =E5=86=99=E9=81=93:
> On Sun, May 10, 2026 at 09:47:04AM +0930, Qu Wenruo wrote:
>> [BUG]
>> The latest btrfs-progs release v7.0 breaks a lot of tests, e.g.
>> btrfs/003:
>>
>> btrfs/003    55s ... [failed, exit status 1]- output mismatch (see /hom=
e/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad)
>>      --- tests/btrfs/003.out     2026-05-09 03:07:52.952213772 +0900
>>      +++ /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.ou=
t.bad     2026-05-09 23:32:17.595751435 +0900
>>      @@ -1,2 +1,3 @@
>>       QA output created by 003
>>      -Silence is golden
>>      +mkfs failed
>>      +(see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.=
full for details)
>>      ...
>>      (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/btrfs=
/003.out /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.b=
ad'  to see the entire diff)
>>
>> [CAUSE]
>> Commit ec8324cc4b8b ("btrfs-progs: help: adjust alignment of text") fro=
m
>> btrfs-progs changed the helpe string output format, the previous help
>> string for "-f" option of mkfs.btrfs looks like this:
>>
>>      -f|--force                force overwrite of existing filesystem
>>
>> There were 4 spaces before the "-f", thus can be matched by
>> "[[:space:]]-f[[:space]|,]".
>>
>> But now the help string looks like:
>>
>> -f, --force               force overwrite of existing filesystem
>>
>> Which removed the spaces at the beginning.
>>
>> The existing regex to catch "-f" requires at least one space before
>> "-f", now it doesn't match the new btrfs help string, and cause mkfs
>> failure because we can not overwrite an existing scratch device without
>> "-f" option.
>>
>> [FIX]
>> Change the regex to allow no space before "-f".
>>
>> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Link: https://lore.kernel.org/linux-btrfs/af9EHC5b-aBdr1zn@shinmob/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   common/config | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/common/config b/common/config
>> index 1420e35d..339f7767 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -103,7 +103,7 @@ set_mkfs_prog_path_with_opts()
>>   	# Note: mkfs.f2fs doesn't support the --help option yet, but it does=
n't
>>   	# matter since it also prints the help when an invalid option is giv=
en.
>>   	if [ "$p" !=3D "" ] && \
>> -		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; then
>> +		$p --help |& grep -q "[[:space:]]*-f[[:space:]|,]"; then
>=20
> Hi Qu,
>=20
> This change looks good to me. But to be a bit nitpicky, the original
> "[[:space:]]-f" required *a* mandatory [space] before the -f, whereas
> "[[:space:]]*-f" allows for *zero* or more spaces. This changes the
> semantics slightly, but it makes sense if you're trying to match cases
> where -f appears at the very beginning of a line.

That's exactly my intention.
Also explained in the commit message:

    The existing regex to catch "-f" requires at least one space before
    "-f", now it doesn't match the new btrfs help string,

And

    Change the regex to allow no space before "-f".

Thanks,
Qu

>=20
> If that wasn't your intention or if you find this behavior unexpected, l=
et me
> know :) Otherwise, I'd like to:
>=20
> Reviewed-by: Zorro Lang <zlang@kernel.org>
>=20
>>   		echo "$p -f"
>>   	else
>>   		echo $p
>> --=20
>> 2.51.2
>>
>>
>=20

