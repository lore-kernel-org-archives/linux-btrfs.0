Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50734 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3FVLCZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 07:02:25 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so3663416bkc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jun 2013 04:02:24 -0700 (PDT)
Date: Sat, 22 Jun 2013 14:02:23 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Tim Castle <timcastle@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance resume + raid5/6
Message-ID: <20130622110223.GA2021@zambezi.lan>
References: <loom.20130616T072808-446@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20130616T072808-446@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 16, 2013 at 06:00:10AM +0000, Tim Castle wrote:
> Greetings! 
> 
> I'm testing raid6, and recently added two drives. 
> I haven't been able to properly resume a balance operation: the number of
> total chunks is always too low.  
> 
> It seems that the balance starts and pauses properly, but always resumes
> with ~7 chunks. 

Hi Tim,

This is the expected behaviour.  Balance does not actually remember
which chunks it had processed before it was paused, instead it uses a
heuristic which is based on the amount of space used out of each chunk.
As you have an almost full filesystem, all of your chunks, except for
those ~7, are fully (or almost fully) used, and balance resume simply
skips them.  If you really want to balance everything (why?) you would
have to run balance to completion, w/o pausing it.

Thanks,

		Ilya
