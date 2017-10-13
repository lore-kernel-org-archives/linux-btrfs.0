Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:44889 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdJMV5E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 17:57:04 -0400
Received: by mail-lf0-f48.google.com with SMTP id 75so11076983lfx.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 14:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRney60+kqPn-9K_Efw1C-L5kMr4DXXwZTkq4==ivpQQg@mail.gmail.com>
References: <CAC+fKQXPGpwuhVz7oNLzPLd0ydo+kiqG1vpcWvx+-DZ+2jL6Bg@mail.gmail.com>
 <pan$2aa3b$47885ead$d44bbe7e$37d6c337@cox.net> <CAJCQCtRney60+kqPn-9K_Efw1C-L5kMr4DXXwZTkq4==ivpQQg@mail.gmail.com>
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Fri, 13 Oct 2017 23:57:02 +0200
Message-ID: <CAC+fKQXnzNxvQzbqxTM_D5hW0A_H3ji+4-Jt0HCqtri58XxE0A@mail.gmail.com>
Subject: Re: Btrfs warnings in kernel 4.13.5
To: Chris Murphy <lists@colorremedies.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-13 20:15 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
> On Fri, Oct 13, 2017 at 12:02 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Those warnings aren't anything to be /too/ worried about.  They are
>> triggered when a btrfs device size isn't a multiple of the btrfs
>> sectorsize (currently 4 KiB on amd64 aka x86_64).  You can manually
>> shrink your btrfs devices the fraction to an exact 4 KiB multiple, or
>> wait a bit, and a new release of btrfs-tools should have a command to do
>> it for you.
>
>
> So it's an open question now why it was created with a device size
> that isn't divisible by 4KiB. Seems like a bad idea to make it easy to
> create virtual block devices based on 512 byte divisions, as it makes
> it easy to end up with unaligned sectors at some point if one of the
> underlying devices is an AF 512e device. Was it manually created? Or
> was it created via the OS installer? Some time ago there was a feature
> proposal for the Fedora installer being able to create bcache and
> dmcache devices, but I haven't seen anything yet.


I'm sure I created all bcache devices with a block size of 4k.
