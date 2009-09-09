From: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>
Subject: Re: btrfs csum failed on git .pack file
Date: Wed, 9 Sep 2009 22:01:28 +0100
Message-ID: <21A769F737B64494B43804084FB1EF88@home.omattos.com>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de> <20090908200041.GF18599@kernel.dk> <20090908202211.GA1901@phenom2.trippelsdorf.de> <20090908203214.GH18599@kernel.dk> <20090909065533.GA2861@phenom2.trippelsdorf.de> <20090909070141.GL18599@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Cc: <linux-btrfs@vger.kernel.org>
To: "Jens Axboe" <jens.axboe@oracle.com>,
	"Markus Trippelsdorf" <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090909070141.GL18599@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>


>> What a strange coincidence that it affected git pack files in both cases.
>> It's almost too improbable...

>Probably more than a coincidence I think, the question is what though...

Some SSD drives (or rather the cheap wear levelling controllers in things
like USB sticks) have firmware which tries to recognise certain data
structures of common filesystems (like FAT and NTFS), and uses information
in those data structures to optimise the allocation and erasure of blocks
(for example the free space linked list in FAT).  If the data you were
saving to the disk was similar to one of those data structures, you might've
triggered one of those algorithms, which would cause data corruption.  This
is common in high performance usb sticks because they want to pre-erase
blocks on file deletion for operating systems not supporting SCSI TRIM - I
imagine the same technology might carry across to cheap SSD's.

Not much BTRFS can do about it though.  If the piece of data that triggers
the bug could be identified, workarounds could possibly be introduced for
the particular buggy controllers.

Oliver Mattos

(resent as I emailled wrong recipients before) 

