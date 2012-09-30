Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35324 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab2I3XmP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 19:42:15 -0400
Date: Mon, 1 Oct 2012 01:42:09 +0200
From: David Sterba <dave@jikos.cz>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: end user may like full path for the subvol
 list display
Message-ID: <20120930234209.GQ14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348836993-19573-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348836993-19573-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 28, 2012 at 08:56:33PM +0800, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>

> [PATCH] Btrfs-progs: end user may like full path for the subvol list
> display

Sure, why not, but please make it optional, eg. with --full-subvol-path
or similar ugly command line option :)

There are several patches touching the output format of the subvolume
listing, it would be great to put them all into one branch and then
unify the options.

It may end up in a more invasive format change where the one-line would
stay as is now and another --verbose format where the rest of the
information (generation, timestamp, uuid, rw/ro, parent) will be listed
separately under the subvol name in a parseable format.


david
