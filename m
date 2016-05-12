Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33322 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbcELS0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 14:26:16 -0400
Received: by mail-pf0-f182.google.com with SMTP id 206so33516308pfu.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 11:26:15 -0700 (PDT)
Message-ID: <1463077564.3636.65.camel@clone1.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: "Richard A. Lochner" <lochner@clone1.com>
To: andrew.j.wade@gmail.com
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 12 May 2016 13:26:04 -0500
In-Reply-To: <CAAuLxcaQ1Uo+pff9AtD74UwUvo5yYKBuNLwKzjVMWV1kt2DcRQ@mail.gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	 <CAAuLxcaQ1Uo+pff9AtD74UwUvo5yYKBuNLwKzjVMWV1kt2DcRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrew,

I agree with your supposition about the metadata and corrupted RAM.  

I verified that the data blocks on both devices are equal (see my reply
to Austin for the commands I used.  I believe that they correctly prove
that the blocks are, in fact, equal.

I am not sure I have the skills to "walk the checksum tree manually" as
you described.  I would also like to verify that the checksum blocks
agree as I expect they do, but I may have to "bone up" on my tree
walking skills first.

Thanks for your help.

Rick Lochner

On Wed, 2016-05-11 at 21:16 -0400, Andrew Wade wrote:
> 
> I would expect the "data at rest" to be good too. But perhaps
> something happened to the metadata (checksum). If the checksum was
> corrupted in RAM it could be written back to the disks due to updates
> elsewhere in the metadata node.
> If this is what happened I would expect the metadata node containing
> the checksum to have a recent generation number.
> I'm not actually a BTRFS developer myself, but you might be able to
> find the generation by using btrfs-debug-tree from btrfs-tools.
> btrfs-debug-tree -r /dev/sdc1 will give you the block number of the
> checksum tree root, which you can then feed into btrfs-debug-tree -b
> #### /dev/sdc1 and walk the tree manually. You're looking for the
> largest key before 3037444042752. 
> For dumping the data and metadata blocks I think btrfs-map-logical is
> what you need, though to be honest I've never used this tool myself.
> Even if the file data is still good I don't know of a simple way to
> tell BTRFS to ignore the checksums for a file. It is possible to
> regenerate the checksum tree for the entire filesystem, but I
> personally wouldn't do that unless you really need the file.
> regards,
> Andrew
> 
