Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFDEAx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 00:00:53 -0400
Message-ID: <538E9AA2.6020507@oracle.com>
Date: Wed, 04 Jun 2014 12:03:46 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com,
        hugo@carfax.org.uk
Subject: Re: [PATCH 6/6 RFC v2] btrfs: revamp /sys/fs/btrfs/<fsid>/devices
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com> <1401766564-7381-7-git-send-email-Anand.Jain@oracle.com> <20140603140807.GO22324@twin.jikos.cz>
In-Reply-To: <20140603140807.GO22324@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


David,

  Thanks for the comments


>> As of now with out this patch the sysfs interface under dir
>> /sys/fs/btrfs/<fsid>/devices is just link to the block devs.
>
> At this point it's part of the sysfs ABI and should not be changed.

  can't we lean on the experimental clause to change it either ?
  practically is there anything thats already depending on this
  dev link ?

> Example:
>
> /sys/fs/btrfs/devmap/by-id/
>    contains directories with integer numbers that represent devices

  This won't work.
  devid isn't unique at the btrfs-module level. its under fsid.


  [IMO. its ok if the ideas doesn't match ;-) as in any case I
  will be doing it in the way the most want]


  When user come to sys/fs/btrfs their  "main"  reference of identifying
  a  "volume"  is the FSID/label.  not individual disks.
  Of course disks are the sub-references of a volume.


  I suggest - first do the way btrfs-kernel does (which is - group disks
  under fsid) And later create abstraction links as needed which we don't
  have to worry about as of now.


Thanks, Anand
