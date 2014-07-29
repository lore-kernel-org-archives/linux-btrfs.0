Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaG2NcL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 09:32:11 -0400
Date: Tue, 29 Jul 2014 15:32:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: introduce test_issubvolname() for
 simplicity
Message-ID: <20140729133208.GS1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53D1F65A.7030606@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D1F65A.7030606@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 25, 2014 at 03:16:58PM +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> There are many duplicated codes to check if the given string is
> correct subvolume name. Introduce test_issubvolname() for this
> purpose for simplicity.

Please move it to utils.c
