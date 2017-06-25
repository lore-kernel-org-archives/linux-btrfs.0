Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34755 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdFYWcC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Jun 2017 18:32:02 -0400
Date: Mon, 26 Jun 2017 00:31:59 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Btrfs: add precomputed log2()
Message-ID: <20170625223159.67pgefqe36wx3c5j@angband.pl>
References: <20170625210210.24383-1-nefelim4ag@gmail.com>
 <20170625210210.24383-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170625210210.24383-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 12:02:09AM +0300, Timofey Titovets wrote:
> +int log2_lshift16(long long unsigned lshift16)
> +{
> +	if (lshift16 < 1)
> +		return -136;
> +	if (lshift16 < 2)
> +		return -123;
> +	if (lshift16 < 3)
> +		return -117;
> +	if (lshift16 < 4)
> +		return -113;
> +	if (lshift16 < 5)
> +		return -110;
> +	if (lshift16 < 6)

Here you have 110 comparisons and branches.  It'd be much better to reorder
those into a sort of a binary search.

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
