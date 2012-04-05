From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [PATCH] Btrfs: remove BUG_ON from get_restripe_target
Date: Wed, 04 Apr 2012 20:46:13 -0400
Message-ID: <4F7CEB55.3090307@suse.de>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <ak@linux.intel.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Bobby Powers <bobbypowers@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/04/2012 04:19 PM, Bobby Powers wrote:
> spin_is_locked always returns 0 on non-SMP systems, which causes 
> btrfs to fail the mount.  There is documentation pending as to why 
> checking for spin_is_locked is a bad idea:
> 
> https://lkml.org/lkml/2012/3/27/413
> 
> As this was the only location in fs/btrfs/extent-tree.c that did 
> lock-correctness checking in a BUG_ON, simply remove it.
> 
> Signed-off-by: Bobby Powers <bobbypowers@gmail.com> CC: Ilya 
> Dryomov <idryomov@gmail.com> CC: Chris Mason 
> <chris.mason@oracle.com> CC: Andi Kleen <ak@linux.intel.com> CC: 
> linux-btrfs@vger.kernel.org CC: linux-kernel@vger.kernel.org --- 
> fs/btrfs/extent-tree.c |    3 --- 1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index 
> a844204..c98b073 100644 --- a/fs/btrfs/extent-tree.c +++ 
> b/fs/btrfs/extent-tree.c @@ -3158,9 +3158,6 @@ static u64 
> get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags) 
> struct btrfs_balance_control *bctl = fs_info->balance_ctl; u64 
> target = 0;
> 
> -	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) && - 
> !spin_is_locked(&fs_info->balance_lock)); - if (!bctl) return 0;
> 

Why not replace both of these with lockdep_assert_held as Andi
suggested in his doc?

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPfOtVAAoJEB57S2MheeWyew4P/ju2FiKPWvFEhShP2BQzmPPL
wYoYP9cEmuoJbr1FXnpVXRy3RJsS+Dv9IHyUt2l8WRddO5PeTC08fS3a1PsR6Lky
dnDBpOTsvBhdUPClA+9cu9HtNZ488PKALTgNX7kocVYm+vd0vkE54Iv0OWRvIMEA
5nmm/r2MJwgQmTsFwAWojxfiSEJNzRSJ6GXZFbIfwGOaJIx7MmnPg4R3PKU1SZiF
ogKIwocfsTA/T7eplK58+EqtQnfTGTKzAbaEQvX/w1ryRRXHqD2zdk2p+zSAtpN6
swnhu156Bb9t2EUPTv9KiYth0BoYhYy9ppdp2Wyh0hX3lYCAP1SrwBVIYCqpvdqr
CuipFWmqbupW41IjQc6bjoIwaVlGNsqwDY3NNrjR+kb29k3+/3MT8QH1ZXLhlpTB
cUixluE62J8QllW4u3Wa2mLMTqdolcWCCTdh4yUqE+8jxguXUKhoTni1vwApmkru
PM158CLPdxWCnDe1TaGcRYcBoweWPl6UDaVj8W+LdSVcYsycZhwehvDg2amX6pdg
9QFUf25PbDzEVw99w3f2hMhRG5pERRheLqPcFUVbnqZYkZBACt9XtIYBINlREoYW
ACjr9dJszluF9dEKWOmlKhsah3gAGJJoC5+QU8oR+vpxKdrI+8vQ+NYtVhCr0hVA
CO/KEEcwNaobsCWiAbSr
=5Op/
-----END PGP SIGNATURE-----
