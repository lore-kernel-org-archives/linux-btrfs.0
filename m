Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794946152;
	b=PmlePOWMDViaTbRxXuwCN/54NfLu4IZifdLDVIA2V8HzadXblbI/eYHiqkkXLUftJtDi
	 qt1HO35vd9h8dflzrcGLEd8jUH4/qDCyvCjzr77TSmg7YqZv93k8v1SSaLkWAHkUKxv2D
	 SJi4JfHvdXeFpcIwgC/ivIRZueD6OfhSs37muVNy42DI4xFxjaxw2+e1vcYH+Yrbu9PXU
	 15K/HsERVBeoVG/Am/rW0tc67nsQqXjUJTU78eb8hHTXFJoXafj8VRS20u/ugqvUD7yYZ
	 /bpPA13pW6lFGZ2SS/7jHhx6U/JPLAMgf5raDMrvPNPGf/aWa8fbmS8AuTuFEuF9F8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794946152;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=vhRkwIBHpROOFkb4CsfUQSbanvfE6Je9OSNy4Xq25ak=;
	b=LlbgtXSmtXXCasLYp2/rQUgd1f1ENHBgLebFc46GN3tEzKspCRkQqwzRkh/8rNbv4Jlt
	 5+YTLMmpujHmz0/yfg0XytFpaJ2aRfiw6JG0qPZzSjWxLdUkx8m9KK8jobC/3756u5XSs
	 7esVpETk8BScPkppFvvEt0G28L5g3gkrQN4Ek2lgL1QKyznKwhKv8rtOm2JpNw1EW4bLz
	 uWZVJNrxVqKt6audXXYWRRbKR1kCtxq/7iWluVnFNL7hlq0nhuhaWh1Ag7enas9zkz0zm
	 1lEqUah0uq+7BXiaMtRwzr3/RiDoK3XgKnqzErS1khiDZS7nisLfMMx98MzaPsu3zbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=TUdtjiHN;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97410606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 20:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97410606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=TUdtjiHN
DKIM2-Signature:  i=1; m=1; t=1794946149;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:GrhSpUtkn75Tn/SLgqrLpvEshr8Q
   iTMTt7rr8wbRYFJS/x2ILdpMHQGtq1ELl7BxMuvDoRUqa1KX6MoCAHK+nHyAryuDwgWGUePlNXU
   6OHW9NM+RevglyFiGY1C8kPP0zM2LFiIYz4rpm6ecDKJEkqjROoy3fg7dUmrgw34n+4hdedfnRK
   Xa21pgtj5rI4o6lA1BZnguohkWZU2zc7B8bNWvpbxwXQWUlplQHxvttUPQXoGTZaaVBZRRj4Kcj
   d/Iiw5CsGhZ2WuxLSBZWTogCF4oX/3o4mWceKHK35KOo7vc8rjOCprtAvgfP5SH+x17aOf5NFJA
   a3huXv0awIXeIg==;
Message-Instance:  m=1;
 h=sha256:
   diGkwzQgDK31d8LA0QPtxzynS8IipLE9yf0dKW1zi9E=:
   GpB8CHl4lr0Woabpc87JzL8Caknn4pgnQ856APDy/FY=,
  sha512:
   0n9DdVMAV3WOFXFMC5CofjXBj8/jQlUPDpTnR4p8jAu6Y9830tp8AgEC9/Vx/oj4QSVWaBhG7L1C/3lv+5yzUw==:
   b2SxAtrhHB09wAK8aCBOfHM+/OGLJfxfdKbxygYmyDCE59a+VzLW8DE6e9jhpL2nXnuIodIXscDf/3w5bEJuUA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794946149; x=1795550949; i=quwenruo.btrfs@gmx.com;
	bh=vhRkwIBHpROOFkb4CsfUQSbanvfE6Je9OSNy4Xq25ak=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=TUdtjiHND2DYOk8x5oJvfyqFfcUPg9sO5aWDHET6cwkSKrKnV1tf1tccpyoAO+Ff
	 3ISuAxa2pRj1Ay60bUYeCDnVZQ/yFBBZiAHxWC3Bmu4ykIMoMmaOnDr29VsVkh5gQ
	 MdmWjrJIdniqRkoK0R65sZmPzfw8nt+OlN9zZF0blPCKB1fG5A6Z7mtkg2BKVg6j7
	 FXaUPh/B7fpe5TJlLUQMjzHBigMjiLt5tX6XM4AaLFUe8rj2TVEGvaoCdxB5WINE1
	 AJQODkw4bYvwbpzZt3kF0dRaup8Vgww2LGjd8yCPjo3wyqla+J1XJoMycRA514my+
	 gRRlQrrOjD8la5DBSA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MmUHp-1wlW9F20e1-00j9ne; Tue, 17
 Nov 2026 21:09:09 +0100
