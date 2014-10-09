Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaJIPsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 11:48:15 -0400
Message-ID: <5436AD4C.8060204@redhat.com>
Date: Thu, 09 Oct 2014 10:44:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <54367193.6000202@gmail.com>	<pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>	<20141009053402.7dc286f0@ws> <54368B1E.4040901@gmail.com> <pan$be94c$47b1139c$477c562b$8f545371@cox.net>
In-Reply-To: <pan$be94c$47b1139c$477c562b$8f545371@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/9/14 8:49 AM, Duncan wrote:
> Austin S Hemmelgarn posted on Thu, 09 Oct 2014 09:18:22 -0400 as
> excerpted:
> 
>> On 2014-10-09 08:34, Duncan wrote:
> 
>>> The only way a read-only
>>> mount should be writable is if it's mounted (bind-mounted or
>>> btrfs-subvolume-mounted) read-write elsewhere, and the write occurs to
>>> that mount, not the read-only mounted location.
> 
>> In theory yes, but there are caveats to this, namely:
>> * atime updates still happen unless you have mounted the fs with noatime

Getting off the topic a bit, but that really shouldn't happen:

#define IS_NOATIME(inode)       __IS_FLG(inode, MS_RDONLY|MS_NOATIME)

and in touch_atime():

        if (IS_NOATIME(inode))
                return;

-Eric
