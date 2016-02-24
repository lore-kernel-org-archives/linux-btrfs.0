Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32985 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbcBXLmO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 06:42:14 -0500
Received: by mail-oi0-f41.google.com with SMTP id j125so13098939oih.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 03:42:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CCEB60.4080404@jp.fujitsu.com>
References: <1456163525-1098-1-git-send-email-fdmanana@kernel.org>
	<56CCEB60.4080404@jp.fujitsu.com>
Date: Wed, 24 Feb 2016 12:42:13 +0100
Message-ID: <CAHji152pNf5nn0asmPbLHiGKeZmaHz3bjNfA6gnVLYZ1fJC5vA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix listxattrs not listing all xattrs packed in
 the same item
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 12:29 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
> On 2016/02/23 2:52, fdmanana@kernel.org wrote:
>>
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> In the listxattrs handler, we were not listing all the xattrs that are
>> packed in the same btree item, which happens when multiple xattrs have
>> a name that when crc32c hashed produce the same checksum value.
(snip)

This gives me (with gcc 5.3.0):

fs/btrfs/xattr.c: In function 'btrfs_listxattr':
fs/btrfs/xattr.c:357:8: warning: 'this_len' may be used uninitialized
in this function [-Wmaybe-uninitialized]
    cur += this_len;
        ^
fs/btrfs/xattr.c:357:8: warning: 'cur' may be used uninitialized in
this function [-Wmaybe-uninitialized]
fs/btrfs/xattr.c:327:9: warning: 'item_size' may be used uninitialized
in this function [-Wmaybe-uninitialized]
   while (cur < item_size) {
         ^
fs/btrfs/xattr.c:358:7: warning: 'di' may be used uninitialized in
this function [-Wmaybe-uninitialized]
    di = (struct btrfs_dir_item *)((char *)di + this_len);
       ^

And at least from a compiler POV these seem to have merit, caused by a possibly
premature "goto next" above the "while (cur < item_size)" loop.

cheers
Holger
