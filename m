From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v8 1/8] btrfs: added helper functions to iterate backrefs
Date: Mon, 07 Nov 2011 17:46:49 +0100
Message-ID: <4EB80B79.3020400@gmx.net>
References: <cover.1311778307.git.list.btrfs@jan-o-sch.net> <915659509a8ca58ec0bbf89001bac5afd4fa81b4.1311778307.git.list.btrfs@jan-o-sch.net> <4EB1F13C.3070801@cn.fujitsu.com> <4EB26DC3.5080409@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB26DC3.5080409@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 03.11.2011 11:32, Jan Schmidt wrote:
> On 03.11.2011 02:41, Li Zefan wrote:
>> (as this is going to be merged into mainline..)
>>
>>> +/*
>>> + * calls iterate() for every inode that references the extent identified by
>>> + * the given parameters. will use the path given as a parameter and return it
>>> + * released.
>>> + * when the iterator function returns a non-zero value, iteration stops.
>>> + */
>>> +int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>>> +				struct btrfs_path *path,
>>> +				u64 extent_item_objectid,
>>> +				u64 extent_offset,
>>> +				iterate_extent_inodes_t *iterate, void *ctx)
>>
>> While trying to use this API, I found there's a big defect in this function.
>>
>>    fs_tree 1       fs_tree 2
>>        \              /
>>         \            /
>>          \          /
>>           \        /
>>              node
>>               |
>>               |
>>              leaf  (EXTENT_DATA item)
>>
>> In the above case, the function will find only 1 reference.
> 
> Hum. You are right.
> 
> I'm convinced that I've been at this point months ago, only I cannot
> find code dealing with counts > 1 on nodes. I'll look for a fix in my
> branches or make a new one.
> 
> Currently, this is more of a best-effort resolver. Support for delayed
> extents is missing, it should be used on commit roots to get a
> consistent state.
> 

The qgroups patch contains an implementation to find all roots for a
given extent. A quite extensive part of qgroups is needed for that, so
it might be easiest to build a new version on top of qgroups.
Otherwise I could split qgroups in 2 parts to factor out that half.

-Arne
