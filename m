Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22634 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750780AbbD2UWC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 16:22:02 -0400
Message-ID: <55413D65.4000204@fb.com>
Date: Wed, 29 Apr 2015 16:21:57 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH] Revert "btrfs: delete chunk allocation attemp when setting
 block group ro"
References: <c99a895bc0facef23387ef7b44c98c0df41216fa.1429431096.git.osandov@osandov.com> <20150429182409.GA23155@mew.dhcp4.washington.edu>
In-Reply-To: <20150429182409.GA23155@mew.dhcp4.washington.edu>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/29/2015 02:24 PM, Omar Sandoval wrote:
> On Sun, Apr 19, 2015 at 01:17:05AM -0700, Omar Sandoval wrote:

>> Holger reported this awhile ago and I haven't seen a proper fix make it
>> to the ML. I messed around with it for awhile and came up empty, but I
>> figured I might as well send this in. Applies to v4.0.
>>
>>  fs/btrfs/extent-tree.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
> 
> Has another fix for this shown up yet? Currently 4.0 and up can't
> convert between data/metadata profiles, which seems like a pretty major
> regression.
> 

I've got a fix in testing here, I'll get it out the door.

-chris


