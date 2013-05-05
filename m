Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58871 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3EELIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 07:08:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYwnl-0001Rt-Rq
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 13:08:21 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 13:08:21 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 13:08:21 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Creating recursive snapshots for all filesystems
Date: Sun, 05 May 2013 13:05:57 +0200
Message-ID: <h1rh5a-1lg.ln1@hurikhan.ath.cx>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Skwar <alexanders.mailinglists+nospam@gmail.com> schrieb:

> Where I'm hanging right now, is that I can't seem to figure out a
> "bullet proof" way to find all the subvolumes of the filesystems I
> might have.

What about this:

# btrfs sub list -a /
ID 256 gen 1487089 top level 5 path <FS_TREE>/root64
ID 258 gen 1487089 top level 5 path <FS_TREE>/home
ID 259 gen 1486932 top level 5 path <FS_TREE>/usr-src
ID 260 gen 1486885 top level 5 path <FS_TREE>/usr-portage
ID 261 gen 1487089 top level 5 path <FS_TREE>/var-tmp

You still need to iterate through the mounted btrfs filesystems if you are 
using more than one:

# btrfs fi show | fgrep uuid
Label: 'usb-backup'  uuid: 7038c8fa-4293-49e9-b493-a9c46e5663ca
Label: 'system'  uuid: d2bb232a-2e8f-4951-8bcc-97e237f1b536

Then translate the uuid back to an fspath somehow.

Another option would be to use blkid:

# blkid -t TYPE=btrfs
/dev/sda3: LABEL="system" UUID="d2bb232a-2e8f-4951-8bcc-97e237f1b536" 
UUID_SUB="7e0a2d93-86cc-4421-9e2c-b5c405075ff3" TYPE="btrfs" 
PARTLABEL="Linux filesystem" PARTUUID="7807f64f-3d0b-4e99-81a4-975128ed2918" 
/dev/sdb3: LABEL="system" UUID="d2bb232a-2e8f-4951-8bcc-97e237f1b536" 
UUID_SUB="caa3a27b-8546-4519-9a13-8f50cd1caf70" TYPE="btrfs" 
PARTLABEL="Linux filesystem" PARTUUID="1330dcf5-f1d3-462b-af08-e7cad839b3dc" 
/dev/sdc3: LABEL="system" UUID="d2bb232a-2e8f-4951-8bcc-97e237f1b536" 
UUID_SUB="e919b066-db86-4818-975c-bae0548c822a" TYPE="btrfs" 
PARTLABEL="Linux filesystem" PARTUUID="847fd503-8dca-4c6b-b199-20a47d62aa55" 
/dev/sdd1: LABEL="usb-backup" UUID="7038c8fa-4293-49e9-b493-a9c46e5663ca" 
UUID_SUB="f2eac9b0-22e3-44a2-bdc5-c98ee86da71f" TYPE="btrfs" 
PARTLABEL="Linux filesystem" PARTUUID="275ba328-9d5a-494b-bf19-a995596a4b6b" 

Still needs translation back to fspathes. But that could be done with 
grep/head/lsblk trickery...

HTH,
Kai

