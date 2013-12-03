Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:51109 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3LCS2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 13:28:25 -0500
Received: by mail-we0-f178.google.com with SMTP id u57so8199631wes.37
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 10:28:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131203164344.GW25312@twin.jikos.cz>
References: <20131129154525.GN25312@twin.jikos.cz>
	<CAL3q7H7CmaKsnQQacpZck3zGV35ikhTwqX=Xg9eAiM97kb5TwA@mail.gmail.com>
	<20131203164344.GW25312@twin.jikos.cz>
Date: Tue, 3 Dec 2013 10:28:24 -0800
Message-ID: <CAEzrpqfGNbFQ8wG7SWVJOp3pM3BwfAdO79VrOK-t9JiUFNCkUQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: optimize btrfs_lookup_extent_info() - extent
 refcount mismatches?
From: Josef Bacik <josef@toxicpanda.com>
To: David Sterba <dsterba@suse.cz>, Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        clm@fb.com, jbacik@fb.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 3, 2013 at 8:43 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Nov 29, 2013 at 07:55:37PM +0000, Filipe David Manana wrote:
>> On Fri, Nov 29, 2013 at 3:45 PM, David Sterba <dsterba@suse.cz> wrote:
>> > Hi,
>> >
>> > On Fri, Jul 05, 2013 at 09:32:05PM +0100, Filipe David Borba Manana wrote:
>> >> If we're looking for a metadata item in the tree and the
>> >> search fails with return value of 1, and the slot doesn't
>> >> point to the first item in the leaf, check if the previous
>> >> item in the leaf corresponds to an extent item for the same
>> >> object id - if it does, then don't do another tree search
>> >> to get it.
>> >
>> > I'm suspecting this patch to cause some trouble, see
>> > https://bugzilla.kernel.org/show_bug.cgi?id=64961
>>
>> What makes you believe the problem is exactly in this function?
>
> It was a first guess based on the stacktraces and last patch that
> touched the code. I've replied to mailinlist because it has higher
> visibility, number of bugreports in balance/relocation has been
> increasing lately (not blaming you).
>
>> I read it again, and I can't see how it can miss an extent item that
>> it couldn't before, specially without skinny metadata enabled.  Did
>> the fs had skinny metadata enabled?
>
> According to the updated bugzilla yes, and that's another possible
> cause although we haven't seen bugs with skinny metadata yet. There's
> another bugreport that has them enabled,
> https://bugzilla.kernel.org/show_bug.cgi?id=66411
>

I've been seeing similar issues while testing my qgroups patches that
I don't think is related to my qgroup work.  I'm going to try and
track it down this week but I may not get to it until next week.
Thanks,

Josef
