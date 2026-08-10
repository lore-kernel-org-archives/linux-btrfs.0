Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF5D212550
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 02:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786327930; cv=none; b=DKAG5SNKYdyezPKudb0ipk7JtVrwtnwmpmL0zJb7dciFieA2TtIaAvtTMeqOvckeMeq0tUrjBkSJNDL3zq30vVLvK8ATpgLVZ9w1CnvRa8Zny3gbV2C9qdF29i3sMIDZGeRVHQzsvFJUk1/GTuSe36oYu8pM0WmDa0a56PqBw4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786327930; c=relaxed/simple;
	bh=VsWPkfwpK/Mx6sTsbe7awP+3p0RzqIecDcGekZkb7Mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxFNGfNDW1+DlsejI0POIHeDf8T7ar91pX2JUxYMyBDzNJKZemcL0m+RyAkCHCxYKJhLaZyl3sFYWZEJeCEIwPUVB5UTk0DBGYHdprIdvavb43XU1GOtuK8MDQVPdGuxTe3MH1nEKQKm9aMqO3UHYW2UEVA2d5vXFBFsxEbWdNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hxhCuX1v; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="hxhCuX1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786327926; x=1786932726; i=quwenruo.btrfs@gmx.com;
	bh=zH3iM7W1Pe3dEBTT0ww82LV9A1saOLqyQdfWVDSH/e4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hxhCuX1veZGuKKgQlcvsohgZRmLrB0E3DuezsU90T0shBPBzjOws1NLHPWJtVOF0
	 UvUCREIEgYAh8+gk5FZKH6s70OXAsPL/Q7QzuZa0O2RdN3sb4rrsqGdUiYRvIKXQu
	 hngyURlqwssqktimrIYrHwKeR5xiIzezNzuvdi8L8UoFUx+jzATg58hVdutxGcpLu
	 mASqxghKz5iXdvHHq/NJ6efQ0lTMzWfnddeUOMjT3OhfnPHjwqGiL2iP1s5tCypbd
	 nH+C0ijaQVy/2m1SjoeiY74tnBcs2GjcDYP+8nnduertKBglZQVWDmYJvSlaLVtlW
	 vjOvAEDBZLVeCBCNkA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M6Ue3-1wmMfc0wXp-001iic; Mon, 10
 Aug 2026 04:12:06 +0200
Message-ID: <e476f197-dc26-4f41-a9e5-0e23623496af@gmx.com>
Date: Mon, 10 Aug 2026 11:41:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <wqu@suse.com>, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
 <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
 <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>
 <f4a10cb9-0237-4326-9356-3704939072a7@gmx.com>
 <DKKW2W8COGXT.3GZPRA6TKLCFV@gmail.com>
 <23eb77d0-d4f3-4d9f-ac53-8dbba575a8c5@gmx.com>
 <ankyGTuFSRGVytJl@hungrycats.org>
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
In-Reply-To: <ankyGTuFSRGVytJl@hungrycats.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:In1UW0VGKlRl89zQ6MZaM6MEcpSs3lI1iz/tOWTndkP8YfKiE7w
 vslDoyj2vm8MQSkpR6LccFuNxy5cgYzbja9foCXIDAkWMfYTTTa/rLJi7uwcvqv+QYlRiLd
 WmAqfi+D8FiLLpnk5vtGkPanbtSkYOSNF4fw+ichF6yzwHUA4YLS+5HgemUeIx9xbk0rGFD
 vV+ilvqfwHua7xcBQX0zw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fZisXLbDXKQ=;RSMQFHOSPaUrOhi6Hu0ZBdG6bB5
 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



=E5=9C=A8 2026/8/10 11:36, Zygo Blaxell =E5=86=99=E9=81=93:
> On Mon, Aug 10, 2026 at 11:27:49AM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/8/10 11:27, koraynilay =E5=86=99=E9=81=93:
>>> On Mon Aug 10, 2026 at 3:54 AM CEST, Qu Wenruo wrote:
>>>>
>>>>
>>>> =E5=9C=A8 2026/8/10 10:35, koraynilay =E5=86=99=E9=81=93:
>>>>> On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
>>>>>>>>>> So either option 2 or 3 would be fine to me. Although I persona=
lly prefer
>>>>>>>>>> option 3 a little more, just because it's much cleaner code wis=
e.
>>>>>>>>>
>>>>>>>>> Option 2 preserves legacy behavior that is 12 years old now, and=
 it
>>>>>>>>> costs a single comparison in two 'if' statements.
>>>>>>>>>
>>>>>>>>> Option 3 makes an already confusing situation worse--it makes th=
e
>>>>>>>>> underspecified behavior change depending on kernel version.
>>>>>>>>
>>>>>>>> One should never rely on something not documented in the first pl=
ace.
>>>>>>>
>>>>>>> Option 3 prevents existing mount-option compression level specific=
ations
>>>>>>> from working when the attribute agress with the mount option; othe=
rwise,
>>>>>>> they would be blocked by a btrfs.compression string that doesn't s=
pecify
>>>>>>> a level.  That's a _regression_.
>>>>>>
>>>>>> Let me be this clear, the current one nor option 2 is not working e=
ither.
>>>>>>
>>>>>> If the current algo is different from the XATTR algo, it will be
>>>>>> whatever random number clamped to the XATTR algo for the current co=
de.
>>>>>>
>>>>>> This applies to the option 2 solution. When mount option changed, t=
he
>>>>>> level will suddenly change from whatever previous mount option to t=
he
>>>>>> default.
>>>>>
>>>>> TBF, I can see how it could be useful (or rather, how it could be go=
od
>>>>> to have it as an option) to have some files with btrfs.compression=
=3D"zstd"
>>>>> and then use -o compress=3D to decide on the fly how much compressed=
 the
>>>>> new data added to them should be.
>>>>> Both are (read: will be, after the per-inode patch) 1 command away, =
but
>>>>> there *might* be use-cases where mount is more suitable.
>>>>
>>>> To be honest, with the proper XATTR compression level specification, =
I
>>>> think we should even deprecate compress=3D mount option, and make the
>>>> XATTR one the only recommended way to specific compression.
>>>
>>> Ah, and in that case, to set compression on the whole fs use btrfs pro=
p to
>>> set it on the root?
>>
>> Yep.
>=20
> I am vehemently opposed to deprecation of a feature that will require
> updating _billions_ of inodes per server to get the same effect, when
> the filesystem was previously able to handle a 4-level hierarchy of
> compression options with "defer to next level" since the beginning.
>=20
> I will maintain a fork if I have to.  Hard NAK.

Do whatever you want.

>=20
> We can have clearer documentation about how options are processed,
> and clearly what options mean "look up to the next level" vs "use the
> default" or "use the locally defined value."
>=20
>>>> There are already too many corner cases with mount option.
>>>>
>>>> IMHO, a good design should allow and only allow the best way to do a =
thing.
>>>>
>>>> And option 3 matches perfect for the XATTR only compression future. I=
t
>>>> still allows old XATTR to work, have a very sane default level, very
>>>> explicit and clear independent from whatever stupid mount option ther=
e
>>>> could be.
>>
>>
>>
>=20

