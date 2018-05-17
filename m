Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbeEQMGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 08:06:55 -0400
Date: Thu, 17 May 2018 14:04:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: balance: prefix kernel logs
Message-ID: <20180517120413.GI6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516025128.9899-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 10:51:26AM +0800, Anand Jain wrote:
> Kernel logs are very important for the forensic investigations of the
> issues in general make it easy to use it. This patch adds 'balance:'
> prefix so that it can be easily searched.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to next, thanks. Please stick to the coding style and add an empty
newlines between declarations and statements and un-indent long printk
strings so they fit 80 columns. I've fixed that for now.
