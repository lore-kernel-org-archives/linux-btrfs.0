From: Jeff Mahoney <jeffm@suse.de>
Subject: Device files on read-only file systems?
Date: Mon, 15 Aug 2011 09:11:24 -0400
Message-ID: <4E491AFC.5030403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -

btrfs_permission currently returns -EROFS when the root is set read-only 
and the open is requested read-write. It doesn't make an exception for 
device files. Is this intentional?

-Jeff

-- 
Jeff Mahoney
SUSE Labs
