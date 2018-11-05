Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72875C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 14:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF9A20819
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 14:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CF9A20819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbeKEXzj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:55:39 -0500
Received: from mout.gmx.net ([212.227.17.20]:40845 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbeKEXzj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 18:55:39 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LqF9o-1fozzb2MYC-00dnGO; Mon, 05
 Nov 2018 15:35:28 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LqF9o-1fozzb2MYC-00dnGO; Mon, 05
 Nov 2018 15:35:28 +0100
Subject: Re: [PATCH] Btrfs: incremental send, fix infinite loop when apply
 children dir moves
To:     fdmanana@gmail.com, Robbie Ko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
References: <1540882702-21104-1-git-send-email-robbieko@synology.com>
 <CAL3q7H4p_fa=5UhfBkSs3GU5EydKQ0J76D5RMShMY-2HQY3F+Q@mail.gmail.com>
 <d1c2ad795fa14784e4908fd3fa50617e@synology.com>
 <CAL3q7H7AG7Nwj-v6scS6c9wxsKELRmLpYVOt1hkfK9Jr_sh1Cw@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <a79f2503-04ea-ed85-7c95-2033dd37ae01@gmx.com>
Date:   Mon, 5 Nov 2018 22:35:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7AG7Nwj-v6scS6c9wxsKELRmLpYVOt1hkfK9Jr_sh1Cw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7XBa3JcwqRFXiqRBGrdgwMLEaXiizwyfA"
X-Provags-ID: V03:K1:Gcs79KyOK8uzLIEiS5BBqna8DyLHDU6bbJaJNsOLYZF/GCF178h
 Ju1VeGeG0K6hsLsqF96EQtYsP5bg35uXk60LSkn3t/x8nIUpQvwjW9Cu5DF8LPNxiqJVzCS
 EW6Z088CwYQOyy4s8tNODjKIbvlXh/qkXYvsoCcKjcPM3EvF+J3l2jSq3tT5OvS9VZ2Q0XT
 InFneFHz1zYU6DW6GxzkQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:AnkAxtSCOpc=:Q7cJ87HfLYvNRXmCRjx7w+
 077/5H3/4as1Xx0Q99zinhJRV1CEsWyOFgGzcz4i6CazRN3hRoNzRWtF0ijHBGnvtkN9j1cbh
 TQwF6diUL4J/JnQ8vKnLH7yaxCoUC1hBA/ji0TrQJ8huTcbtFKOvbh3pfEcLFeCZ3phJ0/8nd
 l3uuKDvy54jziZ9lo/WVHZ67eha7+UarC35jZPduJdbakxOhq9D4yzax7Z3YyObnr/zS+TfHp
 R+VVTgidQ2sZRBKqPNvhlYrBX6755eYupbNKQ8npNINTRvwxFkCgmscED47EnB1eqEShlp6xk
 UWREqA2HOAlKTBVzRAt1tLf2CCv0d38NfVpRwRhqP2pHm3/2vSrU4LrzCcOtCqLS58LzO2OKt
 fuRFcFX4cTPn7cdMV3+9RqzKuW6nrpCnVgLsaU6RYLyjI59WKqiepySgGnRZ5TuYYJ3t7Eunn
 Y9HzJZ5j/zSnoZVjaPqfpLEVopKrtHlurz/3ECJK8eQmCmtH4UzoKe18z4XDbnUSMURen3wdz
 aTOQPSlU1FtE/XwLiVFN7u7Kdu85OH6oGv6DN0NGmLitstjCbw6VooX36GWCt5zRAK+Uaz4Qa
 jMXoxkRL9X4lUQOKHExU6278CPN0C3ql2boq8QbWjrBcUUMWKHj6iV9kvJcViR5Yiy+fU67Qr
 Du+kiFBzqL/LeoeD5WWPIRKNCK5/RRNMi6/i3R/94AOlsMBYiyyNh99kAEpREtuv55I926Dhk
 nbMjLdZ94Mhy/7yEIws7d/YJD0qCjes4wFc9WyaR4iN8Xv5m1rHvZZy6Ul1CVGQ4N+4OVWhTo
 PPY7j1siMzb9kNbiRFMy0BEm1PbStCzPrjf+eNUtSkp5ybg/CTcZGofU4/b8xRDBN/wjc7TZ0
 BVmckxjeTtcYdF2sL7DRBrS71maWlLf52/Ka2suk/MbHEX6VazwP07sQoEruZI
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7XBa3JcwqRFXiqRBGrdgwMLEaXiizwyfA
Content-Type: multipart/mixed; boundary="T0K1TxMKktNpDgpy5YeN9dX2G9h5YJ7CJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Robbie Ko <robbieko@synology.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
 linux-btrfs-owner@vger.kernel.org
Message-ID: <a79f2503-04ea-ed85-7c95-2033dd37ae01@gmx.com>
Subject: Re: [PATCH] Btrfs: incremental send, fix infinite loop when apply
 children dir moves
References: <1540882702-21104-1-git-send-email-robbieko@synology.com>
 <CAL3q7H4p_fa=5UhfBkSs3GU5EydKQ0J76D5RMShMY-2HQY3F+Q@mail.gmail.com>
 <d1c2ad795fa14784e4908fd3fa50617e@synology.com>
 <CAL3q7H7AG7Nwj-v6scS6c9wxsKELRmLpYVOt1hkfK9Jr_sh1Cw@mail.gmail.com>
In-Reply-To: <CAL3q7H7AG7Nwj-v6scS6c9wxsKELRmLpYVOt1hkfK9Jr_sh1Cw@mail.gmail.com>

--T0K1TxMKktNpDgpy5YeN9dX2G9h5YJ7CJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/5 =E4=B8=8B=E5=8D=887:11, Filipe Manana wrote:
> On Mon, Nov 5, 2018 at 4:10 AM robbieko <robbieko@synology.com> wrote:
>>
>> Filipe Manana =E6=96=BC 2018-10-30 19:36 =E5=AF=AB=E5=88=B0:
>>> On Tue, Oct 30, 2018 at 7:00 AM robbieko <robbieko@synology.com> wrot=
e:
>>>>
>>>> From: Robbie Ko <robbieko@synology.com>
>>>>
>>>> In apply_children_dir_moves, we first create an empty list (stack),
>>>> then we get an entry from pending_dir_moves and add it to the stack,=

>>>> but we didn't delete the entry from rb_tree.
>>>>
>>>> So, in add_pending_dir_move, we create a new entry and then use the
>>>> parent_ino in the current rb_tree to find the corresponding entry,
>>>> and if so, add the new entry to the corresponding list.
>>>>
>>>> However, the entry may have been added to the stack, causing new
>>>> entries to be added to the stack as well.

I'm not a send guy, so I can totally be wrong, but that 'may' word seems
to hide the demon.

>>>>
>>>> Finally, each time we take the first entry from the stack and start
>>>> processing, it ends up with an infinite loop.
>>>>
>>>> Fix this problem by remove node from pending_dir_moves,
>>>> avoid add new pending_dir_move to error list.
>>>
>>> I can't parse that explanation.
>>> Can you give a concrete example (reproducer) or did this came out of
>>> thin air?
>>>
>>> Thanks.
>>>
>>
>> I am sorry that I replied so late.
>>
>> I have no way to give a simple example.
>> But I can provide a btrfs image file
>> You can restore the Image via btrfs-image
>> Then directly command "btrfs send -e -p parent send -f dump_file"

According to the name, it doesn't look like a real world case, but some
more or less manually crafted image.
It shouldn't be that hard to describe the root cause in details if it's
crafted.

Or, if it's a image caused by some stress test, then I really hope you
could locate the direct and root cause, or at least minimize the image.
The extra noise will really take a lot of time from reviewer.

IMHO, it shouldn't be that hard to locate the key/key range that send
loops, with that located it should provide some clue to further pin down
the root cause.

I totally understand that everyone has their own work, if you can't
really spare time for this, would you please upload the image to public
for anyone (me for example) to look into the case?

Thanks,
Qu

>> Infinite loop will occur.
>> I use ubuntu 16.04, kernel 4.15.0.36-generic can be stable reproduce
>=20
> You have been occasionally submitting fixes for send/receive for a few
> years now, and you know already
> that I always ask for a changelog that describes well the problem and
> an example/reproducer.
>=20
> Why did you do this?
>=20
> What I can read from your answer is that you were too lazy to extract
> a reproducer from that image.
> Just made some change that fixes the infinite loop and because it
> apparently works you're done with it,
> Without an example at least, I don't think you or anyone can fully
> understand the problem, and if what
> you have (despite somewhat making theoretical sense) is really a good
> solution or just a workaround for
> the cause of the problem - after all if you can't give an example, you
> can't explain how in practice such loop
> of dependencies between directories happens. This, as with most
> send/receive problems, is a pure sequential
> and deterministic problem so there's really no excuse for not getting
> a reproducer.
>=20
> Without an example, an explanation how it happens in the real world,
> does one know that your change is
> fixing the problem is the right place and not introducing other
> problems? Like the receiver not getting some
> changes (missing directories, files, or renames, etc).
>=20
> Tests are not just to prove a change is correct, they exist to catch
> and prevent regressions in the future too.
>=20
> You can do better than that.
>=20
>>
>> Image file, please refer to the attachment.
>>
>> Thanks.
>>
>>
>>>>
>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>> ---
>>>>  fs/btrfs/send.c | 11 ++++++++---
>>>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>>> index 094cc144..5be83b5 100644
>>>> --- a/fs/btrfs/send.c
>>>> +++ b/fs/btrfs/send.c
>>>> @@ -3340,7 +3340,8 @@ static void free_pending_move(struct send_ctx
>>>> *sctx, struct pending_dir_move *m)
>>>>         kfree(m);
>>>>  }
>>>>
>>>> -static void tail_append_pending_moves(struct pending_dir_move *move=
s,
>>>> +static void tail_append_pending_moves(struct send_ctx *sctx,
>>>> +                                     struct pending_dir_move *moves=
,
>>>>                                       struct list_head *stack)
>>>>  {
>>>>         if (list_empty(&moves->list)) {
>>>> @@ -3351,6 +3352,10 @@ static void tail_append_pending_moves(struct
>>>> pending_dir_move *moves,
>>>>                 list_add_tail(&moves->list, stack);
>>>>                 list_splice_tail(&list, stack);
>>>>         }
>>>> +       if (!RB_EMPTY_NODE(&moves->node)) {
>>>> +               rb_erase(&moves->node, &sctx->pending_dir_moves);
>>>> +               RB_CLEAR_NODE(&moves->node);
>>>> +       }
>>>>  }
>>>>
>>>>  static int apply_children_dir_moves(struct send_ctx *sctx)
>>>> @@ -3365,7 +3370,7 @@ static int apply_children_dir_moves(struct
>>>> send_ctx *sctx)
>>>>                 return 0;
>>>>
>>>>         INIT_LIST_HEAD(&stack);
>>>> -       tail_append_pending_moves(pm, &stack);
>>>> +       tail_append_pending_moves(sctx, pm, &stack);
>>>>
>>>>         while (!list_empty(&stack)) {
>>>>                 pm =3D list_first_entry(&stack, struct pending_dir_m=
ove,
>>>> list);
>>>> @@ -3376,7 +3381,7 @@ static int apply_children_dir_moves(struct
>>>> send_ctx *sctx)
>>>>                         goto out;
>>>>                 pm =3D get_pending_dir_moves(sctx, parent_ino);
>>>>                 if (pm)
>>>> -                       tail_append_pending_moves(pm, &stack);
>>>> +                       tail_append_pending_moves(sctx, pm, &stack);=

>>>>         }
>>>>         return 0;
>>>>
>>>> --
>>>> 1.9.1
>>>>
>=20
>=20
>=20


--T0K1TxMKktNpDgpy5YeN9dX2G9h5YJ7CJ--

--7XBa3JcwqRFXiqRBGrdgwMLEaXiizwyfA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvgVSoACgkQwj2R86El
/qgGwggAqgbisnmDBpOYO3cx4DVX2QIkKX4HkFzR/rAtD7UZXz0GcXsPHAbQj3fD
nS9GjmkG2dS3ltsBq+cWPySeSJYH1VEuryyu7J3QH4/vKszhvf048MEuuTJsiI3W
PqtYAAZVOPZgAVlroKul/NgxUA9oRAOdo1owu7V8z9a3hqikTxYEeJxIOw1DnqnF
GPPqc6Zq2WlcvrfN2YmLfy4LPJeL21feXjpv5dYzsThqpVaY+yHxmGatKVj0Gatu
i93p7u/TyJLDcMCsYGyD4iUZtVLVi2r/yukqLggxNxKlGrNpTL7wT2axRk+JbNF1
7K8AucT6vkFwjDT9SAWilS+awvHfGg==
=hPHK
-----END PGP SIGNATURE-----

--7XBa3JcwqRFXiqRBGrdgwMLEaXiizwyfA--
