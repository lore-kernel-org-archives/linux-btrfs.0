Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43207 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3JCSzI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Oct 2013 14:55:08 -0400
Received: by mail-bk0-f45.google.com with SMTP id mx11so1101933bkb.18
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 11:55:06 -0700 (PDT)
Message-ID: <1380826503.910.2.camel@lapchris>
Subject: Re: btrfs kernel bug while balancing
From: Christopher =?ISO-8859-1?Q?Kroo=DF?= <c.krooss@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 03 Oct 2013 20:55:03 +0200
In-Reply-To: <5B88DC80-8A9A-458C-9F02-FDD50FB73207@colorremedies.com>
References: <20131003203431.35b0b9b98d90c9324c941d11@gmail.com>
	 <5B88DC80-8A9A-458C-9F02-FDD50FB73207@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Do, 2013-10-03 at 12:50 -0600, Chris Murphy wrote:
> On Oct 3, 2013, at 12:34 PM, Christopher Krooß <c.krooss@gmail.com> wrote:
> 
> > Hi, I just encountered this kernel bug when I executed "btrfs balance start /". I'm sorry if this is not enough data but I couldn't save the log as my system didn't respond after the dmesg. It said "kernel bug" before the trace.
> > 
> > partial log: http://i.imgur.com/ygk3Nid.jpg
> 
> If it's kernel 3.11.0 through 3.11.4 it may be a known problem. I don't know if it adversely affects the file system. I'd either look at 3.12.0-rc3, or regress to 3.10.14 if you need to balance sooner than later. Or wait until several balance related fixes end up in 3.11.x (maybe 3.11.5).
> 
> If you aren't using a 3.11 kernel, it might be useful to know what version you are using.
> 
> Chris Murphy


Thanks for the info. I'm in fact running 3.11.3 so I'll just wait it
out. There were some csum errors after I rebooted, but it seems to just
be /var/log/journal.

Chris

