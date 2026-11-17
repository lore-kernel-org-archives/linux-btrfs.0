Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794945845;
	b=ABTQ5aazU0HRWwTB1swgK2pHXAeAatdm+ARZ8yrcMGrfRw2ph77Yn2BUpBfIZ0+f6iIh
	 lKENfxPK0T4iQkUVP3KuTiw1rQUsKUNFVwEn12nJC9kmoEV+HS/WqKTBBZ5j91lxeMsEb
	 YunU0W0wpso+tU95n9QP1KvmyHB79UYMZRyuixW/9sPFIcZbhFfBYlcRM68Tv4kO8r66s
	 HR5mVkT50PJ6G9xV8SMiyhgM3eFSgqNDKa17AGMdhL/O0BFRD6Q+HCPGfj4XYmNK/LXuz
	 NigW+jhSWHlPPCz94u6SyZdk2JpZX+LA/TQCpDSEsds7fBtohKCz3Phr0t9cYBDnhGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794945845;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=uRNxcjpQEw4wGX6lb4GjIXNjzICXinkQUxN0vSMlFso=;
	b=q5KJV86JMctLoDG5QslIv90I1r/i6ykPE0somwRttnOwutYURGiQfE8f7dqBXIod8qJF
	 c5NfAM6w9arjKlA9epcLgR7QDw43Au0sjV3+Ij+B2nQpoTWR46lV7kxEu60kf5cU+tkPQ
	 n15OzmawreEcoVPcu/wyXthwP0gsisNYWv/29wjUwLBc4vKvrVdpunxoaSFFYTD8dEGyD
	 3XNSt1yNYBj2+foUbe2UYdOknxjWBGNsUpflvdzyxsfOD1cyQZK0HxCP2HoUjFkt9hqBS
	 LR+hV0q7pud/4Odp9632ZEjqfmnrRovJLQt/rqz789HSsnfiWbhm+9x02mlVvj6j8rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=rJEOm3wW;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E42606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 20:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7E42606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=rJEOm3wW
DKIM2-Signature:  i=1; m=1; t=1794945842;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:aDj06GfjVICd81hKiMz1Nj3H02Y9
   PdpS9qm0qkZsAKwVjUhmZGul/8kPWSXN3NEbkkwaSmIEnNUNiWBLhdhODISsHwyZHc5jLtjKe+p
   OKTDa3HT3oGgZYZZEDVXiqooVXLLZj5phDiLU+BwYgi5IP7852PILMPUsse9dnE3J5nhHQUQsOo
   9q3XZKhVHMUme5HKPxoNFZuRxrhgrlDNT87J4hyDF5/xAcEbS70TCQizxrDIwkV7e1Tm+k+e2Tj
   YZgSZfYnf2v7qQGBCj6fg41tl5aPOi/LbeqcS9gBsK2pu78X9tHhfR2H69S7ADYiWsiRFucTXM5
   hsFmbGO551QGaQ==;
Message-Instance:  m=1;
 h=sha256:
   k+ochP0Y2+VGh0JoB8T7bJdjpNjYQI75d99UVZdDVvU=:
   j9MKYaQfZ8//PLj9bHjYaf9mSfKguGoxv9CYWnw7jWE=,
  sha512:
   0HEQqGCeG0VNZWpmZDAOqf8bMS4vXKb7FL6IZc8JOOLg4JFrCxBM3i+bdqcOkvB8dKsc4jsgTEj2osZP7FI4JA==:
   AekFhEacIuxeNJSooG3vU5a8rpliU2KoTRFKWcV3Nv/67/GhQYo2hVotiFzKN25RMBWmWtykvUF5zuQ2JALgig==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794945842; x=1795550642; i=quwenruo.btrfs@gmx.com;
	bh=uRNxcjpQEw4wGX6lb4GjIXNjzICXinkQUxN0vSMlFso=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rJEOm3wWD0/ERDyEm4Y70UZ5bJ+53Nwat0zPAlDYIWSdPKW9p3BsD7i2AZQkSCSJ
	 ZCMtzpid2r5hE9vBmMJEl/B5Lxd8DouqkU3InMgOn5LXjTvaNzrxXVR0wf/u0tbTV
	 gZEm9YGCTZ3g6hBNsfLxWTDX0m9UEi2xgVP1OVdbrM6SWSt1E3fCJMx031oe8aziM
	 kFvHM5msRUgiM+FLgXSejWKSg5yLTZV/xnYY3hs7c60D4BNlZ02Cbr7dCaV4zPMGZ
	 85b84B8xx2HOiSNbkPAlyRpc2OLhAQsNmDAEotPlYwxix4wqpcYlolsq600lkyiCI
	 0zpHCT/hD1LBgY9MNA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MatVb-1wshkQ3wuh-00oGCs; Tue, 17
 Nov 2026 21:04:02 +0100
