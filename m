Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56600 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422814AbbFEOin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 10:38:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z0slX-0007m2-RE
	for linux-btrfs@vger.kernel.org; Fri, 05 Jun 2015 16:38:35 +0200
Received: from p4ff58260.dip0.t-ipconnect.de ([79.245.130.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 16:38:35 +0200
Received: from holger.hoffstaette by p4ff58260.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 16:38:35 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 1/3] btrfs: iterate over unused chunk space in FITRIM
Date: Fri, 5 Jun 2015 14:38:11 +0000 (UTC)
Message-ID: <pan.2015.06.05.14.38.11@googlemail.com>
References: <1433342874-7099-1-git-send-email-jeffm@suse.com>
	<1433342874-7099-2-git-send-email-jeffm@suse.com>
	<pan.2015.06.04.11.15.24@googlemail.com> <55719F55.8070803@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 05 Jun 2015 09:08:37 -0400, Jeff Mahoney wrote:

>> which conflicts with Filipe's patch on Tuesday called "Btrfs: check
>> pending chunks when shrinking fs to avoid corruption":
>> 
>> +		if (contains_pending_extent(trans, device, &start, len)) {
>> 
>> since trans (returned from start_transaction()) is a handle, not
>> the tx itself.
>> 
>> ISTM that it should now pass trans->transaction instead..or
>> something.
> 
> Yep. That's how you'd resolve that merge. The trans->transaction
> pointer will be valid for the life of the handle.

Good - that's what I've done locally for my branches. Thanks for
confirming. Good to know that I can still make sense of things.

It was more of a question/heads-up since it's not completely unheard of
for warnings to go unnoticed.. :)

cheers
Holger

