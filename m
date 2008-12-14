From: Omen Wild <omen+btrfs@mandarb.com>
Subject: Re: Data De-duplication
Date: Sun, 14 Dec 2008 11:37:25 -0800
Message-ID: <20081214193725.GA14182@mandarb.com>
References: <1228862899.8130.1.camel@mattos-laptop> <1228915802.11900.8.camel@think.oraclecorp.com> <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com> <1228943437.7571.1.camel@mattos-laptop> <20081210211903.GA29002@bludgeon.org> <1228945336.7571.26.camel@mattos-laptop> <20081210215754.GT23979@tracyreed.org> <20081210221006.GA30484@bludgeon.org> <1228954691.7571.33.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228954691.7571.33.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Quoting Oliver Mattos <oliver.mattos08@imperial.ac.uk> on Thu, Dec 11 00:18:
>
> > It would be interesting to see how many duplicate *blocks* there are
> > across the filesystem, agnostic to files...

Here is my contribution.  It's a perl script that goes through every
block (of various block sizes) on a device and prints out summaries.
It uses BerkeleyDB to store the hashes as it goes as there are an
enormous number for smaller block sizes.

It checks every block, not just the used blocks, so on a file system
less that 100% full it really isn't a proper test.

It requires root privileges in order to read the raw block device.

My root filesystem on my Debian box, 20G, 9.2G used:
root:   512 byte blocks 27.07% duplicate.
root:  1024 byte blocks 26.20% duplicate.
root:  4096 byte blocks 23.17% duplicate.
root:  8192 byte blocks 15.31% duplicate.
root: 16384 byte blocks 9.57% duplicate.

For my home partition, 20G, 29% used
home:   512 byte blocks 32.11% duplicate.
home:  1024 byte blocks 31.16% duplicate.
home:  4096 byte blocks 29.85% duplicate.
home:  8192 byte blocks 21.31% duplicate.
home: 16384 byte blocks 10.84% duplicate.

There is, of course, a fair amount of overhead for smaller blocks:
512b 3.91% overhead
1k   1.95% overhead
4k   0.49% overhead
8k   0.24% overhead
16k  0.12% overhead

Though, 4% overhead for 27-32% savings seems pretty impressive.  Again,
it checksums all blocks, not just used blocks, so the whole test might
be bogus.

-- 
Life is wasted on the living.

--a8Wt8u1KmwUX3Y2C
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="duplicate-check-db.pl"

#! /usr/bin/perl

use strict;
use warnings;

use BerkeleyDB;
use DBI;
use Data::Dumper;
use Digest::SHA1;
use Fcntl;

$| = 1;

my $env = new BerkeleyDB::Env({
										 -Home => $ENV{'HOME'} . "/work/bulk",
										});

my @blocksizes = (qw/16384 8192 4096 1024 512/);
#my @blocksizes = (qw/16384/);

while (my $device = shift) {
  my $device_size = `env POSIXLY_CORRECT=1 df $device | tail -1 | awk '{printf "%d", \$1}'`;
  if ($device_size <= 0) {
	 die "Unable to find device block count through df, make sure you pass /dev/mapper/devicename for logical volumes.\n";
  }

  foreach my $blocksize (sort {$a <=> $b} @blocksizes) {
	 my $device_blocks = ($device_size * 512) / $blocksize;

	 print "Testing \`$device': $blocksize bytes, $device_blocks blocks\n";

	 my $device_sanitized = $device;
	 $device_sanitized =~ s@/@_@g;
	 $device_sanitized =~ s/[^-a-zA-Z0-9_]//g;

	 my $data;
	 my $percent_done = 0;
	 my $blocks = 0;

	 my %hashes;
	 unlink("$device_sanitized.db");
	 my $db = tie %hashes, 'BerkeleyDB::Hash',
		-Filename => "$device_sanitized.db",
		  -Cachesize => 2**26,
			 -Flags    => DB_CREATE;
			 

	 my $time_start = time();
	 sysopen(DEVICE, $device, O_RDONLY) or die;
	 while ((my $bytes_read = sysread(DEVICE, $data, 2**20)) >= $blocksize) {
		# Read 1M at a time
		for (my $i = 0; $i < $bytes_read / $blocksize; $i++) {
		  my $substr = substr($data, $i * $blocksize, $blocksize);
		  #printf("Block %d, i = %d, offset = %d\n",
			#		$blocks, $i, $i * $blocksize);
		  my $digest = Digest::SHA1->sha1($substr);
		  $hashes{$digest}++;
		  $blocks++;
		  my $pdone = int(100 * ($blocks / $device_blocks));
		  if ($pdone != $percent_done) {
			 printf STDERR ("Done: %d%% %d/%d, %d seconds\n",
								$pdone, $blocks, $device_blocks,
								time() - $time_start);
			 $percent_done = $pdone;
			 $time_start = time();
		  }
		}
	 }
	 close(DEVICE);

	 my $blocks_saved = 0.0;
	 while (my ($key, $value) = each(%hashes)) {
		if ($value > 1) {
		  $blocks_saved += $value;
		}
	 }
	 my $saved = $blocks_saved * $blocksize;
	 my $total_size = $blocks * $blocksize;

	 printf("%s: %5d byte blocks, %d blocks\n",
			  $device, $blocksize);
	 printf("\t%d duplicate blocks, %.0f duplicate bytes.\n",
			  $blocks, $blocks_saved, $saved);
	 printf("\t%.2f%% overhead, %.2f%% duplicate.\n",
			  (20.0 / $blocksize) * 100, ($saved / ($total_size + $saved)) * 100);
  }
}

--a8Wt8u1KmwUX3Y2C--
