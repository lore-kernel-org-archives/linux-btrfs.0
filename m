Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32817 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2EaTmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 15:42:46 -0400
Received: by eeit10 with SMTP id t10so628655eei.19
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 12:42:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120530210905.GD1887@localhost.localdomain>
References: <CAHg_5go6zYdWUspTxRSWNFTtrxxr1=AZh2OaT3GW_wGwnV1Y7g@mail.gmail.com>
 <20120530210905.GD1887@localhost.localdomain>
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 31 May 2012 21:42:25 +0200
Message-ID: <CAHg_5gpF4GRdHrXZ-6tEnhZgyKwg7H4BbgtYnXXCxaMWcJytVA@mail.gmail.com>
Subject: Re: Very slow mount
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2012 at 11:09 PM, Josef Bacik <josef@redhat.com> wrote:
> Hrm well being on root makes it hard to figure out what is going on.  The mount
> stuff is all in reads but who knows whats going on.  Can you do bootchart so I
> can see what threads are spawned, maybe the old caching stuff is getting tripped
> for some reason.

You can find the result of running bootchart here:
http://ctrlv.in/89812

> The next thought is to boot up with a rescue disk and mount
> while running latencytop -c (you'll need this patch
> http://oss.oracle.com/~mason/latencytop.patch) and post the output somewhere so
> we can see it.

I downloaded a daily snapshot of openSUSE Factory and booted that, it
has kernel 3.4.0. Mounting took less than 10 seconds but probably
still too much:

linux:/home/linux # time mount
-onoatime,space_cache,inode_cache,autodefrag,compress=lzo -t btrfs
/dev/sda8 /mnt/

real 0m3.769s
user 0m0.005s
sys 0m0.273s

Latencytop output is at:
https://gist.github.com/2845725

Thanks for your help,
Catalin
