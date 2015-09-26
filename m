Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33553 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbIZAZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 20:25:45 -0400
Received: by obbbh8 with SMTP id bh8so93712391obb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 17:25:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150922144518.GM12815@twin.jikos.cz>
References: <1441242317-16547-1-git-send-email-jmaggard@netgear.com>
	<20150922144518.GM12815@twin.jikos.cz>
Date: Fri, 25 Sep 2015 17:25:44 -0700
Message-ID: <CAKgsxVTfxtJGWeLpjDNTyYe1JanDsQiFN1UcpD+uXkatNj1Pow@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: qgroup: exit the rescan worker during umount
From: Justin Maggard <jmaggard10@gmail.com>
To: dsterba@suse.cz, Justin Maggard <jmaggard10@gmail.com>,
        BTRFS <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 7:45 AM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Sep 02, 2015 at 06:05:17PM -0700, Justin Maggard wrote:
>> v2: Fix stupid error while making formatting changes...
>
> I haven't noticed any difference between the patches, what exactly did
> you change?
>

I broke compiling while cleaning up some checkpatch.pl feedback.
Here's what changed between v1 and v2:

-       if (!btrfs_fs_closing(fs_info)) {
+       if (!btrfs_fs_closing(fs_info))


>> I was hitting a consistent NULL pointer dereference during shutdown that
>> showed the trace running through end_workqueue_bio().  I traced it back to
>> the endio_meta_workers workqueue being poked after it had already been
>> destroyed.
>>
>> Eventually I found that the root cause was a qgroup rescan that was still
>> in progress while we were stopping all the btrfs workers.
>>
>> Currently we explicitly pause balance and scrub operations in
>> close_ctree(), but we do nothing to stop the qgroup rescan.  We should
>> probably be doing the same for qgroup rescan, but that's a much larger
>> change.  This small change is good enough to allow me to unmount without
>> crashing.
>>
>> Signed-off-by: Justin Maggard <jmaggard@netgear.com>
>
> Can you please submit the test you've used to trigger the crash to
> fstests?
>

Sure, I've got a reproducer coded up for xfstests now.  Should I just
send that to this list, or is there a better place to send it?

-Justin
