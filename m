Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932720Ab3AJD0F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 22:26:05 -0500
Message-ID: <50EE3492.4030704@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 11:25:06 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 0/2] send: Avoid sending disknr==0 and PREALLOC extents
 when possible
References: <CAOcd+r1VfBCRmDptpp47CLDAbH-o+NpAQxx42ou5JVG-hfM0PA@mail.gmail.com>
In-Reply-To: <CAOcd+r1VfBCRmDptpp47CLDAbH-o+NpAQxx42ou5JVG-hfM0PA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Alex
The patches can only solve part of questions, but some like "punch holes" problems 
as Alexander wrote are still unsolved. So I think these patches are unnecessary
if adding new command would help to solve all the questions.

Chen.

On 2013-1-9 4:11, Alex Lyakas wrote:
> These two patches address the issue of sending unneeded zero data for
> disknr==0 and PREALLOC extents.
> There is room for additional improvement for PREALLOC extents, but it
> requires adding a new command, so for
> now this is not addressed.
> 
> Please review and comment.
> 
> Thanks,
> Alex.
> 
> Alex Lyakas (2):
>   Avoid sending disknr==0 extents in the following cases:     1) full
>     send 2) new inode in a diff-send 3) when disknr==0 extents are
>     added to the end of an inode
>   On a diff-send, avoid sending PREALLOC extents, if the parent root
>     has only     PREALLOC extents on an appropriate file range.
> 
>  fs/btrfs/send.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 172 insertions(+), 6 deletions(-)
> 
> --
> 1.7.9.5
> 

