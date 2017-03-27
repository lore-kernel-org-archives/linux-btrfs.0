Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36525 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752776AbdC0Pa7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 11:30:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1csWbP-0008Ib-Lk
        for linux-btrfs@vger.kernel.org; Mon, 27 Mar 2017 17:30:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug: btrfs dev del missing fails where it shouldn't
Date: Mon, 27 Mar 2017 15:30:27 +0000 (UTC)
Message-ID: <pan$eac86$c78d3917$f70a02ec$1b8bf9ef@cox.net>
References: <pan$6d207$1e762e21$4d82ed9e$78bb3ca@cox.net>
        <63b13b68a616abf8f828d6725f792be4@webmail.pados.hu>
        <c2f848ab7e4294f35f1bca29db33e3de@webmail.pados.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Karoly Pados posted on Mon, 27 Mar 2017 14:12:58 +0000 as excerpted:

>> But, even there, a close read says missing tells btrfs to delete the
>> first device described by the filesystem metadata that wasn't present
>> when the filesystem was mounted. And since your case does a remount,
>> not a full unmount and clean mount, that "missing" device was present
>> when the filesystem was mounted, so attempting to delete missing
>> /should/ be expected to fail.
> 
> I checked, and a full unmount+mount instead of a remount makes 'missing'
> work for me as expected. Thank you once more. Here though I have a (IMHO
> important) feature suggestion: make 'missing' behave the same after a
> remount as after a full-unmount-mount. And though I have no specific
> example yet, possibly other features too aside from 'missing'. For a
> simple reason:
> 
> Even if you describe 'missing' as "delete the first device described by
> the filesystem metadata that wasn't present when the filesystem was
> mounted", no normal admin or user is going to interpret it that way. You
> are right the info is in there, and kernel or btrfs devs will take that
> sentence apart like lawyers and interpret it very exactly. But I dare to
> say that most admins think of remount as unmount-mount-on-steroids,
> basically as a possibly atomic unmount+mount that does not break file
> descriptors. My point is, I argue that most people will expect 'missing'
> to work after a remount even after reading its correct description
> above. So I would either explicitly spell out in the docs that 'missing'
> will not work in that case, or better, 'fix' it to work even after a
> remount.

FWIW...

I absolutely agree with you on how an admin would take delete missing, as 
I'd definitely expect it to work that way myself.  =:^/  Only after 
having it fail would I be trying to figure out why, and presumably would 
come across that "at mount" wording and smack myself upside the head, 
"Oh, OK, I can deal with that!"

Unfortunately, I suspect the change at least short term will have to be 
spelling it out explicitly in the docs, as btrfs as it currently is 
really doesn't have the concept of a device going MIA, missing in action, 
and will simply continue to try to write to it, filling memory with 
unwritten data...  IOW, the "missing" thing isn't the only or even the 
most critical issue with btrfs not really detecting device presence or 
absence except on mount.

There are longer-term-project patches to change that and make btrfs aware 
of device changes, but AFAIK, they're moldering in a developer's branch 
somewhere (the global hot-spare patches branch), and when they'll 
actually be polished up and mainlined is I believe unknown, ATM.  
Certainly I don't know, tho Chris Mason and the dev in question might 
have some general idea.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

