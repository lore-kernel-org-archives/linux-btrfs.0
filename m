Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3HLCto (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 22:49:44 -0400
Message-ID: <52084EB0.9030606@oracle.com>
Date: Mon, 12 Aug 2013 10:55:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs device stats /dev/mapper/ext4 SEGV
References: <201308101907.50539.russell@coker.com.au> <1384122.xvVNAvLv2n@quad>
In-Reply-To: <1384122.xvVNAvLv2n@quad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 08/10/2013 09:56 PM, Chris Samuel wrote:
> On Sat, 10 Aug 2013 07:07:50 PM Russell Coker wrote:
>
>> I can repeatedly get the following SEGV from running "btrfs device stats" on
>> a  device node for an Ext3/4 filesystem.  This happens with the version of
>> the code downloaded from the above GIT repository as well as with an older
>> version.  Obviously the command in question is not going to do anything
>> useful when run against a non-BTRFS filesystem, but it should do something
>> other than crash.
>
> The code calls btrfs_read_dev_super() on that filesystem, but it looks like the
> checks are failing to detect it as not btrfs.  :-(
>
> I can reproduce the crash here too with ext3 and XFS filesystems.

  There are quite a number of bug similar to this (that was
  reported to the mainling list here, but hard to search now)
  which is all triggered by using the backup super block invariably.


  v6: access to backup superblock
  http://permalink.gmane.org/gmane.comp.file-systems.btrfs/24746

  provided fix. But it needs rebase, if you could
  goback in git this patch might apply nicely for testing.

Thanks, Anand

