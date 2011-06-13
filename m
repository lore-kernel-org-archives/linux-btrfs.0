From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: bug caused by removal of trans_mutex? (Was: Re: kernel BUG at fs/btrfs/extent-tree.c:6164!)
Date: Mon, 13 Jun 2011 15:49:10 +0800
Message-ID: <BANLkTi=UE+6uAq+wtvqRNwbZ1Lft4u2iOg@mail.gmail.com>
References: <4DEC90CB.4050609@jp.fujitsu.com>
	<4DEDB7AF.2060308@cn.fujitsu.com>
	<4DEDBE4B.2020403@jp.fujitsu.com>
	<4DEDC293.30105@jp.fujitsu.com>
	<4DEDE03B.9050907@jp.fujitsu.com>
	<4DEDE328.5060405@cn.fujitsu.com>
	<1307461229-sup-9822@shiny>
	<4DEF04CF.8010502@jp.fujitsu.com>
	<4DF5B889.5080202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF5B889.5080202@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add a mutex to btrfs_init_reloc_root() to prevent the reloc tree
creation from concurrent execution.

On Mon, Jun 13, 2011 at 3:13 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Cc: Josef
>
>>>>>>>>> I encountered following panic using 'btrfs-unstable + for-lin=
us'
>>>>>>>>> kernel.
>>>>>>>>>
>>>>>>>>> I ran "btrfs fi bal /test5" command, and mount option of /tes=
t5
>>>>>>>>> is as follows:
>>>>>>>>>
>>>>>>>>> =A0/dev/sdc3 on /test5 type btrfs (rw,space_cache,compress=3D=
lzo,inode_cache)
>>>>>>>>>
>>>>>>>> So, just a "btrfs fi bal" would lead to the bug?
>>>>>>> I think so.
>>>
>>> It should be specific to the inode caching code. =A0The balancing c=
ode is
>>> finding the inode map cache extents, but it doesn't know how to rel=
ocate
>>> them.
>>
>> However, the panic has occurred even if inode_cahce is turned off.
>> Is this another problem?
>>
>
> I don't think free inode cache isthe cause of the bug here (even if i=
node_cache
> is turned on).
>
> What I have found out is:
>
> 1. git checkout a4abeea41adfa3c143c289045f4625dfaeba2212
>
> So the top commit is the removal of trans_mutex and no delayed_inode =
patch
> or free inode cache patchset in the tree, and bug can be triggered.
>
> 2. git checkout 2a1eb4614d984d5cd4c928784e9afcf5c07f93be
>
> So the top commit is the one before trans_mutex removal, and no bug t=
riggered.
>
> 3. test linus' tree
>
> bug triggered.
>
> 4. revert that suspicoius commit manually from linus' tree
>
> no bug.
>
> so either that commit is buggy or it reveals some bugs covered by the=
 trans_mutex.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
