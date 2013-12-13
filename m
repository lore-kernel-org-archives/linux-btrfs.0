Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39769 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752777Ab3LMSC3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 13:02:29 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:53200 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VrX4E-003ZIG-Jb
	for linux-btrfs@vger.kernel.org; Fri, 13 Dec 2013 11:02:27 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: moving a subvol
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAGvEgFHg-wO4BM9imQA9EpkMSLaEREchb9LBKXHkfFUPWwbfzQ@mail.gmail.com>
Date: Fri, 13 Dec 2013 11:02:26 -0700
Message-Id: <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com>
References: <52AB30D4.7050408@czarc.net> <52AB3673.1030607@czarc.net> <27814825-5AD6-4AA3-A286-D258D62CAB0C@colorremedies.com> <CAGvEgFHg-wO4BM9imQA9EpkMSLaEREchb9LBKXHkfFUPWwbfzQ@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 13, 2013, at 10:37 AM, Cobin Bluth <cbluth@gmail.com> wrote:
> That seems a little less intuitive than one would think. I wonder if there would an argument to specify read-write for btrfs-receive.

I'm going to guess it's on purpose to prevent writes from happening in the subvolume while it's still being received. The send file is a stream so my interpretation of what's going on is that subvolume's file system isn't really in a state to be modified until it's completely done being written. And for that matter, it's the same thing with sending. The wiki says send requires subvolumes to be ro, and all of the examples there are ro subvolumes.

I don't know that this is an apt analogy, but think of dd'ing a partition that contains a live mounted volume. Oops - not a good idea right? Because as you dd the first part, the uncopied portion is being modified and is now inconsistent. 

Chris Murphy