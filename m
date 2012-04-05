From: Bobby Powers <bobbypowers@gmail.com>
Subject: Re: [PATCH] Btrfs: remove BUG_ON from get_restripe_target
Date: Wed, 4 Apr 2012 21:48:36 -0400
Message-ID: <CAArOQ2XoGCgc7nwcxwfzLEzA2Scj3GMnOOmzyT+NREi0AMWQrQ@mail.gmail.com>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
	<4F7CEB55.3090307@suse.de>
	<CAArOQ2U54=zmCuErM2EOd2BNmfv=K7ujJET5RXpp_V64UJStTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <ak@linux.intel.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAArOQ2U54=zmCuErM2EOd2BNmfv=K7ujJET5RXpp_V64UJStTQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 4, 2012 at 9:19 PM, Bobby Powers <bobbypowers@gmail.com> wr=
ote:
> On Wed, Apr 4, 2012 at 8:46 PM, Jeff Mahoney <jeffm@suse.de> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 04/04/2012 04:19 PM, Bobby Powers wrote:
>>> spin_is_locked always returns 0 on non-SMP systems, which causes
>>> btrfs to fail the mount. =A0There is documentation pending as to wh=
y
>>> checking for spin_is_locked is a bad idea:
>>>
>>> https://lkml.org/lkml/2012/3/27/413
>>>
>>> As this was the only location in fs/btrfs/extent-tree.c that did
>>> lock-correctness checking in a BUG_ON, simply remove it.
>>>
>>> Signed-off-by: Bobby Powers <bobbypowers@gmail.com> CC: Ilya
>>> Dryomov <idryomov@gmail.com> CC: Chris Mason
>>> <chris.mason@oracle.com> CC: Andi Kleen <ak@linux.intel.com> CC:
>>> linux-btrfs@vger.kernel.org CC: linux-kernel@vger.kernel.org ---
>>> fs/btrfs/extent-tree.c | =A0 =A03 --- 1 file changed, 3 deletions(-=
)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
>>> a844204..c98b073 100644 --- a/fs/btrfs/extent-tree.c +++
>>> b/fs/btrfs/extent-tree.c @@ -3158,9 +3158,6 @@ static u64
>>> get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
>>> struct btrfs_balance_control *bctl =3D fs_info->balance_ctl; u64
>>> target =3D 0;
>>>
>>> - =A0 =A0 BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) && -
>>> !spin_is_locked(&fs_info->balance_lock)); - if (!bctl) return 0;
>>>
>>
>> Why not replace both of these with lockdep_assert_held as Andi
>> suggested in his doc?
>
> The complication here is that the existing statement was asserting
> that _either_ volume_mutex was held _or_ balance_lock was held -
> lockdep_assert_held is defined as:
>
> #define lockdep_assert_held(l) =A0WARN_ON(debug_locks && !lockdep_is_=
held(l))

Well, I guess it works fine if lockdep.h defines lockdep_is_held(l)
for the !LOCKDEP case:

       BUG_ON(debug_locks && !lockdep_is_held(&fs_info->volume_mutex) &=
&
              !lockdep_is_held(&fs_info->balance_lock));

> which doesn't map to the existing logic. =A0Although I could be missi=
ng something.
>
> Sorry for the double email, forgot to turn off html mail initially.
>
> yours,
> Bobby
>
>> - -Jeff
>>
>> - --
>> Jeff Mahoney
>> SUSE Labs
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v2.0.18 (GNU/Linux)
>> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>>
>> iQIcBAEBAgAGBQJPfOtVAAoJEB57S2MheeWyew4P/ju2FiKPWvFEhShP2BQzmPPL
>> wYoYP9cEmuoJbr1FXnpVXRy3RJsS+Dv9IHyUt2l8WRddO5PeTC08fS3a1PsR6Lky
>> dnDBpOTsvBhdUPClA+9cu9HtNZ488PKALTgNX7kocVYm+vd0vkE54Iv0OWRvIMEA
>> 5nmm/r2MJwgQmTsFwAWojxfiSEJNzRSJ6GXZFbIfwGOaJIx7MmnPg4R3PKU1SZiF
>> ogKIwocfsTA/T7eplK58+EqtQnfTGTKzAbaEQvX/w1ryRRXHqD2zdk2p+zSAtpN6
>> swnhu156Bb9t2EUPTv9KiYth0BoYhYy9ppdp2Wyh0hX3lYCAP1SrwBVIYCqpvdqr
>> CuipFWmqbupW41IjQc6bjoIwaVlGNsqwDY3NNrjR+kb29k3+/3MT8QH1ZXLhlpTB
>> cUixluE62J8QllW4u3Wa2mLMTqdolcWCCTdh4yUqE+8jxguXUKhoTni1vwApmkru
>> PM158CLPdxWCnDe1TaGcRYcBoweWPl6UDaVj8W+LdSVcYsycZhwehvDg2amX6pdg
>> 9QFUf25PbDzEVw99w3f2hMhRG5pERRheLqPcFUVbnqZYkZBACt9XtIYBINlREoYW
>> ACjr9dJszluF9dEKWOmlKhsah3gAGJJoC5+QU8oR+vpxKdrI+8vQ+NYtVhCr0hVA
>> CO/KEEcwNaobsCWiAbSr
>> =3D5Op/
>> -----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
