Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57404 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbbDCJ5I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 05:57:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YdyLT-0006z4-Dr
	for linux-btrfs@vger.kernel.org; Fri, 03 Apr 2015 11:56:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 11:56:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 11:56:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Date: Fri, 3 Apr 2015 09:56:48 +0000 (UTC)
Message-ID: <pan$d3473$5acd4d32$9b1eb3cc$28bf977f@cox.net>
References: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com>
	<pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
	<551E3C06.9040305@cn.fujitsu.com> <20150403121656.35782bda@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Fri, 03 Apr 2015 12:16:56 +0500 as excerpted:

> On Fri, 3 Apr 2015 15:06:46 +0800 Qu Wenruo <quwenruo@cn.fujitsu.com>
> wrote:
> 
>> >> +WARNING: If one hopes to rollback to ext2/3/4, he or she should not
>> >> execute
> 
> It also seems a bit awkward to spell out "he or she", if you want to
> refer to a user without specifying the gender, in software documentation
> it's more common to use "they":
> https://en.wikipedia.org/wiki/Singular_they

Tho as the link notes, "singular they" has been and remains somewhat 
controversial.

While "singular they" is accepted as correct (and as the link points out, 
has been used by certain professional writers in some instances for 
centuries, so it's not new!), so is "he or she", with both being 
generally agreed to be slightly awkward attempts at political 
correctness, for those uncomfortable with the arguably more traditional 
masculine second-person-generic when referring to a human, feminine when 
personifying an animal or inanimate object.

An individual's choice of usage will depend on how politically correct 
and inclusive their (usage in point) intent is, vs how traditional they 
intend to be.

So either usage would have been fine here in a modern context, as would  
the more traditional "he" in a traditional context, since the individual 
is assumed to be a person not an object.

The ones that really bother me, however, are the ones that arguably 
inappropriately use a feminine second-person singular when obviously 
referring to a (gender-unknown) person, not an object.  That's in-your-
face political correctness to the point of extremism, partly because it 
triggers a reparse, since the reader is then left to figure out whether 
the intent was really specifically human female or an inanimate object, 
where they had thought human generic or male, previously, and when the 
traditional usage doesn't match, the extreme in-your-face politically 
correct assertiveness of the deliberate female choice over singular-they, 
appropriate he/she form, or traditional gender-unknown but assumed human 
masculine, is jarring, to say the least.  I understand why some people 
make that choice and respect that they have the right to choose it, but 
still resent that they don't have at least minimal respect for my need as 
a reader to read without jarringly forced reparse.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

