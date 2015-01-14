Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.114.20]:52037 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbANSUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:20:32 -0500
Date: Wed, 14 Jan 2015 23:20:29 +0500
From: Roman Mamedov <rm@romanrm.net>
To: dsterba@suse.cz
Cc: Fan Chengniang <fancn.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
Message-ID: <20150114232029.04bb3bec@natsu>
In-Reply-To: <20150114154633.GU3685@twin.jikos.cz>
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
	<20150114154633.GU3685@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 14 Jan 2015 16:46:33 +0100
David Sterba <dsterba@suse.cz> wrote:

> On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
> > make btrfs qgroups show human readable sizes
> > using --human-readable option, example:
> 
> That's too long to type and the idea was to add all the long options
> that force the specific unit base, ie. --kbytes/--mbytes/..., --raw,
> --si and --iec. We can possibly make the human readable the default
> because that's what I'd expect to see to have a quick overview and can
> use the other options otherwise.
> 
> The geopt parser accepts short options if they're unique, so --kb or
> even --k works as a very convenient shorcut for frequent commandline
> use.

FWIW both of the GNU coreutils "df" and "ls" use the "-h, --human-readable"
combination of options. Also the human-readable sizes are not the default format with those.
Why not follow the rule of the least surprise and just adopt the same behavior?

-- 
With respect,
Roman
