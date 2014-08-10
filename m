Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49598 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751235AbaHJQZ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 12:25:56 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:59791 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XGVwS-003cU1-BA
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 10:25:56 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
Date: Sun, 10 Aug 2014 10:25:53 -0600
Message-Id: <A7CFCD27-F663-425A-A695-3E7842777348@colorremedies.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com> <2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com> <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com> <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com> <pan$29b1$ee1dac$e6091513$d07b2702@cox.net> <CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com> <CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com> <CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com> <pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 10, 2014, at 2:24 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Either way, the question then comes up of what to use when you do a new 
> mkfs.  My personal feeling?  Btrfs isn't yet fully stable, and there's a 
> very real possibility that one may have to restore from backup, so one 
> should be prepared for that.

Jose said early on he that he is prepared for this, but nevertheless a week is a rather long time for restore.

>  Given the size of the data store you're 
> working with and the remote nature of that backup, with access over 
> limited-speed pipes, I wonder if btrfs is really an appropriate choice 
> for you at this point.

We don't know if this backup is extra icing on the cake. Yes it's a week of restore, but it still might be entirely dispensable; e.g. 1 of 2+ glusterfs georep slaves and at least one of the others is XFS based.

> I guess xfs is the standard recommendation for big-data sizes and it is 
> said to be long past the "better have a UPS" days, or of course the 
> default ext4.  

XFS is now the default filesystem for RHEL 7 and Fedora 21 Server, likely also for Fedora 21 Cloud. This includes /boot.

> 
> You can of course try btrfs again in a year or so, when it should have 
> matured quite a bit.  I actually did that after my first try at btrfs, 
> leaving for a time then coming back, and was impressed at how much it had 
> matured in the mean time.

I'm looking back to Aug 2011 when Fedora 16 was slated to have Btrfs by default.


Chris Murphy

