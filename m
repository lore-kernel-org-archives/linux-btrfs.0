Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbcEWLJQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 07:09:16 -0400
Date: Mon, 23 May 2016 13:08:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH v2.1 16/16] btrfs-progs: fsck: Introduce low memory
 mode
Message-ID: <20160523110844.GJ29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463477930-3925-17-git-send-email-quwenruo@cn.fujitsu.com>
 <fa6160a4-64d2-9ce6-1c0d-eaf6069ca2c5@fb.com>
 <827a9e93-f525-4a8b-edb1-a0ac90175716@cn.fujitsu.com>
 <20160519145112.GF29147@twin.jikos.cz>
 <23d061e0-06e8-3e81-7595-4fc76a5353a2@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <23d061e0-06e8-3e81-7595-4fc76a5353a2@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 10:33:55AM +0800, Qu Wenruo wrote:
> We'll enrich the test cases for current low memory mode.

I started something to add optional default options for a few basic
commands (mkfs, fsck, convert) to extend the coverage. I'm not finished,
the idea is to call the commands via some wrapper that will grab the
defaults from a file or from environment.
