Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:33037 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbbFNEeU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jun 2015 00:34:20 -0400
Message-ID: <557D0447.6040506@shroop.net>
Date: Sat, 13 Jun 2015 21:34:15 -0700
From: Rich Rauenzahn <rich@shroop.net>
MIME-Version: 1.0
To: crocket <crockabiscuit@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: How do I make 'btrfs scrub' report errors via email?
References: <CAL0=0H19M7JG4o4p55Li3tF4PeA-UXb8mURcSOdPLwxfL0c1DQ@mail.gmail.com>
In-Reply-To: <CAL0=0H19M7JG4o4p55Li3tF4PeA-UXb8mURcSOdPLwxfL0c1DQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/13/2015 6:48 AM, crocket wrote:
> I can check the result of 'btrfs scrub' later, but I don't want to
> take time to actually check it.
> Does anyone know how to make 'btrfs scrub' report errors via email?
> It seems google doesn't know.

I use this job in /etc/cron.d/btrfs.scrub.cron :

0 0 * * fri root for dev in `mount | grep "type btrfs" | awk '{print 
$1}' | sort -u`; do  echo --------------------------; echo Scrubbing 
$dev :; echo --------------------------; /usr/sbin/btrfs scrub start -B 
$dev; done

I also use sec:

http://superuser.com/questions/789303/how-to-monitor-btrfs-filesystem-raid-for-errors


