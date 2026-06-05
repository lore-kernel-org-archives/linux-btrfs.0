Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C822EEE85;
	Fri,  5 Jun 2026 04:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780632858; cv=none; b=iEcfWXuDktI3cu2Mx6CaEagBNJsLdqJmboms5Mq/xMOqkih+fSQ9Bm2F2JJobe2s3VpkvC0w5/VufCdhGkgIC4JLHSCBlIOem25SD6DBg+m/1fczp0D+CMJskzqSva+594vGQTfzoGerf6RAwW0Offi9Bax8ihkNJDaNmYcfGT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780632858; c=relaxed/simple;
	bh=98Xu0dE8okMo/BpSvIVifKB64fccNlOqf2+0l1GqAw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnUpr0+5j+ShRi9FiIo4UJtbzNhaj/j7OMXyXrRapBQFrkM7kRy/UwrvzfdlRzBWoS0LWyN8jM7OtecmJXCL7sVVachlHv7x07KTGl+XLTa5f1B88/HYhcs0OxfvS1hDtrwcIqiGbmhVuWxgDqyYcEh/afzAG4XdMBCqwxBIUwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=eoQy6XpK; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="eoQy6XpK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780632846; x=1781237646; i=quwenruo.btrfs@gmx.com;
	bh=z3c2gNoQ5bMAQoBH9Jt9bJ2rF0b3/ewio3jlZNTLmMA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=eoQy6XpKkgeRI0yeLo67mRnbR5HEWjju8t7bQ4DaYhPhchShZzKE+xSP/tO1jcwS
	 qNiqMrxP/qJNHXIft6y0wEWcwu7dXfZACDYA6QWk9TNnI1Vpwt3D1JWIb9o5T3es9
	 4Vo1PLmg5YGUYLeWxuslVj81EzRez24EaRcgiuLpKRvMi8F4fUGYafGRG4izm1ZOu
	 B5KPDYi2XMZ/4o4km4TdpjWX+GlW1vZnYtO2UKlmtPmTX77b63ucA+ylGND4hucR3
	 pPGQ9ZkMw9xCCHoBDccBpQequLW18LBq9mHkhXhQP1LLnvm18G4oFfz24U7HLTTOu
	 6DNTtPqW8SyKj9eRhQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mq2jC-1wznDz362s-00ZZnn; Fri, 05
 Jun 2026 06:14:06 +0200
Message-ID: <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
Date: Fri, 5 Jun 2026 13:44:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use -f by default for mkfs as xfs/extN do
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 linux-btrfs@vger.kernel.org
References: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
 <aiJL1CBTV_N4YAtb@infradead.org>
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
In-Reply-To: <aiJL1CBTV_N4YAtb@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tsdwJlWRA8MYnwiHARdZTN0P74P/NizZhuVNLp3HcoZLadJkrkE
 3g3+2aswOBjfVZEEmRKCyGkFJr86e98nW8niTD6XGBt6X9AQRdvbK9QSNme+Rw3CzIbKMa3
 tv8pNTZ13+zobWU8f8bxyUuxhnIS1QiZtkLUIY4lMpW0ANNrg+X1cpA8vi7kAmhPOmXgWXO
 TyIqLIzlRM4ZDId2RH3vQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NR3ExtGjcrc=;YerrAkHV9Spq+zgjiUHVvHh2zUK
 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
 drDAjWYhY6dpDng==



=E5=9C=A8 2026/6/5 13:38, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Jun 02, 2026 at 10:47:39PM -0500, Eric Sandeen wrote:
>> Recently saw a case where testing ext4, xfs, then btrfs failed all
>> btrfs tests because mkfs.btrfs refused to overwrite the left-over
>> xfs filesystem on $SCRATCH_DEV.
>>
>> This seems well-enough fixed by only making the change to _scratch_mkfs=
,
>> but several other helper functions explicitly use -f / -F for xfs
>> and extN, so I've updated them for btrfs as well.
>=20
> I haven't run into this yet, but it seem like btrfs needs this.
> But maybe you should also Cc the btrfs list?

This is the wrong fix.

It's caused by a mkfs.btrfs help string output change, and it's properly=
=20
fixed by this patch which is already merged for a while:

https://lore.kernel.org/linux-btrfs/20260510001704.68396-1-wqu@suse.com/

Thanks,
Qu
>=20
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> TBH I'm a little baffled, has nobody really run into this before, or
>> am I missing something?
>>
>>   common/rc | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/common/rc b/common/rc
>> index 9632b211..e77edf97 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -871,7 +871,7 @@ _test_mkfs()
>>           $MKFS_UDF_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>>   	;;
>>       btrfs)
>> -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>> +        $MKFS_BTRFS_PROG -f $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>>   	;;
>>       ext2|ext3|ext4)
>>   	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* $TEST_DEV
>> @@ -920,7 +920,7 @@ _try_mkfs_dev()
>>           $MKFS_UDF_PROG $MKFS_OPTIONS $*
>>   	;;
>>       btrfs)
>> -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $*
>> +        $MKFS_BTRFS_PROG -f $MKFS_OPTIONS $*
>>   	;;
>>       ext2|ext3|ext4)
>>   	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $*
>> @@ -1010,7 +1010,7 @@ _scratch_mkfs()
>>   		mkfs_filter=3D"cat"
>>   		;;
>>   	btrfs)
>> -		mkfs_cmd=3D"$MKFS_BTRFS_PROG"
>> +		mkfs_cmd=3D"$MKFS_BTRFS_PROG -f"
>>   		mkfs_filter=3D"cat"
>>   		;;
>>   	ext3)
>> @@ -1176,7 +1176,7 @@ _scratch_pool_mkfs()
>>   {
>>       case $FSTYP in
>>       btrfs)
>> -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/nul=
l
>> +        $MKFS_BTRFS_PROG -f $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/=
null
>>           ;;
>>       *)
>>           echo "_scratch_pool_mkfs is not implemented for $FSTYP" 1>&2
>> @@ -1369,7 +1369,7 @@ _try_scratch_mkfs_sized()
>>   		# the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
>>   		(( fssize < $((256 * 1024 * 1024)) )) &&
>>   			! _scratch_btrfs_is_zoned && mixed_opt=3D'--mixed'
>> -		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATCH_D=
EV
>> +		$MKFS_BTRFS_PROG -f $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATC=
H_DEV
>>   		;;
>>   	jfs)
>>   		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS "$@" $SCRATCH_DEV $blocks
>> --=20
>> 2.54.0
>>
>>
> ---end quoted text---
>=20

