Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47125 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaIPHif (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 03:38:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XTnLN-0007Yf-R6
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 09:38:33 +0200
Received: from pd953e0d8.dip0.t-ipconnect.de ([217.83.224.216])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 09:38:33 +0200
Received: from holger.hoffstaette by pd953e0d8.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 09:38:33 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 3.14.18 btrfs_set_item_key_safe BUG
Date: Tue, 16 Sep 2014 07:38:22 +0000 (UTC)
Message-ID: <pan.2014.09.16.07.38.22@googlemail.com>
References: <CAMVG2svU-tbpgJ5MqjnS=XGBNZcwfPd0WGMkp1aN4W0M1ewm5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 16 Sep 2014 12:33:09 +0800, Daniel J Blueman wrote:

> On 3.14.18 with a BTRFS partition mounted
> noatime,autodefrag,compress=lzo, I see the second assertion in
> btrfs_set_item_key_safe() trip:
> 
> void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
>                              struct btrfs_key *new_key)
> {
>         struct btrfs_disk_key disk_key;
>         struct extent_buffer *eb;
>         int slot;
> 
>         eb = path->nodes[0];
>         slot = path->slots[0];
>         if (slot > 0) {
>                 btrfs_item_key(eb, &disk_key, slot - 1);
>                 BUG_ON(comp_keys(&disk_key, new_key) >= 0);
>         }
>         if (slot < btrfs_header_nritems(eb) - 1) {
>                 btrfs_item_key(eb, &disk_key, slot + 1);
>                 BUG_ON(comp_keys(&disk_key, new_key) <= 0); <---
>         }
> 
> Full backtrace:
> 
> kernel BUG at /home/apw/COD/linux/fs/btrfs/ctree.c:3215!

This matches exactly the description mentioned just recently:
http://article.gmane.org/gmane.comp.file-systems.btrfs/38340

(not in that posting, but in the patch description).

You seem to be running a custom kernel, so try if that patch
helps. Also try nuking the free space cache when you have it
applied.

-h

