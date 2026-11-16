Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794790981;
	b=ZPt+FTuB+vvUpfStWVEcdbvRP/T0g8zF3KTcWkDQCN8il54JfbYwqlt+Kfdwg6nV5+J8
	 gH0pVuR3SWYH/AeaO6ypodyAwoOQus0fU6SNBaU1Tq9tBnewOsUxBiqr8+u4037pncJrq
	 VSJwQvk+trkV76Sv3uvYdJAWPfuRjXNQ3EGiBmrxBbLA6ELAPTdxmrb0B609HKevT0hRY
	 kuIlWV5KUAgesXKrCnqjnqZd10kPyszxEjWRjZVIsAUo42yDqvmxTHPf0tlQXuons3EZ8
	 Ua/MsDn9HlE4daKJNTa6Cfghof7VWn3AjahIHz3xEcKK7aCLvjqlseyro/QogfaEZLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794790981;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=Y1Y7jbh3BiDTU1EyRzCfkFXW+8tN+LCDZmGqBMRDTkc=;
	b=ZdiaPUh0RyJ4Hbr6q2s+r3FolQaXZ3g24EgZXmQG+L6boae4C65oMNJfcD1JpT8ZY2He
	 /FR7jmg20vnceRtHIW4e2mo26kH0PcF/tTl7icRyan8+Gz6luKQP66nV8lvGyn9LWzJ+Y
	 9XXf3ob4kuew8N2SytJB9o/wYReJHdf+Tog77I26pB6GjMGb7b8AaqgDuXS6RTXB+VrU1
	 1oU86166g81be1U47icTVAxDg+teHAjwOCmwJ7wPvppKBYSTrsvmAAzF9dFKoxwvOQjqL
	 L0lvJciopB/zGVQucSUNuwVKcPjUppQTrlApiBDjzy3RFYgwENKbFyBR4/gKDXINB/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Jd4JBDKl;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8117A606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 01:03:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8117A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Jd4JBDKl
DKIM2-Signature:  i=1; m=1; t=1794790978;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:YMiqOyCMZQ0vjzdFpVhFUEvxKwYA
   H0eOcR8Pdgw3Li9pQkIYPYF8e82IryEQM0LUTACbPMhXpf9mQFIHC2uLmP90vkdaXk+HE29O7R+
   K6ZJIVbzCTmBz/DeXEcYsPkvF4uGgsN8Fs3/N3HcDj/+aM+KJmjjBR4BOmOEDNJwP3YB2TP83ln
   Q59hAXkbbGCIsh0nz3w1hTrLQWijjl9L+DjPGVJ3bQQen5WLe6b+xTG4HSuY1g995eYIaSlPWgY
   PSewPN7cdeCfN/3+bSdMuc07RqyPEUacXx0RD8tA9JiLFmLwbrn7nmVbaUCz2u4uY18jMh0Jn1p
   4PGARREXAC9XGQ==;
Message-Instance:  m=1;
 h=sha256:
   1ZIv1zpkvhIhp29a4QEjeG0La/eA15ZjOtr3pPW73ZM=:
   k9dOj6/Jr0ariC3GLfAsNMc9jNeArIiF3E08lY6gAVU=,
  sha512:
   rzZJXt70/CR4dOpDXBOVfrcBjuU+np+OmD9LOZyp0gUbjFom5nxfp43YV1shp/HZXI2wMI5vHG4KjX40pxAd9g==:
   llRzvcmKOretsDRyEXhZ3PJAWPJTFo6K2VK0cdKx3bpp4ky2T3vdKjVlrXpeihlRJTf9qbso6kPnjOhumK9n3g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794790972; x=1795395772; i=quwenruo.btrfs@gmx.com;
	bh=Y1Y7jbh3BiDTU1EyRzCfkFXW+8tN+LCDZmGqBMRDTkc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Jd4JBDKlUA8rjRx+wUV0FFhi2B77xrrG07pYXKx7gmA60b8jOkGZ8jmQS0JcmgGJ
	 1Fi+Ahd00wk8djldapWAHFS7U/2UJmt/U03vzU0XHD6ZNKg9dmpf0zQtj94foFVvk
	 IR/gwRRhztaOFzxQwgbfKqPK+o/tBLrhmL2fHTaXWtGpqFMOzvwOrpbMKSyi9gjeF
	 6M6Dn/EVCGi56nzjALECsbnHexjiKiKdF3cGDae5x4Jl8NMqf0TbOWhmjrQ/VUxtI
	 lmwYjWXq/4jWcrPZvaAqkf8pDNjEcu5yGp95ygOm3E/EZ2WGPk6HtqphAk7CjI3ja
	 eeOaLVlXKgYLY7oHAg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MGQj7-1xEl0g3fFF-00FZSt; Mon, 16
 Nov 2026 02:02:52 +0100
