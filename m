Return-Path: <SRS0=9x/W=AW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A451C433E0
	for <linux-btrfs@archiver.kernel.org>; Sat, 11 Jul 2020 18:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA20E20720
	for <linux-btrfs@archiver.kernel.org>; Sat, 11 Jul 2020 18:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jots.org header.i=@jots.org header.b="AYKVET/a";
	dkim=pass (2048-bit key) header.d=jots.org header.i=@jots.org header.b="Nfnx90iO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgGKSoV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 11 Jul 2020 14:44:21 -0400
Received: from basidium.jots.org ([174.138.47.155]:43162 "EHLO
        basidium.jots.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgGKSoU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Jul 2020 14:44:20 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2020 14:44:20 EDT
Received: by basidium.jots.org (Postfix, from userid 1002)
        id 205587FD56; Sat, 11 Jul 2020 14:38:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jots.org; s=mail;
        t=1594492710; bh=/OdTFi2jTV9nIUdAl1Dp5wA39hUAHMfhpWqpFox4oWs=;
        h=Date:From:To:Subject;
        b=AYKVET/a0Yr3KRD63oxEEUTHNl7QuE1YHaykfieO8Qn6q1/+hWUkmPtSq9Sc056f+
         oMcoIKb2f1tkBYQ3mShuh9/95CzMJhUe3o7HoZ1B5hrn44ko9XQdvnYzo8xg/exUNa
         1vmMKF3fur1XY4xjsA5hl4HDD7KOaI3AX+YtSb+dcV9Wvpt+/xQHlJg9gsjA6h5pc6
         Zy+Ku5ZZ+ASWvu0RiNPOV1IzPkVZ9Q5ijFZqFElZPeIxOcbUJ5tvp0lNu5N50b6hvp
         GnK28Md17DP2ZDFbLDcCthcInxqueNBRaYzn0akjntuNk5g8D0UwGjTPWVV6XxIwdA
         p4/wkAF8btN4g==
Received: from webmail.jots.org (localhost [127.0.0.1])
        by basidium.jots.org (Postfix) with ESMTP id 73D6A7EB2A;
        Sat, 11 Jul 2020 14:38:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jots.org; s=mail;
        t=1594492706; bh=/OdTFi2jTV9nIUdAl1Dp5wA39hUAHMfhpWqpFox4oWs=;
        h=Date:From:To:Subject;
        b=Nfnx90iOvjuQ4MmbPkAmpr17XImFY2FGEcAQv7wJTcCao0L/pIWZjk4o/3hjPNAX+
         S7/9e0kV/+wJGLCvdWFIRzGfSvqfdXYsdXg7QDuHVDonTP7BIlNoDEyY7ErShxRRCm
         HoTdzEb4ha6oKNK4ptnBs1xOjQepfFOy5cFpBYqZF2dnMc39I/TU1PwpqoMh/PeK3q
         MQTxh74NqwTzN+LbQiDZuKVmMMHlQqHlRpJjkD0XU3fuxkNrtyqpR5VuhQtYeMymSq
         B6sIWz8JY2EbFJMaOcj1ItV5QiNnfbPAXSpjLqg8Q1OTVE8SA5v6uP6efA2Nkf+au/
         6aOumtBs0zH6g==
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 11 Jul 2020 14:38:26 -0400
From:   Ken D'Ambrosio <ken@jots.org>
To:     ken@jots.org, linux-btrfs@vger.kernel.org
Subject: Btrfs default on Fedora?
User-Agent: Roundcube Webmail/1.4-beta
Message-ID: <933824829995390cef16f757cab1ddbc@jots.org>
X-Sender: ken@jots.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!  I just saw this mentioned on a BBS I'm on:
https://fedoraproject.org/wiki/Changes/BtrfsByDefault

I'll admit, I'm incredibly surprised, and pleased, to see that this 
might happen.  I do have three items of concern as Joe End User.  (Do 
note that for home use (where I use btrfs) I'm usually on Ubuntu or a 
variant and not RH, if that matters.)

* Swap files.  At least last time I checked, it was a PITA to take a 
snapshot of a volume that had a swapfile on it -- I wound up writing a 
wrapper that goes, does a swapoff, removes the file, creates the 
snapshot, and then re-creates the file.   Is this still "a thing"?  Or 
is there a way to work around that that isn't kludgey?

* When Stuff Goes Wrong(tm).  Again, my experience is not terribly 
current, but when things hit the fan, for most FSes, you do an
fsck -y /path/to/dev
and hope things come together.  But with btrfs, it seems that it's 
substantially more complicated to figure out what to do.  Have the 
tools, perhaps, been updated to help end users figure out what choices 
to make, etc., when dealing with an issue?

* RAID 5/6.  Last time I looked, that was in an unhappy state, so I just 
set up a RAID with mdadm, lay btrfs on top of that, and call it good.  
That seems to do the job, though it loses lots of smarts that would be 
had with btrfs running the RAID.  I see discussion on the wiki 
(https://btrfs.wiki.kernel.org/index.php/RAID56) talking about an RFC 
submitted to address the underlying issues; is this still broken?

Thanks much,

-Ken

P.S.  If there's a better mailing list, e.g., "end user questions" or 
something, please feel free to point me to it.
