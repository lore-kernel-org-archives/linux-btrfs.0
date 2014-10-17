Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26478 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753263AbaJQSZz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 14:25:55 -0400
Message-ID: <54415F1C.1060902@fb.com>
Date: Fri, 17 Oct 2014 14:25:32 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Petr Janecek <janecek@ucw.cz>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: Poll: time to switch skinny-metadata on by default?
References: <20141017123036.GA8052@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20141017123036.GA8052@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/17/2014 08:30 AM, Petr Janecek wrote:
> Hello,
>
>> the core of skinny-metadata feature has been merged in 3.10 (Jun 2013)
>> and has been reportedly used by many people. No major bugs were reported
>> lately unless I missed them.
>
>    so far I haven't succeeded running btrfs balance on a large
> skinny-metadata fs -- segfault, kernel bug, reproducible.  No such
> problems on ^skinny-metadata fs (same disks, same data).  Tried both
> several times on 3.17.  More info in comments 10,14 in
> https://urldefense.proofpoint.com/v1/url?u=https://bugzilla.kernel.org/show_bug.cgi?id%3D64961&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=3qxE39iiu%2BoZB%2F05dE7hnGHZojWhjjijrtjNYki0NFg%3D%0A&s=b262347a1ad2505ebdcb21dcc9f0944a14c174a1dcf447746ce196faddd99092
>
>

I can't reproduce this, how big is your home directory, and are you 
still seeing corruptions after just rsyncing to a clean fs?  Thanks,

Josef

