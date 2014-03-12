Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:63626 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCLM4L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 08:56:11 -0400
Received: by mail-ve0-f173.google.com with SMTP id oy12so10193443veb.32
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 05:56:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140307002549.GC16439@lenny.home.zabbo.net>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
	<20140307002549.GC16439@lenny.home.zabbo.net>
Date: Wed, 12 Mar 2014 08:56:10 -0400
Message-ID: <CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Zach Brown <zab@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 6, 2014 at 7:25 PM, Zach Brown <zab@redhat.com> wrote:
> On Thu, Mar 06, 2014 at 07:01:07PM -0500, Josef Bacik wrote:
>> Zach found this deadlock that would happen like this
>>
>
> And this fixes it.  It's run through a few times successfully.

I'm not sure if my issue is related to this or not - happy to start a
new thread if not.  I applied this patch as I was running into locks,
but I am still having them.

See: http://picpaste.com/IMG_20140312_072458-KPH35pQ6.jpg

After a number of reboots the system became stable, presumably
whatever race condition btrfs was hitting followed a favorable path.

I do have a 2GB btrfs-image pre-dating my application of this patch
that was causing the issue last week.

Rich
