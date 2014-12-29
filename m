Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42411 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaL2P52 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 10:57:28 -0500
Date: Mon, 29 Dec 2014 10:57:14 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: 3.16.3: fs/btrfs/delayed-inode.c:1410
 btrfs_assert_delayed_root_empty
To: Marc MERLIN <marc@merlins.org>
CC: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <1419868634.13012.19@mail.thefacebook.com>
In-Reply-To: <20141229154144.GC17254@merlins.org>
References: <20141228192614.GO17254@merlins.org>
	<20141229010047.7f9b6d43@natsu> <20141228213606.GP17254@merlins.org>
	<1419866220.13012.18@mail.thefacebook.com>
	<20141229154144.GC17254@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 29, 2014 at 10:41 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Dec 29, 2014 at 10:17:00AM -0500, Chris Mason wrote:
>>  I've hit this recently on my laptop, and haven't yet been able to
>>  recreate it on a machine where I can debug things.  The messages are
>>  an error in the log tree replay code, and I don't think they are
>>  actually related to any corruptions.  Trying to nail it down today.
> 
> Thanks for the update and looking at it.
> 
> Just to rule things out for me, on your laptop, are you running btrfs
> directly on disk, or do you have layers like dmcrypt in the middle?
> (having 2 other layers myself, I never know if it's btrfs that could 
> be
> to blame, or the other 2 layers not passing data through in atomic 
> bits
> like they're supposed to)

I do have dmcrypt, but I really think this is only in btrfs.

-chris



