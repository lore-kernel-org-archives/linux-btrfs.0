Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43058 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3JPE4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 00:56:39 -0400
Received: by mail-pd0-f181.google.com with SMTP id y13so314748pdi.26
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 21:56:38 -0700 (PDT)
Date: Wed, 16 Oct 2013 12:56:33 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: check return value of realpath(3)
Message-ID: <20131016045633.GB11404@dhcp-13-216.nay.redhat.com>
References: <1381592872-24751-1-git-send-email-guaneryu@gmail.com>
 <20131015164941.GL5787@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131015164941.GL5787@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 06:49:41PM +0200, David Sterba wrote:
> On Sat, Oct 12, 2013 at 11:47:52PM +0800, Eryu Guan wrote:
> > I hit a segfault when deleting a subvolume with very long name(>4096),
> 
> How do you get a valid pathname longer than PATH_MAX which is 4096 ?

Just as the steps in reproducer, you can try the following

path=/mnt/btrfs
for i in `seq 1 381`;do
	path="$path/subvol_$i"
	btrfs sub create $path
done
echo ${#path}  # len is 4093 here

((i++))
path="$path/subvol_$i"
btrfs sub create $path
echo ${#path}  # The length of absolute path of this subvolume is greater than 4096 now

Maybe just another bug of btrfs-progs?
> 
> > Fix it by checking return value of realpath(3), also fix the one in
> > find_mount_root().
> 
> The error handling itself is ok.

Thanks for the review!

Eryu
