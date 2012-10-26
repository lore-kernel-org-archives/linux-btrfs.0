Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:52387
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab2JZEDp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 00:03:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <chris@colorremedies.com>
In-Reply-To: <CAE5mzvicb1xXTEFKv2DtjxrnHUPi0TSn0d58aN+mBU7o80sRaA@mail.gmail.com>
Date: Thu, 25 Oct 2012 22:03:43 -0600
Message-Id: <7E875C8F-DCB9-4FC0-97EF-F142C4866E4D@colorremedies.com>
References: <50899151.1070503@inwind.it> <3BC0780A-C657-4195-BBAB-FFBDDBD989FB@colorremedies.com> <CAE5mzvi=czHnRcBUkyTn7NxzCRiZ-5GcZtZt8KGEX0tUiUz73g@mail.gmail.com> <1D6DC5A8-27E2-4470-B5D0-D1A7CC639825@colorremedies.com> <CAE5mzvicb1xXTEFKv2DtjxrnHUPi0TSn0d58aN+mBU7o80sRaA@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 25, 2012, at 9:36 PM, cwillu <cwillu@cwillu.com> wrote:

> On Thu, Oct 25, 2012 at 8:33 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> So what's the intended distinction between 'fi df' and 'fi show'? Because for months using btrfs I'd constantly be confused which command was going to show me what information I wanted, and that tells me there should be some better distinction between the commands.
> 
> Or the distinction should be removed, which is what this patch effectively does.

Ok fine. But I still think it needs a -s (summary) or -v (more detail) switch. The combined amount of information from existing df and show in a single command is too much information at a glance. The idea that only a human being can evaluate that pile of data into a meaningful answer to their questions strikes me as flawed. That it's a non-trivial boolean problem I'll accept, but if a human can consistently draw reasonable conclusions from this data dump then something can summarize it into the same - albeit not answering all possible questions.

Chris Murphy