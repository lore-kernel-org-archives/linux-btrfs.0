Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51639 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752817AbcKIKts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 05:49:48 -0500
Date: Wed, 9 Nov 2016 11:49:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: send-test: add checking of clone-src
 option
Message-ID: <20161109104944.GX12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611090444.AA00014@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201611090444.AA00014@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2016 at 01:44:15PM +0900, Tsutomu Itoh wrote:
> V2: old sending stream image is used
> V3: image file has been compressed by gzip

Thanks. Should be compressed by 'xz -9', the result is now 2k instead of
11k. The extract_image now understands compressed streams. Test script
updated.
