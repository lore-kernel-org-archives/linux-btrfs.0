From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 19:48:44 +0100
Message-ID: <201012151948.44152.kreijack@libero.it>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012150753.37204.kreijack@libero.it> <4D086A80.6020904@cn.fujitsu.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D086A80.6020904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 15 December, 2010, Li Zefan wrote:
> Goffredo Baroncelli wrote:
> > On Wednesday, 15 December, 2010, Li Zefan wrote:
> >> h4) objectid asis, type asis, offset++ -> we should get the correct 
result.
> > 
> > This fix the problem of the "missing subvolume". But for the other case 
> > (searching for more than one type) the problem still here.
> > 
> 
> I don't think so. And the above "h4" has showed how we search for more
> than one type.
> 
> The generic userland code for next search is:
> 
> /* this is in essence the same as how we advance key in kernel code */
> if (sk->min_offset < (u64)-1 && sk->min_offset < sk->max_offset)
> 	sk->min_offset++;
> else if (sk->min_type < (u8)-1 && sk->min_type < sk->max_type) {
> 	sk->min_offset = 0;
> 	sk->min_type++;
> } else if (sk->min_objectid < (u64)-1 && sk->min_objectid < sk-
>max_objectid){
> 	sk->min_offset = 0;
> 	sk->min_type = 0;

Sorry but if you reset the sk->min_type to 0, this means that the min_type 
lost its purpose (act as lover bound of the acceptance criteria).

> 	sk->min_objectid++;
> } else
> 	break;
> 
> ioctl(...);
> 
> for (i = 0; i < nr_items; i++) {
> 	if (!filter(items[i]))
> 		continue;

So you are suggesting: "Move all tree items from kernel to user space and 
filter it in userspace ?". This mean a lot of un-needed kernel-space <-> 
userspace transition...

Sorry I don't understand if we are talking about a workaround or a solution.

> 	/* process this item */
> 	...
> }
> 
> >> because the current ioctl uses min_{x,y,z} and max_{x,y,z} as start_key 
and
> >> end_key, and it returns all keys that falls in [start_key, end_key].
> >>
> >> So this btrfs-progs patch should fix missing subvolumes in the output of
> >> "subvolume list":
> >>
> >> diff --git a/btrfs-list.c b/btrfs-list.c
> >> index 93766a8..1b9ea45 100644
> >> --- a/btrfs-list.c
> >> +++ b/btrfs-list.c
> >> @@ -620,7 +620,10 @@ int list_subvols(int fd)
> >>                 /* this iteration is done, step forward one root for the 
> > next
> >>                  * ioctl
> >>                  */
> >> -               if (sk->min_objectid < (u64)-1) {
> >> +               if (sk->min_type < BTRFS_ROOT_BACKREF_KEY) {
> >> +                       sk->min_type = BTRFS_ROOT_BACKREF_KEY;
> >> +                       sk->min_offset = 0;
> >> +               } else  if (sk->min_objectid < (u64)-1) {
> >>                         sk->min_objectid++;
> >>                         sk->min_type = BTRFS_ROOT_BACKREF_KEY;
> >>                         sk->min_offset = 0;
> >>
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
