Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61064 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3BVSbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 13:31:08 -0500
Received: by mail-pb0-f52.google.com with SMTP id ma3so545855pbc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 10:31:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMfhy924GJHkxTmy2bDZc=TaYD9ivyg6Q8LBN=+9_m6Xo=tnag@mail.gmail.com>
References: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
	<20130222165302.GE2062@localhost.localdomain>
	<CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
	<20130222174401.GF2062@localhost.localdomain>
	<CAMfhy92G2yGh4HeQGq1VYVZ=pr2VkH+6yT86ZwfnLvxrUY=Wyg@mail.gmail.com>
	<20130222181017.GG2062@localhost.localdomain>
	<CAMfhy924GJHkxTmy2bDZc=TaYD9ivyg6Q8LBN=+9_m6Xo=tnag@mail.gmail.com>
Date: Fri, 22 Feb 2013 13:31:07 -0500
Message-ID: <CAMfhy90toxsRFFQVB-3kotm4zyoCJDOFknq-AUegaCsia2pazg@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718 map_private_extent_buffer+0xd4/0xe0
 [btrfs]()
From: Mace Moneta <moneta.mace@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 1:16 PM, Mace Moneta <moneta.mace@gmail.com> wrote:
> On Fri, Feb 22, 2013 at 1:10 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> On Fri, Feb 22, 2013 at 10:52:19AM -0700, Mace Moneta wrote:
>>> On Fri, Feb 22, 2013 at 12:44 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>>> > On Fri, Feb 22, 2013 at 10:22:04AM -0700, Mace Moneta wrote:
>>> >> On Fri, Feb 22, 2013 at 11:53 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>>> >> > On Fri, Feb 22, 2013 at 07:46:16AM -0700, Mace Moneta wrote:
>>> >> >> https://bugzilla.redhat.com/show_bug.cgi?id=906142
>>> >> >>
>>> >> >> With 3.8 kernels in Fedora 18, using encfs on btrfs I get the
>>> >> >> following error.  It can take hours of use before I get a
>>> >> >> reoccurrence, and I need to btrfsck, btrfs-zero-log, and/or mount with
>>> >> >> '-o recovery' to get the filesystem back after a reboot.  No data
>>> >> >> appears to be lost, and a scrub runs to completion with no errors.
>>> >> >
>>> >> > Could you do
>>> >> >
>>> >> > gdb btrfs.ko
>>> >> > list *(btrfs_log_inode+0x3b8)
>>> >> >
>>> >> > and tell me what it says?  Thanks,
>>> >> >
>>> >> > Josef
>>> >>
>>> >> # uname -r
>>> >> 3.8.0-0.rc7.git0.1.fc19.x86_64
>>> >>
>>> >> # gdb /usr/lib/modules/3.8.0-0.rc7.git0.1.fc19.x86_64/kernel/fs/btrfs/btrfs.ko
>>> >>
>>> >
>>> > Sigh sorry, I miseed the other line because of line wrapping, can you do
>>> >
>>> > list *(btrfs_log_changed_extents+0x384)
>>> >
>>> > Thanks,
>>> >
>>> > Josef
>>>
>>> (gdb) list *(btrfs_log_changed_extents+0x384)
>>> 0x65264 is in btrfs_log_changed_extents (fs/btrfs/ctree.h:2731).
>>> 2726                       generation, 64);
>>> 2727    BTRFS_SETGET_FUNCS(file_extent_disk_num_bytes, struct
>>> btrfs_file_extent_item,
>>> 2728                       disk_num_bytes, 64);
>>> 2729    BTRFS_SETGET_FUNCS(file_extent_offset, struct btrfs_file_extent_item,
>>> 2730                      offset, 64);
>>> 2731    BTRFS_SETGET_FUNCS(file_extent_num_bytes, struct btrfs_file_extent_item,
>>> 2732                       num_bytes, 64);
>>> 2733    BTRFS_SETGET_FUNCS(file_extent_ram_bytes, struct btrfs_file_extent_item,
>>> 2734                       ram_bytes, 64);
>>> 2735    BTRFS_SETGET_FUNCS(file_extent_compression, struct
>>> btrfs_file_extent_item,
>>> (gdb)
>>
>> Ok nothing obvious is jumping out at me, anything specifc to your btrfs setup?
>> Mount options, raid etc.  I'm going to setup encfs up here and hammer it with
>> fsstress and see if I can reproduce.  Thanks,
>>
>> Josef
>
> The btrfs mount options I'm using are: subvol=home,noatime,autodefrag
>
> The encfs is mounted with default options.

Oh, and there's no raid data, just a single drive.  I don't do heavy
I/O to the encfs, which may explain why it takes minutes to hours to
recreate.  I have my google-chrome config directory (cache, profile,
passwords, etc.) in the encfs, so it's getting read/written as I
browse.

# btrfs fi show
failed to read /dev/sr0
Label: 'btrfs'  uuid: 057239ee-1cc7-44b2-8fa3-714661dfa7fe
        Total devices 1 FS bytes used 39.06GB
        devid    1 size 455.58GB used 77.04GB path /dev/sda3

Btrfs Btrfs v0.19

# btrfs fi df /home
Data: total=58.01GB, used=38.46GB
System, DUP: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=9.50GB, used=611.59MB
Metadata: total=8.00MB, used=0.00


Btrfs Btrfs v0.19
