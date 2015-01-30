Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62983 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbbA3Qzv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 11:55:51 -0500
Date: Fri, 30 Jan 2015 11:55:26 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: add missing blk_finish_plug in btrfs_sync_log()
To: <dsterba@suse.cz>
CC: Forrest Liu <forrestl@synology.com>, <linux-btrfs@vger.kernel.org>
Message-ID: <1422636926.13510.1@mail.thefacebook.com>
In-Reply-To: <20150130165110.GN3641@twin.jikos.cz>
References: <1422618132-30272-1-git-send-email-forrestl@synology.com>
	<20150130165110.GN3641@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 11:51 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Jan 30, 2015 at 07:42:12PM +0800, Forrest Liu wrote:
>>  Add missing blk_finish_plug in btrfs_sync_log()
>> 
>>  Signed-off-by: Forrest Liu <forrestl@synology.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>
> 
> Did you find that by code inspection or was there a runtime problem.

I was wondering the same.  I'll send in for 3.19-final

-chris



