Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38617 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaAXUiP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 15:38:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W6nW2-0002kD-6a
	for linux-btrfs@vger.kernel.org; Fri, 24 Jan 2014 21:38:14 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 21:38:14 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 21:38:14 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Options for SSD - autodefrag etc?
Date: Fri, 24 Jan 2014 21:27:19 +0100
Message-ID: <7uuara-hf5.ln1@hurikhan77.spdns.de>
References: <52E2B73E.1050903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

KC <conrad.francois.artus@googlemail.com> schrieb:

> I followed your advice on NOCOW for virtualbox images and torrents like
> so: chattr -v /home/juha/VirtualBox\ VMs/
> chattr -RC /home/juha/Downloads/torrent/#unfinished
> 
> As you can see, i used the recursive flag. However, I do not know
> whether this will automatically apply to files that will be created in
> the future in subfolders that do not yet exist.
> 
> Also, how can I confirm whether a file/folder has a NOCOW attribute set
> on it?

The C attribute is also inherited by newly created directories. But keep in 
mind that, at the time applied, it only has effects on existing files if 
they are empty (read: never written to yet). Newly created files will 
inherit the attribute from its directory and then behave as expected.

You can use lsattr to confirm the C attribute was set. But again keep in 
mind: it does not reflect the file is actually nocow because of the above 
caveat. So in your use-case you may want to be sure by doing this (quit all 
VirtualBox instances beforehand):

# mkdir "VirtualBox VMs.new"
# chattr +C "VirtualBox VMs.new"
# rsync -aSv "VirtualBox VMs"/. "VirtualBox VMs.new"/.
# mv "VirtualBox VMs" "VirtualBox VMs.bak"
# mv "VirtualBox VMs.new" "VirtualBox VMs"

Then ensure everything is working, you can use lsattr to see the C attribute 
has been inherited. You should immediatly notice the effects of this by 
seeing better performing IO in VirtualBox (at least this was what I 
noticed). If everything was copied correctly, you can delete the backups. 
You could compare md5sums to be sure, of course before running a VM. ;-)

-- 
Replies to list only preferred.

