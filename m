Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:64380 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaCLQeh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 12:34:37 -0400
Received: by mail-ve0-f171.google.com with SMTP id cz12so10632075veb.30
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 09:34:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53207C4B.6020000@fb.com>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
	<20140307002549.GC16439@lenny.home.zabbo.net>
	<CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
	<53207C4B.6020000@fb.com>
Date: Wed, 12 Mar 2014 12:34:37 -0400
Message-ID: <CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Josef Bacik <jbacik@fb.com>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 12, 2014 at 11:24 AM, Josef Bacik <jbacik@fb.com> wrote:
> On 03/12/2014 08:56 AM, Rich Freeman wrote:
>>
>>  After a number of reboots the system became stable, presumably
>> whatever race condition btrfs was hitting followed a favorable
>> path.
>>
>> I do have a 2GB btrfs-image pre-dating my application of this
>> patch that was causing the issue last week.
>>
>
> Uhm wow that's pretty epic.  I will talk to chris and figure out how
> we want to deal with that and send you a patch shortly.  Thanks,

If you need any info from me at all beyond the capture let me know.

A tiny bit more background.  The system would boot normally, but panic
after about 30-90 seconds (usually long enough to log into KDE,
perhaps even fire up a browser/etc).  In single-user mode I could
mount the filesystem read-only without issue.  If I mounted it
read-write (in recovery mode or normally) I'd get the panic after
about 30-60 seconds.  On one occasion it seemed stable, but panicked
when I unmounted it.

I have to say that I'm impressed that it recovers at all.  I'd rather
have the file system not write anything if it isn't sure it can't
write it correctly, and that seems to be the effect here.  Just about
all the issues I've run into with btrfs have tended to be lockup/etc
type issues, and not silent corruption.

Rich
