Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:42876 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaHaSHj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 14:07:39 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: add -k option to filesystem df
References: <or61h94yvf.fsf@free.home>
	<CAH-HCWX49Rw6psFtbUP+ohWMQVBLuOYLwBz0q46hvrGytJzhCA@mail.gmail.com>
Date: Sun, 31 Aug 2014 15:07:32 -0300
In-Reply-To: <CAH-HCWX49Rw6psFtbUP+ohWMQVBLuOYLwBz0q46hvrGytJzhCA@mail.gmail.com>
	(Shriramana Sharma's message of "Sun, 31 Aug 2014 05:48:33 +0530")
Message-ID: <or1trw4job.fsf@free.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Aug 30, 2014, Shriramana Sharma <samjnaa@gmail.com> wrote:

> But somehow I feel the name of the long option could be made better than
> --kbytes which is not exactly descriptive of what it accomplishes. IIUC so
> far only bytes are displayed right?

kbytes displays KiBs, whereas the preexisting code chooses a magnitude
most suitable to present the size in a human-friendly way.  I'd be happy
to drop the long option, to follow GNU df's practice: there's no long
option (without arguments) equivalent to -k there.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
