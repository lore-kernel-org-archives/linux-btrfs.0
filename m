Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57746 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbbJHXSf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 19:18:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZkKSG-0000EY-Uv
	for linux-btrfs@vger.kernel.org; Fri, 09 Oct 2015 01:18:33 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2015 01:18:32 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2015 01:18:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using BtrFS and backup tools for keeping two systems in sync
Date: Thu, 8 Oct 2015 23:18:25 +0000 (UTC)
Message-ID: <pan$1460a$dca727ad$9f868710$44ab0973@cox.net>
References: <CAH-HCWV2mO1FFRGPh+jh2TrZMYV-7w7MwytSV4WZ33-9PW=qRw@mail.gmail.com>
	<20151008063745.GB25907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 08 Oct 2015 06:37:45 +0000 as excerpted:

> On Thu, Oct 08, 2015 at 08:05:09AM +0530, Shriramana Sharma wrote:
>> Hello. I see there are some backup tools taking advantage of BtrFS's
>> incremental send/receive feature:
>> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup. [BTW Ames
>> Cornish's ButterSink (https://github.com/AmesCornish/buttersink) seems
>> to be missing from that page.]
>> 
>> Now I'd like to know if anyone has evolved some good practices w.r.t
>> maintaining the data of two systems in sync using this feature of
>> BtrFS. What I have in mind is: I work on my desktop by default, and for
>> ergonomics reasons only use my laptop when I need the mobility.
>> I'd like to keep the main data (documents I create, programs I write
>> etc) in sync between the two. (The profile data such as in the ~/.*
>> hidden folders had better stay separate though, I guess.)
>> 
>> I figure with the existing tools it would not be too difficult to
>> maintain a synced set of snapshots between the two systems if I only
>> use the desktop vs laptop alternatingly and sync at each switchover,
>> but the potential problem only would come if I modify both (something
>> like having to do git merge, I guess).
>> 
>> Has anyone come across this situation and evolved any policies to
>> handle it?
> 
>    You can't currently do this efficiently with send/receive. It
> should be possible, but it needs a change to the send stream format.

Elucidating somewhat...

AFAIK (as a list regular but not a dev or a user, personally, of the send/
receive functionality), currently, btrfs send/receive incremental works 
only one way.  That is, the send-stream format provides sufficient 
information for incremental sends after an original send, but there's no 
way to reverse the process and sync the other way, from the original 
receiver back to the sender.  A full send can be done, but then it's no 
longer linked to the the original.

As Hugo says, the base functionality is available, but actually hooking 
it up to work will require a bump to the send stream format, as the 
required information simply isn't sent, ATM.  That send stream format 
bump is likely to eventually happen, but there's a very strong interest 
in keeping the number of formats that must be supported for backward 
compatibility to a minimum, and thus in a minimum number of format 
bumps.  So the devs want to delay the bump as long as possible, 
identifying anything else that might need to change in the mean time, and 
make, ideally, one final bump, including all changes discovered to be 
needed since the last one, and then no more.

So while this necessary change is known, it could be some time, yet, 
before it's actually done, with hopefully no further changes necessary or 
allowed after that.

Which back on the reoccurring theme of btrfs stability...

... is another point toward btrfs "definitely stabilizing now, but not 
yet fully stable and mature."  When the devs decide there are likely no 
further as-yet undiscovered necessary changes coming and finally do this 
bump, we'll know they really do consider btrfs to be settling down into 
stability.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

