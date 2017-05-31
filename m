Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36675 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750952AbdEaNxR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 09:53:17 -0400
Date: Wed, 31 May 2017 15:52:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: Re: [PATCH v4 05/20] btrfs-progs: Introduce wrapper to recover
 raid56 data
Message-ID: <20170531135215.GE14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
 <20170525062205.11660-6-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525062205.11660-6-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 02:21:50PM +0800, Qu Wenruo wrote:
> Introduce a wrapper to recover raid56 data.
> 
> The logical is the same with kernel one, but with different interfaces,
> since kernel ones cares the performance while in btrfs we don't care
> that much.

Can you please rephrase this paragraph? I'll commit the patch as-is for
now but want replace the changelog with an improved one. 
