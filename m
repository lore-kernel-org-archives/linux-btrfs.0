Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:52798 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab2FNQbu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 12:31:50 -0400
Received: from [192.168.242.10] (50-193-208-193-static.hfc.comcastbusiness.net [50.193.208.193])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by lulu.zabbo.net (Postfix) with ESMTPSA id EC2932216CB
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jun 2012 09:31:49 -0700 (PDT)
Message-ID: <4FDA11F5.6050703@zabbo.net>
Date: Thu, 14 Jun 2012 09:31:49 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Question, Does BTRFS provide a read speed increase with RAID1
References: <CACCfv7q83FYmrcVO3TwMwX2HmNZpkdO=uJOTtR1X9E7_wUWz9w@mail.gmail.com> <4FD9AAA0.2040802@gmx.net> <20120614095232.GL32402@twin.jikos.cz>
In-Reply-To: <20120614095232.GL32402@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> I'd like to find a better mirror selection hint that would work well on
> avearage and will get back to it someday, unless somebody else wants to
> continue experimenting here.

Well, for some context you can see what the existing kernel raid 
implementations do:

	drivers/md/raid1.c:read_balance()
	drivers/md/dm-raid1.c:do_reads()

- z
