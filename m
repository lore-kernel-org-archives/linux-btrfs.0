Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.47.80]:45735 "EHLO
	gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964925AbbJ1PgJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 11:36:09 -0400
Received: from ham06.websitewelcome.com (unknown [108.179.254.230])
	by gateway23.websitewelcome.com (Postfix) with ESMTP id 6E818F2693C0E
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 10:12:56 -0500 (CDT)
Received: from br538.hostgator.com.br (br538.hostgator.com.br [108.179.252.175])
	by ham06.websitewelcome.com (Postfix) with ESMTP id 04E0A40012
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 10:12:56 -0500 (CDT)
MIME-Version: 1.0
In-Reply-To: <87oafkc5kp.fsf@notabene.neil.brown.name>
References: <87oafkc5kp.fsf@notabene.neil.brown.name>
Date: Wed, 28 Oct 2015 13:12:55 -0200
Message-ID: <CAMu38xKzWmDU5hL431tniymMviVyFV3_jXeat5P0pi+=QENipw@mail.gmail.com>
Subject: Re: [PATCH/RFC] make btrfs subvol mounts appear in /proc/mounts
From: Albino B Neto <bino@bino.us>
To: Neil Brown <neil@brown.name>
Cc: Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-10-27 20:25 GMT-02:00 Neil Brown <neil@brown.name>:
>

snif

>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 611b66d73e80..e96c53590f72 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5621,6 +5621,23 @@ static void btrfs_dentry_release(struct dentry *dentry)

Signed-off-by: ?


      Albino
