Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262DF37DAAA
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780695794; cv=none; b=g3N+P5tpxE55uatM6ZjIT0QCKNtTJCcA/H4l7SMO5lc+sJJJqEk6IEepEMCY4Mp1NushemF0BrzNnuu+JtvoZEYyXsHjks1oT3bSBkWnoLvmjdHiHn9SpDwkR5tthZzK6MUKri867Ych1v1D+r6VVG6UQDMAYXF/nqcE/mjY7JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780695794; c=relaxed/simple;
	bh=uUjjTYBDEB4YPHIvqSc3uO25M6DNdKmTYfHZ/ySABTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R//Xlyjj/3zOAWx5K/p7V9JgTO0T07gWCA9xICeiXjF6EEPhcVYd8acs0D/DpK9LklBj+fXKellBoDwgLyrz8c8lTlS7w2GYXIZqrcfZd4XLF8CMUAsGVwlqJNtnI5qYl7QTv5Wk3fSazN5ylNbRT0SWOzX9+f2gWYTiKyHHNsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ohZdDTXt; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ohZdDTXt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780695790; x=1781300590; i=quwenruo.btrfs@gmx.com;
	bh=eFKMhmgKTin99vXBm+GyAiqSQy+6VaUxsNDDNPDhXvU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ohZdDTXtymq0I7X1zd5FisWc9dTTzQHyr4ThErbhHkgRFUh27sburoFpcJtw0S8Z
	 0hxJS2/CJkehiryo3tw9KTkx/0qaZGgDELPwBffKlFBWtkPYArLiiPcQ7i/Cil0Tf
	 zovX0jBn3QZpq9Rmlx92/NPeov5YzzoHHpa5zCmd58vun4pcEx0rszSzcR4fEHbj6
	 EdUTsuab4Lv6mmugW9zFlCE5xgmeZd4MURN/c+rTygKu/yfkJgW5D4NHNSWo9jM0Z
	 sqPh4gvEFSiLbuZzuWT4oSsoSsPOHuCkOM9APMi6v7UxSI45QJSImctah8iFwbDQo
	 qM8Z45NlEejcrg1BIw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N6sit-1xKcV82xo7-00s9iz; Fri, 05
 Jun 2026 23:43:10 +0200
Message-ID: <65d90768-8654-454d-a2a8-2f379bb72e55@gmx.com>
Date: Sat, 6 Jun 2026 07:13:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] btrfs: wait for OE to be fully removed before falling
 back to buffered
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1780645090.git.wqu@suse.com>
 <30dc9cbbaef57713552d7d00f1137c7c2b5be53e.1780645090.git.wqu@suse.com>
 <CAL3q7H5HP-aRh4eotU_qbwdA2ppFCYDdBqRSuwW=uB2H6mukvQ@mail.gmail.com>
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
In-Reply-To: <CAL3q7H5HP-aRh4eotU_qbwdA2ppFCYDdBqRSuwW=uB2H6mukvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2A9LMKfDZrKWAnqLPkQuhV/0z8PN/CZx05i/yzqIQwBcQUu8d+G
 JUgye6oym96nSi/sTn6ZD9jJEG6Lh+UWL16AeOEJM0TA6NryuB+JgkkkRqlia4xfEbx1pa1
 uVfqXlPOZdi5vlN1q6+VomRBx7rMFNfb8MtbAzyoV0+CooewPulpO/MYw4xCorCQAZvxbkT
 G4SXWRetW2aVQnBSke97g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GOg+s/QWusw=;HxBZegKwzgh+Eum3Q7tRxwNNalW
 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
 Q3uYojI7y63Bjavons=



=E5=9C=A8 2026/6/5 19:40, Filipe Manana =E5=86=99=E9=81=93:
> On Fri, Jun 5, 2026 at 10:08=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>
>> Currently if a direct write failed for whatever reasons, e.g. page faul=
t
>> failure or IO error, then we fallback to buffered IO.
>>
>> But it's possible that the direct write attempt has created some ordere=
d
>> extent, and they may not be fully removed from the inode io tree yet:
>>
>>   btrfs_direct_write:
>>   |- __iomap_dio_rw()
>>   |  |- btrfs_dio_iomap_begin()
>>   |  |  |- btrfs_get_blocks_direct_write()
>>   |  |     |- btrfs_create_dio_extent()
>>   |  |        Now an OE is created for the whole range
>>   |  |
>>   |  |- iomap_dio_iter()
>>   |  |  Failed with -EFAULT, which is pretty common inside
>>   |  |  btrfs as we have set iov_iter->nofault flag.
>>   |  |
>>   |  |- btrfs_dio_iomap_end()
>>   |     |- btrfs_finish_ordered_extent()
>>   |        |- btrfs_queue_ordered_fn()
>>   |           The real removal of the OE is queued into a workqueue.
>>   |
>>   |- btrfs_buffered_write()
>>   |- btrfs_fdatawrite_range()
>>      |- cow_file_range()
>>         |- btrfs_alloc_ordered_extent()
>>            If the previous OE is not yet removed, a conflicting OE
>>            will be inserted and trigger a panic.
>>
>> Fix it by calling btrfs_wait_ordered_range() before buffered writes.
>=20
> No, this should not be needed, we already wait for ordered extents elsew=
here:
>=20
> btrfs_buffered_write() -> copy_one_range() ->
> lock_and_cleanup_extent_if_need() -> lock_and_cleanup_extent_if_need()

Right, I'll drop this one.

>=20
> Was this a theoretical fix or did you actually find this happening in pr=
actice?

I was hitting OE conflicts during development on another direct IO=20
related patchset, but that's after some extent lock related changes, and=
=20
I have not yet hit it again on for-next.

So it may be some other bugs.

Thanks,
Qu

>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/direct-io.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>> index c97396ca476d..8efe3a722206 100644
>> --- a/fs/btrfs/direct-io.c
>> +++ b/fs/btrfs/direct-io.c
>> @@ -1025,6 +1025,16 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, s=
truct iov_iter *from)
>>          }
>>
>>          pos =3D iocb->ki_pos;
>> +       /*
>> +        * Direct writes may have created an OE, then submitted nothing=
.
>> +        * Although iomap_end() should have marked the OE as finished, =
it's
>> +        * not yet removed from io-tree.
>> +        * Thus we have to wait for them to be removed.
>> +        */
>> +       ret =3D btrfs_wait_ordered_range(BTRFS_I(inode), pos, iov_iter_=
count(from));
>> +       if (ret < 0)
>> +               goto out;
>> +
>>          written_buffered =3D btrfs_buffered_write(iocb, from);
>>          if (written_buffered < 0) {
>>                  ret =3D written_buffered;
>> --
>> 2.54.0
>>
>>
>=20

