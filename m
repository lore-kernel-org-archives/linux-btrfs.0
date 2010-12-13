From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Mon, 13 Dec 2010 19:13:01 +0100
Message-ID: <201012131913.02276.kreijack@libero.it>
References: <4D05EBC9.6020908@cn.fujitsu.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05EBC9.6020908@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Li,

On Monday, 13 December, 2010, Li Zefan wrote:
> The keys returned by tree search ioctl should be restricted to:
> 
> 	key.objectid = [min_objectid, max_objectid] &&
> 	key.offset   = [min_offset, max_offset] &&
> 	key.type     = [min_type, max_type]
> 
> But actually it returns those keys:
> 
> 	[(min_objectid, min_type, min_offset),
> 		(max_objectid, max_type, max_offset)].
> 

I have to admit that I had need several minutes to understand what you wrote 
:). Then I came to conclusion that the tree search ioctl is basically wrong.

IMHO, the error in this API is to use the lower bound of the acceptance 
criteria (the min_objectid, min_offset, min_type fields) also as starting 
point for the search.

Let me explain with an example.

Suppose to want to search all the keys in the range

 	key.objectid = 10..20
 	key.offset   = 100..200
 	key.type     = 2..5


Suppose to set sk->nr_items to 1 for simplicity, and the keys available which 
fit in the range are

1)	[15,150,3]
2)	[16,160,4]
3)	[17,180,3]

All these key satisfy the "acceptance criteria", but because we have to 
restart the search from the last key found, the code should resemble

	sk = &args.key

	sk->min_objectid=10; sk->max_objectid=20
	sk->min_offset=100; sk->max_offset=200
	sk->min_type=2; sk->max_type=5
	sk->nr_items = 1;

	while(1){
		ioctl(fd,  BTRFS_IOC_TREE_SEARCH, &args);
		if( !sk->nr_items )
			break

		for(off = 0, i=0 ; i < sk->nr_items ; i   ){
			sh = (struct btrfs_ioctl_search_header *)(args.buf  
                                                                 off);

			[...]
	                sk->min_objectid = sh->objectid;
        	        sk->min_offset = sh->offset;
	                sk->min_type = sh->type;
		}

		<increase the sk->min_* key of 1>
				
	}

But in this case, the code after found the key #2, sets the minimum acceptance 
criteria to [16,160,4], which exclude the key #3 because min_type is too high.

Ideally, we should add three new field to the search key structure:

	sk->start_objectid
	sk->start_offset
	sk->start_type

And after every iteration the code (even the kernel code) should set these 
fields as "last key found  1", leaving the min_* fields as they are.

My analysis is correct or I miss  something ?

Regards
G.Baroncelli

> And the bug can result in missing subvolumes in the output of
> "btrfs subvolume list"
> 
> Reported-by: Ian! D. Allen <idallen@idallen.ca>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |   20 ++++----------------
>  1 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f1c9bb4..785f713 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1028,23 +1028,11 @@ out:
>  static noinline int key_in_sk(struct btrfs_key *key,
>  			      struct btrfs_ioctl_search_key *sk)
>  {
> -	struct btrfs_key test;
> -	int ret;
> -
> -	test.objectid = sk->min_objectid;
> -	test.type = sk->min_type;
> -	test.offset = sk->min_offset;
> -
> -	ret = btrfs_comp_cpu_keys(key, &test);
> -	if (ret < 0)
> +	if (key->type < sk->min_type || key->type > sk->max_type)
>  		return 0;
> -
> -	test.objectid = sk->max_objectid;
> -	test.type = sk->max_type;
> -	test.offset = sk->max_offset;
> -
> -	ret = btrfs_comp_cpu_keys(key, &test);
> -	if (ret > 0)
> +	if (key->offset < sk->min_offset || key->offset > sk->max_offset)
> +		return 0;
> +	if (key->objectid < sk->min_objectid || key->objectid > sk-
>max_objectid)
>  		return 0;
>  	return 1;
>  }
> -- 
> 1.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
