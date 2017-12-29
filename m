Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:56852 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdL2TPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 14:15:04 -0500
Date: Fri, 29 Dec 2017 22:14:28 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: enchanse raid1/10 balance heuristic
Message-ID: <20171229221429.30053615@demfloro.ru>
In-Reply-To: <20171229214159.33932054@demfloro.ru>
References: <20171229020914.3618-1-nefelim4ag@gmail.com>
        <20171229214159.33932054@demfloro.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Dec 2017 21:44:19 +0300
Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:
> > +/**
> > + * guess_optimal - return guessed optimal mirror
> > + *
> > + * Optimal expected to be pid % num_stripes
> > + *
> > + * That's generaly ok for spread load
> > + * Add some balancer based on queue leght to device
> > + *
> > + * Basic ideas:
> > + *  - Sequential read generate low amount of request
> > + *    so if load of drives are equal, use pid % num_stripes
> > balancing
> > + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as
> > optimal
> > + *    and repick if other dev have "significant" less queue lenght
> > + *  - Repick optimal if queue leght of other mirror are less
> > + */
> > +static int guess_optimal(struct map_lookup *map, int optimal)
> > +{
> > +	int i;
> > +	int round_down = 8;
> > +	int num = map->num_stripes;  
> 
> num has to be initialized from map->sub_stripes if we're reading
> RAID10, otherwise there will be NULL pointer dereference
> 

Check can be like:
if (map->type & BTRFS_BLOCK_GROUP_RAID10)
	num = map->sub_stripes;

>@@ -5804,10 +5914,12 @@ static int __btrfs_map_block(struct
>btrfs_fs_info *fs_info,
> 			stripe_index += mirror_num - 1;
> 		else {
> 			int old_stripe_index = stripe_index;
>+			optimal = guess_optimal(map,
>+					current->pid %
>map->num_stripes);
> 			stripe_index = find_live_mirror(fs_info, map,
> 					      stripe_index,
> 					      map->sub_stripes,
> stripe_index +
>-					      current->pid %
>map->sub_stripes,
>+					      optimal,
> 					      dev_replace_is_ongoing);
> 			mirror_num = stripe_index - old_stripe_index
> + 1; }
>-- 
>2.15.1

Also here calculation should be with map->sub_stripes too.
