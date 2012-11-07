Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:46951 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2KGKaH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2012 05:30:07 -0500
Message-ID: <509A382E.2040904@giantdisaster.de>
Date: Wed, 07 Nov 2012 11:30:06 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 19/26] Btrfs: add code to scrub to copy read data to another
 disk
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <cef5c0f66f73ef151157fa524dede94eb29ae882.1352217244.git.sbehrens@giantdisaster.de> <5099ABC3.6050806@jp.fujitsu.com>
In-Reply-To: <5099ABC3.6050806@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 07 Nov 2012 09:30:59 +0900, Tsutomu Itoh wrote:
> (2012/11/07 1:38), Stefan Behrens wrote:
>> +static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
>> +				    struct scrub_page *spage)
>> +{
>> +	struct scrub_wr_ctx *wr_ctx = &sctx->wr_ctx;
>> +	struct scrub_bio *sbio;
>> +	int ret;
>> +
>> +	mutex_lock(&wr_ctx->wr_lock);
>> +again:
>> +	if (!wr_ctx->wr_curr_bio) {
>> +		wr_ctx->wr_curr_bio = kzalloc(sizeof(*wr_ctx->wr_curr_bio),
>> +					      GFP_NOFS);
>> +		if (!wr_ctx->wr_curr_bio)
> 
> I think mutex_unlock(&wr_ctx->wr_lock) is necessary before it returns.
> 
>> +			return -ENOMEM;

Thanks Tsutomu!
I'll fix it in
git://btrfs.giantdisaster.de/git/btrfs device-replace

