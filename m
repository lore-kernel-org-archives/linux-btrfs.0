Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2FHRku (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 13:40:50 -0400
Date: Fri, 8 Jun 2012 13:40:48 -0400
From: Josef Bacik <josef@redhat.com>
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New WARNING at fs/btrfs/extent_map.c:226 unpin_extent_cache with
 kernel 3.5-rc1
Message-ID: <20120608174048.GB1532@localhost.localdomain>
References: <CAHg_5gpyMpa2HcRc+tSrbbEyWCcyrFOHfzK5w0N-TXABgCenYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHg_5gpyMpa2HcRc+tSrbbEyWCcyrFOHfzK5w0N-TXABgCenYA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2012 at 09:58:44PM +0200, Catalin Iacob wrote:
> I just booted into a current git kernel and got 6 of these in about
> 1h30min of usage
> 

Yeah sorry!  I've been working on this all week, I've just about got it nailed
down, go back to 3.4 and you'll be fine for now.  Thanks,

Josef
