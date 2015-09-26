Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36390 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbbIZLtV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 07:49:21 -0400
Received: by ioii196 with SMTP id i196so135357997ioi.3
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 04:49:20 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAKgsxVTfxtJGWeLpjDNTyYe1JanDsQiFN1UcpD+uXkatNj1Pow@mail.gmail.com>
References: <1441242317-16547-1-git-send-email-jmaggard@netgear.com>
	<20150922144518.GM12815@twin.jikos.cz>
	<CAKgsxVTfxtJGWeLpjDNTyYe1JanDsQiFN1UcpD+uXkatNj1Pow@mail.gmail.com>
Date: Sat, 26 Sep 2015 12:49:20 +0100
Message-ID: <CAL3q7H7cbybhgbx2P928Gpfyxn0DwiJ7_X9Mmt1uv=5shN99uQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: qgroup: exit the rescan worker during umount
From: Filipe Manana <fdmanana@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, BTRFS <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 26, 2015 at 1:25 AM, Justin Maggard <jmaggard10@gmail.com> wrote:
> On Tue, Sep 22, 2015 at 7:45 AM, David Sterba <dsterba@suse.cz> wrote:
>> On Wed, Sep 02, 2015 at 06:05:17PM -0700, Justin Maggard wrote:
>>> v2: Fix stupid error while making formatting changes...
>>
>> I haven't noticed any difference between the patches, what exactly did
>> you change?
>>
>
> I broke compiling while cleaning up some checkpatch.pl feedback.
> Here's what changed between v1 and v2:
>
> -       if (!btrfs_fs_closing(fs_info)) {
> +       if (!btrfs_fs_closing(fs_info))
>
>
>>> I was hitting a consistent NULL pointer dereference during shutdown that
>>> showed the trace running through end_workqueue_bio().  I traced it back to
>>> the endio_meta_workers workqueue being poked after it had already been
>>> destroyed.
>>>
>>> Eventually I found that the root cause was a qgroup rescan that was still
>>> in progress while we were stopping all the btrfs workers.
>>>
>>> Currently we explicitly pause balance and scrub operations in
>>> close_ctree(), but we do nothing to stop the qgroup rescan.  We should
>>> probably be doing the same for qgroup rescan, but that's a much larger
>>> change.  This small change is good enough to allow me to unmount without
>>> crashing.
>>>
>>> Signed-off-by: Justin Maggard <jmaggard@netgear.com>
>>
>> Can you please submit the test you've used to trigger the crash to
>> fstests?
>>
>
> Sure, I've got a reproducer coded up for xfstests now.  Should I just
> send that to this list, or is there a better place to send it?

Just send it to fstests@vger.kernel.org with the btrfs mailing list on
cc. If you take a look at test submission emails in the btrfs mailing
list, you'll see how it's usually done.

thanks

>
> -Justin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
