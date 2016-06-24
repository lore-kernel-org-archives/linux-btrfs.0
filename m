Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbcFXMAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 08:00:32 -0400
Date: Fri, 24 Jun 2016 14:01:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: fi show: print error message if no valid
 Btrfs is specified
Message-ID: <20160624120107.GA5574@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a22eda17-c639-9b2b-fa08-d4f0b032d4c9@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a22eda17-c639-9b2b-fa08-d4f0b032d4c9@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 05:24:47PM +0900, Satoru Takeuchi wrote:
> * Before this patch
> 
>  ===============================
>  # ./btrfs fi show foo      # "foo" doesn't mean any valid Btrfs
>  #                          # no error message
>  # echo $?
>  1
>  ===============================
> 
> * After this patch
> 
>  ===============================
>  # ./btrfs fi show foo
>  ERROR: foo is not a valid Btrfs
>  #
>  # echo $?
>  1
>  ===============================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
