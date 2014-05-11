Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36865 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbaEKB67 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 21:58:59 -0400
Date: Sat, 10 May 2014 18:59:05 -0700
From: David Brown <davidb@davidb.org>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub
Message-ID: <20140511015905.GA29448@davidb.org>
References: <20140510235717.GB15909@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20140510235717.GB15909@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 10, 2014 at 04:57:18PM -0700, Marc MERLIN wrote:

>On Fri, May 09, 2014 at 11:39:13AM -0700, Anacron wrote:
>> /etc/cron.daily/btrfs-scrub:
>> scrub device /dev/mapper/cryptroot (id 1) done
>> 	scrub started at Fri May  9 06:09:14 2014 and finished after 19153 seconds
>> 	total bytes scrubbed: 646.15GiB with 0 errors
>
>So, does scrub actually make sure everything on my filesystem is sane,
>or can it miss some kinds of corruptions?

Does scrub make sure _anything_ on the filesystem is sane?  I guess it
would detect some failures because the tree is incorrect, but I
thought scrub was mostly about making sure the data match the
checksums.

Just curious, the future "online filesystem check", will that be part
of scrub, or another command.  It seems like it would be common to
want a faster integrity check that doesn't have to read all of the
data as well.

David
