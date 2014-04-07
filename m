Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21495 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753057AbaDGQMO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 12:12:14 -0400
Message-ID: <5342CE0C.3070707@fb.com>
Date: Mon, 7 Apr 2014 12:10:52 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
References: <20140407160506.GG10789@merlins.org>
In-Reply-To: <20140407160506.GG10789@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2014 12:05 PM, Marc MERLIN wrote:
> I was debugging my why backup failed to run, and eventually found it was
> stuck on sync:
> 14080       18:18 btrfs_tree_read_lock           sync
>
> This was hung for hours on this lock.
>
> Strangely, it looks like taking my sysrq-w hung the machine pretty hard for
> close to 30sec, but this seems to have unhung sync and in the end btrfs send
> completed after that.
>
> Sysqrq-w is here:
> https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/sysrq-btrfs-sync-hang.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=IHXWC1Chbc0jEiUWu1v4Va9NOphtjPbjYp6yVMdUmXM%3D%0A&s=bd787a3422e9ff0972d2d09de7d424f56589aadc9d6db33e19fc44886dce604f

Try Chris's integration branch in a few hours and see if that fixes it. 
  Thanks,

Josef

