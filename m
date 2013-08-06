Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35264 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3HFPJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 11:09:00 -0400
Message-ID: <52011178.8090200@oracle.com>
Date: Tue, 06 Aug 2013 23:08:40 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11 v2 (resend)] btrfs-progs: coalesce of patches
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com> <20130805173643.GF5284@twin.jikos.cz>
In-Reply-To: <20130805173643.GF5284@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/08/2013 01:36, David Sterba wrote:
> On Mon, Jul 15, 2013 at 01:30:46PM +0800, Anand Jain wrote:
>> Anand Jain (11):
>>    btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
>>    btrfs-progs: label option in btrfs filesystem show is not coded
>>    btrfs-progs: update device scan usage
>>    btrfs-progs: congregate dev scan
>>    btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
>>      provided
>>    btrfs-progs: scan /dev/mapper in filesystem show and device scan
>>    btrfs-progs: device delete to get errors from the kernel
>>    btrfs-progs: get_label_mounted to return label instead of print
>>    btrfs-progs: move out print in cmd_df to another function
>>    btrfs-progs: get string for the group profile and type
>>    btrfs-progs: introduce btrfs filesystem show --kernel
>
> patches 1-4,7,8 added to integration, skipped 5,6 as they enhance dev
> scan that'll need a rewrite anyway.
>
> 9-11 are sort of independent of the previous changes so I'd like to look
> at them in context of all the other df/show patches.

  makes sense. I am looking at them.

Thanks,  Anand
