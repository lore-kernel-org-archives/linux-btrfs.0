Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45039 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbcBMCJG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:09:06 -0500
Subject: Re: [PATCH 0/7] Introduce device delete by devid
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
 <20160212182207.GJ4374@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56BE903C.9030805@oracle.com>
Date: Sat, 13 Feb 2016 10:09:00 +0800
MIME-Version: 1.0
In-Reply-To: <20160212182207.GJ4374@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/13/2016 02:22 AM, David Sterba wrote:
> On Tue, Oct 06, 2015 at 11:19:17PM +0800, Anand Jain wrote:
>> The operation of device replace and device delete follows same steps
>> upto some depths, however they don't share codes.
>> This set of enhancement will help device replace and device delete to
>> share codes.
>> And at the end add support to delete device using devid.
>
> I'd like to get this rolling again, do you have an updated branch? I'm
> not sure what's the latest status of the



> 'number of devices vs raid
> constraints' problem. Qu did some patches, I hope either of you can let
> me know. Thanks.

  Hi Dave,

    Qu patch is required with my patch set titled
      'btrfs: Hot spare and Auto replace'
    I can send that again. pls let me know.

    However I think you are looking for the patch set
      'Introduce device delete by devid'
    here these patch does not depend on Qu patches.
    I have sent them again in a separate thread.

Thanks, Anand
