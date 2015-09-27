Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57816 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbbI0VpH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 17:45:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZgJkl-0004LG-07
	for linux-btrfs@vger.kernel.org; Sun, 27 Sep 2015 23:45:03 +0200
Received: from 84.76.233.227 ([84.76.233.227])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Sep 2015 23:45:02 +0200
Received: from iam by 84.76.233.227 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Sep 2015 23:45:02 +0200
To: linux-btrfs@vger.kernel.org
From: Juan Francisco Cantero Hurtado <iam@juanfra.info>
Subject: mkfs.btrfs(8) --data outdated?
Date: Sun, 27 Sep 2015 22:33:01 +0200
Message-ID: <mu9jpv$l25$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel: 4.1.7
btrfs-progs: 4.2

mkfs.btrfs(8) man page says:
-d|--data <type>
     Specify how the data must be spanned across the devices
     specified. Valid values are raid0, raid1, raid5, raid6,
     raid10 or single.

$ sudo mkfs.btrfs -d dup -m dup -M -O no-holes -f /dev/sdb1
SMALL VOLUME: forcing mixed metadata/data groups
btrfs-progs v4.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               29de8c3e-92da-4fe1-aa31-830c1068f532
Node size:          4096
Sector size:        4096
Filesystem size:    3.00GiB
Block group profiles:
   Data+Metadata:    DUP             161.56MiB
   System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  mixed-bg, extref, skinny-metadata, no-holes
Number of devices:  1
Devices:
    ID        SIZE  PATH
     1     3.00GiB  /dev/sdb1


The man page doesn't mention the option "-d dup". Am I missing something 
or the man page is outdated?. The partition will contain two copies of 
the data blocks?

