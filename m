From: David Sterba <dave@jikos.cz>
Subject: Re: Regression in btrfs-next: BUG at fs/btrfs/super.c:984!
Date: Sun, 2 Oct 2011 19:39:10 +0200
Message-ID: <20111002173910.GL22205@twin.jikos.cz>
References: <1317505390.2071.4.camel@picard>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317505390.2071.4.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 01, 2011 at 11:43:10PM +0200, Maciej Marcin Piechotka wrote:
> PS. It might happened that it was caused by parition mounted read-only
> on read-only block device.
  ^^^

This is the key information!

super.c: btrfs_calc_avail_data_space()
 983         nr_devices = fs_info->fs_devices->rw_devices;
 984         BUG_ON(!nr_devices);


If there are no writable devices, this BUGON fires, although this case
in connection with RO mount is handled elsewhere properly.

This is called through sysfs and just tries to obtain available free
space information to print it. I think the BUG_ON is not necessary here
and the function can take a short track returning 0 as available free
space:

if (!nr_devices) {
	*free_bytes = 0;
	return 0;
}

I could be possible to actually read the free space even from a RO
device (be it RO mount or not), but I don't see much benefit which would
justify the work.

Can you please test the fix and let us know if the statfs number look
reasonable?


david
