Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36652 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbcG1Rxd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 13:53:33 -0400
Received: by mail-qk0-f178.google.com with SMTP id x1so69581247qkb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 10:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160728105555.GR30795@twin.jikos.cz>
References: <pan$acc$75dc71b8$532c7a5c$47aab598@cox.net> <CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>
 <20160728105555.GR30795@twin.jikos.cz>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Thu, 28 Jul 2016 13:53:31 -0400
Message-ID: <CAD=QJKgmrd_pmcYPOk6BXstVJ+JSdSwm7s0KEPbLJrezbUCLpw@mail.gmail.com>
Subject: Re: btrfs fi defrag does not defrag files >256kB?
To: dsterba@suse.cz, Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 July 2016 at 06:55, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Jul 27, 2016 at 01:19:01PM -0400, Nicholas D Steeves wrote:
>> > In that regard a defrag -t 32M recommendation is reasonable for a
>> > converted filesystem, tho you can certainly go larger... to 1 GiB as I
>> > said.
>>
>> I only mentioned btrfs-convert.asciidoc, because that's what led me to
>> the discrepancy between the default target extent size value, and a
>> recommended value.  I was searching for everything I could find on
>> defrag, because I had begun to suspect that it wasn't functioning as
>> expected.
>
> Historically, the 256K size is from kernel. Defrag can create tons of
> data to write and this is noticeable on the system. However the results
> of defragmentation are not satisfactory to the user so the recommended
> value is 32M. I'd rather not change the kernel default but we can
> increase the default threshold (-t) in the userspace tools.

Thank you, I just saw that commit too!  For the purposes of minimizing
the impact btrfs fi defrag in a background cron or systemd.trigger job
has on a running system, I've read that "-f" (flush data after defrag
of each file) is beneficial.  Would it be even more beneficial to
ionice -c idle the defragmentation?

>> Is there any reason why defrag without -t cannot detect and default to
>> the data chunk size, or why it does not default to 1 GiB?
>
> The 1G value wouldn't be reached on an average filesystem where the free
> space is fragmented, besides there are some smaller internal limits on
> extent sizes that may not reach the user target size.  The value 32M has
> been experimentally found and tested on various systems and it proved to
> work well. With 64M the defragmentation was less successful but as it's
> only a hint, it's not wrong to use it.

Thank you for sharing these results :-)

>> In the same
>> way that balance's default behaviour is a full balance, shouldn't
>> defrag's default behaviour defrag whole chunks?  Does it not default
>> to 1 GiB because that would increase the number of cases where defrag
>> unreflinks and duplicates files--leading to an ENOSPC?
>
> Yes, this would also happen, unless the '-f' option is given (flush data
> after defragmenting each file).

When flushing data after defragmenting each file, one might still hit
an ENOSPC, right?  But because the writes are more atomic it will be
easier to recover from?

Additionally, I've read that -o autodefrag doesn't yet work well for
large databases.  Would a supplementary targeted defrag policy be
useful here?  For example: a general cron/systemd.trigger default of
"-t 32M", and then another job for /var/lib/mysql/ with a policy of
"-f -t 1G"?  Or did your findings also show that large databases did
not benefit from larger target extent defrags?

Best regards,
Nicholas
