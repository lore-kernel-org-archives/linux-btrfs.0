Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57542 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753413AbaBYSde convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:33:34 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:54279 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WIMov-0047so-Vo
	for linux-btrfs@vger.kernel.org; Tue, 25 Feb 2014 11:33:34 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: VM nocow, should VM software set +C by default?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <530CD898.6090401@jrs-s.net>
Date: Tue, 25 Feb 2014 11:33:34 -0700
Message-Id: <630BA589-DD50-4C7C-9E95-610662BD66B9@colorremedies.com>
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com> <530C5F65.6020607@internetionals.nl> <4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com> <530CD898.6090401@jrs-s.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 25, 2014, at 10:53 AM, Jim Salter <jim@jrs-s.net> wrote:
> IME, IMO, the potential performance problems with COW and db/vm do /exist/ but they're way, WAY overstated, and unlikely to rear their heads at all in the majority of use-cases.

Right. Unfortunately I'm only aware of such anecdotes, including my own, that performance is OK or not OK. The specifics of the configuration need to be described. So what information do we need to ask users who are having such problems, before we ask them to use +C?


On Feb 25, 2014, at 11:01 AM, Roman Mamedov <rm@romanrm.net> wrote:

> Insisting that every program now has to include a workaround for a
> filesystem-specific gimmick does not seem to be a nice design decision
> long-term.


I have tepid agreement that +C is a short term work around, and ideally neither application developers nor users would need to do anything special to use VM images on Btrfs.

But in that case I'd still like to better understand what configurations are causing real performance problems to occur for some people when they don't use +C. Is this simply needing to implement a better or best practice rather than use of +C? So I guess more configuration information is needed to see what combination of attributes is inducing these reported  problems.

I've had a qcow2 image with more than 30,000 extents and didn't notice a performance drop. So I don't know that number of extents is the problem. Maybe it's how they're arranged on disk and what's causing the problem is excessive seeking on HDD? Or does this problem sometimes also still happen on SSD?

Chris Murphy