From: Josef Bacik <josef@redhat.com>
Subject: Re: how to check data and metadata type
Date: Sat, 30 Jan 2010 10:18:49 -0500
Message-ID: <20100130151848.GA7233@localhost.localdomain>
References: <42D1AF99-19ED-4C44-9A01-8039576AA572@kupper.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <42D1AF99-19ED-4C44-9A01-8039576AA572@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2010 at 11:43:45PM +0100, Thomas Kupper wrote:
> Just a short question:
> 
> How can I check the data and metadata modes of a multi-device btrfs device? btrfs-show is of no help and df is still not showing the correct size of it either (using latest btrfs kernel module and btrfs tools).

There are patches to do this for you, look for the "-i" patch for btrfs-progs
and the "df" patch for the kernel, that will give you the information you are
looking for.  Thanks,

Josef
