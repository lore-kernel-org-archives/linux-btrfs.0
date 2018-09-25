Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbeIYOgZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 10:36:25 -0400
From: "sunny.s.zhang" <sunny.s.zhang@oracle.com>
Subject: Re: btrfs panic problem
To: Nikolay Borisov <nborisov@suse.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <2cce0d8b-0958-9fb9-bb88-09fbfbf94c9e@oracle.com>
 <pan$2c938$bb350250$d5f6ae11$13519ef4@cox.net>
 <8f6641aa-fc2e-a7b2-4dee-d69706ed8801@oracle.com>
 <d98035c5-77fa-6a1c-0c4c-a8df138c4aaf@suse.com>
Message-ID: <4eafd6dd-814e-49fc-07d8-45a3bf8e7680@oracle.com>
Date: Tue, 25 Sep 2018 16:29:35 +0800
MIME-Version: 1.0
In-Reply-To: <d98035c5-77fa-6a1c-0c4c-a8df138c4aaf@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2018年09月20日 00:12, Nikolay Borisov 写道:
> On 19.09.2018 02:53, sunny.s.zhang wrote:
>> Hi Duncan,
>>
>> Thank you for your advice. I understand what you mean.  But i have
>> reviewed the latest btrfs code, and i think the issue is exist still.
>>
>> At 71 line, if the function of btrfs_get_delayed_node run over this
>> line, then switch to other process, which run over the 1282 and release
>> the delayed node at the end.
>>
>> And then, switch back to the  btrfs_get_delayed_node. find that the node
>> is not null, and use it as normal. that mean we used a freed memory.
>>
>> at some time, this memory will be freed again.
>>
>> latest code as below.
>>
>> 1278 void btrfs_remove_delayed_node(struct btrfs_inode *inode)
>> 1279 {
>> 1280         struct btrfs_delayed_node *delayed_node;
>> 1281
>> 1282         delayed_node = READ_ONCE(inode->delayed_node);
>> 1283         if (!delayed_node)
>> 1284                 return;
>> 1285
>> 1286         inode->delayed_node = NULL;
>> 1287         btrfs_release_delayed_node(delayed_node);
>> 1288 }
>>
>>
>>    64 static struct btrfs_delayed_node *btrfs_get_delayed_node(
>>    65                 struct btrfs_inode *btrfs_inode)
>>    66 {
>>    67         struct btrfs_root *root = btrfs_inode->root;
>>    68         u64 ino = btrfs_ino(btrfs_inode);
>>    69         struct btrfs_delayed_node *node;
>>    70
>>    71         node = READ_ONCE(btrfs_inode->delayed_node);
>>    72         if (node) {
>>    73                 refcount_inc(&node->refs);
>>    74                 return node;
>>    75         }
>>    76
>>    77         spin_lock(&root->inode_lock);
>>    78         node = radix_tree_lookup(&root->delayed_nodes_tree, ino);
>>
>>
> You are analysis is correct, however it's missing one crucial point -
> btrfs_remove_delayed_node is called only from btrfs_evict_inode. And
> inodes are evicted when all other references have been dropped. Check
> the code in evict_inodes() - inodes are added to the dispose list when
> their i_count is 0 at which point there should be no references in this
> inode. This invalidates your analysis...
Thanks.
Yes, I know this.  and I know that other process can not use this inode 
if the inode is in the I_FREEING status.
But,  Chris has fixed a bug, which is similar with this and is found in 
production.  it mean that this will occur in some condition.

btrfs: fix refcount_t usage when deleting btrfs_delayed_nodes
https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dec35e48b286959991cdbb886f1bdeda4575c80b4&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=mcYQsljqnoxPHJVaWVFtwsEEDhXdP3ULRlrPW_9etWQ&m=O7fQASCATWfOIp82M24gmi314geaUJDU-9erYxJ2ZEs&s=QtIafUNfkdy5BqfRQLhoHLY6o-Vk8-ZB0sD28mM-o_s&e=

>> 在 2018年09月18日 13:05, Duncan 写道:
>>> sunny.s.zhang posted on Tue, 18 Sep 2018 08:28:14 +0800 as excerpted:
>>>
>>>> My OS(4.1.12) panic in kmem_cache_alloc, which is called by
>>>> btrfs_get_or_create_delayed_node.
>>>>
>>>> I found that the freelist of the slub is wrong.
>>> [Not a dev, just a btrfs list regular and user, myself.  But here's a
>>> general btrfs list recommendations reply...]
>>>
>>> You appear to mean kernel 4.1.12 -- confirmed by the version reported in
>>> the posted dump:  4.1.12-112.14.13.el6uek.x86_64
>>>
>>> OK, so from the perspective of this forward-development-focused list,
>>> kernel 4.1 is pretty ancient history, but you do have a number of
>>> options.
>>>
>>> First let's consider the general situation.  Most people choose an
>>> enterprise distro for supported stability, and that's certainly a valid
>>> thing to want.  However, btrfs, while now reaching early maturity for the
>>> basics (single device in single or dup mode, and multi-device in single/
>>> raid0/1/10 modes, note that raid56 mode is newer and less mature),
>>> remains under quite heavy development, and keeping reasonably current is
>>> recommended for that reason.
>>>
>>> So you you chose an enterprise distro presumably to lock in supported
>>> stability for several years, but you chose a filesystem, btrfs, that's
>>> still under heavy development, with reasonably current kernels and
>>> userspace recommended as tending to have the known bugs fixed.  There's a
>>> bit of a conflict there, and the /general/ recommendation would thus be
>>> to consider whether one or the other of those choices are inappropriate
>>> for your use-case, because it's really quite likely that if you really
>>> want the stability of an enterprise distro and kernel, that btrfs isn't
>>> as stable a filesystem as you're likely to want to match with it.
>>> Alternatively, if you want something newer to match the still under heavy
>>> development btrfs, you very likely want a distro that's not focused on
>>> years-old stability just for the sake of it.  One or the other is likely
>>> to be a poor match for your needs, and choosing something else that's a
>>> better match is likely to be a much better experience for you.
>>>
>>> But perhaps you do have reason to want to run the newer and not quite to
>>> traditional enterprise-distro level stability btrfs, on an otherwise
>>> older and very stable enterprise distro.  That's fine, provided you know
>>> what you're getting yourself into, and are prepared to deal with it.
>>>
>>> In that case, for best support from the list, we'd recommend running one
>>> of the latest two kernels in either the current or mainline LTS tracks.
>>>
>>> For current track, With 4.18 being the latest kernel, that'd be 4.18 or
>>> 4.17, as available on kernel.org (tho 4.17 is already EOL, no further
>>> releases, at 4.17.19).
>>>
>>> For mainline-LTS track, 4.14 and 4.9 are the latest two LTS series
>>> kernels, tho IIRC 4.19 is scheduled to be this year's LTS (or was it 4.18
>>> and it's just not out of normal stable range yet so not yet marked LTS?),
>>> so it'll be coming up soon and 4.9 will then be dropping to third LTS
>>> series and thus out of our best recommended range.  4.4 was the previous
>>> LTS and while still in LTS support, is outside the two newest LTS series
>>> that this list recommends.
>>>
>>> And of course 4.1 is older than 4.4, so as I said, in btrfs development
>>> terms, it's quite ancient indeed... quite out of practical support range
>>> here, tho of course we'll still try, but in many cases the first question
>>> when any problem's reported is going to be whether it's reproducible on
>>> something closer to current.
>>>
>>> But... you ARE on an enterprise kernel, likely on an enterprise distro,
>>> and very possibly actually paying /them/ for support.  So you're not
>>> without options if you prefer to stay with your supported enterprise
>>> kernel.  If you're paying them for support, you might as well use it, and
>>> of course of the very many fixes since 4.1, they know what they've
>>> backported and what they haven't, so they're far better placed to provide
>>> that support in any case.
>>>
>>> Or, given what you posted, you appear to be reasonably able to do at
>>> least limited kernel-dev-level analysis yourself.  Given that, you're
>>> already reasonably well placed to simply decide to stick with what you
>>> have and take the support you can get, diving into things yourself if
>>> necessary.
>>>
>>>
>>> So those are your kernel options.  What about userspace btrfs-progs?
>>>
>>> Generally speaking, while the filesystem's running, it's the kernel code
>>> doing most of the work.  If you have old userspace, it simply means you
>>> can't take advantage of some of the newer features as the old userspace
>>> doesn't know how to call for them.
>>>
>>> But the situation changes as soon as you have problems and can't mount,
>>> because it's userspace code that runs to try to fix that sort of problem,
>>> or failing that, it's userspace code that btrfs restore runs to try to
>>> grab what files can be grabbed off of the unmountable filesystem.
>>>
>>> So for routine operation, it's no big deal if userspace is a bit old, at
>>> least as long as it's new enough to have all the newer command formats,
>>> etc, that you need, and for comparing against others when posted.  But
>>> once things go bad on you, you really want the newest btrfs-progs in
>>> ordered to give you the best chance at either fixing things, or worst-
>>> case, at least retrieving the files off the dead filesystem.  So using
>>> the older distro btrfs-progs for routine running should be fine, but
>>> unless your backups are complete and frequent enough that if something
>>> goes wrong it's easiest to simply blow the bad version away with a fresh
>>> mkfs and start over, you'll probably want at least a reasonably current
>>> btrfs-progs on your rescue media at least.  Since the userspace version
>>> numbers are synced to the kernel cycle, a good rule of thumb is keep your
>>> btrfs-progs version to at least that of the oldest recommended LTS kernel
>>> version, as well, so you'd want at least btrfs-progs 4.9 on your rescue
>>> media, for now, and 4.14, coming up, since when the new kernel goes LTS
>>> that'll displace 4.9 and 4.14 will then be the second-back LTS.
>>>
