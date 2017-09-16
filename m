Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:52202 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdIPMjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 08:39:12 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 34FA9253732E
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 14:39:11 +0200 (CEST)
Subject: Re: subvolume list as user?
To: linux-btrfs@vger.kernel.org
References: <20170916094504.GL32347@rus.uni-stuttgart.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <684fb723-4270-9589-b80b-e60ccc6dadfe@mendix.com>
Date: Sat, 16 Sep 2017 14:39:10 +0200
MIME-Version: 1.0
In-Reply-To: <20170916094504.GL32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2017 11:45 AM, Ulli Horlacher wrote:
> Every user can create subvolumes (and root cannot prevent it!).
> But how can a user list these subvolumes?
> 
> tux@xerus:/test/tux: btrfs subvolume create test
> Create subvolume './test'

>From your other posts I don't quickly get if you actually do want to
have this possible, or accept that it's currently like that and try to
do damage control by having users also remove their things again.

Actually, if you don't want this I think it's quite easily to patch your
kernel with one or two lines of code to disallow it.

> tux@xerus:/test/tux: btrfs subvolume list .
> ERROR: can't perform the search - Operation not permitted

Yes, because the SEARCH ioctl only allows root to directly query any of
the filesystem metadata from kernel memory. subvolume list uses this
SEARCH ioctl to find it's info.

-- 
Hans van Kranenburg