Message-ID: <78f24a85-3080-476f-af47-c30b56bdd329@gmx.com>
Date: Wed, 18 Nov 2026 06:39:05 +1030
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
Subject: Re: [PATCH 2/2] btrfs: scrub: fix use-after-free when waking up the
 stripe I/O waiter
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1794867985.git.wqu@suse.com>
 <51527ea5f9f456a7ebe70b7fcaf626fac3dab945.1794867985.git.wqu@suse.com>
 <CAL3q7H6xiDZVeWmS2K64KmKLLa=9yWBt9JTgk-BsfdASmqjrhg@mail.gmail.com>
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
In-Reply-To: <CAL3q7H6xiDZVeWmS2K64KmKLLa=9yWBt9JTgk-BsfdASmqjrhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:frTeLBI1IuYqnL5gGbL0eu+IX9/+W0tGbMu3RRw9OWkqSn5ECkx
 gxo6H7tVd6OVp4YqeAiHKg6GAKwA1G1zKVxE/g79ntflL4VsCGVHbMm91j/ugld+CgUqgoh
 Voc86s3Lq5kywxyfVsLFc4900SNm+ebAYHgcriREedTIBbIMGqj14NoHwaJZewpkm1yTW/d
 2duj5VeyLyi9IYil/UZ5w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HbzAoq5eogo=;sIPXQNE4knofRYis/3a9bUvfRZl
 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
 ygIQrFOKRCpw9pTPhQQ==



=E5=9C=A8 2026/11/18 03:19, Filipe Manana =E5=86=99=E9=81=93:
> On Mon, Nov 16, 2026 at 10:34=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>>
>> The scrub_write_endio() can race with scrub finishing, which can lead t=
o
>> use-after-free:
>>
>>   CPU0 (write endio)                  CPU1 (scrub)
>>   scrub_write_endio()                 flush_scrub_stripes()
>>   |                                   |-wait_scrub_stripe_io()
>>   |                                   | \-wait_event()
>>   |                                   |   ^^^ checks the condition with=
out
>>   |                                   |       taking io_wait.lock
>>   |-atomic_dec_and_test()             |
>>   | ^^^ pending_io hits 0             |
>>   |                                   | ^^^ sees 0, doesn't sleep
>>   |                                   |
>>   |                                   btrfs_scrub_dev()
>>   |                                   \-scrub_put_ctx()
>>   |                                     \-scrub_free_ctx()
>>   |                                       ^^^ stripe freed
>>   |
>>   \-wake_up()
>>     \-_raw_spin_lock_irqsave()
>>       ^^^ io_wait.lock is in freed memory
>>           Too late.
>=20
> I have the same comment here regarding the diagram.
> It confuses me, it gives the wrong idea that flush_scrub_stripes()
> either calls btrfs_scrub_dev() or that they are called from the same
> function.
>=20
> This can be clearer by using indentation and not skipping functions in
> the call chain:
>=20
> btrfs_scrub_dev()
>     scrub_enumerate_chunks()
>        scrub_chunk()
>           scrub_stripe()
>              flush_scrub_stripes()
>                 wait_scrub_stripe_io()
>                    wait_event()
>                       (...)

The problem is, this takes up almost all space of a colum.
And the indent is not that space efficient either.

One space is not enough to distinguish them, and if you go two spaces,=20
it's no different than using |- or \-, they also take up two spaces.

To keep thing clears and leave enough space for comments, I'd prefer not=
=20
to include everything.

Thus I'd prefer to skip the scrub_enumerate_chunks() and scrub_chunk()=20
parts, only showing btrfs_scrub_dev() -> scrub_stripe() directly.

But in this case, I'd say the btrfs_scrub_dev() part is not placed where=
=20
it should be.

