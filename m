Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:58630 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751655AbbELBAJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 21:00:09 -0400
Message-ID: <55515093.4060504@techsquare.com>
Date: Mon, 11 May 2015 21:00:03 -0400
From: Matt McKinnon <matt@techsquare.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
References: <55512147.5030708@techsquare.com> <20150511234604.GF15670@merlins.org> (sfid-20150511_194636_455719_4715EB1E)
In-Reply-To: <20150511234604.GF15670@merlins.org> (sfid-20150511_194636_455719_4715EB1E)
Content-Type: text/plain; charset=windows-1252; format=flowed
Subject: Re: btrfs send/receive error
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Typically get a new kernel where this is fixed, Filipe
> has been working on fixing them.
> What kernel was this on?
>
> Marc

Send box is 3.16.6 .  Receive box is 3.17.4 .

Just upgraded the receiving box to 4.0.2 which didn't fix it, so I'll 
schedule a reboot of the sending box.

-Matt
