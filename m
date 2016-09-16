Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37365 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbcIPCqR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 22:46:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkjA8-0005zO-5f
        for linux-btrfs@vger.kernel.org; Fri, 16 Sep 2016 04:46:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to handle kernel paging request
Date: Fri, 16 Sep 2016 02:45:43 +0000 (UTC)
Message-ID: <pan$870ae$e71e207d$86afd0fb$1fb7c517@cox.net>
References: <CAAwVk4ny29d5qEAEvv=ydGN9DudUpWDQxzusmW1FpdBpLeVDYA@mail.gmail.com>
        <6059ae41-ce19-e75f-dbb2-e606d9c8fa7d@fb.com>
        <CAAwVk4kBfG6_A9J8Kc9rFY_CXcekdRyDK37EYe-XqPo6DKwqMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Gavalda posted on Thu, 15 Sep 2016 22:12:57 +0200 as excerpted:

[Moved to bottom to retain quote/reply order.]

> On Thu, Sep 15, 2016 at 6:05 PM, Chris Mason <clm@fb.com> wrote:
>> On 09/15/2016 10:08 AM, Mark Gavalda wrote:
>>>
>>> Hi,
>>>
>>> Bumped into the following one today; kernel 4.4.0-36-generic Ubuntu
>>> 16.4.1; CPU went to 100% and only a hard restart solved the issue.
>>> Since then everything's back to normal.
>>>
>>> Please let me know how can I help get to the bottom of this?
>>
>>
>> I saw similar traces when tracking down this bug:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/
commit/?h=for-linus-4.8&id=cbd60aa7cd17d81a434234268c55192862147439
>>
>> It's flagged for stable, so you'll get it with the next stable update,
>> or you can apply it by hand and rebuild.

> Thanks, I can see it included in 4.8-rc6 but not the other branches.
> Will it get pulled later or is this a 4.8 only fix?

Flagged for stable means it's headed to the maintained stable branches 
(well, the ones to which the fix applies for regression fixes, but 
definitely 4.4 LTS series in this case since Chris Mason indicated it 
should apply in your case), not just current.

But stabilization policy says a patch must hit mainline current first, 
before it is eligible for older stable as well.  So it would be 
/expected/ to hit 4.8-rc, current development, first.  After that, given 
that it's already flagged for stable, it should eventually hit all the 
stable kernels to which it applies as well.  That can be right away, but 
if the stable maintainer (Greg K-H, normally) is backlogged due to just 
getting back from vacation or something, as sometimes happens, it can 
take a few weeks to work thru the backlog, so it can take a bit, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

