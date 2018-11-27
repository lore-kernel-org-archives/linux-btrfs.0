Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F227EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6E12086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA6E12086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbeK0SRy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:17:54 -0500
Received: from [195.159.176.226] ([195.159.176.226]:50075 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbeK0SRy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 13:17:54 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gRXds-0001iZ-TP
        for linux-btrfs@vger.kernel.org; Tue, 27 Nov 2018 08:18:44 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to fixup (regular) error
Date:   Tue, 27 Nov 2018 07:18:38 +0000 (UTC)
Organization: UNO (USENET News Organization)
Message-ID: <pan$f1f1$ae87783$50df180$b6b94f2a@cox.net>
References: <f367f1b4-f360-0f6d-ee30-42eb735a9bbc@mpi-dortmund.mpg.de>
        <beefd32d-b34b-9242-b16d-e66c82b23d8f@gmx.com>
        <a1766b0a-8293-3cb5-e592-df09754e4417@mpi-dortmund.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
x-munging1: Usenet replies preferred,  If replying by mail,
x-munging2: do ALL the following to avoid the spam traps:
x-munging3: 1) Use plain text.  HTML format auto-trashed.
x-munging4: 2) Kill address reply2group and please phrases.
x-munging5: 3) Put " -news" at the END of the subject
x-munging6: (no quotes, space, dash, news, END)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Alexander Fieroch posted on Mon, 26 Nov 2018 11:23:00 +0100 as excerpted:

> Am 26.11.18 um 09:13 schrieb Qu Wenruo:
>> The corruption itself looks like some disk error, not some btrfs error
>> like transid error.
> 
> You're right! SMART has an increased value for one harddisk on
> reallocated sector count. Sorry, I missed to check this first...
> 
> I'll try to salvage my data...

FWIW as a general note about raid0 for updating your layout...

Because raid0 is less reliable than a single device (failure of any 
device of the raid0 is likely to take it out, and failure of any one of N 
is more likely than failure of any specific single device), admins 
generally consider it useful only for "throw-away" data, that is, data 
that can be lost without issue either because it really /is/ "throw-
away" (internet cache being a common example), or because it is 
considered a "throw-away" copy of the "real" data stored elsewhere, with 
that "real" copy being either the real working copy of which the raid0 is 
simply a faster cache, or with the raid0 being the working copy, but with 
sufficiently frequent backup updates that if the raid0 goes, it won't 
take anything of value with it (read as the effort to replace any data 
lost will be reasonably trivial, likely only a few minutes or hours, at 
worst perhaps a day's worth, of work, depending on how many people's work 
is involved and how much their time is considered to be worth).

So if it's raid0, you shouldn't be needing to worry about trying to 
recover what's on it, and probably shouldn't even be trying to run a 
btrfs check on it at all as it's likely to be more trouble and take more 
time than the throw-away data on it is worth.  If something goes wrong 
with a raid0, just declare it lost, blow it away and recreate fresh, 
restoring from the "real" copy if necessary.  Because for an admin, 
really with any data but particularly for a raid0, it's more a matter of 
when it'll die than if.

If that's inappropriate for the value of the data and status of the 
backups/real-copies, then you should really be reconsidering whether 
raid0 of any sort is appropriate, because it almost certainly is not.


For btrfs, what you might try instead of raid0, is raid1 metadata at 
least, raid0 or single mode data if there's not room enough to do raid1 
data as well.  And the raid1 metadata would have very likely saved the 
filesystem in this case, with some loss of files possible depending on 
where the damage is, but with the second copy of the metadata from the 
good device being used to fill in for and (attempt to, if the bad device 
is actively getting worse it might be a losing battle) repair any 
metadata damage on the bad device, thus giving you a far better chance of 
saving the filesystem as a whole.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

