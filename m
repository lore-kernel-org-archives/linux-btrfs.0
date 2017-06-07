Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:32941 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdFGRhj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 13:37:39 -0400
Received: by mail-pg0-f51.google.com with SMTP id f185so7573829pgc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 10:37:39 -0700 (PDT)
Date: Wed, 7 Jun 2017 10:37:37 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, kernel-team@fb.com
Subject: Re: [PATCH 0/7] Btrfs: fix total_bytes_pinned counter
Message-ID: <20170607173737.GB7481@vader.DHCP.thefacebook.com>
References: <cover.1496792333.git.osandov@fb.com>
 <af6b94b7-3aa9-5bcb-df7e-01c21506a219@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <af6b94b7-3aa9-5bcb-df7e-01c21506a219@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 05:48:05PM +0200, Holger Hoffstätte wrote:
> On 06/07/17 01:45, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > This series fixes several problems with the total_bytes_pinned counter.
> > Patches 1 and 2 are cleanups. Patches 3 and 4 are straightforward fixes.
> > Patch 5 is prep for patch 6. Patch 6 is the most complicated fix.
> > Patches 5 and 6 are ugly, I'd love any suggestions for a cleaner fix.
> > Finally, patch 7 adds a warning to catch similar issues in the future.
> 
> Since this didn't really change the code significantly from the previous
> version (except for the addition of minor patches 2+7) have a
> 
> Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks for testing, Holger!
