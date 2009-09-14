From: Josef Bacik <josef@redhat.com>
Subject: Re: Oops with enospc-branch
Date: Mon, 14 Sep 2009 11:42:23 -0400
Message-ID: <20090914154222.GA25833@localhost.localdomain>
References: <200909141326.48354.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200909141326.48354.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2009 at 01:26:48PM +0200, Johannes Hirte wrote:
> With the enospc-branch my system oops with some workload. Netconsole gave me 
> this trace:
> 

Thank you for reporting this.  I'm able to reproduce it here and am working on a
fix.  Thanks,

Josef
