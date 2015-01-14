Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbANPsc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 10:48:32 -0500
Date: Wed, 14 Jan 2015 16:48:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs:btrfstune: choose to ignore error when
 setting seeding enabled
Message-ID: <20150114154831.GV3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420791102-9948-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420791102-9948-1-git-send-email-fancn.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 04:11:41PM +0800, Fan Chengniang wrote:
> Before with -S option, setting positive value on seeding-enabled btrfs
> filesystem will cause error. So I add -i option which can ignore it.

Why can't we use the existing --force/-f option for that?
