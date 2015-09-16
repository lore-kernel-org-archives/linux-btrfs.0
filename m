Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:32931 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752536AbbIPK2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 06:28:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 16 Sep 2015 12:28:14 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
Message-ID: <f81878fadaf2980a72522e54010e0415@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-16 07:02, Duncan a écrit :
> Stéphane Lesimple posted on Tue, 15 Sep 2015 23:47:01 +0200 as 
> excerpted:
> 
>> Le 2015-09-15 16:56, Josef Bacik a écrit :
>>> On 09/15/2015 10:47 AM, Stéphane Lesimple wrote:
>>>>> I've been experiencing repetitive "kernel BUG" occurences in the 
>>>>> past
>>>>> few days trying to balance a raid5 filesystem after adding a new
>>>>> drive.
>>>>> It occurs on both 4.2.0 and 4.1.7, using 4.2 userspace tools.
>>>> 
>>>> I've ran a scrub on this filesystem after the crash happened twice,
>>>> and if found no errors.
>>>> 
>>>> The BUG_ON() condition that my filesystem triggers is the following 
>>>> :
>>>> 
>>>> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
>>>> // in insert_inline_extent_backref() of extent-tree.c.
>>>> 
>>> Does btrfsck complain at all?
> 
> Just to elucidate a bit...
> [...]
> Which is where btrfs check comes in and why JB asked you to run it, 
> since
> unlike scrub, check is designed to catch filesystem logic errors.

Thanks for your clarification Duncan, that perfectly makes sense.

>> You're right, even if btrfs scrub didn't complain, btrfsck does :
>> 
>> checking extents
>> bad metadata [4179166806016, 4179166822400) crossing stripe boundary
>> bad metadata [4179166871552, 4179166887936) crossing stripe boundary
>> bad metadata [4179166937088, 4179166953472) crossing stripe boundary
> 
> This is an actively in-focus bug ATM, and while I'm not a dev and can't
> tell you for sure that it's behind the specific balance-related crash 
> and
> traces you posted (tho I believe it so), it certainly has the potential
> to be that serious, yes.
> 
> The most common cause is a buggy btrfs-convert that was creating 
> invalid
> btrfs when converting from ext* at one point.  AFAIK they've hotfixed 
> the
> immediate convert issue, but are still actively working on a longer 
> term
> proper fix.  Meanwhile, while btrfs check does now detect the issue 
> (and
> even that is quite new code, added in 4.2 I believe), there's still no
> real fix for what was after all a defective btrfs from the moment the
> convert was done.
> [...]
> If, however, you created the filesystem using mkfs.btrfs, then the
> problem must have occurred some other way.  Whether there's some other
> cause beyond the known cause, a buggy btrfs-convert, has in fact been 
> in
> question, so in this case the devs are likely to be quite interested
> indeed in your case and perhaps the filesystem history that brought you
> to this point.  The ultimate fix is likely to be the same (unless the
> devs have you test new fix code for btrfs check --repair), but I'd
> strongly urge you to delay blowing away the filesystem, if possible,
> until the devs have a chance to ask you to run other diagnostics and
> perhaps even get a btrfs-image for them, since you may well have
> accidentally found a corner-case they'll have trouble reproducing,
> without your information.

Nice to know that this bug was already somewhat known, but I can confirm 
that it actually doesn't come from an ext4 conversion on my case.

Here is the filesystem history, which is actually quite short :
- FS created from scratch, no convert, on 2x4T devices using mkfs.btrfs 
with raid1 metadata, raid5 data. This is using the 4.2 tools and kernel 
3.19, so a couple incompat features were turned on by default (such as 
skinny metadata).
- Approx. 4T worth of files copied to it, a bit less, I had around 30G 
free after the copy.
- Upgraded to kernel 4.2.0
- Added a third 4T device to the filesystem
- Ran a balance to get an even repartition of data/metadata among the 3 
drives
- Kernel BUG after a couple hours. The btrfs balance userspace tool 
segfaulted at the same time. Due to apport default configuration (damn 
you, Ubuntu !), core file was discarded, but I don't think the segfault 
is really interesting. The kernel trace is.

This was all done within ~1 week.

I've just created an image of the metadata, using btrfs-image -s. The 
image is 2.9G large, I can drop it somewhere in case a dev would like to 
have a look at it.

For what it's worth, I've been hitting another kernel BUG, almost 
certainly related, while trying to dev del the 3rd device, after 8 hours 
of work (kernel 4.1.7) :

kernel BUG at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:2248!
in __btrfs_run_delayed_refs+0x11a1/0x1230 [btrfs]

Trace:
[<ffffffff813d9a65>] ? __percpu_counter_add+0x55/0x70
[<ffffffffc02ea483>] btrfs_run_delayed_refs.part.66+0x73/0x270 [btrfs]
[<ffffffffc02ea697>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
[<ffffffffc02fb169>] btrfs_should_end_transaction+0x49/0x60 [btrfs]
[<ffffffffc02e8aa2>] btrfs_drop_snapshot+0x472/0x880 [btrfs]
[<ffffffffc034ab00>] ? should_ignore_root.part.15+0x50/0x50 [btrfs]
[<ffffffffc034fd49>] merge_reloc_roots+0xd9/0x240 [btrfs]
[<ffffffffc0350119>] relocate_block_group+0x269/0x670 [btrfs]
[<ffffffffc03506f6>] btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
[<ffffffffc0323cbe>] btrfs_relocate_chunk.isra.38+0x3e/0xc0 [btrfs]
[<ffffffffc0324944>] btrfs_shrink_device+0x1d4/0x450 [btrfs]
[<ffffffffc0328d43>] btrfs_rm_device+0x323/0x810 [btrfs]
[<ffffffffc0334ee6>] btrfs_ioctl+0x1e86/0x2b30 [btrfs]
[<ffffffff81183544>] ? filemap_map_pages+0x1d4/0x230
[<ffffffff811b29f5>] ? handle_mm_fault+0xd95/0x17e0
[<ffffffff81115112>] ? from_kgid_munged+0x12/0x20
[<ffffffff811fe710>] ? cp_new_stat+0x140/0x160
[<ffffffff8120ce68>] do_vfs_ioctl+0x2f8/0x510
[<ffffffff81066f76>] ? __do_page_fault+0x1b6/0x450
[<ffffffff811fe75f>] ? SYSC_newstat+0x2f/0x40
[<ffffffff8120d101>] SyS_ioctl+0x81/0xa0
[<ffffffff81067240>] ? do_page_fault+0x30/0x80
[<ffffffff817d8ab2>] system_call_fastpath+0x16/0x75


If JB or any other btrfs dev wants me to try anything at this filesystem 
before I recreate it from scratch, such as a kernel patch or userland 
tool patch, or run a more verbose debug balance, I would be happy to do 
so.
If this is the case, please tell me, so I can keep the filesystem as it 
is. On the other hand if you're sure the btrfs-image is enough, please 
tell me too, so I can go forward and fix my system :)

Thanks,

-- 
Stéphane.

