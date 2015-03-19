Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbCSMrl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 08:47:41 -0400
Date: Thu, 19 Mar 2015 13:47:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Accounting fixes
Message-ID: <20150319124739.GD20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426624683-3085-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426624683-3085-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 04:37:59PM -0400, Josef Bacik wrote:
> I've changed all of these a whole bunch recently, I think I've gotten all the
> issues worked out, please review/test to make sure there's not some other
> fucking corner I've missed.  Thanks,

The dirty_bgs assert is gone and fstests have been cycling since
yesterday. Thanks.
