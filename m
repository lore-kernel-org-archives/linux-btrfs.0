Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:51908 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2F0Soh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 14:44:37 -0400
Received: by qcmt36 with SMTP id t36so962998qcm.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 11:44:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFwScO8xtn39pkQkT-w3vRHjuxMytbqiFF++NKxa9A8eUunh_w@mail.gmail.com>
References: <CAFwScO_ENB2tDKpXozCqz09PjH6sCRvDCB-Pr2XJSy2HTerwFQ@mail.gmail.com>
	<20120627143110.GU28144@twin.jikos.cz>
	<CAFwScO8xtn39pkQkT-w3vRHjuxMytbqiFF++NKxa9A8eUunh_w@mail.gmail.com>
Date: Wed, 27 Jun 2012 13:44:36 -0500
Message-ID: <CAFwScO9jwvjMarFPCTq78ePxdG=XcyTz1sRZnPKGjNE0HVLwdA@mail.gmail.com>
Subject: Re: waiting for deferred cleanup operations
From: David Nicol <davidnicol@gmail.com>
To: dave@jikos.cz, David Nicol <davidnicol@gmail.com>,
        BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

silly gmail rich-text...

On Wed, Jun 27, 2012 at 1:42 PM, David Nicol <davidnicol@gmail.com> wrote:
>
>
>
> On Wed, Jun 27, 2012 at 9:31 AM, David Sterba <dave@jikos.cz> wrote:
>>
>> On Tue, Jun 26, 2012 at 08:55:20PM -0500, David Nicol wrote:
>> > [let's discuss the] architecture
>
>
>>
>> Simply waiting is not enough, I've seen cleaner or defrag on a root
>> subvol running for days. A way to cancel the operations would be more
>> useful here. This asks for a more generic interface for threads that do
>> not yet have their own control ioctls (like scrub or balance).
>>
>> I've counted these:
>>
>> * defrag - triggered by 'btrfs fi defrag'
>> * device add - this holds the uuid mutex and the same mutex is needed
>>               for mkfs which blocks
>> * device del - dtto, plus it needs fully cancellable balance/relocation
>> * cleaner
>> * free space / inode cache writeout
>>
>> the criterias are whether the operation blocks umount, ro-remount or
>> other filesystem-wide operations (like mkfs) or generally slows down the
>> throughput.
>>
>
> Five subsystems at one bit each
>
>
>>
>> The set of operations on the threads:
>>
>> * wait
>> * pause - eg. when cleaner activity is not desired atm
>> * cancel - either Ctrl-C/kill -9 or separate command via 'btrfs'
>> * resume - explicitly wake the thread and let it continue or just check
>>           for work
>> * status - paused/active/idle
>
>
> Five mutually exclusive action codes : three bits, allowing three reserved
> action codes
>
>
>>
>> I don't know if you'd want to implement this in full, I guess not.
>
>
> Sure! In fact it could even be backwards-compatible with the proposed bit
> protocol, mostly. The installed base is AFAIK all under one administration,
> so backwards-compatibility isn't that important.
>
> The new protocol could be made which would be clearer:
>
> Three bits for action code,
> five bits for subsystem selection,
> one bit for strict mask parsing (is this a YAGNI or a BCP?)
> Remaining 23 bits reserved for future subsystems.
>
> Or would it be better to only affect one subsystem at a time, and if so
> why? I think the mask approach is better, that we want fewer ioctl calls,
> but may be wrong.
>
> And how does the timer field affect each of the five commands?
>>
>> * wait
>
>   0: wait forever
>   non-zero: wait that many ms
>
>>
>> * pause - eg. when cleaner activity is not desired atm
>
>  pause for that many ms, so 0 means until resumed
>
>>
>> * cancel - either Ctrl-C/kill -9 or separate command via 'btrfs'
>
> I don't see how "cancel" makes sense here
>
>
>>
>> * resume - explicitly wake a paused thread and let it continue or just
>> check for work
>
>
> Hmm. if resume is only the opposite of pause, and we're at system (not
> thread) granularity, there could be another check verb, that is
> informational -- that's the status -- does a paused thread check for its
> work? could the timeout value on a pause indicate some kind of desperation
> metric leading to unpausing, or just mean pause for so many ms
>
> if paused threads still check but don't do,
>
>>
>> * status - paused/active/idle
>
>
> expands to two bits, one is there work and the other are we looking for
> work (ha ha ha)
>
