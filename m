Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:32929 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab2JKSiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 14:38:16 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1462951lag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2012 11:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121011145601.GA29841@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
	<50733D66.5020600@gmx.net>
	<20121009111830.GC31743@campbell-lange.net>
	<CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
	<20121010221107.GA19266@campbell-lange.net>
	<CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
	<20121011113359.GD22640@campbell-lange.net>
	<CAOcd+r3E=vhtHwenmHbqV_i3FN5e4rK0x+CkOOHz3WHKVAQi1A@mail.gmail.com>
	<20121011145601.GA29841@campbell-lange.net>
Date: Thu, 11 Oct 2012 20:38:14 +0200
Message-ID: <CAOcd+r2tj6O=6c2jbiykg5tDNHZApZ2t53Q0YZ-oPX+T2fFcXQ@mail.gmail.com>
Subject: Re: btrfs receive to subdirectory
From: Alex Lyakas <alex@zadarastorage.com>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Rory,
my kernel is slightly different, but the send-receive kernel code that
I use is on the same commit. However, the issue you are hitting is
most probably not a kernel issue. The receive part works totally in
user-space. To confirm that, maybe you can post somewhere the full-
and diff-streams that you generate: instead of piping to "btrfs
receive", pls redirect it into some file (like /tmp/full_stream and
/tmp/diff_stream) and post the files. Not sure how sensitive is the
content of your files or how big the stream is - it might be not
possible for you to do this.

I suspect there is some issue with finding subvolume paths relative to
your mount root.
If possible, pls post "cat /proc/mounts" and also the output of "mount" command.

Finally, it might be useful to post strace outputs of the failing
receives. To do this, please redirect the stream into some file first,
and then receive from this file (and not in one step like you are
doing) under strace.

Next step, I will probably send you a patch with some prints. Hope in
a few iterations we can find the issue (unless you give up:).

Thanks,
Alex.


On Thu, Oct 11, 2012 at 4:56 PM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:
> On 11/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
>> Hi Rory,
>> all your tests work perfectly for me (really, I swear:)), with exact
>> same mount points and subvol/snap/dir names.
>> Just to make that the patch some how did not get messed up in the
>> mail, I attach it.
>
> ... happy to try things further. Please confirm your btrfs/kernel
> version. I'm on
>
>     5c4e935f44e1aace28988fdc06f233ef5c184103 refs/heads/send-recv
>
> Cheers
> Rory
>
> --
> Rory Campbell-Lange
> rory@campbell-lange.net
>
> Campbell-Lange Workshop
> www.campbell-lange.net
> 0207 6311 555
> 3 Tottenham Street London W1T 2AF
> Registered in England No. 04551928
