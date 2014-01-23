Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58512 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaAWWXj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 17:23:39 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so653528eek.9
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 14:23:37 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id o13sm43825821eex.19.2014.01.23.14.23.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 23 Jan 2014 14:23:37 -0800 (PST)
Message-ID: <52E19667.6090005@gmail.com>
Date: Thu, 23 Jan 2014 23:23:35 +0100
From: KC <conrad.francois.artus@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Options for SSD - autodefrag etc?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was wondering about whether using options like "autodefrag" and 
"inode_cache" on SSDs.

On one hand, one always hears that defragmentation of SSD is a no-no, 
does that apply to BTRFS's autodefrag?
Also, just recently, I heard something similar about "inode_cache".

On the other hand, Arch BTRFS wiki recommends to use both options on SSDs
  http://wiki.archlinux.org/index.php/Btrfs#Mount_options

So to clear things up, I ask at the source where people should know best.

Does using those options on SSDs gives any benefits and causes 
non-negligible increase in SSD wear?
