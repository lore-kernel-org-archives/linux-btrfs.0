Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaGGPpO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jul 2014 11:45:14 -0400
Message-ID: <53BAC083.5020308@redhat.com>
Date: Mon, 07 Jul 2014 10:45:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi
 df' command
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com> <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com> <20140704135226.GO1553@twin.jikos.cz>
In-Reply-To: <20140704135226.GO1553@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/4/14, 8:52 AM, David Sterba wrote:
> On Fri, Jul 04, 2014 at 04:38:49PM +0800, Qu Wenruo wrote:
>> 'btrfs fi df' command is currently able to be executed on any file/dir
>> inside btrfs since it uses btrfs ioctl to get disk usage info.
>>
>> However it is somewhat confusing for some end users since normally such
>> command should only be executed on a mount point.
> 
> I disagree here, it's much more convenient to run 'fi df' anywhere and
> get the output. The system 'df' command works the same way.

I agree with that, and said as much in the original bug filed @Fedora.

-Eric
