Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932075AbdJJQiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 12:38:51 -0400
Date: Tue, 10 Oct 2017 18:37:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] Btrfs: handle unaligned tail of data ranges more
 efficient
Message-ID: <20171010163706.GR3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
 <20171003150604.19596-4-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003150604.19596-4-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 06:06:03PM +0300, Timofey Titovets wrote:
> At now while switch page bits in data ranges
> we always hande +1 page, for cover case
> where end of data range is not page aligned

The 'end' is inclusive and thus not aligned in most cases, ie. it's
offset 4095 in the page, so the IS_ALIGNED is allways true and the code
is equivalent to the existing condition (index <= end_index).
