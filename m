Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbcELLlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 07:41:55 -0400
Date: Thu, 12 May 2016 13:41:32 +0200
From: David Sterba <dsterba@suse.cz>
To: M G Berberich <btrfs@oss.m-berberich.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATHCH] add option to =?utf-8?Q?supre?=
 =?utf-8?B?c3MgIkF0IHN1YnZvbCDigKYi?= message in btrfs send
Message-ID: <20160512114131.GO29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160507162958.GA2241@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160507162958.GA2241@invalid>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 07, 2016 at 06:29:58PM +0200, M G Berberich wrote:
> btrfs send puts a “At subvol …” on stderr, which is very annoying in
> scripts, esp. cron-jobs. Piping stderr to /dev/null does suppress this
> message, but also error-messages which one would probably want to
> see. I added an option to not change the behavior of btrfs send
> and possibly break existing scripts, but moving this message to
> verbose would be O.K. for me too.

We should use the current verbosity option. For compatibility reasons,
I'd keep the 'At subvol' printed as default, matching verbosity level 1.
All existing messages verbosity should then become 2, and the proposed
quiet option 0.