>=20
>     scrub_put_ctx()
>        scrub_free_ctx()
>=20
>=20
>>
>> Fix it by waiting with a completion instead. complete_all() wakes the
>> waiter under the completion's lock and does not touch it afterwards, an=
d
>> wait_for_completion_io() returns only after taking that lock, so the
>> stripe can be freed as soon as the wait returns.
>>
>> There are locations that we submit multiple bios in one go, with extra
>> care the pending_io can reach 0 during the submission, to address it:
>>
>> - Re-arm the completion when the first pending_io ref is taken, in
>>    scrub_stripe_get_io(). Any previous round of IO is waited for before=
 the
>>    next one starts.
>>
>> - Hold one extra ref for batched submission
>>    This includes:
>>    * scrub_write_sectors()
>>    * scrub_stripe_submit_repair_read() for non-zoned cases
>>
>>    This is the same pattern used in other scrub path.
>>
>> The completion is initialized as completed, so waiting on a stripe with=
out
>> any pending IO returns immediately as before.
>>
>> This is the same problem fixed for the RAID56 rbio in commit
>> 26eb4d70f96d ("btrfs: raid56: fix use-after-free when waking up the rbi=
o
>> I/O waiter").
>=20
> Just like for the previous patch, I have the same comment regarding
> the commit ID not being stable here; it can change after rebasing and
> so on.
>=20
> The code looks good.
> Thanks.
>=20
>>
>> Fixes: 9ecb5ef543d3 ("btrfs: scrub: introduce the main read repair work=
er for scrub_stripe")
>> Fixes: 058e09e6fe7c ("btrfs: scrub: introduce a writeback helper for sc=
rub_stripe")
>> Cc: stable@vger.kernel.org # 6.4+
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/scrub.c | 97 ++++++++++++++++++++++++++++++++++-------------=
-
>>   1 file changed, 69 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 4b37ae143f61..a8c62a3aea0c 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -149,7 +149,9 @@ struct scrub_stripe {
>>          atomic_t pending_io;
>>          /* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_S=
TRIPE_LEN. */
>>          u32 stripe_len;
>> -       wait_queue_head_t io_wait;
>> +
>> +       /* Completed by the last endio when pending_io drops to zero. *=
/
>> +       struct completion io_done;
>>
>>          /* Completed when the read-repair is finished. */
>>          struct completion repair_done;
>> @@ -357,9 +359,11 @@ static int init_scrub_stripe(struct btrfs_fs_info =
*fs_info,
>>          stripe->stripe_len =3D BTRFS_STRIPE_LEN;
>>          stripe->state =3D 0;
>>
>> -       init_waitqueue_head(&stripe->io_wait);
>>          init_completion(&stripe->repair_done);
>> +       init_completion(&stripe->io_done);
>>          atomic_set(&stripe->pending_io, 0);
>> +       /* No pending IO by default, thus nothing to wait. */
>> +       complete_all(&stripe->io_done);
>>          spin_lock_init(&stripe->write_error_lock);
>>
>>          stripe->buffer =3D kvmalloc(BTRFS_STRIPE_LEN, GFP_KERNEL);
>> @@ -381,9 +385,25 @@ static int init_scrub_stripe(struct btrfs_fs_info =
*fs_info,
>>          return -ENOMEM;
>>   }
>>
>> +static void scrub_stripe_get_io(struct scrub_stripe *stripe)
>> +{
>> +       /* The first pending IO re-arms the completion. */
>> +       if (atomic_inc_return(&stripe->pending_io) =3D=3D 1)
>> +               reinit_completion(&stripe->io_done);
>> +}
>> +
>> +/* Drop one pending IO, return true if it was the last one. */
>> +static bool scrub_stripe_put_io(struct scrub_stripe *stripe)
>> +{
>> +       if (!atomic_dec_and_test(&stripe->pending_io))
>> +               return false;
>> +       complete_all(&stripe->io_done);
>> +       return true;
>> +}
>> +
>>   static void wait_scrub_stripe_io(struct scrub_stripe *stripe)
>>   {
>> -       wait_event(stripe->io_wait, atomic_read(&stripe->pending_io) =
=3D=3D 0);
>> +       wait_for_completion_io(&stripe->io_done);
>>   }
>>
>>   static void scrub_put_ctx(struct scrub_ctx *sctx);
>> @@ -891,8 +911,7 @@ static void scrub_repair_read_endio(struct btrfs_bi=
o *bbio)
>>
>>          scrub_read_endio_common(bbio);
>>
>> -       if (atomic_dec_and_test(&stripe->pending_io))
>> -               wake_up(&stripe->io_wait);
>> +       scrub_stripe_put_io(stripe);
>>   }
>>
>>   static int calc_next_mirror(int mirror, int num_copies)
>> @@ -941,6 +960,18 @@ static struct btrfs_bio *alloc_scrub_bbio(struct b=
trfs_fs_info *fs_info,
>>          return bbio;
>>   }
>>
>> +static void scrub_submit_repair_read_bio(struct scrub_stripe *stripe,
>> +                                        struct btrfs_bio *bbio, int mi=
rror,
>> +                                        bool wait)
>> +{
>> +       ASSERT(bbio->bio.bi_iter.bi_size);
>> +
>> +       scrub_stripe_get_io(stripe);
>> +       btrfs_submit_bbio(bbio, mirror);
>> +       if (wait)
>> +               wait_scrub_stripe_io(stripe);
>> +}
>> +
>>   static void scrub_stripe_submit_repair_read(struct scrub_stripe *stri=
pe,
>>                                              int mirror, int blocksize,=
 bool wait)
>>   {
>> @@ -953,15 +984,19 @@ static void scrub_stripe_submit_repair_read(struc=
t scrub_stripe *stripe,
>>          ASSERT(atomic_read(&stripe->pending_io) =3D=3D 0,
>>                 "atomic_read(&stripe->pending_io)=3D%d", atomic_read(&s=
tripe->pending_io));
>>
>> +       /*
>> +        * Hold an extra ref during submission, so the IO can not be re=
ported as
>> +        * finished before all bios are submitted.
>> +        * If we wait for every bio, no extra ref as it would block the=
 wait.
>> +        */
>> +       if (!wait)
>> +               scrub_stripe_get_io(stripe);
>> +
>>          for_each_set_bit(i, &old_error_bitmap, stripe->nr_sectors) {
>>                  /* The current sector cannot be merged, submit the bio=
. */
>>                  if (bbio && ((i > 0 && !test_bit(i - 1, &old_error_bit=
map)) ||
>>                               bbio->bio.bi_iter.bi_size >=3D blocksize)=
) {
>> -                       ASSERT(bbio->bio.bi_iter.bi_size);
>> -                       atomic_inc(&stripe->pending_io);
>> -                       btrfs_submit_bbio(bbio, mirror);
>> -                       if (wait)
>> -                               wait_scrub_stripe_io(stripe);
>> +                       scrub_submit_repair_read_bio(stripe, bbio, mirr=
or, wait);
>>                          bbio =3D NULL;
>>                  }
>>
>> @@ -973,13 +1008,10 @@ static void scrub_stripe_submit_repair_read(stru=
ct scrub_stripe *stripe,
>>
>>                  scrub_bio_add_sector(bbio, stripe, i);
>>          }
>> -       if (bbio) {
>> -               ASSERT(bbio->bio.bi_iter.bi_size);
>> -               atomic_inc(&stripe->pending_io);
>> -               btrfs_submit_bbio(bbio, mirror);
>> -               if (wait)
>> -                       wait_scrub_stripe_io(stripe);
>> -       }
>> +       if (bbio)
>> +               scrub_submit_repair_read_bio(stripe, bbio, mirror, wait=
);
>> +       if (!wait)
>> +               scrub_stripe_put_io(stripe);
>>   }
>>
>>   static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
>> @@ -1242,8 +1274,7 @@ static void scrub_read_endio(struct btrfs_bio *bb=
io)
>>
>>          scrub_read_endio_common(bbio);
>>
>> -       if (atomic_dec_and_test(&stripe->pending_io)) {
>> -               wake_up(&stripe->io_wait);
>> +       if (scrub_stripe_put_io(stripe)) {
>>                  INIT_WORK(&stripe->work, scrub_stripe_read_repair_work=
er);
>>                  queue_work(stripe->bg->fs_info->scrub_workers, &stripe=
->work);
>>          }
>> @@ -1269,8 +1300,7 @@ static void scrub_write_endio(struct btrfs_bio *b=
bio)
>>          }
>>          bio_put(&bbio->bio);
>>
>> -       if (atomic_dec_and_test(&stripe->pending_io))
>> -               wake_up(&stripe->io_wait);
>> +       scrub_stripe_put_io(stripe);
>>   }
>>
>>   static void scrub_submit_write_bio(struct scrub_ctx *sctx,
>> @@ -1283,7 +1313,7 @@ static void scrub_submit_write_bio(struct scrub_c=
tx *sctx,
>>                        stripe->logical;
>>
>>          fill_writer_pointer_gap(sctx, stripe->physical + bio_off);
>> -       atomic_inc(&stripe->pending_io);
>> +       scrub_stripe_get_io(stripe);
>>          btrfs_submit_repair_write(bbio, stripe->mirror_num, dev_replac=
e);
>>          if (!btrfs_is_zoned(fs_info))
>>                  return;
>> @@ -1322,6 +1352,15 @@ static void scrub_write_sectors(struct scrub_ctx=
 *sctx, struct scrub_stripe *str
>>          struct btrfs_bio *bbio =3D NULL;
>>          int sector_nr;
>>
>> +       /*
>> +        * Hold an extra ref during submission, so the IO can not be re=
ported as
>> +        * finished before all bios are submitted.
>> +        * For zoned, we wait for every bio, no extra ref as it would b=
lock the
>> +        * wait.
>> +        */
>> +       if (!btrfs_is_zoned(fs_info))
>> +               scrub_stripe_get_io(stripe);
>> +
>>          for_each_set_bit(sector_nr, &write_bitmap, stripe->nr_sectors)=
 {
>>                  /* We should only writeback sectors covered by an exte=
nt. */
>>                  ASSERT(scrub_bitmap_test_bit_has_extent(stripe, sector=
_nr));
>> @@ -1340,6 +1379,8 @@ static void scrub_write_sectors(struct scrub_ctx =
*sctx, struct scrub_stripe *str
>>          }
>>          if (bbio)
>>                  scrub_submit_write_bio(sctx, stripe, bbio, dev_replace=
);
>> +       if (!btrfs_is_zoned(fs_info))
>> +               scrub_stripe_put_io(stripe);
>>   }
>>
>>   /*
>> @@ -1786,7 +1827,8 @@ static void scrub_submit_extent_sector_read(struc=
t scrub_stripe *stripe)
>>          int mirror =3D stripe->mirror_num;
>>          int i;
>>
>> -       atomic_inc(&stripe->pending_io);
>> +       /* The extra ref is dropped after all bios are submitted. */
>> +       scrub_stripe_get_io(stripe);
>>
>>          for_each_set_bit(i, &has_extent, stripe->nr_sectors) {
>>                  /* We're beyond the chunk boundary, no need to read an=
ymore. */
>> @@ -1798,7 +1840,7 @@ static void scrub_submit_extent_sector_read(struc=
t scrub_stripe *stripe)
>>                      ((i > 0 && !test_bit(i - 1, &has_extent)) ||
>>                       bbio->bio.bi_iter.bi_size >=3D stripe_len)) {
>>                          ASSERT(bbio->bio.bi_iter.bi_size);
>> -                       atomic_inc(&stripe->pending_io);
>> +                       scrub_stripe_get_io(stripe);
>>                          btrfs_submit_bbio(bbio, mirror);
>>                          bbio =3D NULL;
>>                  }
>> @@ -1844,12 +1886,11 @@ static void scrub_submit_extent_sector_read(str=
uct scrub_stripe *stripe)
>>
>>          if (bbio) {
>>                  ASSERT(bbio->bio.bi_iter.bi_size);
>> -               atomic_inc(&stripe->pending_io);
>> +               scrub_stripe_get_io(stripe);
>>                  btrfs_submit_bbio(bbio, mirror);
>>          }
>>
>> -       if (atomic_dec_and_test(&stripe->pending_io)) {
>> -               wake_up(&stripe->io_wait);
>> +       if (scrub_stripe_put_io(stripe)) {
>>                  INIT_WORK(&stripe->work, scrub_stripe_read_repair_work=
er);
>>                  queue_work(stripe->bg->fs_info->scrub_workers, &stripe=
->work);
>>          }
>> @@ -1877,7 +1918,7 @@ static void scrub_submit_initial_read(struct scru=
b_ctx *sctx,
>>          /* Read the whole range inside the chunk boundary. */
>>          for (unsigned int cur =3D 0; cur < nr_sectors; cur++)
>>                  scrub_bio_add_sector(bbio, stripe, cur);
>> -       atomic_inc(&stripe->pending_io);
>> +       scrub_stripe_get_io(stripe);
>>
>>          /*
>>           * For dev-replace, either user asks to avoid the source dev, =
or
>> --
>> 2.56.0
>>
>>
>=20

