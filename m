Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64485 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMJIl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 05:08:41 -0400
Received: by gglu4 with SMTP id u4so208588ggl.19
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 02:08:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan.2012.06.13.07.23.04@cox.net>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
	<pan.2012.06.12.01.53.23@cox.net>
	<1477951.uUzcAEg64Z@when>
	<CAG1y0sfRE502A1vEGyNUz9O9XdNZ+iu4bKs0=OKsWGtoSZKT_w@mail.gmail.com>
	<pan.2012.06.13.07.23.04@cox.net>
Date: Wed, 13 Jun 2012 16:08:40 +0700
Message-ID: <CAG1y0setJcXT-ncyvQJhCeSdfRKXksx9azVHih7Tpe6UxGkMgQ@mail.gmail.com>
Subject: Re: Moving top level to a subvolume
From: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 2:23 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Fajar A. Nugraha posted on Wed, 13 Jun 2012 08:49:47 +0700 as excerpted:
>
>> As for "lose their filesystems", are there recent ones that uses one of
>> the three distros above, and is purely btrfs "fault"? The ones I can
>> remember (from the post to this list) were broken on earlier kernels, or
>> caused by bad disks.

> My system's old and has a bit of a problem with overheating in the
> Phoenix summer, so has been suffering SATA resets

> it's exactly this sort of
> corner-case that filesystems need to be able to deal with

IIRC XFS had corruption problems when used on top of LVM (or other
block device that doesn't support barriers correctly), while using
ext2/3/4 on the same block device will be "fine". Yet XFS doesn't have
the mark of "unstable, highly experimental, do not use". People simply
use the right (for them) fs for the right job.

My point is yes, btrfs is new. And it's being developed at much faster
rate than any other more-mature fs out there. And there are known
cases of data loss on certain configuration of corner cases/"buggy"
hardware and/or old version of kernel. But when used in the correct
environment, btrfs can be a good choice, even for critical data.

Of course IF the data were REALLY critical, and I REALLY need btrfs'
features, and it were on an enterprise environment, I would've bought
support from oracle linux (or SLES 12, when it's out, or whatever
enterprise distro supporting btrfs which sells support contract) so I
can have someone to turn to in case of problems, and (in some cases)
transfer the risk/blame :D

-- 
Fajar
