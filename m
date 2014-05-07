Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49235 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932134AbaEGQtM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 12:49:12 -0400
Message-ID: <536A647E.9030804@fb.com>
Date: Wed, 7 May 2014 12:51:10 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Back from leave
References: <53679FFD.2090501@fb.com> <20140507163849.GY5988@twin.jikos.cz>
In-Reply-To: <20140507163849.GY5988@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2014 12:38 PM, David Sterba wrote:
> Hi back,
>
> On Mon, May 05, 2014 at 10:28:13AM -0400, Josef Bacik wrote:
>> I had way too much email so I just deleted it all, if there was something
>> you wanted my specific attention on then bounce it back at me and I'll look
>> at it.  Thanks,
>
> it would be really great if you resurrect btrfs-next. Most of the current
> patches have been merged to 3.15 so for now it's IMHO ok to do a hard reset
> to linus/master. Please push anything you've already queued so we can
> let you know about the rest.
>

I've got them all queued up here, but I'm having trouble getting through 
an overnight stress.sh run (hangs).  As soon as I nail down the problem 
I'll push out to my linux-next queue.

At least for the next release, trying to help Josef focus on qgroups and 
other work he's had queued up.

-chris

