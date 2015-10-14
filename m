Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24865 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbbJNK4f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 06:56:35 -0400
Message-ID: <561E34DD.3090006@oracle.com>
Date: Wed, 14 Oct 2015 18:56:29 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] btrfs-progs: Introduce device delete by devid
References: <1444487458-2988-1-git-send-email-anand.jain@oracle.com> <20151013124808.GJ27761@twin.jikos.cz>
In-Reply-To: <20151013124808.GJ27761@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/13/2015 08:48 PM, David Sterba wrote:
> On Sat, Oct 10, 2015 at 10:30:55PM +0800, Anand Jain wrote:
>> This is the btrfs-progs part of the kernel patch
>>     Btrfs: Introduce device delete by devid
>
> Thanks, now in next/delete-by-id-v3, I made some changes so please have
> a look. Notably, I've dropped the BTRFS_VOL_ARG_V2_FLAGS mask, this
> belongs to kernel only (unless you need it userspace of course).

  sorry that was by oversight. yep no need.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
