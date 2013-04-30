Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40061 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3D3Od6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 10:33:58 -0400
Received: by mail-oa0-f49.google.com with SMTP id j1so543975oag.8
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 07:33:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130430135816.GD2580@localhost.localdomain>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com>
 <CVrGRAreCXB@helmut.hullen.de> <20130430094131.GA8274@carfax.org.uk>
 <loom.20130430T133556-803@post.gmane.org> <20130430135816.GD2580@localhost.localdomain>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Tue, 30 Apr 2013 16:33:38 +0200
Message-ID: <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
 [btrfs]()
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef

On Tue, Apr 30, 2013 at 3:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:

> So we deal with this case fine, but it really shouldn't be happening, it only
> happens if your block groups are way too large, which again shouldn't be
> happening.  Can you run fsck on this device and see if it complains?  Thanks,


a@ewzw032:~$ sudo btrfsck /dev/system/Data
checking extents
checking fs roots
checking root refs
found 115308904448 bytes used err is 0
total csum bytes: 112056692
total tree bytes: 521891840
total fs tree bytes: 353947648
btree space waste bytes: 122297974
file data blocks allocated: 114787012608
 referenced 114787000320
Btrfs v0.20-rc1


No errors.

Alexander
-- 
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
