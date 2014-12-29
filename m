Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:53681 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaL2VNJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 16:13:09 -0500
Received: by mail-yk0-f172.google.com with SMTP id 131so6721564ykp.17
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 13:13:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
Date: Mon, 29 Dec 2014 14:13:08 -0700
Message-ID: <CAJCQCtTYektPvzvbr8UQNpNNLxDuN3DGBta+SaBayPq1vekCrQ@mail.gmail.com>
Subject: Re: I need to P. are we almost there yet?
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By asking the question this way, I don't think you understand how
Btrfs development works. But if you check out the git pull for 3.19
you'll see a bunch of patches that pretty much close the feature
parity (no pun intended) gap for raid56 and raid0,1,10. But it is an
rc, and still needs testing, and even once 3.19 becomes a stable
kernel it's new enough code there can always be edge cases. And raid1
has been tested in Btrfs for how many years now? So if you want the
same amount of raid6 testing by time it would be however many years
that's been from the time 3.19 is released.

Chris Murphy
