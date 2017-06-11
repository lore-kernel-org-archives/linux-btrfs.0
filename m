Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34343 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdFKKFg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Jun 2017 06:05:36 -0400
Received: by mail-wr0-f193.google.com with SMTP id u101so15801948wrc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Jun 2017 03:05:35 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com>
Date: Sun, 11 Jun 2017 12:05:31 +0200
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <6BE7B702-122D-406B-B8D5-9DFAB78BA587@dominion.thruhere.net>
References: <oherub$g5a$1@blaine.gmane.org>
 <20170609195718.GC30723@carfax.org.uk>
 <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Op 11 jun. 2017, om 06:20 heeft Chris Murphy <lists@colorremedies.com> het volgende geschreven:
> 
> On Fri, Jun 9, 2017 at 1:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Jun 09, 2017 at 09:12:16PM +0200, Koen Kooi wrote:
>>> Hi,
>>> 
>>> Today the kernel got wedged during shutdown (4.11.x tends to do that, haven't
>>> debugged) and I pressed the reset button. The next boot btrfs won't mount:
>>> 
>>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
>>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): parent transid verify failed on 5840011722752 wanted 170755 found 170832
>>> [Fri Jun  9 20:46:07 2017] BTRFS error (device md0): failed to read block groups: -5
>>> [Fri Jun  9 20:46:08 2017] BTRFS error (device md0): open_ctree failed
>> 
>>   With a transid failure on mount, about the only thing that's likely
>> to work is mounting with -o usebackuproot. If that doesn't work, then
>> a rebuild of the FS is almost certainly needed.
> 
> Weird that it wants almost 80 generations back from what's found.
> Sounds like betrayal somewhere…

The issue I have with 4.11.x is that after a few days “kworker” starts to take 100% cpu which only a reboot will fix. I’m not sure what caused this btrfs corruption, since multiple things changed: 

1) kernel 4.10.x -> 4.11.x
2) A journal was added to /dev/md0
3) Force blk-mq mode

4.12rc would hard lock, but rc4 looks a lot better, it’s still up after 2 days, but then again, /dev/md0 hasn’t been used :)

I now fully understand what “RAID is not a backup” is all about :/

> I'd say take a btrfs-image and put it up somewhere and also file a
> bug. The fsck should not crash.

I’ll create a bugzilla account and file a bug for that.

> 
> What are these showing?

Output attached inline, see below.

> # btrfs insp dump-s -f /dev/