Message-ID: <1b0550a5-6200-4f2d-9731-f9c984d23707@gmx.com>
Date: Wed, 18 Nov 2026 06:33:59 +1030
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
Subject: Re: [PATCH 1/2] btrfs: scrub: fix use-after-free when waking up the
 repair waiter
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1794867985.git.wqu@suse.com>
 <217e66b15e1646812cc86be582be67b7e558b270.1794867985.git.wqu@suse.com>
 <CAL3q7H4Q1pEzYnXf16sNR2JSwj=V0nbMf2YE2iwrQPEKuPJ2WA@mail.gmail.com>
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
In-Reply-To: <CAL3q7H4Q1pEzYnXf16sNR2JSwj=V0nbMf2YE2iwrQPEKuPJ2WA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/s3+RzUWZdHumFalPfYDHkTQCJ99bm70i3OyIOvOrXkcB1ECt8g
 XVh1N0KF2aCJPTIaAPT4DxVKuPxhQo3p1gNwQ5vA5eGq8u6y9jq50Le7qF67mTwne7Liodo
 LmTX+djY53JTcdqr5mOP+sR+vsCSFnfuCon9wqinz5x+Dr6mNXSRk+O764lBdYbI1VYtUOR
 o5UiYg0HiK3EbEav1mCww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:eDLA9NYXykg=;Fsc1Ll/EubI17RuWStFrs7zoeKd
 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
 8l3fqZ5pg==



=E5=9C=A8 2026/11/18 03:06, Filipe Manana =E5=86=99=E9=81=93:
> On Mon, Nov 16, 2026 at 10:34=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>>
>> The read-repair worker of a scrub_stripe can race with stripe freeing:
>>
>>   CPU0 (repair worker)                CPU1 (scrub)
>>   scrub_stripe_read_repair_worker()   scrub_raid56_parity_stripe()
>>   |                                   |-wait_event()
>>   |                                   | ^^^ checks the condition withou=
t
>>   |                                   |     taking repair_wait.lock
>>   |-set_bit(REPAIR_DONE)              |
>>   | ^^^ the waiter can see it now     | ^^^ sees the bit, doesn't sleep
>>   |                                   |
>>   |                                   \-scrub_simple_mirror()
>>   |                                     \-...
>>   |                                   scrub_stripe()
>>   |                                   |-release_scrub_stripe()
>>   |                                   \-kfree(sctx->raid56_data_stripes=
)
>>   |                                     ^^^ stripe freed
>>   |
>>   \-wake_up()
>>     \-_raw_spin_lock_irqsave()
>>       ^^^ repair_wait.lock is in freed memory
>>       Too late.
>=20
> There's something odd and very confusing with the diagram.
> The way it's structured it gives the idea that
> scrub_raid56_parity_stripe() calls scrub_simple_mirror() for example.
> But it's scrub_stripe() that calls scrub_raid56_parity_stripe() and
> scrub_simple_mirror().
>=20
> I also find it confusing the mention of scrub_simple_mirror(), since
> it doesn't add any value.
>=20
> Something like this instead (the indentation may be screwed up by gmail)=
:
>=20
> scrub_stripe()
>      scrub_raid56_parity_stripe()
>           wait_event()
>              ^^ ...
>      release_scrub_stripe()
>           (...)
>=20
> This way, the flow is clearer.
>=20
> Also, the notation you are using is confusing.
> On the left side set_bit() and wake_up() are called by
> scrub_stripe_read_repair_worker(), but one if prefixed with |- while
> the other with \-.

|- is for cases that there are other sibling calls.
\- is for the last sibling.

That's kept consistent.

I'll update the race chart to make it more clear though.

Thanks,
Qu

