Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.robertbuhren.de ([91.190.225.190]:33072 "EHLO
	mail.robertbuhren.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2HYIYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Aug 2012 04:24:49 -0400
Message-ID: <50388BBF.70903@robertbuhren.de>
Date: Sat, 25 Aug 2012 10:24:31 +0200
From: Robert Buhren <robert@robertbuhren.de>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs-progs: replace find_mount_root from send code
References: <5028D57F.5090803@robertbuhren.de> <1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net> <5035EFDE.4090404@robertbuhren.de> <20120824133348.GY17430@twin.jikos.cz>
In-Reply-To: <20120824133348.GY17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24.08.2012 15:33, David Sterba wrote:
> On Thu, Aug 23, 2012 at 10:54:54AM +0200, Robert Buhren wrote:
>> I'm on linux-3.6-rc2 and btrfs-progs from git.
> Please try it with Chris' for-linus branch, it contains a fair portion
> of send-related fixes and from brief look they may be related to the
> errors you see.
>
> david
Hi David,

i just tried it with a kernel from the "for-linus" branch. But i still 
get the same error.
Just to be sure:
You ment this branch: 
http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=shortlog;h=refs/heads/for-linus

right?


Regards,

Robert
