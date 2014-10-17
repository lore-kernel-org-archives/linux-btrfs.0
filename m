Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42284 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751289AbaJQPHn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 11:07:43 -0400
Received: from cablepool1-225.stoweaccess.com ([199.188.178.225]:53759 helo=[192.168.2.7])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xf982-002nqA-Kr
	for linux-btrfs@vger.kernel.org; Fri, 17 Oct 2014 09:07:43 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: unexplainable corruptions 3.17.0
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$6eb1$c20caee6$477f612f$2b524b4d@cox.net>
Date: Fri, 17 Oct 2014 11:07:42 -0400
Message-Id: <DD5CB8A9-8243-4D55-90E3-0020933B3633@colorremedies.com>
References: <20141016091726.GA582640@mother.pipebreaker.pl> <20141017080202.GA3604@localhost.localdomain> <pan$6eb1$c20caee6$477f612f$2b524b4d@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 17, 2014, at 7:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> When I switched to systemd here, I set it to volatile storage only, and 
> kept syslog-ng setup for longer term storage.  I arranged things so 
> journald's volatile logs had enough room to grow for a normal single 
> session in the /run/log tmpfs.  That gives me the nice journald systemd 
> integration, systemctl status reporting the last few log entries for a 
> specific service, etc.
> 
> But everything still gets passed to syslog-ng 

For the uninitiated: To do the above, delete /var/log/journal and install syslog daemon of choice (and is systemd-journald compatible of course). That's it. By deleting /var/log/journal, systemd-journald will write logs to /run/log/journal.


Chris Murphy