> On the right side,
>=20
>>
>> The same applies to flush_scrub_stripes(), where the stripes are freed =
by
>> scrub_free_ctx() at the end of the scrub.
>>
>> Fix it by waiting with a completion instead. complete_all() wakes the
>> waiter under the completion's lock and does not touch it afterwards, an=
d
>> wait_for_completion() returns only after taking that lock, so the strip=
e
>> can be freed as soon as the wait returns.
>>
>> The completion is re-armed by scrub_reset_stripe(), which is called
>> before every refill of a stripe, i.e. after the previous waiter has
>> returned. The SCRUB_STRIPE_FLAG_REPAIR_DONE flag has no user left, remo=
ve
>> it.
>>
>> This is the same problem fixed for the RAID56 rbio in commit
>> 26eb4d70f96d ("btrfs: raid56: fix use-after-free when waking up the rbi=
o
>> I/O waiter").
>=20
> We can't place the commit ID here, it's not stable yet since it's in
> github's for-next only and will change as it's rebased and so on.
>=20
> The code itself looks good.
>=20
> Thanks.
>=20
>>
>> Fixes: 9ecb5ef543d3 ("btrfs: scrub: introduce the main read repair work=
er for scrub_stripe")
>> Cc: stable@vger.kernel.org # 6.4+
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/scrub.c | 19 ++++++++-----------
>>   1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 98362c91bce4..4b37ae143f61 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -80,9 +80,6 @@ enum scrub_stripe_flags {
>>          /* Set when @mirror_num, @dev, @physical and @logical are set.=
 */
>>          SCRUB_STRIPE_FLAG_INITIALIZED,
>>
>> -       /* Set when the read-repair is finished. */
>> -       SCRUB_STRIPE_FLAG_REPAIR_DONE,
>> -
>>          /*
>>           * Set for data stripes if it's triggered from P/Q stripe.
>>           * During such scrub, we should not report errors in data stri=
pes, nor
>> @@ -153,7 +150,9 @@ struct scrub_stripe {
>>          /* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_S=
TRIPE_LEN. */
>>          u32 stripe_len;
>>          wait_queue_head_t io_wait;
>> -       wait_queue_head_t repair_wait;
>> +
>> +       /* Completed when the read-repair is finished. */
>> +       struct completion repair_done;
>>
>>          /*
>>           * Indicate the states of the stripe.  Bits are defined in
>> @@ -359,7 +358,7 @@ static int init_scrub_stripe(struct btrfs_fs_info *=
fs_info,
>>          stripe->state =3D 0;
>>
>>          init_waitqueue_head(&stripe->io_wait);
>> -       init_waitqueue_head(&stripe->repair_wait);
>> +       init_completion(&stripe->repair_done);
>>          atomic_set(&stripe->pending_io, 0);
>>          spin_lock_init(&stripe->write_error_lock);
>>
>> @@ -1234,8 +1233,7 @@ static void scrub_stripe_read_repair_worker(struc=
t work_struct *work)
>>          }
>>
>>          scrub_stripe_report_errors(sctx, stripe, &errors);
>> -       set_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &stripe->state);
>> -       wake_up(&stripe->repair_wait);
>> +       complete_all(&stripe->repair_done);
>>   }
>>
>>   static void scrub_read_endio(struct btrfs_bio *bbio)
>> @@ -1762,6 +1760,7 @@ static void scrub_reset_stripe(struct scrub_strip=
e *stripe)
>>          stripe->nr_meta_extents =3D 0;
>>          stripe->nr_data_extents =3D 0;
>>          stripe->state =3D 0;
>> +       reinit_completion(&stripe->repair_done);
>>
>>          for (int i =3D 0; i < stripe->nr_sectors; i++) {
>>                  stripe->sectors[i].csum =3D NULL;
>> @@ -1960,8 +1959,7 @@ static int flush_scrub_stripes(struct scrub_ctx *=
sctx)
>>          for (int i =3D 0; i < nr_stripes; i++) {
>>                  stripe =3D &sctx->stripes[i];
>>
>> -               wait_event(stripe->repair_wait,
>> -                          test_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &str=
ipe->state));
>> +               wait_for_completion(&stripe->repair_done);
>>          }
>>
>>          /* Submit for dev-replace. */
>> @@ -2236,8 +2234,7 @@ static int scrub_raid56_parity_stripe(struct scru=
b_ctx *sctx,
>>          for (int i =3D 0; i < data_stripes; i++) {
>>                  stripe =3D &sctx->raid56_data_stripes[i];
>>
>> -               wait_event(stripe->repair_wait,
>> -                          test_bit(SCRUB_STRIPE_FLAG_REPAIR_DONE, &str=
ipe->state));
>> +               wait_for_completion(&stripe->repair_done);
>>          }
>>          /* For now, no zoned support for RAID56. */
>>          ASSERT(!btrfs_is_zoned(sctx->fs_info));
>> --
>> 2.56.0
>>
>>
>=20

