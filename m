From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: converting one-disk btrfs into RAID-1?
Date: Mon, 11 Oct 2010 14:11:47 +0200
Message-ID: <4CB2FF03.8090608@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Some Linux distributions started adding btrfs support in their 
installers. Unfortunately, you can't specify your own mkfs.btrfs 
parameters, so the best an installer can produce is a btrfs filesystem 
made on one partition.

Is it possible to turn a 1-disk (partition) btrfs filesystem into RAID-1?

Suppose you have your / btrfs filesystem on /dev/vda3, and there is a 
free /dev/vdb3 partition which you would like to use to have btrfs 
RAID-1 - what are the options to set it up like this?


A command like:

	btrfs device add /dev/vdb3 /

will, I suppose, simply make RAID-0 and double your available storage - 
are there any options to make it RAID-1?

Or, will it be RAID-1 after I do:

	btrfs filesystem balance /

?

-- 
Tomasz Chmielewski
http://wpkg.org
