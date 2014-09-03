Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52997 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbaICBRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 21:17:35 -0400
Message-ID: <54066C22.6070307@cn.fujitsu.com>
Date: Wed, 3 Sep 2014 09:17:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: make 'btrfs replace' signal-handling works.
References: <1407287827-28694-1-git-send-email-quwenruo@cn.fujitsu.com> <20140902112518.GD5888@twin.jikos.cz>
In-Reply-To: <20140902112518.GD5888@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: make 'btrfs replace' signal-handling 
works.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年09月02日 19:25
> On Wed, Aug 06, 2014 at 09:17:07AM +0800, Qu Wenruo wrote:
>> Current BTRFS_IOC_DEV_REPLACE ioctl is synchronous, and during the ioctl
>> program is fallen into kernel and unable to handle signal, the original
>> signal function will never be executed until the dev replace is done.
>> This is very annoying for someone who wants to stop dev replace by
>> Ctrl-c (we have to admit that's the most users will do when replacing
>> dev with nodatacow/nodatasum mount option).
>>
>> This patch will create a thread to do the ioctl things, making the main
>> thread able to handle signal correctly.
> As described under the kernel patch, I'd like to use the respective
> cancel ioctls instead of signals.
I think I didn't describe it clear in the patch, the patch still uses 
cancel ioctl to cancel the dev-replace,
it just makes the original dev_replace_handle_sigint() function get 
called correctly.
(Before the patch, it will only be called after the ioctl is done, not 
when Ctrl-C is pressed, as explained in patch)

If you mean 'dev-replace cancel' is correct way Ctrl-C should not be 
used, then I can only agree with the first half.
Ctrl-C is almost a conditioned response for most people if they want to 
stop some program,
due to the principle of least astonishment, I think the SIGINT handling 
is still useful for most sysadmin.

Thanks,
Qu


