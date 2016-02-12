Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbcBLSWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 13:22:10 -0500
Date: Fri, 12 Feb 2016 19:22:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/7] Introduce device delete by devid
Message-ID: <20160212182207.GJ4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2015 at 11:19:17PM +0800, Anand Jain wrote:
> The operation of device replace and device delete follows same steps
> upto some depths, however they don't share codes.
> This set of enhancement will help device replace and device delete to
> share codes.
> And at the end add support to delete device using devid.

I'd like to get this rolling again, do you have an updated branch? I'm
not sure what's the latest status of the 'number of devices vs raid
constraints' problem. Qu did some patches, I hope either of you can let
me know. Thanks.
