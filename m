Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbcA0IsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 03:48:15 -0500
Date: Wed, 27 Jan 2016 09:48:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "'David Sterba'" <dsterba@suse.cz>,
        "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: Re: test fail for btrfs: synchronize incompat feature bits with
 sysfs files
Message-ID: <20160127084803.GH8567@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <003501d158cf$f71750f0$e545f2d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <003501d158cf$f71750f0$e545f2d0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Jan 27, 2016 at 02:57:18PM +0800, Zhao Lei wrote:
> Hi, David Sterba
> 
> I find this patch caused NULL pointer accessing in lattest integration-4.5:
>   btrfs: synchronize incompat feature bits with sysfs files
>   CommitID: 14e46e04958df740c6c6a94849f176159a333f13

yeah, Chris notified me already, I'm going to fix it today. Thanks.
