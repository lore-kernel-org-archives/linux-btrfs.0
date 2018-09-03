Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727428AbeICSjr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 14:39:47 -0400
Subject: Re: [PATCH 12/35] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-13-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c7905ccc-ba8c-fe9d-e6b7-fa44443a8984@suse.com>
Date: Mon, 3 Sep 2018 17:19:19 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-13-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> +		if (flush_state == ALLOC_CHUNK_FORCE && !commit_cycles)
> +			flush_state++;

This is a bit obscure. So if we allocated a chunk and !commit_cycles
just break from the loop? What's the reasoning behind this ?
