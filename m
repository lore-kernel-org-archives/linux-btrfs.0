Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46878 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbcD1J6e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 05:58:34 -0400
Message-ID: <5721DEAD.6000505@osg.samsung.com>
Date: Thu, 28 Apr 2016 10:58:05 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Roman Mamedov <rm@romanrm.net>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] df returns 100% used for empty mixed block group filesystem
References: <CAJCQCtRzt-BeoW9KNQC3kmBXw8MoydJv7Qy8fu0HmF3hAOgFRQ@mail.gmail.com> <20160310133334.1528bc88@natsu> <20160310174054.GL18908@twin.jikos.cz> <20160427225510.GQ29353@twin.jikos.cz>
In-Reply-To: <20160427225510.GQ29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27/04/16 23:55, David Sterba wrote:
> On Thu, Mar 10, 2016 at 06:40:54PM +0100, David Sterba wrote:
>> On Thu, Mar 10, 2016 at 01:33:34PM +0500, Roman Mamedov wrote:
>>> On Thu, 10 Mar 2016 01:24:44 -0700
>>> Chris Murphy <lists@colorremedies.com> wrote:
>>>
>>>> kernel 4.5.0 rc7
>>>> btrfs-progs-4.4.1-1
>>>>
>>>> Summary: A new empty mixed block group "-M" filesystem shows up as
>>>> 100% full with regular df (gnu coreutils 8.24). Pretty sure this is
>>>> not a regression, but no regression testing done.
>>>>
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=114281
>>>
>>> Just guessing here, but this might be related?
>>>
>>>   [PATCH] btrfs: statfs: report zero available if metadata are exhausted
>>>   http://www.spinics.net/lists/linux-btrfs/msg48013.html
>>>
>>> Maybe some maths there are wrong in case of a mixed blockgroup filesystem.
>>
>> Yes it's caused by the referenced patch.  The statfs has been broken for
>> mixed blockgroups but the 100% used on empty filesystem looks weird, so
>> it's time to fix the mixed-bg case.
> 
> JFYI, fixed by Luis de Bethencourt and patches queued for 4.7
> 

Good to know the issue was important to some people :)
It was fun to fix.

David,
I have been travelling the last week. I will continue with my second bug this
weekend. [0] Sorry for the delay on this.

Thanks,
Luis


[0] btrfs fi usage crash when multiple device volume contains seed device
https://bugzilla.kernel.org/show_bug.cgi?id=115851


