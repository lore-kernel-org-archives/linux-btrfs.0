Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-2.tng.de ([213.178.66.96]:57610 "EHLO smtp2-2.tng.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2FMMxu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 08:53:50 -0400
Received: from smtp.tng.de (proxy03.mailcluster.tng.de [82.97.146.17])
	by smtp2-2.tng.de (Postfix) with ESMTP id 3ED829C185
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 14:15:34 +0200 (CEST)
Received: from [213.178.67.139] (myrmidia.tng.de [213.178.67.139])
	by smtp.tng.de (Postfix) with ESMTPSA id 2B5D520479
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 14:15:34 +0200 (CEST)
Message-ID: <4FD88465.3020303@ki.tng.de>
Date: Wed, 13 Jun 2012 14:15:33 +0200
From: Jan-Hendrik Palic <billgotchy@ki.tng.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Computing size of snapshots approximatly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we using on a server several lvm volumes with btrfs. We want to use 
nightly build snapshots for some days as an alternative to backups.

Now I want to get the size of the snapshots in detail. Therefore I 
played with

   btrfs subvolume find-new $snapshot $gen-id.

And I know, that this is quite complicated and not implemented. 
Therefore I try to go my own way:

Now assume there are two snapshots of one subvolume, snap1 and snap2. 
Further get the find-new informations of these snapshots with $gen-id=1 
and save them into different files. A diff of these files shows the 
changes between snap1 and snap2, right?

Ok.

There are three operations on a filesystem, I think,

1. copy a file on the filesystem
2. change a file on the filesystem
3. delete a file on the filesystem

Am I right to assume, that operation 1 and 2 are not change much the 
size of a snapshot and the delete operation let increase the size of a 
snapshot in the size of the deleted files?

If it is so, it would be enough for me to get the deletions of files 
between two snapshots and their size. But is there another way to get 
these informations beside btrfs subvolume find-new? Perhaps it makes 
sense to use ioctl for it? What about the send/receive feature, which is 
upcoming?

Are there any hints?

Many thanks in advance.

Jan
