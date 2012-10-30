Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:58761
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab2J3UNe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 16:13:34 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC][V2] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121030183240.GU2381@yeono.kjorling.se>
Date: Tue, 30 Oct 2012 14:13:32 -0600
Message-Id: <9C6B5F87-DEA3-4A59-9218-A0A14D169D78@colorremedies.com>
References: <50899151.1070503@inwind.it> <508F015F.5090507@gmail.com> <20121030094253.GA20662@yeono.kjorling.se> <50901937.80002@gmail.com> <20121030183240.GU2381@yeono.kjorling.se>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 30, 2012, at 12:32 PM, Michael Kjörling <michael@kjorling.se> wrote:
> 
> 
> I'm not so much concerned about the exact word being used as I feel
> the same word should be used throughout a UI to describe the same
> concept. Whether it's called "free" space, "unused" space,
> "unallocated" space or "fuzzbar'd" space is really beside the point.

Agreed. If there's some meaningful distinction, then different words should be used. There is the small vagueness of what exactly is "used". So if you say "50GB used" what exactly does this mean? Because btrfs fi show regularly shows me two completely different used values and they're significantly different (in value) so while the word "used" may be applicable, what's missing is the "what".

Chris Murphy