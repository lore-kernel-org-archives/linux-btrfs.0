Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54975 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1033468AbdD3HDx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 03:03:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d4itV-0006PM-Bw
        for linux-btrfs@vger.kernel.org; Sun, 30 Apr 2017 09:03:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: cannot find parent subvolume, can't see reason for it.
Date: Sun, 30 Apr 2017 07:03:37 +0000 (UTC)
Message-ID: <pan$870c0$65ba0d6f$ead17f60$deb3e014@cox.net>
References: <590555B8.3070006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

J. Hart posted on Sat, 29 Apr 2017 23:10:48 -0400 as excerpted:

> I am trying to do a "send -p src/snp1 src/snp2 dst/" and getting the
> following error:
> 
> ERROR: cannot find parent subvolume
> 
> The "src/snp1" is present in both "src/" and "dst/".   The "src/snp2" is
> present in "src/" .
> The send works when "-p" is not used, but will not work when it is.
> 
> I imagine I am missing something obvious but cannot see what, and would
> appreciate some suggestions on what might be causing the error.

Note that my own use-case doesn't include send/receive, so the degree to 
which I can get into specific detail is limited, but as you mentioned 
sometimes we miss the obvious and need someone else to point it out, so 
in that spirit, here's a couple obvious things:

* Your apparently contrived for posting paths above are relative.  Have 
you tried absolute paths and/or are you certain the relative paths are 
correctly relative to your current working directory?

* src/snp1 is a read-only snapshot, not just a directory, correct?

> note: I have sent several queries to this list, but have not heard
> anything back.   I hope they have not been inappropriate.  If so, I
> would be grateful if you would let me know, or if there is somewhere
> else I should be going for advice.

I see three previous threads (the first starting on March 25) with you as 
original poster on the list, all of which have followups to the list, one 
of which has a single followup from you to someone replying to you, from 
you as well.  I don't however see any followups from you to replies on 
the other two threads, and only the one followup to someone replying on 
the one thread.

So it may be that you're not getting the replies very well.

Are you subscribed to the list?  While some posters reply directly to 
author as well, and that's encouraged, some reply only to the list 
(including me unless specifically asked or there's some other hint, as 
here, that it may be needed).

The other possibility, of course, is that replies are getting spam-binned 
via gmail or on your end.  You may want to check that.

Meanwhile, if you're subscribed or are otherwise not getting replies, 
there's a number of list archives available, see:

https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list

The mail-archive one is probably easier to use than marc, and the gmane 
web-based archive is offline, possibly permanently. 

(Gmane does still have the news-based, that is nntp:// archive available, 
which I actually read and post thru myself, but the service recently 
changed hands and there's little information on whether the web service 
is coming back or not, and without it the news side is likely to 
eventually die as well.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

