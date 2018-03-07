Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47269 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbeCGO1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 09:27:39 -0500
Date: Wed, 7 Mar 2018 15:25:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 55/63] btrfs: Convert page cache to XArray
Message-ID: <20180307142515.GB23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180306192413.5499-1-willy@infradead.org>
 <20180306192413.5499-56-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180306192413.5499-56-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 11:24:05AM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Acked-by: David Sterba <dsterba@suse.com>
