Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51883 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab2HUOvy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 10:51:54 -0400
Date: Tue, 21 Aug 2012 16:51:49 +0200
From: David Sterba <dave@jikos.cz>
To: Roman Mamedov <rm@romanrm.ru>
Cc: Curtis Jones <curtis.jones@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs and mdadm raid 6
Message-ID: <20120821145149.GL17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
 <20120820230603.1ba1afca@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120820230603.1ba1afca@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2012 at 11:06:03PM +0600, Roman Mamedov wrote:
> 2) On filesystem converted with btrfs-convert the metadata allocation is
> unnecessarily large due to some other, conversion-related reasons; but this
> can be fixed with "btrfs filesystem balance -musage=5 /mount/point" (do
> several runs increasing the value from 5 to 10, 20 or more, if it fails to
> free up a sufficient amount of space). This will defragment metadata and free
> up chunks which end up being completely unused (which will be a lot of them),
> but only down to the kernel's desired minimum allocation, see point #1.

There's one recommended preceding step -- remove the saved
ext2_subvol/image .  (General note, that further rollback to ext4 is
impossible, does not apply in this case.)

The data blocks will otherwise inherit the layout from ext4 and are
(probably and naturally) allocated using different assumptions and
needs.


david
