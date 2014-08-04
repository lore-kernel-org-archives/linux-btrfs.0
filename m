Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58790 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751259AbaHDQ1N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 12:27:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unrecoverable errors when the btrfs file system was modified outside the running OS
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
Date: Mon, 4 Aug 2014 10:27:11 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <30ECDD3D-6680-4A38-9582-36AD082701BF@colorremedies.com>
References: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
To: rocwhite168 <rocwhite168@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 4, 2014, at 12:29 AM, rocwhite168 <rocwhite168@163.com> wrote:

> Hello,
> 
> I just had a very frustrating experience with btrfs, which I was only
> able to resolve by rolling back to ext4 using the subvol btrfs-convert
> created. The same type of situation occurred before when I was using
> the ext file system and the result was far less disastrous.

The recoverability of a filesystem after it's been used simultaneously by two computers can't be a useful metric. This is so highly non-deterministic I just don't buy the one off comparison of two filesystems' survival rates.

This is sort of in the realm of if you're going to slam doors, make really certain first there aren't any fingers near the door frame.



Chris Murphy

