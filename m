Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbbHYRaS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:30:18 -0400
Date: Tue, 25 Aug 2015 19:29:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH V2] btrfs-progs: add newline to some error messages
Message-ID: <20150825172942.GU10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201508070020.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201508070020.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 07, 2015 at 09:20:25AM +0900, Tsutomu Itoh wrote:
> Added a missing newline to some error messages.
> Also printf() was changed to fprintf(stderr) for error message.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
