Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbaEWM4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 08:56:11 -0400
Message-ID: <537F4566.2000907@suse.com>
Date: Fri, 23 May 2014 08:56:06 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com> <537D5136.4050007@suse.com> <537DEB3F.5020303@fb.com> <537E1242.1010109@suse.com> <537E313E.8050906@fb.com> <20140523123849.GE5346@suse.cz>
In-Reply-To: <20140523123849.GE5346@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/23/14, 8:38 AM, David Sterba wrote:
> On Thu, May 22, 2014 at 01:17:50PM -0400, Chris Mason wrote:
>> On 05/22/2014 11:05 AM, Jeff Mahoney wrote:
>>> - gpg control packet On 5/22/14, 8:19 AM, Chris Mason wrote:
>>>> Can we safely reinit a kobject that has been put in use in
>>>> sysfs? Given all the things that can hold refs etc is this
>>>> legal?
>>> 
>>> It depends on how the kobject is being used.
>>> 
>>> It wouldn't be safe to re-use the kobject embedded in
>>> space_info since it controls the lifetime of the object,
>>> regardless of its use in sysfs.
>>> 
>>> The kobjects for block groups only exist for creating the 
>>> subdirectories and their lifetime is actually the lifetime of
>>> the space_info. We take a reference to the space_info when we
>>> add them to sysfs because that's where they draw their data.
>>> The only reference to a block group kobject is taken when we
>>> add it to sysfs and is dropped when we remove it. Holding a
>>> sysfs file open doesn't pin the kobject, so once we remove it
>>> from sysfs (kobject_del waits for readers to complete), it's
>>> safe to reinitialize it.
>>> 
>> 
>> Fair enough, once you've tested this new patch a bit I'll drop
>> mine for yours.
> 
> With a fixup in __link_block_group
> 
> -               kobject->name = get_raid_name(index); +
> kobj->name = get_raid_name(index);
> 
> it crashes right away, tests/btrfs/001, patch applied on top of
> 3.15-rc6, I haven't analyzed the cause yet.

Sigh. Yep. kobject_cleanup caches ->name before the release function
and ignores the cleared value. It seems the "free name if we alloced
it" comment in there was leftover from the middle of a patch series
Kay applied in late 2007. Commit 0f4dafc05 adds the comment while
adding a flag to indicate that kobject_set_name_vargs set the name.
The commit af5ca3f4e says kobject names must be dynamic but didn't
update the comment.

Ok, so we can't save the strdup.

- -Jeff


