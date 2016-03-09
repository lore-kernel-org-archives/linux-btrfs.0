Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbcCINTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 08:19:39 -0500
Date: Wed, 9 Mar 2016 14:19:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix broken 'device scan' arguments parsing
Message-ID: <20160309131918.GD738@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457486380-4051-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
 <56DFDDB0.5090207@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DFDDB0.5090207@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 05:24:16PM +0900, Satoru Takeuchi wrote:
> > --- a/cmds-device.c
> > +++ b/cmds-device.c
> > @@ -273,7 +273,7 @@ static int cmd_device_scan(int argc, char **argv)
> >   	if (all && check_argc_max(argc - optind, 1))
> 
> It's better to the above line as follows.
> 
> ========
> 	if (all && check_argc_exact(argc - optind, 0))

check_argc_exact prints error messages, and is usually followed by
the usage() call that exits. In the condition it's supposed to check if
there are no arguments (ie. scan all) or if the -d option was given
(scan all). The validity of the option combinations should be done
before that, so the patch is IMO correct.
