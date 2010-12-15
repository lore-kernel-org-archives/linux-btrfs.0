From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 07:53:36 +0100
Message-ID: <201012150753.37204.kreijack@libero.it>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012141916.41682.kreijack@libero.it> <4D08370D.6020705@cn.fujitsu.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D08370D.6020705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 15 December, 2010, Li Zefan wrote:
> h4) objectid asis, type asis, offset++ -> we should get the correct result.

This fix the problem of the "missing subvolume". But for the other case 
(searching for more than one type) the problem still here.

> because the current ioctl uses min_{x,y,z} and max_{x,y,z} as start_key and
> end_key, and it returns all keys that falls in [start_key, end_key].
> 
> So this btrfs-progs patch should fix missing subvolumes in the output of
> "subvolume list":
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 93766a8..1b9ea45 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -620,7 +620,10 @@ int list_subvols(int fd)
>                 /* this iteration is done, step forward one root for the 
next
>                  * ioctl
>                  */
> -               if (sk->min_objectid < (u64)-1) {
> +               if (sk->min_type < BTRFS_ROOT_BACKREF_KEY) {
> +                       sk->min_type = BTRFS_ROOT_BACKREF_KEY;
> +                       sk->min_offset = 0;
> +               } else  if (sk->min_objectid < (u64)-1) {
>                         sk->min_objectid++;
>                         sk->min_type = BTRFS_ROOT_BACKREF_KEY;
>                         sk->min_offset = 0;
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
