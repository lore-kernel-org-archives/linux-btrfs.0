Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34170 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbcDEDoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 23:44:07 -0400
Received: by mail-ob0-f179.google.com with SMTP id bg3so1132529obb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 20:44:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
	<pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
Date: Tue, 5 Apr 2016 13:44:05 +1000
Message-ID: <CA+WRLO_fkZWsZJFdvMQud1aMTR7kErJVxr9JT0vNpjhQrh2e2Q@mail.gmail.com>
Subject: Re: Scrub priority, am I using it wrong?
From: Gareth Pye <gareth@cerberos.id.au>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 5, 2016 at 12:37 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 1) It appears btrfs scrub start's -c option only takes numeric class, so
> try -c3 instead of -c idle.


Does it count as a bug if it silently accepts the way I was doing it?

I've switched to -c3 and at least now the idle class listed in iotop
is idle, so I hope that means it will be more friendly to other
processes.

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