> [  520.880250] ------------[ cut here ]------------ [  520.884185]
> kernel BUG at mm/slub.c:3376! [  520.884185] invalid opcode: 0000
> [#1] SMP DEBUG_PAGEALLOC [  520.884185] Modules linked in:
> rpcsec_gss_krb5 dm_crypt loop btrfs [  520.884185] CPU: 1 PID: 3698
> Comm: umount Not tainted 3.15.0-rc6-default+ #144 [  520.884185]
> Hardware name: Intel Corporation Santa Rosa platform/Matanzas, BIOS
> TSRSCRB1.86C.0047.B00.0610170821 10/17/06 [  520.884185] task:
> ffff880075892370 ti: ffff88006e0ce000 task.ti: ffff88006e0ce000 [
> 520.884185] RIP: 0010:[<ffffffff8116efcf>]  [<ffffffff8116efcf>]
> kfree+0x1bf/0x1d0 [  520.884185] RSP: 0018:ffff88006e0cfcb8
> EFLAGS: 00010246 [  520.884185] RAX: 4000000000000000 RBX:
> ffffffffa00bb63e RCX: 0000000180190007 [  520.884185] RDX:
> 0000000000000000 RSI: ffffea0001d5ad40 RDI: ffffffffa00bb63e [
> 520.884185] RBP: ffff88006e0cfce8 R08: 0000000000000001 R09:
> 0000000000000000 [  520.884185] R10: 0000000000000000 R11:
> 0000000000000001 R12: ffffea0000802ec0 [  520.884185] R13:
> ffffffff813ba137 R14: ffffffffa00bb63e R15: 0000000000000003 [
> 520.884185] FS:  00007fba2c0cd7e0(0000) GS:ffff88007d400000(0000)
> knlGS:0000000000000000 [  520.884185] CS:  0010 DS: 0000 ES: 0000
> CR0: 000000008005003b [  520.884185] CR2: 00007fba2b759610 CR3:
> 00000000756a6000 CR4: 00000000000007e0 [  520.884185] Stack: [
> 520.884185]  ffff88007a849000 ffffffffa00cde20 ffff880075950be0
> ffff880075950ba8 [  520.884185]  ffffffffa00bb63e 0000000000000003
> ffff88006e0cfd18 ffffffff813ba137 [  520.884185]  ffff880075950ba8
> ffff880075950800 ffff8800755e5a58 0000000000000004 [  520.884185]
> Call Trace: [  520.884185]  [<ffffffff813ba137>]
> kobject_release+0xa7/0x1d0 [  520.884185]  [<ffffffff813ba291>]
> kobject_put+0x31/0x70 [  520.884185]  [<ffffffffa00223ca>]
> btrfs_free_block_groups+0x30a/0x420 [btrfs] [  520.884185]
> [<ffffffffa002f939>] close_ctree+0x149/0x2e0 [btrfs] [  520.884185]
> [<ffffffff8119560f>] ? dispose_list+0x4f/0x60 [  520.884185]
> [<ffffffff81196544>] ? evict_inodes+0x114/0x130 [  520.884185]
> [<ffffffffa00019b9>] btrfs_put_super+0x19/0x20 [btrfs] [
> 520.884185]  [<ffffffff8117c78e>]
> generic_shutdown_super+0x7e/0x110 [  520.884185]
> [<ffffffff8117c8b6>] kill_anon_super+0x16/0x30 [  520.884185]
> [<ffffffffa000289a>] btrfs_kill_super+0x1a/0xa0 [btrfs] [
> 520.884185]  [<ffffffff8117c94d>]
> deactivate_locked_super+0x4d/0x80 [  520.884185]
> [<ffffffff8117cf5a>] deactivate_super+0x4a/0x70 [  520.884185]
> [<ffffffff8119a341>] mntput_no_expire+0x111/0x180 [  520.884185]
> [<ffffffff8119a247>] ? mntput_no_expire+0x17/0x180 [  520.884185]
> [<ffffffff81190213>] ? dput+0x23/0x110 [  520.884185]
> [<ffffffff8119b8eb>] SyS_umount+0xcb/0x420 [  520.884185]
> [<ffffffff81a16092>] ? system_call_fastpath+0x16/0x1b [
> 520.884185]  [<ffffffff81a16092>] system_call_fastpath+0x16/0x1b [
> 520.884185] Code: c4 40 74 05 41 8b 74 24 68 4c 89 e7 e8 4b 25 fc
> ff e9 4f ff ff ff 49 8b 44 24 30 49 8b 14 24 80 e6 80 4c 0f 45 e0
> e9 ae fe ff ff <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> 55 48 89 e5 [  520.884185] RIP  [<ffffffff8116efcf>]
> kfree+0x1bf/0x1d0 [  520.884185]  RSP <ffff88006e0cfcb8> [
> 521.242658] ---[ end trace 4228a5dbb43499c0 ]---
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTf0VmAAoJEB57S2MheeWyzg4QAL8ZbJ4t9Pky0iE5p9odTbHe
RaZkS6ctraqHtHgmViqTxu78cnbRvxoQ6oOE9ZSCS9YczWkuABFk8EQ0AbTRnblo
wO6awRI0++rHmf1gA+soAtu6TfLOYR43SOFu2H9aMK/YLAGBzFnaLefeFfloj8gb
xVZnBlv3M4syKtcOmrxkCraxz9G9XakwFDI1AGtSTgxBU4tFIE0cyQOtQZf0sAlI
XqphtcoyWMa+T9GOLdFlUpV0p1OMArZhj+/tyMV7UotwHG5Y754kBU4Vd1wCiP/q
p/+lmnlMxVRdREHkGYZLpeG39bQQjMhp8qBgznPBln/R3IQq0nFJxrcPTO3ADH5T
LuLZwl63vW/uetWbVCvDLev27RXmg9aU1RtOGes0bK7HKDx+EymE5CpayADPnmlo
ZLcRol6wol8+R4BJQI9tKffy30PN7Uzhtt79X7EZiVHX5DMGH3aMnOwUihdlgvNd
YBgzwuXFjceoby7y+K1p7CpsDuh2VTBDnQ5e5SiJ3uyLpLeLwvctJ2BmVsEyS076
e4TLQRo+bW9M1y2Pn70B3tjKcQDPnufavk5bvsJqXqXLbpAp2xQDaN0RQrbnXeZG
PU8uknhLvOmdMdxw9wqVPOGpUOIZytDofAVK4QSXGzjCsMFnl3NLqj0tGgUh9DOU
mNH6TpALtxBaY1sJh8DN
=3sYp
-----END PGP SIGNATURE-----
