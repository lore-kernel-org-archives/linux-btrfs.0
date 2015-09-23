Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbbIWM7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 08:59:31 -0400
Date: Wed, 23 Sep 2015 14:58:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: declare rsv_count as unsigned int instead
 of int
Message-ID: <20150923125834.GZ12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150922210007.GA27786@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922210007.GA27786@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 09:00:07PM +0000, Alexandru Moise wrote:
> rsv_count ultimately gets passed to start_transaction() which
> now takes an unsigned int as its num_items parameter.
> The value of rsv_count should always be positive so declare it
> as being unsigned.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
