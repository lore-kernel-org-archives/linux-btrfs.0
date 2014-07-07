Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54483 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGJvs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 05:51:48 -0400
Received: by mail-pa0-f53.google.com with SMTP id ey11so5107666pad.26
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 02:51:48 -0700 (PDT)
Date: Mon, 7 Jul 2014 15:21:40 +0530
From: Vikram Goyal <vikigoyal@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi df'
 command
Message-ID: <20140707095140.GA7732@mail2.smcindiaonline.com>
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com>
 <20140704135226.GO1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20140704135226.GO1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 03:52:26PM +0200, David Sterba wrote:
>On Fri, Jul 04, 2014 at 04:38:49PM +0800, Qu Wenruo wrote:
>> 'btrfs fi df' command is currently able to be executed on any file/dir
>> inside btrfs since it uses btrfs ioctl to get disk usage info.
>>
>> However it is somewhat confusing for some end users since normally such
>> command should only be executed on a mount point.
>
>I disagree here, it's much more convenient to run 'fi df' anywhere and
>get the output. The system 'df' command works the same way.

Just to clarify, in case my earlier mail did not convey the idea
properly.

The basic difference between traditional df & btrfs fi df is that
traditional df does not errors out when no arg is given & <without an
arg> outputs all the mounted FSes with their mount points. So to be
consistent, btrfs fi df should output all BTRFSes with mount points if
no arg is given.

Btrfs fi df insists for an arg <path> but does not clarifies in its
output if the given arg is a path inside of a mount point or is the
mount point itself, which can become transparent, if the mount point is
also shown in the output.

This is a just a request & a pointer to an oversight/anomaly but if the
developers do not feel in resonance with it right now then I just wish
that they keep it in mind, think about it & remove this confusion caused
by btrfs fi df as,when & how they feel fit.

>
>The 'fi df' command itself is not that user friendly and the numbers
>need further interpretation. I'm using it heavily during debugging and
>restricting it to the mountpoint seems too artifical, the tool can cope
>with that.
>
>The 'fi usage' is supposed to give the user-friendly overview, but the
>patchset is stuck because I found the numbers wrong or misleading under
>some circumstances.
>
>I'll reread the thread that motivated this patch to see if there's
>something to address.

Thanks

-- 
vikram...
         ||||||||
         ||||||||
^^'''''^^||root||^^^'''''''^^
        // \\   ))
       //(( \\// \\
      // /\\ ||   \\
     || / )) ((    \\
-- 
Rule of Life #1 -- Never get separated from your luggage.
-- 
  _
 ~|~
  =
