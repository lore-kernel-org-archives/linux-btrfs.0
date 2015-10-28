Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:8256
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965253AbbJ1K3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 06:29:37 -0400
From: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
To: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Questions about FIEMAP
Date: Wed, 28 Oct 2015 09:57:29 +0000
Message-ID: <CY1PR10MB0428CCC32D899CB0405B29ACE4210@CY1PR10MB0428.namprd10.prod.outlook.com>
References: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
 <561BB531.6070706@redhat.com>
In-Reply-To: <561BB531.6070706@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you all for your comments.

A further question is: if I mount a btrfs file system in "readonly" mode, will any operation cause the blocks of a file get changed?


Regards
Mike



-----Original Message-----
From: Eric Sandeen [mailto:sandeen@redhat.com] 
Sent: Monday, October 12, 2015 9:27 PM
To: Wang, Zhiye; linux-btrfs@vger.kernel.org
Subject: Re: Questions about FIEMAP

On 10/11/15 11:37 PM, Wang, Zhiye wrote:
> Hello everyone,
> 
> After googled a bit, I got information that btrfs supports FIEMAP (as "cp" needs it), but it's not valid for "write" operation.

cp should not be using fiemap any more.  It was for a while, until they realized that copying based on fiemap output could lead to corruption because things changed between the fiemap call and the actual copy...

> I guess we cannot write to block device directly after get block list using FIEMAP. This is because:
> 
> 1. COW feature of btrfs (but this can be disabled using NOCOW) 2. File 
> system rebalance 3. Defragmentation
> 
> Aren't item #2 and #3 also a problem for "read" operation? For example, after "cp" get block list using FIEMAP, file system rebalance occurs, So, previous result of FIEMAP is not valid anymore.
> 
> Or maybe I misunderstood something. Please correct me.

That all may be true for btrfs, but more fundamentally as dsterba said, nothing guarantees that the layout won't change *immediately* after your fiemap call.  This is the case on any filesystem, not just btrfs.

-Eric

