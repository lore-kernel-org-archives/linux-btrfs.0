Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49937 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbbDTOQE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 10:16:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YkCUM-00030S-EA
	for linux-btrfs@vger.kernel.org; Mon, 20 Apr 2015 16:15:54 +0200
Received: from 168.159.160.58 ([168.159.160.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 16:15:54 +0200
Received: from toyours_sridhar by 168.159.160.58 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 16:15:54 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs send to file differences
Date: Mon, 20 Apr 2015 14:15:47 +0000 (UTC)
Message-ID: <loom.20150420T160700-483@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a subvolume with only one file (file.txt) with 5Mb size.
under /btrfs/subvol1/
1)
I have created 1st snapshot /btrfs/snap1_subvol1. Then I ran "btrfs 
send" and given -f out1.img

size of out1.img is 5Mb.

2)
Next, I have appended 1Mb data to file.txt

And again created snapshot /btrfs/snap2_subvol2. And rand "btrfs send" 
out put to file out2.img

3)
After that I ran "btrfs send -p  /btrfs/snap1_subvol1 
/btrfs/snap2_subvol1 -f outwith_poption.img.

Beween out1.img and out2.img there is difference of 1Mb

I would like to know what is the difference between out2.img and 
outwith_poption.img ?

When I do btrfs send to a file, is there a way to send only changes to 
new file i.e. for step 2 and step 1, out2.img is 6Mb and out1.img is 
5Mb.
can I get difference if the file and use it as input to btrfs receive 
option if I want to recover incremental recover i.e out1.img + 1Mb ??

Here with my steps I can give only out2.img which is of 6Mb or out1.img 
which is of 5Mb.
So for incremetal backup, it consumes total of 11Mb.
I want a way to reduce it to total of 6Mb but there should a way to 
recover from fist snapshot dump and second snapshot dump as well.

Thank you in advance.


