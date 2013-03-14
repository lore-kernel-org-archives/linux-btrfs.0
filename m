Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab3CNOr6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 10:47:58 -0400
Message-ID: <5141E31B.30407@redhat.com>
Date: Thu, 14 Mar 2013 09:47:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by
 default
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-4-git-send-email-anand.jain@oracle.com> <514153B0.7020100@redhat.com> <514190AA.2080405@oracle.com>
In-Reply-To: <514190AA.2080405@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/14/13 3:56 AM, Anand Jain wrote:
> 
> 
> On 03/14/2013 12:36 PM, Eric Sandeen wrote:
>> On 3/13/13 10:05 PM, Anand Jain wrote:
>>
>> <maybe a little more commit log would be good?>
>>
>> So here is what confuses me now. :)
>>
>> *every* caller of btrfs_read_dev_super() is now called with
>> 0 for the flags variable, so it never reads the backup
>> under any circumstance.
>>
>> If it's always called w/ 0, what is the point of the argument?
>> Is there another patch you have planned that would use this argument
>> later?
> 
>  Thanks for the review. yes true. as of now it (BTRFS_SCAN_BACKUP_SB)
>  only serves the purpose if in future should we need it.
>  purpose is something like a user initiated thread which
>  should to go to the backup-SB if primary-SB is not found ?.
>  Or I can drop BTRFS_SCAN_BACKUP_SB idea depending on how
>  it is convenient as a whole.

See what others think, perhaps, but if nobody is using it, I think
it should just go away.  I'd call it "dead code." :)

But I am surprised that none of the commands which accept alternate
superblock locations find their way into btrfs_read_dev_super() -
that seems odd to me.  Is it re-implemented or open-coded in other
places?

-Eric


> Thanks,  Anand
> 
> 

