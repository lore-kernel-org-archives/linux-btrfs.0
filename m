Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1386BC07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 09:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA8A720868
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 09:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA8A720868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbeLGJVz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 04:21:55 -0500
Received: from [195.159.176.226] ([195.159.176.226]:47639 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbeLGJVy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 04:21:54 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gVCIP-0005Eo-2U
        for linux-btrfs@vger.kernel.org; Fri, 07 Dec 2018 10:19:41 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: HELP unmountable partition after btrfs balance to RAID0
Date:   Fri, 7 Dec 2018 09:19:35 +0000 (UTC)
Message-ID: <pan$24dd8$40db96fa$55784ec4$68a49135@cox.net>
References: <44bba061-a784-e79e-a379-373895d653c0@mohrkeg.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thomas Mohr posted on Thu, 06 Dec 2018 12:31:15 +0100 as excerpted:

> We wanted to convert a file system to a RAID0 with two partitions.
> Unfortunately we had to reboot the server during the balance operation
> before it could complete.
> 
> Now following happens:
> 
> A mount attempt of the array fails with following error code:
> 
> btrfs recover yields roughly 1.6 out of 4 TB.

[Just another btrfs user and list regular, not a dev.  A dev may reply to 
your specific case, but meanwhile, for next time...]

That shouldn't be a problem.  Because with raid0 a failure of any of the 
components will take down the entire raid, making it less reliable than a 
single device, raid0 (in general, not just btrfs) is considered only 
useful for data of low enough value that its loss is no big deal, either 
because it's truly of little value (internet cache being a good example), 
or because backups are kept available and updated for whenever the raid0 
array fails.  Because with raid0, it's always a question of when it'll 
fail, not if.

So loss of a filesystem being converted to raid0 isn't a problem, because 
the data on it, by virtue of being in the process of conversion to raid0, 
is defined as of throw-away value in any case.  If it's of higher value 
than that, it's not going to be raid0 (or in the process of conversion to 
it) in the first place.

Of course that's simply an extension of the more general first sysadmin's 
rule of backups, that the true value of data is defined not by arbitrary 
claims, but by the number of backups of that data it's worth having.  
Because "things happen", whether it's fat-fingering, bad hardware, buggy 
software, or simply someone tripping over the power cable or running into 
the power pole outside at the wrong time.

So no backup is simply defining the data as worth less than the time/
trouble/resources necessary to make that backup.

Note that you ALWAYS save what was of most value to you, either the time/
trouble/resources to do the backup, if your actions defined that to be of 
more value than the data, or the data, if you had that backup, thereby 
defining the value of the data to be worth backing up.

Similarly, failure of the only backup isn't a problem because by virtue 
of there being only that one backup, the data is defined as not worth 
having more than one, and likewise, having an outdated backup isn't a 
problem, because that's simply the special case of defining the data in 
the delta between the backup time and the present as not (yet) worth the 
time/hassle/resources to make/refresh that backup.

(And FWIW, the second sysadmin's rule of backups is that it's not a 
backup until you've successfully tested it recoverable in the same sort 
of conditions you're likely to need to recover it in.  Because so many 
people have /thought/ they had backups, that turned out not to be, 
because they never tested that they could actually recover the data from 
them.  For instance, if the backup tools you'll need to recover the 
backup are on the backup itself, how do you get to them?  Can you create 
a filesystem for the new copy of the data and recover it from the backup 
with just the tools and documentation available from your emergency boot 
media?  Untested backup == no backup, or at best, backup still in 
process!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

