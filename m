Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49897 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3CNIzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 04:55:36 -0400
Message-ID: <514190AA.2080405@oracle.com>
Date: Thu, 14 Mar 2013 16:56:10 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by
 default
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-4-git-send-email-anand.jain@oracle.com> <514153B0.7020100@redhat.com>
In-Reply-To: <514153B0.7020100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/14/2013 12:36 PM, Eric Sandeen wrote:
> On 3/13/13 10:05 PM, Anand Jain wrote:
>
> <maybe a little more commit log would be good?>
>
> So here is what confuses me now. :)
>
> *every* caller of btrfs_read_dev_super() is now called with
> 0 for the flags variable, so it never reads the backup
> under any circumstance.
>
> If it's always called w/ 0, what is the point of the argument?
> Is there another patch you have planned that would use this argument
> later?

  Thanks for the review. yes true. as of now it (BTRFS_SCAN_BACKUP_SB)
  only serves the purpose if in future should we need it.
  purpose is something like a user initiated thread which
  should to go to the backup-SB if primary-SB is not found ?.
  Or I can drop BTRFS_SCAN_BACKUP_SB idea depending on how
  it is convenient as a whole.

Thanks,  Anand


