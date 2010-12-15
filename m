From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH
 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 15:13:04 +0800
Message-ID: <4D086A80.6020904@cn.fujitsu.com>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012141916.41682.kreijack@libero.it> <4D08370D.6020705@cn.fujitsu.com> <201012150753.37204.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012150753.37204.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> On Wednesday, 15 December, 2010, Li Zefan wrote:
>> h4) objectid asis, type asis, offset++ -> we should get the correct result.
> 
> This fix the problem of the "missing subvolume". But for the other case 
> (searching for more than one type) the problem still here.
> 

I don't think so. And the above "h4" has showed how we search for more
than one type.

The generic userland code for next search is:

/* this is in essence the same as how we advance key in kernel code */
if (sk->min_offset < (u64)-1 && sk->min_offset < sk->max_offset)
	sk->min_offset++;
else if (sk->min_type < (u8)-1 && sk->min_type < sk->max_type) {
	sk->min_offset = 0;
	sk->min_type++;
} else if (sk->min_objectid < (u64)-1 && sk->min_objectid < sk->max_objectid){
	sk->min_offset = 0;
	sk->min_type = 0;
	sk->min_objectid++;
} else
	break;

ioctl(...);

for (i = 0; i < nr_items; i++) {
	if (!filter(items[i]))
		continue;
	/* process this item */
	...
}

>> because the current ioctl uses min_{x,y,z} and max_{x,y,z} as start_key and
>> end_key, and it returns all keys that falls in [start_key, end_key].
>>
>> So this btrfs-progs patch should fix missing subvolumes in the output of
>> "subvolume list":
>>
>> diff --git a/btrfs-list.c b/btrfs-list.c
>> index 93766a8..1b9ea45 100644
>> --- a/btrfs-list.c
>> +++ b/btrfs-list.c
>> @@ -620,7 +620,10 @@ int list_subvols(int fd)
>>                 /* this iteration is done, step forward one root for the 
> next
>>                  * ioctl
>>                  */
>> -               if (sk->min_objectid < (u64)-1) {
>> +               if (sk->min_type < BTRFS_ROOT_BACKREF_KEY) {
>> +                       sk->min_type = BTRFS_ROOT_BACKREF_KEY;
>> +                       sk->min_offset = 0;
>> +               } else  if (sk->min_objectid < (u64)-1) {
>>                         sk->min_objectid++;
>>                         sk->min_type = BTRFS_ROOT_BACKREF_KEY;
>>                         sk->min_offset = 0;
>>
> 
> 
