Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-2.smtp-out.eu-west-1.amazonses.com ([54.240.4.2]:58850 "EHLO
        a4-2.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751320AbdJSMOn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 08:14:43 -0400
Subject: Re: 4.13: "error in btrfs_run_delayed_refs:3009: errno=-28 No space
 left" with 1.3TB unallocated / 737G free?
To: Vladimir Panteleev <thecybershadow@gmail.com>, 1i5t5.duncan@cox.net,
        linux-btrfs@vger.kernel.org
References: <pan$7012a$2aa3b3f4$9c2bb50d$e909647e@cox.net>
 <0caa6041-8ba6-52f6-950e-f07ee0470b63@gmail.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015f348e9867-37a2530c-b78e-4efb-9528-d13136194eae-000000@eu-west-1.amazonses.com>
Date: Thu, 19 Oct 2017 12:14:41 +0000
MIME-Version: 1.0
In-Reply-To: <0caa6041-8ba6-52f6-950e-f07ee0470b63@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19.10.2017 10:16 Vladimir Panteleev wrote:
> On Tue, 17 Oct 2017 16:21:04 -0700, Duncan wrote:
>> * try the balance on 4.14-rc5+, where the known bug should be fixed
>
> Thanks! However, I'm getting the same error on
> 4.14.0-rc5-g9aa0d2dde6eb. The stack trace is different, though:
>
> Aside from rebuilding the filesystem, what are my options? Should I
> try to temporarily add a file from another volume as a device and
> retry the balance? If so, what would be a good size for the temporary
> device?
>
Hi,

for me a work-around for something like this has been to reduce the
amount of dirty memory via e.g.

sysctl vm.dirty_background_bytes=$((100*1024*1024))
sysctl vm.dirty_bytes=$((400*1024*1024))

this reduces performance, however. You could also mount with
"enospc_debug" to give the devs more infos about this issue.
I am having more ENOSPC issues with 4.9.x than with the latest 4.14.

Regards,
Martin

