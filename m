Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65442 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933812AbaDIS5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 14:57:34 -0400
Message-ID: <53459768.8020408@fb.com>
Date: Wed, 9 Apr 2014 14:54:32 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes
 in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com> <20140409043125.GI10789@merlins.org> <20140409053139.GJ10789@merlins.org> <20140409154259.GM10789@merlins.org> <53456B45.8050906@fb.com> <20140409165134.GO10789@merlins.org>
In-Reply-To: <20140409165134.GO10789@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2014 12:51 PM, Marc MERLIN wrote:
> On Wed, Apr 09, 2014 at 11:46:13AM -0400, Chris Mason wrote:
>> Downloading the image now.  I'd just run a readonly btrfsck /dev/xxx
>
> https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/btrfs-raid0-image-fsck.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=FvUwVb5mtQKfcHDJf0YzDhzyfAaFwrR9BXQbyCmT0No%3D%0A&s=633624e090ad2c187c1c5d62169bc0a8470ff2560049f83f195642638bff4b91 (6MB)
>
> I admit to not knowing how to read that output, I've only ever seen
> thousands of lines of output from it on any filesystem., but hopefully you
> know how to grep out expected noise.
>
> But since we're talking about this, is btrfsck ever supposed to return clean
> on a clean filesystem?

Looks like I'm getting different results from btrfsck on the image. 
Still a ton of corruptions but complaints about different blocks.

Can you please use btrfs-map-logical to dump both copies of block
245432320 and send me the results?

-chris
