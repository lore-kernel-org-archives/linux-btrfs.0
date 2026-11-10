Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344453;
	b=KblMrC77MBMWudAakGjHTyQ8ObTEOvy+yAE0wFrwHx0WysXOMuv14KAN8C+bWO1mf+zY
	 h/iH0RTQuqM0MN/oc5/XUYsdA28kHvhXB/dfXKG9jQtP/naJGyj5jFpsungMpjiSwh+EW
	 9nKKbVK2E/pImO8pBLhM2diMw2TBdKBWz4L0subt2UD2DeMp3DsXl3rVwClepxfE1UP7l
	 NohW6aI+Dz+Yd3lrOL+fCiw4LXMixAJO0u+4hYWR/5efJJf8r1McTDlGSC9fGVDIG3dND
	 aXr6g7QqcAlheMmRIE8wA0YwbVuEsiaE/JRsqv8wNZlYoTgB9vc6flvzr19N8B+hLMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344453;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=ikI9QYsiZeU1cF4dv6s14H95MOvpi0OujTh6P8EXdMw=;
	b=dI/OJQQtaE74FC+x3bEVNWmzeKpjg6zyy2gsvxqfNYFLcSdW+mI68jy+SC9ioiJaqN/Y
	 JVcWyD5qXWdsn2jCj2cfnu+Umu+DV39fByf6qBXM1HAfVHgL4eeecT3G8nvjF5d+qT5eq
	 9z/CanAliA6VkgwC3K+3HK6AgWPhP9bOY3aDU83t6QnuzbRVKRQTbex0R9WKIozz2ViV9
	 zHo3RCbg1rYgPpJlVjdnDhnwKL0T5JFKjvK9nzgp16ljwr2lAzBDBxG/LeGpTeK/Tb4mE
	 IhPNw3Qr+JSWd++cZJsjFEmyvTWLQq70DRLOPhJ7F0ynR+bQAB2KK+n6zgu+LofeZww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=eSaX7JJF;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4D606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 21:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37C4D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=eSaX7JJF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794344450; x=1794949250; i=quwenruo.btrfs@gmx.com;
	bh=ikI9QYsiZeU1cF4dv6s14H95MOvpi0OujTh6P8EXdMw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=eSaX7JJFm5wl/BRZWZHMkcOBKRGh8dpGNtTZOUO+CnXS3RRAI/D+5lE1SgeupU/V
	 QJvSpiVJCFAPVwu2iXk/Z9X1P2Z64js0VHQgnuts9os+Ueg19nLeFX4pK/wmSO+w8
	 VDDZZRMkV6w8uyoXmV9S0hJvrWMY9+AQjaH1XVUWGdV+PQ7DEhcIx3iLfrEV82vzK
	 Q1xFRt59dYqvbr8B6ifPieiO0HY/Oqt8cPc3vSxqHfa+bdlgPdFMaGH9WVQAEO+Lx
	 JcXbiMJwCuCpcpqCYLAQGMx9OjGP3/+HAi4C9Q+WyCiuIg4nm7hfAFDUd/L9WNZkF
	 /FgtYiCSm6oMfMD04A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M8ygY-1xN2wh2Cb0-00BuVK for
 <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:00:50 +0100
Message-ID: <45cc4550-e744-4c35-8113-cc28bfa6799c@gmx.com>
Date: Wed, 11 Nov 2026 07:30:47 +1030
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
Subject: Re: [PATCH v2 1/4] btrfs: do not allow fast fsync if there is any
 async dio write
To: linux-btrfs@vger.kernel.org
References: <cover.1794290876.git.wqu@suse.com>
 <aa2343bbda662ef5f425c0dfbb5c84cc67940fcd.1794290876.git.wqu@suse.com>
 <6399e4a7-8a3a-4c64-9e80-9cd26a4613db@suse.com>
 <CAL3q7H58WgEFz5EH0ikgoZooH136gRGXsdoog0nJMnA_k9B+4A@mail.gmail.com>
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
In-Reply-To: <CAL3q7H58WgEFz5EH0ikgoZooH136gRGXsdoog0nJMnA_k9B+4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:caeHWhsvF/YfGoRjl2EIcqIfda4MH1CYOMyXYnQagp/SKUzddOc
 vETHC8cD6wEeHfcB0jM1nm7123V2iS9Re2DUul85C+EUJFBKnHND5jzU9sISSFWJltwMrlx
 hwEuOlaxdzy+P9jVmAfOuDeCSZ3d5xwbfC+eScmzHUq69uXSRWr0qbqmRXAZE1MOqHqqqz3
 j2QEFhIH/nIbE9uMA2o/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Nne2/QoG71s=;Qp//X+a226Fbcq6AITvWH5HchPi
 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



=E5=9C=A8 2026/11/10 20:31, Filipe Manana =E5=86=99=E9=81=93:
> On Tue, Nov 10, 2026 at 7:06=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>>
>> =E5=9C=A8 2026/11/10 16:42, Qu Wenruo =E5=86=99=E9=81=93:
>>> Sashiko reported a possible race where an async direct write happened,=
 a
