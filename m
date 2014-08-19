Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbaHSPRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:17:02 -0400
Date: Tue, 19 Aug 2014 17:17:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs-progs: Show error message if btrfs filesystem
 show failed to find any btrfs filesystem
Message-ID: <20140819151700.GY1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53E8891F.3010607@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E8891F.3010607@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 06:13:03PM +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Current btrfs doesn't display any error message if this command
> failed to find any btrfs filesystem corresponding to
> <path>|<uuid>|<device>|<label> which user specified.

I'm not sure if it is necessary to print anything. Like if grep printed
"Sorry I did not find any lines, please check your regexp"

Although, we can add a non-zero return value if there was anything found
or not.
