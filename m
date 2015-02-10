Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41703 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbbBJSjg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 13:39:36 -0500
Message-ID: <54DA5060.7080201@fb.com>
Date: Tue, 10 Feb 2015 13:39:28 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.cz>
Subject: Re: [PATCH 09/16] Btrfs-progs: Introduce metadump_v2
References: <1423512199-16552-1-git-send-email-jbacik@fb.com> <1423512199-16552-10-git-send-email-jbacik@fb.com> <54DA4DE8.4070701@redhat.com>
In-Reply-To: <54DA4DE8.4070701@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2015 01:28 PM, Eric Sandeen wrote:
> On 2/9/15 2:03 PM, Josef Bacik wrote:
>> The METADUMP super flag makes us skip doing the chunk tree reading which isn't
>> helpful for the new restore since we have a valid chunk tree.  But we still want
>> to have a way for the kernel to know that this is a metadump restore so it
>> doesn't do things like verify data checksums.  We also want to skip some of the
>> device extent checks in fsck since those will obviously not match.  Thanks,
>
> coverity points out that the "metadump_v2" flag is never set to anything but 0.
>
> # git show 797a937e | grep metadump_v2
>      Btrfs-progs: Introduce metadump_v2
> +	int metadump_v2 = 0;
> +		    (!metadump_v2 &&
> +	if (metadump_v2)
> #
>
> is that ... intentional?
>

Sort of?  So I originally skipped these checks with metadump_v2 set, but 
then I fixed btrfs-image to fix the chunk tree, so I deleted that stuff. 
  However btrfs-image doesn't fix everything so we still want to skip 
sometimes.  Soooooo I'll just delete this bit and add it back when I 
decide what I want.  Thanks,

Josef

