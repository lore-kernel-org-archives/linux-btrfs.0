Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:58659 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3ECIs0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 04:48:26 -0400
Date: Fri, 3 May 2013 10:48:22 +0200
From: Sander <sander@humilis.net>
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Creating recursive snapshots for all filesystems
Message-ID: <20130503084822.GA22531@panda>
Reply-To: sander@humilis.net
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Skwar wrote (ao):
> Where I'm hanging right now, is that I can't seem to figure out a
> "bullet proof" way to find all the subvolumes of the filesystems I
> might have.

> Is there an easier way to achieve what I want? I want to achieve:
> 
> Creating recursive snapshots for all filesystems

Not sure if this helps, but I have subvolid=0, which contains all my
subvolumes, mounted under /.root/

/etc/fstab:
LABEL=panda   /  btrfs  subvol=rootvolume,space_cache,inode_cache,compress=lzo,ssd  0  0
LABEL=panda   /home           btrfs   subvol=home                                   0  0
LABEL=panda   /root           btrfs   subvol=root                                   0  0
LABEL=panda   /var            btrfs   subvol=var                                    0  0
LABEL=panda   /holding        btrfs   subvol=.holding                               0  0
LABEL=panda   /.root          btrfs   subvolid=0                                    0  0
LABEL=panda   /.backupadmin   btrfs   subvol=backupadmin                            0  0 
/Varlib       /var/lib        none    bind                                          0  0

panda:~# ls -l /.root/
total 0
drwxr-xr-x. 1 root root 580800 Jan 30 17:46 backupadmin
drwxr-xr-x. 1 root root     24 Mar 27  2012 home
drwx------. 1 root root    742 Mar 19 15:50 root
drwxr-xr-x. 1 root root    226 May 16  2012 rootvolume
drwxr-xr-x. 1 root root     96 Apr  3  2012 var

In my snapshots script:

  ...
  yyyymmddhhmm=`date +%Y%m%d_%H.%M`
  ...
  for subvolume in `ls /.root/`
  do
    ...
    /sbin/btrfs subvolume snapshot ${filesystem}/${subvolume}/ \
      /.root/.snapshot_${yyyymmddhhmm}_${hostname}_${subvolume}/ || result=2
    ...
  done
  ...

This creates timestamped snapshots for all subvolumes.

	Sander
