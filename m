Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3CMNry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 09:47:54 -0400
Message-ID: <5140837A.70409@redhat.com>
Date: Wed, 13 Mar 2013 08:47:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
CC: russell@coker.com.au, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Debian 3.7.1 BTRFS crash
References: <201303131238.33692.russell@coker.com.au> <513FDE67.1050907@redhat.com> <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
In-Reply-To: <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/13/13 12:07 AM, Jérôme Poulin wrote:
> On Tue, Mar 12, 2013 at 10:03 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> [   37.176790] BTRFS error (device dm-0) in __btrfs_free_extent:5143: IO failure
>> [   37.176791] btrfs is forced readonly
>> [   37.176793] btrfs: run_one_delayed_ref returned -5
>>
> 
> 
> It seems the SSD has bad blocks now, BTRFS seems to abuse SSD disks, I
> burnt 1 SSD disk and 2 USB flash drive since I'm using BTRFS, in about
> 2 months for each. ddrescue'ing the SSD would probably give better
> chances of recovery and give BTRFS/btrfsck a chance to write correctly
> to the newly copied image.

On what do you base that theory?  I suppose it could be, but nothing
in the logs necessarily suggests that.  The "IO failure" is because 
the fs shut down, went readonly, and subsequent IOs got -EIO,
I think.

-Eric

