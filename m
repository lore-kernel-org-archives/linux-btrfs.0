Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3JKPVj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 11:21:39 -0400
Message-ID: <5258177F.7080003@redhat.com>
Date: Fri, 11 Oct 2013 10:21:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Emil Karlson <jekarlson@gmail.com>
CC: Duncan <1i5t5.duncan@cox.net>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG relating to fstrim on btrfs partitions
References: <20131010102043.74230@gmx.com> <pan$d3f39$3d6ac9b9$db7362c7$80c1ae2b@cox.net> <52580EE5.8090408@redhat.com> <CAELSAVYqeoj=SoaqtVENxfVjv10ZmFOruHNe6pGCjtkTGy8=WQ@mail.gmail.com>
In-Reply-To: <CAELSAVYqeoj=SoaqtVENxfVjv10ZmFOruHNe6pGCjtkTGy8=WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/11/13 10:14 AM, Emil Karlson wrote:
>> If the filesystem is clever enough to know that the range in question has
>> not been written to since the last discard, then it takes no action, and
>> reports zero bytes.
> 
> File system images can be rewritten on a new media so there is a
> drawback to that.

It's in-memory for the mounted filesystem, not on disk.

It checks the EXT4_GROUP_INFO_WAS_TRIMMED_BIT flag stored in bb_state
in the ext4_group_info structure.

So when you mount a dd'd copy, it takes a fresh look, and DTRT.

-Eric

> Best Regards
> -Emil
> 

