Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56843 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579AbaFXPke convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 11:40:34 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAB=7dh=KejR8HH-uEt0-D8WffEJYOpRop_UVY_CDYQeM9UMZjQ@mail.gmail.com>
Date: Tue, 24 Jun 2014 09:40:31 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <E57F7583-D093-4B00-B665-536130EB3C7F@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com> <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <53A8E079.1060803@cn.fujitsu.com> <CAB=7dhm4wz7tXm7am0ezNvAiH+YjKBYrL53AQsn9DMQJwaus4Q@mail.gmail.com> <53A8EBEB.1030702@cn.fujitsu.com> <CAB=7dh=KejR8HH-uEt0-D8WffEJYOpRop_UVY_CDYQeM9UMZjQ@mail.gmail.com>
To: Mike Hartman <mike@hartmanipulation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 23, 2014, at 11:39 PM, Mike Hartman <mike@hartmanipulation.com> wrote:
>> 
>> https://github.com/kdave/btrfs-progs.git  integration-20140619
> 
> Thanks. I pulled that version and retried everything in my original
> transcript, including the "btrfs check --init-csum-tree
> --init-extent-tree". Results are identical across the board.

Does this version's btrfs-image allow you to make an image of the file system?


Chris Murphy