>>> fast fsync() can return before the write reaches the storage:
>>>
>>>     CPU0 (io_uring/AIO direct write)| CPU1
>>>     --------------------------------+---------------------------------=
=2D-
>>>     btrfs_direct_write()
>>>     |-btrfs_dio_write()
>>>     | \-__iomap_dio_rw()
>>>     |   |-btrfs_dio_iomap_begin()
>>>     |   | |-btrfs_new_extent_direct()
>>>     |   |   ^^^ new extent + ordered extent, data not written yet
>>>     |   |
>>>     |   |-btrfs_dio_submit_io()
>>>     |   | |-btrfs_submit_bbio()
>>>     |   |   ^^^ bio in flight, not finished
>>>     |   |
>>>     |   \- return -EIOCBQUEUED
>>>     \-btrfs_inode_unlock()
>>>                                       btrfs_sync_file()
>>>                                       |-btrfs_get_ordered_extents_for_=
logging()
>>>                                       | ^^^grabs the incomplete OE
>>>                                       |
>>>                                       |-filemap_fdatawait_range()
>>>                                       | ^^^no folio under writeback, r=
eturns
>>>                                       |    immediately
>>>                                       |
>>>                                       |-btrfs_log_dentry_safe()
>>>                                       | | ...
>>>                                       | \-btrfs_log_changed_extents()
>>>                                       |   ^^^ logs file extent item fo=
r the new extent
>>>                                       |       OE only marked PENDING, =
nobody waits for its IO
>>>                                       |
>>>                                       \-btrfs_sync_log()
>>>                                         ^^^ log tree is on disk, data =
bio still in flight
>>>                                             fsync() returns
>>>
>>>     power loss, the data bio never reached disk
>>>
>>>     mount
>>>     |-btrfs_recover_log_trees()
>>>       ^^^ replays the extent item, file now points to unwritten blocks
>>>
>>> To prevent such problem, disable fast fsync for async direct writes.
>>>
>>> Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback"=
)
>>> Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-86113699=
3fc7
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>    fs/btrfs/direct-io.c | 11 +++++++++++
>>>    1 file changed, 11 insertions(+)
>>>
>>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>>> index ed3914257d39..6e796163015e 100644
>>> --- a/fs/btrfs/direct-io.c
>>> +++ b/fs/btrfs/direct-io.c
>>> @@ -974,6 +974,17 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, st=
ruct iov_iter *from)
>>>
>>>        if (IS_ERR_OR_NULL(dio)) {
>>>                ret =3D PTR_ERR_OR_ZERO(dio);
>>> +             /*
>>> +              * The async direct write is not waiting for its IO to f=
inish.
>>> +              *
>>> +              * If fsync() went through the fast path, the direct wri=
te OE
>>> +              * will be logged, but the data may not yet reach disks.
>>> +              * And fsync() returned without waiting for the data.
>>> +              *
>>> +              * So for async direct writes, we can not go to fast syn=
c path.
>>> +              */
>>> +             if (ret =3D=3D -EIOCBQUEUED)
>>> +                     btrfs_set_inode_full_sync(BTRFS_I(inode));
>>
>> Unfortunately btrfs_set_inode_full_sync() is not safe if the caller is
>> only holding a shared inode lock.
>>
>> So it can still race with fsync.
>=20
> How can it race? An fsync takes the inode lock in exclusive mode.

CPU0 (sync DIO write within EOF)  CPU1 (async DIO write within EOF)
btrfs_direct_write()              btrfs_direct_write()
   btrfs_inode_lock(..., SHARED)     btrfs_inode_lock(..., SHARED)
   iomap_dio_complete()              btrfs_dio_write()
     ...                               ...
     btrfs_sync_file()                 btrfs_dio_iomap_begin()
       down_write(&i_mmap_lock)        btrfs_dio_submit_io()
       full_sync =3D test_bit(...)
       /* full_sync is false, skips
          btrfs_wait_ordered_range() */
                                     btrfs_set_inode_full_sync()
       btrfs_log_dentry_safe()
         ...
         btrfs_log_inode()
           test_bit(NEEDS_FULL_SYNC) <-- now true!
           clear_bit(NEEDS_FULL_SYNC)
           copy_inode_items_to_log()
           /* skips btrfs_log_changed_extents()
              and purges modified_extents */

>=20
>>
>> The shared inode lock for dio writes is introduced by commit
>> e9adabb9712e ("btrfs: use shared lock for direct writes within EOF").
>>
>> This is making me wonder if the shared inode lock for direct IO is a
>> good idea in the first place.
>=20
> Why would it not be a good idea?

OK, then I guess encoded write can be fixed using the same wait, other=20
than using that FULL_SYNC flag.

>=20
>>
>> Or should I change fsync() to wait for direct IOs instead of using
>> btrfs_set_inode_full_sync()?
>=20
> Under which conditions is  -EIOCBQUEUED returned?
> Are these async writes (like io_uring)?

Yes, AIO/io_uring.
>=20
> If that's common, then forcing full fsyncs badly affects performance.
>=20
> We had fast fsync long before 487781796d30.
> It got introduced back in 2012 in commit 5dc562c541e1, then removed in
> b5e6c3e170b770 and then added back (in a slightly different form) in
> 487781796d30.
> So are you sure 487781796d30 is the culprit?

At least that's the newest commit that doesn't wait for async direct=20
writes nor encoded writes.

Thanks,
Qu

>=20
>=20
>>
>> Thanks,
>> Qu
>>>        } else {
>>>                /*
>>>                 * If we have a synchronous write, we must make sure th=
e fsync
>>
>>
>=20

