Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35861 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbFAReO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 13:34:14 -0400
Received: by qgf2 with SMTP id 2so50120977qgf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 10:34:14 -0700 (PDT)
Message-ID: <1433180051.8616.2.camel@kepstin.ca>
Subject: Re: howto create subvolume at top level?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Neal Becker <ndbecker2@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 01 Jun 2015 13:34:11 -0400
In-Reply-To: <mki4j1$vvo$1@ger.gmane.org>
References: <mki4j1$vvo$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2015-06-01 at 13:25 -0400, Neal Becker wrote:
> [ nbecker@nbecker2~]$ sudo btrfs subvolume create /home2
> Create subvolume '//home2'
> [ nbecker@nbecker2~]$ sudo btrfs subvolume list /
> ID 257 gen 66376 top level 5 path root
> ID 316 gen 66376 top level 257 path home2
> 
> This created home2 under root.  How do I create home2 with top level 
> as top 
> level 5, at the same level as root?
> 
> IOW:
> 
> ID 257 gen 66376 top level 5 path root
> ID 316 gen 66376 top level 5 path home2

To do this, you have to mount the top level of the btrfs filesystem 
somewhere. For example:

mount -o subvolid=5 /dev/sda2 /mnt/btrfs

Then you can create your home directory under the top level by doing

btrfs subvolume create /mnt/btrfs/home2


-- 
Calvin Walton <calvin.walton@kepstin.ca>
