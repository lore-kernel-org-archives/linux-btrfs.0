Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751153AbeEPWiH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 18:38:07 -0400
Date: Thu, 17 May 2018 00:35:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
Message-ID: <20180516223523.GG6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180516100359.7752-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516100359.7752-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
> Not yet ready for the integration. As I need to introduce
> -o no_read_mirror_policy instead of -o read_mirror_policy=-<devid>

Mount option is mostly likely not the right interface for setting such
options, as usual.
