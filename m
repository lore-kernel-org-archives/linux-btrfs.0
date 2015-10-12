Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbbJLN1P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:27:15 -0400
Subject: Re: Questions about FIEMAP
To: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <561BB531.6070706@redhat.com>
Date: Mon, 12 Oct 2015 08:27:13 -0500
MIME-Version: 1.0
In-Reply-To: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/11/15 11:37 PM, Wang, Zhiye wrote:
> Hello everyone,
> 
> After googled a bit, I got information that btrfs supports FIEMAP (as "cp" needs it), but it's not valid for "write" operation.

cp should not be using fiemap any more.  It was for a while, until they realized that copying based on fiemap output could lead to corruption because things changed between the fiemap call and the actual copy...

> I guess we cannot write to block device directly after get block list using FIEMAP. This is because:
> 
> 1. COW feature of btrfs (but this can be disabled using NOCOW)
> 2. File system rebalance
> 3. Defragmentation
> 
> Aren't item #2 and #3 also a problem for "read" operation? For example, after "cp" get block list using FIEMAP, file system rebalance occurs, So, previous result of FIEMAP is not valid anymore.
> 
> Or maybe I misunderstood something. Please correct me.

That all may be true for btrfs, but more fundamentally as dsterba said, nothing guarantees that the layout won't change *immediately* after your fiemap call.  This is the case on any filesystem, not just btrfs.

-Eric

