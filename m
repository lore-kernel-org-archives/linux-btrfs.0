Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59436 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2JaUAh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 16:00:37 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so948746eek.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 13:00:36 -0700 (PDT)
Date: Wed, 31 Oct 2012 21:00:32 +0100
From: Franke <ttfranke@googlemail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
Message-ID: <20121031210032.303c1c36@googlemail.com>
In-Reply-To: <50907514.3060400@oracle.com>
References: <20121031005736.306fd86b@googlemail.com>
	<50907514.3060400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

since yesterday I have run a balance while asleep/at work. Now I
experimented a bit, and the situation has changed.

I am now getting hard hangs ( system is gone without even writing
anything to syslog ), some time ( minutes to an hour ) into running a
scrub.

Those hangs happen with 3.6.2 , 3.6.4 and Jan's unstable version.
It hasn't hung yet without running a scrub.

I have no idea if this is part of the same problem or something else.
Do you have any idea either way?

I will probably destroy my btrfs and create a new one over the weekend,
unless you still need info for debugging.

thanks,
Tobias

On Wed, 31 Oct 2012 08:47:16 +0800
Liu Bo <bo.li.liu@oracle.com> wrote:

> On 10/31/2012 07:57 AM, Franke wrote:
> > Hello,
> > 
> > I have been having some crashes like this. Since I upgraded to
> > 3.6.4 they have become common. The crashes happen pretty randomly
> > during normal system usage. After the syslog messages the system
> > stays semi usable for a minute, but when I run any new program it
> > hangs. I had to downgrade to 3.6.2 to get my system usable again.
> > 
> > Is there any way I can help find the cause of those crashes? 
> > 
> 
> Hi Franke,
> 
> Jan and me have worked together to fix the mentioned bugs days
> before, and you can try Jan's git repo and see if it works in your
> situation:
> 
>           git.jan-o-sch.net for-chris
> 
> (It contains most of patches related to backref walking.)
> 
> thanks,
> liubo
> 
