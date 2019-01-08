Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE20C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 01:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5913720652
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 01:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfAHBLY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 20:11:24 -0500
Received: from mout.gmx.net ([212.227.15.15]:33699 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfAHBLX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 20:11:23 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LpKrt-1hC9Fl3EpR-00fCRE; Tue, 08
 Jan 2019 02:11:13 +0100
Subject: Re: [PATCH] btrfs: Introduce new mount option to skip block group
 items scan
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181220080137.22819-1-wqu@suse.com>
 <20190107185945.GC23615@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <0e5ec6f7-cdc0-2089-5e3e-64990fa873cc@gmx.com>
Date:   Tue, 8 Jan 2019 09:11:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20190107185945.GC23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="z8o9gE0mpjvY9v6d4AFQmoKMRgHuXZuXG"
X-Provags-ID: V03:K1:vshNO5PdyKWNqA4LB2Lc1GJT9isucjr1DOoLUsbjbeYdOEk1DZQ
 bVriaXlvouy32DheuuBqH6D4eKx3j/sbgKaYVSpIRE3I9qbVaO652jONYLBSHyeK2liv+YF
 uWD43i+ok9VZd8TsC27Dzic67hrlC3e2fF8ZFVrW2pbPfPARJD3cQpAdf7tORv9fGXhabRh
 2350CBSHIQVT9Kz6KtI0w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JhnCZTtY5Rk=:3oZvdwrqDzQo/SWFaSyDDA
 2YdyhiLGq5HleEAfGjZKwKuVtUzWsQklcb1PicXM8pBtcw/uzz7sgeGHMzC0aJBy0EU8XktsE
 lJ239ZN6xB/NbyG1CeHcz8/kacwkRUwp3zBzkVdLqSBpv9HiEFWUpe7G0a6DyO/OtWV/+Yz6Y
 SYXN0MCdJw18R39URpgyTYdRDgkO79AZghbVNiC9MeQpoGbEikcH8NeCk52ZPlnTnOM5s6she
 Fe1QvnZkMHboEdKamnXPeY9nAX/NEh5MRGfCduf7OmLVdRHBkfmMaatZHEs05DA5zHIFosOtF
 XrHhyHFtQ8BBzljl/criufHmodiUKWhYtZdBbcvDqawpImT5I8mmEaepOLmjAxYGPevbBb746
 gAQ6ZZUopKXXw4Fzja/0u+5evyIuEDP7/Xn6pUJtaEpkWwWgnLSOx+Z6sRSUI7ioRlndSq67C
 ePiL/R6zrDRi64q3yLI5EUK5sQMqn+Tt4Js9sirwPTxNPvoBv6Nk0qtQOejb2V4pgp0X7IBR3
 Y5h7/XFlE+12FlaspjN7zYcnrbHEGp5NdiqqGjFHHRmhjE1jONzh3GM3akvI4CeKHJ4tMTCir
 KjKjToKMvBkeDFRfNFRnzf+hZdNRpZDWI9eNQzwKEnPXGg993zaI7T3Fnuc7f0FQI0lDzJ89S
 eOvBJ/LkB9SnmdEGiFCp8CqVyMez9ku4vY2el8inTxxwVKJfJy0dmhg7xkZD6N3RH63RqpT4d
 1K9hErOAL6fkXtgyO9WZ8a+Bgyb3YOY87OFStJw9uofq7fgW1A3KGXcFe7Dmwvyj9sX11FGGj
 0TZJnA9WDJdPeQXMwX1ELe8dUGf08BTkUoJNzFLaHIGjZ+yvMMXgnqIh74j/J59/e1GS/4KOr
 /EsyNYvY/LXSypNq4wGbYPEbEc6eKvWvZxGMRG15TxOMPesuHX5xNtEUGxU5B0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z8o9gE0mpjvY9v6d4AFQmoKMRgHuXZuXG
Content-Type: multipart/mixed; boundary="Yq8IgMu7yuZyNqjLSINmnfRYJ0qcksFbK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <0e5ec6f7-cdc0-2089-5e3e-64990fa873cc@gmx.com>
Subject: Re: [PATCH] btrfs: Introduce new mount option to skip block group
 items scan
References: <20181220080137.22819-1-wqu@suse.com>
 <20190107185945.GC23615@twin.jikos.cz>
In-Reply-To: <20190107185945.GC23615@twin.jikos.cz>

--Yq8IgMu7yuZyNqjLSINmnfRYJ0qcksFbK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/8 =E4=B8=8A=E5=8D=882:59, David Sterba wrote:
> On Thu, Dec 20, 2018 at 04:01:37PM +0800, Qu Wenruo wrote:
>> Btrfs needs to read out all block group (bg) items to fill its bg
>> caches.
>>
>> However such bg caches are only needed for read-write mount, and makes=

>> no sense for RO mount.
>>
>> So this patch introduce new mount option, skip_bg, to skip block group=

>> items scan.
>>
>> This new 'skip_bg' mount option can only be used with TRUE read-only
>> mount, which needs the following dependency:
>> - RO mount
>>   Obviously.
>>
>> - No log tree or notreelog mount option
>>
>> - No way to remoutn RW
>>   Similar to notreelog mount option.
>>
>> - No chunk <-> bg <-> dev extents restrict check
>>
>> This option should only be used as kernel equivalent of btrfs-restore.=

>>
>> With this patch, we can even mount a btrfs whose extent root is
>> completely corrupted.
>=20
> So it's a last-resort rescue option, I'd suggest to make that more
> explicit. Something like rescue=3Dskip-bg. We can add all sorts of othe=
r
> values that would relax some checks. Adding a separate mount option
> would be quite impractical.

Nice suggestion, I'm also not satisfied with current mount option name.
I'll add new rescue mount option, and convert some existing options to it=
=2E

>=20
> This would also align with the constraints you mention above, eg. no wa=
y
> to remount RW. This is fine for the corrupted extent root. I wonder wha=
t
> kind of metadata damage support would still make sense.

E.g. one leaf corrupted while containing the block group item.
Since we're going to read all block group items at mount time, such
corruption will reject mount immediately, no matter what mount option
we're using.

> a 'completely
> corrupted extent root' means you never know what you get from the
> filesystem.

Not exactly.
Just extent root node corrupted could reject mount, while fs tree could
be completely fine.

Normally we would go backup root and hopes we could get an good old
extent root.
But with this option, we should be able to access fs tree without problem=
=2E

>=20
> The in-kernel checks and interconnection of the structures would have t=
o
> be ready for missing metadata or more sanity checks would need to be
> added.

If fact, as mentioned, extent tree only affects write operation.

For fs tree read operations, current code is more or less good enough to
handle corruption, at least much robust than extent tree corruption.

>=20
> I think that all the restore and rescue functionality is better suited
> for userspace where the unpredictable corruptions that cannot be parsed=

> do not lead to kernel crashes or silent memory overwrites.

That's true.
Although btrfs-restore still can't provide everything, like
snapshot/subvolume structure, so such rescue option may still make sense.=


>=20
>> But can also be an option to test if btrfs_read_block_groups() is the
>> major cause for slow btrfs mount.
>=20
> We have a debugging/testing -only mount option 'fragment', so we may
> consider adding more.

For this part, in fact it has better way to verify the cause, without
any modification to the kernel.

We could just use ftrace to get the non-inline function execution time,
like:
# perf ftrace -t function_graph -T open_ctree \
	-T btrfs_read_block_groups \
	-T check_chunk_block_group_mappings \
	-T btrfs_read_chunk_tree \
	-T btrfs_verify_dev_extents \
	mount /dev/test/test /mnt

Thanks,
Qu


--Yq8IgMu7yuZyNqjLSINmnfRYJ0qcksFbK--

--z8o9gE0mpjvY9v6d4AFQmoKMRgHuXZuXG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwz+KsACgkQwj2R86El
/qhHWwf/eQVCox7hRPCJUYDgRSH4V7YTrwLDEi7UJ3uBwjU2csFHIIMvizjfCY8G
6sYhhqmuUdxQfZVdObG/YzK8CooYuBFTh+QWSaGlV+9q0mEGmOj6+mxsxV180kBG
rsots+p5OiPTWkvtEweGhxSdwq//zvnx8CAuYAJjl+dbhiCyJVpompBX3QfGSoo3
3oYXB0IX4vpW/szdakbQrtV3zdu5jQH8ucMyY+EI6kDH3XKzwZsR9hSs49mR4Vqm
Oao2LKneSgeH9w8fV1qPfBZ1JZvU5iUC4iORId4OqAc4Aegr78pgVr26JiI4Ldu7
CeNlz2myKm32DrSzr4wnJTLRR4VEWA==
=xY4Q
-----END PGP SIGNATURE-----

--z8o9gE0mpjvY9v6d4AFQmoKMRgHuXZuXG--