Message-ID: <29d117e7-8ccd-4d55-a8d5-1ef78d851700@gmx.com>
Date: Mon, 16 Nov 2026 11:32:48 +1030
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
Subject: Re: [PATCH v2] btrfs: raid56: fix use-after-free when waking up the
 rbio I/O waiter
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org
References: <20261116001903.63524-1-mc@raidlab.org>
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
In-Reply-To: <20261116001903.63524-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BLfZMUw2qhZtMoeEzlh6K1FRls/v2CAneVzAGW/z5Gj+Ly+9HKs
 ARLkCrP26s1rSHQlYPWo/UdvleVTrwaE1EwBOjN8cBXoo6qtV7gqqaQ6z72QJDaBBRQeUz2
 A30lcy0l3B4H1wKRkWXs9lSfwmnPVIGT8VcIZUUlQiq6nSJAgygX3yUkAXTQdSvgNHKczWA
 Hsnp1+36jYFvSSsa0vV3A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8X4DgaQHlAw=;zeR+P8SAf9RvP7+rXd5qrcZD8wz
 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



=E5=9C=A8 2026/11/16 10:49, Miroslav Cimerman =E5=86=99=E9=81=93:
> The end_io functions of the RAID56 read and write bios decrement
> rbio->stripes_pending and call wake_up(&rbio->io_wait) when it drops
> to zero. The submitter waits with wait_event(rbio->io_wait,
> atomic_read(&rbio->stripes_pending) =3D=3D 0) and then can drop the last
> reference to the rbio, which frees it.
>=20
> If the submitter checks the condition after the last decrement and
> before the wake_up(), it does not sleep at all:
>=20
>    CPU0 (endio, irq)                  CPU1 (submitter, rmw_rbio)
>    raid_wait_write_end_io()           rmw_rbio()
>    |                                  |-submit_write_bios()
>    |                                  | \-submit_bio()
>    |                                  |
>    |                                  |-wait_event()
>    |-bio_put()                        | ^^^ checks the condition without
>    |                                  |     taking io_wait.lock
>    |-atomic_dec_and_test()            |
>    | ^^^ stripes_pending hits 0       |
>    |                                  | ^^^ sees 0, doesn't sleep
>    |                                  |
>    |                                  \-rbio_orig_end_io()
>    |                                    \-kfree()
>    |                                      ^^^ last rbio reference, rbio
>    |                                          freed
>    |
>    \-wake_up()
>      \-_raw_spin_lock_irqsave()
>        ^^^ io_wait.lock is in freed memory
>        Too late.
>=20
> Even when the submitter sleeps, the wake-up takes it off the wait
> queue, so finish_wait() returns without taking the queue's lock while
> wake_up() still holds it:
>=20
>    CPU0 (endio, irq)                  CPU1 (submitter, rmw_rbio)
>    raid_wait_write_end_io()           rmw_rbio()
>    |                                  \-wait_event()
>    |                                    |-prepare_to_wait_event()
>    |                                    \-schedule()
>    |-atomic_dec_and_test()
>    | ^^^ stripes_pending hits 0
>    |
>    \-wake_up()
>      \-__wake_up_common_lock()
>        |-_raw_spin_lock_irqsave()
>        |-__wake_up_common()
>        | ^^^ autoremove_wake_function()
>        |     takes the waiter off the
>        |     queue and wakes CPU1       finish_wait()
>        |                                |-list_empty_careful()
>        |                                | ^^^ entry already removed,
>        |                                |     returns without taking
>        |                                |     io_wait.lock
>        |                                |
>        |                                \-rbio_orig_end_io()
>        |                                  \-kfree()
>        |                                    ^^^ rbio freed
>        |
>        \-_raw_spin_unlock_irqrestore()
>          ^^^ io_wait.lock is in freed memory
>          Too late.
>=20
> The same happens on the read side (raid_wait_read_end_io() and
> submit_read_wait_bio_list()) and in the parity scrub. On 6.12.117
> (bio_endio() and the end_io function are tail calls, so they do not
> show in the trace):
>=20
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    RIP: 0010:__wake_up_common+0x25/0xa0
>    Call Trace:
>     <IRQ>
>     __wake_up+0x31/0x60
>     blk_update_request+0xfd/0x410
>     blk_mq_end_request+0x1d/0x1a0
>    Kernel panic - not syncing: Fatal exception in interrupt
>=20
> With KASAN on v7.4-rc2 and a test-only delay between the decrement
> and the wake-up:
>=20
>    BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x76/0xe0
>     __wake_up+0x1c/0x60
>     raid_wait_read_end_io+0x132/0x10f0
>     blk_update_request+0x21e/0xea0
>    Allocated by task 82:
>     alloc_rbio.isra.0+0xa8/0xbf0
>     raid56_parity_recover+0x10a/0x9c0
>    Freed by task 84:
>     kfree+0x154/0x420
>     rbio_orig_end_io+0x1c4/0x340
>     recover_rbio+0x393/0x590
>=20
> Wait with a completion instead. complete() wakes the waiter under the
> completion's lock and does not touch it afterwards, and
> wait_for_completion() returns only after taking that lock, so the
> rbio may be freed as soon as the wait returns. The parity scrub waits
> for its writes only when finish_parity_scrub() submitted them.
>=20
> Fixes: d817ce35d24a ("btrfs: raid56: switch recovery path to a single fu=
nction")
> Fixes: 5eb30ee26fa4 ("btrfs: raid56: introduce the main entrance for RMW=
 path")
> Fixes: 6bfd0133bee2 ("btrfs: raid56: switch scrub path to use a single f=
unction")
> Cc: stable@vger.kernel.org # 6.2+
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Miroslav Cimerman <mc@raidlab.org>

Pushed to for-next branch.

Thanks,
Qu

> ---
> Changes in v2:
> - ASCII race charts (Qu)
> - drop the FuzzyRAID sentence and the completion.h include (Qu)
>=20
> Found with FuzzyRAID, a fault-injection tester for RAID that is not
> public yet. The analysis, the fix, the tests and the commit message
> were prepared with the help of an LLM. I reviewed everything.
>=20
> The crash: 4 of 10,711 fault-injection scenarios on a 3-device data
> RAID5 in QEMU (6.12.117). With KASAN on v7.4-rc2, a test-only delay
> (20 ms between the last decrement and the wake-up, 0.5 ms before the
> read wait) shows the use-after-free above in the first pass of reads
> over the RAID5 with one device dead. With this patch and the same
> delay there is no report and every block reads back correctly.
>=20
> v1: https://lore.kernel.org/linux-btrfs/20261115232358.58163-1-mc@raidla=
b.org/
> ---
>   fs/btrfs/raid56.c | 30 ++++++++++++++++++++++--------
>   fs/btrfs/raid56.h |  3 ++-
>   2 files changed, 24 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index a8a8004bb14c..60f270c3a339 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1019,7 +1019,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct bt=
rfs_fs_info *fs_info,
>   	}
>  =20
>   	bio_list_init(&rbio->bio_list);
> -	init_waitqueue_head(&rbio->io_wait);
> +	init_completion(&rbio->io_done);
>   	INIT_LIST_HEAD(&rbio->plug_list);
>   	spin_lock_init(&rbio->bio_list_lock);
>   	INIT_LIST_HEAD(&rbio->stripe_cache);
> @@ -1619,7 +1619,19 @@ static void raid_wait_read_end_io(struct bio *bio=
)
>  =20
>   	bio_put(bio);
>   	if (atomic_dec_and_test(&rbio->stripes_pending))
> -		wake_up(&rbio->io_wait);
> +		complete(&rbio->io_done);
> +}
> +
> +/*
> + * Prepare to wait for the nr bios about to be submitted. With none the=
re is
> + * nothing to wait for.
> + */
> +static void rbio_prepare_io_wait(struct btrfs_raid_bio *rbio, int nr)
> +{
> +	reinit_completion(&rbio->io_done);
> +	atomic_set(&rbio->stripes_pending, nr);
> +	if (nr =3D=3D 0)
> +		complete(&rbio->io_done);
>   }
>  =20
>   static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
> @@ -1627,7 +1639,7 @@ static void submit_read_wait_bio_list(struct btrfs=
_raid_bio *rbio,
>   {
>   	struct bio *bio;
>  =20
> -	atomic_set(&rbio->stripes_pending, bio_list_size(bio_list));
> +	rbio_prepare_io_wait(rbio, bio_list_size(bio_list));
>   	while ((bio =3D bio_list_pop(bio_list))) {
>   		bio->bi_end_io =3D raid_wait_read_end_io;
>  =20
> @@ -1640,7 +1652,7 @@ static void submit_read_wait_bio_list(struct btrfs=
_raid_bio *rbio,
>   		submit_bio(bio);
>   	}
>  =20
> -	wait_event(rbio->io_wait, atomic_read(&rbio->stripes_pending) =3D=3D 0=
);
> +	wait_for_completion_io(&rbio->io_done);
>   }
>  =20
>   static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
> @@ -2329,7 +2341,7 @@ static void raid_wait_write_end_io(struct bio *bio=
)
>   		rbio_update_error_bitmap(rbio, bio);
>   	bio_put(bio);
>   	if (atomic_dec_and_test(&rbio->stripes_pending))
> -		wake_up(&rbio->io_wait);
> +		complete(&rbio->io_done);
>   }
>  =20
>   static void submit_write_bios(struct btrfs_raid_bio *rbio,
> @@ -2337,7 +2349,7 @@ static void submit_write_bios(struct btrfs_raid_bi=
o *rbio,
>   {
>   	struct bio *bio;
>  =20
> -	atomic_set(&rbio->stripes_pending, bio_list_size(bio_list));
> +	rbio_prepare_io_wait(rbio, bio_list_size(bio_list));
>   	while ((bio =3D bio_list_pop(bio_list))) {
>   		bio->bi_end_io =3D raid_wait_write_end_io;
>  =20
> @@ -2444,7 +2456,7 @@ static void rmw_rbio(struct btrfs_raid_bio *rbio)
>   	/* We should have at least one bio assembled. */
>   	ASSERT(bio_list_size(&bio_list));
>   	submit_write_bios(rbio, &bio_list);
> -	wait_event(rbio->io_wait, atomic_read(&rbio->stripes_pending) =3D=3D 0=
);
> +	wait_for_completion_io(&rbio->io_done);
>  =20
>   	/* We may have more errors than our tolerance during the read. */
>   	for (sectornr =3D 0; sectornr < rbio->stripe_nsectors; sectornr++) {
> @@ -2915,7 +2927,9 @@ static void scrub_rbio(struct btrfs_raid_bio *rbio=
)
>   	 * and writeback the good content.
>   	 */
>   	ret =3D finish_parity_scrub(rbio);
> -	wait_event(rbio->io_wait, atomic_read(&rbio->stripes_pending) =3D=3D 0=
);
> +	/* It submitted its writes if and only if it returned 0. */
> +	if (ret =3D=3D 0)
> +		wait_for_completion_io(&rbio->io_done);
>   	for (sector_nr =3D 0; sector_nr < rbio->stripe_nsectors; sector_nr++)=
 {
>   		int found_errors;
>  =20
> diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
> index 8700910b8dc9..c86ffd655360 100644
> --- a/fs/btrfs/raid56.h
> +++ b/fs/btrfs/raid56.h
> @@ -175,7 +175,8 @@ struct btrfs_raid_bio {
>  =20
>   	atomic_t stripes_pending;
>  =20
> -	wait_queue_head_t io_wait;
> +	/* Completed by the last end_io when stripes_pending drops to zero. */
> +	struct completion io_done;
>  =20
>   	/* Bitmap to record which horizontal stripe has data */
>   	unsigned long dbitmap;
>=20
> base-commit: 3aefd67f08f8ed59ed0fa90619b25856df415031

