Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11093 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755882AbaICBCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 21:02:49 -0400
Message-ID: <540668AF.1060402@cn.fujitsu.com>
Date: Wed, 3 Sep 2014 09:02:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: cancel scrub/replace if the user space process
 receive SIGKILL.
References: <1407317662-9364-1-git-send-email-quwenruo@cn.fujitsu.com> <20140902110502.GC5888@twin.jikos.cz>
In-Reply-To: <20140902110502.GC5888@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: cancel scrub/replace if the user space 
process receive SIGKILL.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年09月02日 19:05
> On Wed, Aug 06, 2014 at 05:34:22PM +0800, Qu Wenruo wrote:
>> When impatient sysadmin is tired of waiting background running btrfs
>> scrub/replace and send SIGKILL to btrfs process, unlike
>> SIGINT/SIGTERM which can be caught by user space program and cancel the
>> scrub work, user space program will continue running until ioctl exits.
> I don't understand why it's needed to add another way to cancel scrub.
> Does it mean that 'btrfs scrub cancel' is not sufficient? It cancels
> both foreground and background scrub.  Same for dev-replace, it has the
> cancel subcommand.
Yes, 'scrub cacnel' is sufficient and it's what userspace calls when 
catching SIGINT.
I sent the user-space patch to fix the 'dev-replace cancel' signal 
handling and then consider
since SIGKILL can't be caught, it can't be handle in user-space so I 
then sent the kernel patch to handle it.

But if user-space can handle SIGINT correctly, the SIGKILL won't be 
sent, so the kernel patch can be ignored.

Thanks,
Qu
>
> Sending KILL signal to some random process is not the right way, how can
> the admin know to which filesystem the process belongs?
>
>> To keep it consistent with the behavior of btrfs-progs, which cancels
>> the work when SIGINT is received, this patch will make scrub routine to
>> check SIGKILL pending of current task and cancel the work if SIGKILL is
>> already pending.
> The foreground scrub starts a separate process and then wait()s.If you
> want to catch a SIGINT, then change it to a loop that checks for if the
> forked process exited or if Ctrl-c was pressed.

>
> The dev-replace can be started without a userspace process via
> kthread_run from btrfs_dev_replace_continue_on_mount, and sending
> signals to kernel processes requires some caution. For one, the signals
> have to be explicitly allowed. But before that I'd like to better
> understand where the SIGKILL is unavoidable.
>
> Thanks.