superblock: bytenr=65536, device=/dev/md0
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0x0fb18762 [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			e00f9fd0-8b57-43c1-8d8b-1c27a40aef28
label			
generation		170816
root			4355118137344
sys_array_size		129
chunk_root_generation	170426
root_level		1
chunk_root		29519205384192
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		20003257057280
bytes_used		14730770751488
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x3
			( FREE_SPACE_TREE |
			  FREE_SPACE_TREE_VALID )
incompat_flags		0x169
			( MIXED_BACKREF |
			  COMPRESS_LZO |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
cache_generation	74920
uuid_tree_generation	170816
dev_item.uuid		acbd8ddf-5bf8-4b08-9cdd-a750c2cb7bc6
dev_item.fsid		e00f9fd0-8b57-43c1-8d8b-1c27a40aef28 [match]
dev_item.type		0
dev_item.total_bytes	20003257057280
dev_item.bytes_used	14871399759872
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
sys_chunk_array[2048]:
	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 29519205367808)
		length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 1
			stripe 0 devid 1 offset 288874299392
			dev_uuid acbd8ddf-5bf8-4b08-9cdd-a750c2cb7bc6
			stripe 1 devid 1 offset 288907853824
			dev_uuid acbd8ddf-5bf8-4b08-9cdd-a750c2cb7bc6
backup_roots[4]:
	backup 0:
		backup_tree_root:	4354691088384	gen: 170813	level: 1
		backup_chunk_root:	29519205384192	gen: 170426	level: 1
		backup_extent_root:	4354711486464	gen: 170814	level: 2
		backup_fs_root:		1667614900224	gen: 110362	level: 0
		backup_dev_root:	2324468563968	gen: 170426	level: 1
		backup_csum_root:	3920799973376	gen: 170813	level: 3
		backup_total_bytes:	20003257057280
		backup_bytes_used:	14730770980864
		backup_num_devices:	1

	backup 1:
		backup_tree_root:	4354823323648	gen: 170814	level: 1
		backup_chunk_root:	29519205384192	gen: 170426	level: 1
		backup_extent_root:	4354840641536	gen: 170815	level: 2
		backup_fs_root:		1667614900224	gen: 110362	level: 0
		backup_dev_root:	2324468563968	gen: 170426	level: 1
		backup_csum_root:	4354717155328	gen: 170814	level: 3
		backup_total_bytes:	20003257057280
		backup_bytes_used:	14730770448384
		backup_num_devices:	1

	backup 2:
		backup_tree_root:	4354996797440	gen: 170815	level: 1
		backup_chunk_root:	29519205384192	gen: 170426	level: 1
		backup_extent_root:	4354840641536	gen: 170815	level: 2
		backup_fs_root:		1667614900224	gen: 110362	level: 0
		backup_dev_root:	2324468563968	gen: 170426	level: 1
		backup_csum_root:	4354796797952	gen: 170815	level: 3
		backup_total_bytes:	20003257057280
		backup_bytes_used:	14730771238912
		backup_num_devices:	1

	backup 3:
		backup_tree_root:	4355118137344	gen: 170816	level: 1
		backup_chunk_root:	29519205384192	gen: 170426	level: 1
		backup_extent_root:	4355008118784	gen: 170816	level: 2
		backup_fs_root:		1667614900224	gen: 110362	level: 0
		backup_dev_root:	2324468563968	gen: 170426	level: 1
		backup_csum_root:	4355016966144	gen: 170816	level: 3
		backup_total_bytes:	20003257057280
		backup_bytes_used:	14730770751488
		backup_num_devices:	1


> # btrfs rescue super /dev/

All supers are valid, no need to recover


> # btrfs-find-root /dev/

parent transid verify failed on 5840011722752 wanted 170755 found 170832
parent transid verify failed on 5840011722752 wanted 170755 found 170832
parent transid verify failed on 5840011722752 wanted 170755 found 170832
parent transid verify failed on 5840011722752 wanted 170755 found 170832
Ignoring transid failure
leaf parent key incorrect 5840011722752
Superblock thinks the generation is 170816
Superblock thinks the level is 1
Found tree root at 4355118137344 gen 170816 level 1
Well block 4354996797440(gen: 170815 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4354823323648(gen: 170814 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4354691088384(gen: 170813 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920776822784(gen: 170812 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920648683520(gen: 170811 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920519102464(gen: 170810 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920409886720(gen: 170809 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920512614400(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920511877120(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920497213440(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920497180672(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920483827712(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920483549184(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920480845824(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920477782016(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920474439680(gen: 170808 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632324214784(gen: 170807 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632175087616(gen: 170806 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632058548224(gen: 170805 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3402176970752(gen: 170804 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3402008510464(gen: 170803 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3401865854976(gen: 170802 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3401679929344(gen: 170801 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2987096358912(gen: 170800 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986964189184(gen: 170799 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986906697728(gen: 170798 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986818224128(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986818174976(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986817961984(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986817617920(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986817126400(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986816045056(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986815602688(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986814570496(gen: 170797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986728783872(gen: 170796 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765384974336(gen: 170795 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765262077952(gen: 170794 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765159809024(gen: 170793 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765042728960(gen: 170792 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765193871360(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765182697472(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765159661568(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765158744064(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765153009664(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765150879744(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765149847552(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765147389952(gen: 170791 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324589068288(gen: 170790 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324445954048(gen: 170789 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324315488256(gen: 170788 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324254621696(gen: 170787 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324156514304(gen: 170786 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2192021258240(gen: 170785 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191862366208(gen: 170784 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191789588480(gen: 170783 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191678226432(gen: 170782 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191680700416(gen: 170781 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2026102620160(gen: 170780 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025933881344(gen: 170779 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025814949888(gen: 170778 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025660760064(gen: 170777 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1668038115328(gen: 170776 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667950346240(gen: 170775 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667747971072(gen: 170774 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667703422976(gen: 170773 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667565420544(gen: 170772 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1508284694528(gen: 170771 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1308069642240(gen: 170770 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1126971392000(gen: 170769 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821708357632(gen: 170768 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 275006996480(gen: 170767 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229345869824(gen: 170766 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 796049408(gen: 170765 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765287948288(gen: 170750 level: 1) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 128040960(gen: 170742 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2026116218880(gen: 170708 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324180336640(gen: 170683 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 311267000320(gen: 170679 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229606326272(gen: 170678 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229600624640(gen: 170678 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920753180672(gen: 170665 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986824318976(gen: 170663 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324340162560(gen: 170662 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 310997417984(gen: 170635 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 274972278784(gen: 170634 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632131407872(gen: 170576 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324638646272(gen: 170567 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324630601728(gen: 170567 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324501069824(gen: 170566 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324500185088(gen: 170566 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324498776064(gen: 170566 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324483391488(gen: 170566 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324476919808(gen: 170566 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324476411904(gen: 170566 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324284768256(gen: 170565 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191856779264(gen: 170562 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2026012000256(gen: 170559 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025652240384(gen: 170557 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025646227456(gen: 170557 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667756310528(gen: 170555 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667766910976(gen: 170554 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1508429234176(gen: 170553 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1508192452608(gen: 170552 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1307887976448(gen: 170550 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821883437056(gen: 170547 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229776621568(gen: 170539 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229607653376(gen: 170538 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1018658816(gen: 170535 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 749125632(gen: 170534 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 242810880(gen: 170533 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 241991680(gen: 170533 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920460431360(gen: 170469 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632451862528(gen: 170468 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3401807314944(gen: 170466 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191681552384(gen: 170463 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025893642240(gen: 170462 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632219373568(gen: 170430 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324431192064(gen: 170427 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324525285376(gen: 170426 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025644965888(gen: 170418 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667763372032(gen: 170414 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1127139622912(gen: 170407 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 428294144(gen: 170384 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 237649920(gen: 170383 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4354691219456(gen: 170312 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2987031625728(gen: 170302 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2987031085056(gen: 170302 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986792615936(gen: 170300 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986792321024(gen: 170300 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765067714560(gen: 170296 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191595847680(gen: 170289 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4354990538752(gen: 170207 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632206430208(gen: 170199 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986842931200(gen: 170193 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1307870199808(gen: 170169 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920401514496(gen: 170063 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765439221760(gen: 170053 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765270663168(gen: 170052 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2192018800640(gen: 170045 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632501899264(gen: 169967 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3401944252416(gen: 169966 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821680259072(gen: 169956 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632042934272(gen: 169932 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3401725231104(gen: 169930 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986981359616(gen: 169929 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191786033152(gen: 169924 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324221837312(gen: 169801 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191671984128(gen: 169798 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191537160192(gen: 169797 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1668009689088(gen: 169793 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324434321408(gen: 169728 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191589457920(gen: 169061 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2191587786752(gen: 169061 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632090152960(gen: 168819 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2025661218816(gen: 168814 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1307916861440(gen: 168812 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229558452224(gen: 168402 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 148536950784(gen: 168401 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632381444096(gen: 168367 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324218937344(gen: 168028 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920711663616(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920710025216(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920709337088(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920707993600(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920704045056(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920700702720(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920699490304(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920696066048(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920694362112(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920692903936(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920692494336(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920678486016(gen: 167071 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2987110809600(gen: 166922 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1127331561472(gen: 166859 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1127331446784(gen: 166859 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920862871552(gen: 163859 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4355037626368(gen: 163532 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2026026254336(gen: 163177 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2026022371328(gen: 163177 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667959111680(gen: 163168 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821833072640(gen: 161910 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1508154916864(gen: 161669 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3401783640064(gen: 160537 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986725294080(gen: 155239 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986690527232(gen: 153501 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229325111296(gen: 151165 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4354747006976(gen: 151126 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920798105600(gen: 151125 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4355032956928(gen: 149200 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 4354733359104(gen: 140440 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324435550208(gen: 140145 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3632266641408(gen: 139233 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 523862016(gen: 138880 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920367943680(gen: 129807 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324334821376(gen: 129681 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1667982508032(gen: 129543 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920580247552(gen: 128089 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324203683840(gen: 125689 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1307993440256(gen: 125613 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 73793536(gen: 125514 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3920520560640(gen: 117610 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821908652032(gen: 117557 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821906702336(gen: 117557 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 229307285504(gen: 117553 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 3402075029504(gen: 115365 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765179437056(gen: 115362 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2324660895744(gen: 115361 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 821834317824(gen: 115350 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 354058240(gen: 115342 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2986964877312(gen: 115078 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1508221681664(gen: 115069 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 275323371520(gen: 112992 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 148554186752(gen: 106210 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 275306004480(gen: 105301 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 275108298752(gen: 103537 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 2765000704000(gen: 103015 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1
Well block 1308153970688(gen: 101215 level: 0) seems good, but generation/level doesn't match, want gen: 170816 level: 1

regards,

Koen