Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD881FBEBC;
	Tue, 12 May 2026 22:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623246; cv=none; b=rhDbCUy/KujbB/SnKgzaZ0cnUN3R2hqT1WTxrxQgXPnTtirLKqzMDLAp0Zjph5AYX/kzKtsBszef5PzT26jY8/PnHE1eJ86+WnpL/wpjX7E2TPJCKGRFnfSv9L298vGeAu0/GjWuplX4tgH2idAWhxSxEIJ8Mn5W0psWOdEc5RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623246; c=relaxed/simple;
	bh=hSk0j7u+sL31MMlO/Q52FoPABMs9K7R+Q4bY6RO9e8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AyFK5dqG+K0QR0KgxQCz+4Y5CsC6J95bv4gdP0cRwPmcTai61wdpG0koLEdJM7jPBRP/JDznAYAG3VLu1hM2yVHwHUdL6Istsg+V8vUsETTBcPPUuwmzBtoeUYY8Qm36VN1aRQI/65s/5iQ8mDKdwDHek1X512tU+qr+BmNCi9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=F6dfajmm; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="F6dfajmm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1778623236; x=1779228036; i=quwenruo.btrfs@gmx.com;
	bh=2IkB+h3eVN1PipoERm0P1qTHQbXimH6ByLJ/vY1ShEg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=F6dfajmmnp08AZBMwBpPbPA8j6azffqP7VmXjB8LQPG6uU0I20PWsy3F+FTZEC7j
	 TE3IDHMrwaI6KP1vJrsMkJh9Kef6QrTQf5Ocs3hsyM0D+7wjmQ+ZR472CWC+Hzn2o
	 JLDZIZrRQ9ZX1FLJghG6ctwlcfunFdLRYHB5PNC6IvezeZkiFVNatszKtjwNvOOtM
	 JpgByXNF+TFI8FoEYEfD+2mRH+JcZ6VF9f16RHaNpDRjd/6XNQm4ENhQU+DyDnQ9o
	 0ZyDkDxgsy92czwR/ddxOQLMhe/Sa5duKGMJESvHx7NBQJGLr+QH1QMqLLBdDLc00
	 3c+2XZ+ZrNI6mujbng==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mnpnm-1xAouX3qvq-00hOw5; Wed, 13
 May 2026 00:00:36 +0200
Message-ID: <623ab375-5de1-4d21-bccd-29a872aa5bc4@gmx.com>
Date: Wed, 13 May 2026 07:30:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
To: dsterba@suse.cz, Zhang Cen <rollkingzzc@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>, zerocling0077@gmail.com, 2045gemini@gmail.com
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
 <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
 <20260512151846.GJ2558453@twin.jikos.cz>
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
In-Reply-To: <20260512151846.GJ2558453@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AjJ/c2qq9eempJoOuCSsM7nWNF0vjJ4jv6q6ALJ+6O+Jg8FnkEe
 kYZe8TGShfaxa6T5deW1O1mRsy6FUlzYY1jAY/PgQH2ZjILXhO7NUzAWFqhd0rF9nu0poHV
 R3Fe+VpYduavu5BuvTucquF2Am9erIlLsMlij1PWFdGPseAY6YJX4ojn+Lf7qkEZPJx2peC
 BMqs9y+wooJfMRLHqgS9w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bOeG8lgw0gc=;5an4EKSm+YR73sXf40/w1xvScmX
 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



=E5=9C=A8 2026/5/13 00:48, David Sterba =E5=86=99=E9=81=93:
> On Sun, May 10, 2026 at 11:03:22PM +0800, Zhang Cen wrote:
>> +static int validate_free_space_key(struct btrfs_block_group *block_gro=
up,
>> +				   const struct btrfs_key *key,
>> +				   u8 expected_type)
>> +{
>> +	const u64 end =3D btrfs_block_group_end(block_group);
>> +
>> +	if (unlikely(key->type !=3D expected_type)) {
>> +		btrfs_err(block_group->fs_info,
>> +			  "block group %llu has unexpected free space key type %u, expected=
 %u",
>> +			  block_group->start, key->type, expected_type);
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	if (unlikely(key->objectid + key->offset > end)) {
>=20
> This has a review comment https://sashiko.dev/#/patchset/20260510152848.=
3844894-1-rollkingzzc%40gmail.com
> that the expression can overflow. I did a light check if it is valid at
> all (we're still evaluating the quality of AI reviews) but I think in
> this case more checks to the key.offset and key.objectid could be added.
> As this would is in checker it's meant to be extensive so partially
> overlapping conditions are not a problem.
>=20
I have already submitted tree-checker enhancement to address this:
https://lore.kernel.org/linux-btrfs/cover.1778460959.git.wqu@suse.com/T/

Which adds extra overflow and overlap checks for fst.

Thanks,
Qu

