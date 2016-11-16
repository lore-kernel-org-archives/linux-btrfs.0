Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:44480 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbcKPUau (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 15:30:50 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 25A47600BD
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 21:30:46 +0100 (CET)
Subject: Btrfs Heatmap - v2 - block group internals!
To: linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
Date: Wed, 16 Nov 2016 21:30:45 +0100
MIME-Version: 1.0
In-Reply-To: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the last two days I've added the --blockgroup option to btrfs heatmap
to let it create pictures of block group internals.

Examples and more instructions are to be found in the README at:
https://github.com/knorrie/btrfs-heatmap/blob/master/README.md

To use the new functionality it needs a fairly recent python-btrfs for
the 'skinny' METADATA_ITEM_KEY to be present. Latest python-btrfs
release is v0.3, created yesterday.

Yay,

-- 
Hans van Kranenburg
