From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Wed, 2 May 2012 16:48:22 +0200
Message-ID: <20120502144822.GB7110@ds.suse.cz>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
 <20120502142843.GD6740@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
To: Hubert Kario <kario@wit.edu.pl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120502142843.GD6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 02, 2012 at 04:28:43PM +0200, David Sterba wrote:
> I had prototyped a similar utility (in perl, so nothing for progs
> inclusion for now)

attached.

david

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=btrfs-dev-clear-sb

#!/usr/bin/perl

# clear btrfs signature from a device

use Fcntl;

use constant BTRFS_SUPER_INFO_OFFSET => 64 * 1024;
use constant BTRFS_SUPER_INFO_SIZE => 4096;

use constant BTRFS_SUPER_MIRROR_MAX => 3;
use constant BTRFS_SUPER_MIRROR_SHIFT => 12;

use constant BTRFS_MAGIC => "_BHRfS_M";
use constant BTRFS_DEAD  => '_BHRf$_M';

sub btrfs_sb_offset($) {
	my $mirror =$_[0];
	my $start = 16 * 1024;
	if ($mirror>0) {
		return $start << (BTRFS_SUPER_MIRROR_SHIFT * $mirror);
	}
	return BTRFS_SUPER_INFO_OFFSET;
}

my $dbg=1;
my $savesb=0;

# main
my $dev=$ARGV[0];
my $size;
if(!-b $dev) {
	print("Not a block device: $dev\n");
	$size=(stat($dev))[7];
} else {
	$size=`blockdev --getsize64 "$dev"`;
}
sysopen(F, $dev, O_EXCL | O_RDWR) or die("Cannot open $dev exclusively: $!");
print("Device size: $size\n") if($dbg);
for(my $i=0;$i<6;$i++) {
	my $off=btrfs_sb_offset($i);
	if($off > $size) {
		print("Offset for SB $i beyond EOF\n") if($dbg);
		last;
	}
	print("Offset $i is $off\n") if($dbg);
	sysseek(F, $off, 0);
	sysread(F, $buf, BTRFS_SUPER_INFO_SIZE);
	if($savesb) {
		open(Q,">SB$i");
		print Q ($buf);
		close(Q);
	}
	my $sbmagic=substr($buf, 0x40, length(BTRFS_MAGIC));
	print("SB magic: $sbmagic\n") if($dbg);
	if(BTRFS_MAGIC eq $sbmagic) {
		print("Found a valid signature of superblock $i\n");
		sysseek(F, $off + 0x40, 0);
		print("Clearing...\n");
		syswrite(F, BTRFS_DEAD, length(BTRFS_DEAD));
	} elsif(BTRFS_DEAD eq $sbmagic) {
		print("Found a signature of a dead superblock $i\n");
	} else {
		print("Superblock $i does not look like a btrfs one\n");
	}
}
close(F);
print("Syncing dev\n");
if (!-b $dev) {
	system("fsync \'$dev\'");
} else {
	system("blockdev --flushbufs \'$dev\'");
}

--u3/rZRmxL6MmkK24--
