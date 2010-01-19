From: jim owens <jowens@hp.com>
Subject: [RFC PATCH 00/03] Btrfs Direct I/O for .34 maybe
Date: Tue, 19 Jan 2010 16:58:24 -0500
Message-ID: <4B562B00.3050003@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is the completed code for direct I/O read.  It handles all extent
types, validates checksums, and does retries.

I have tested all the paths (on X86-64) but it needs testing with
automation in a larger setup.  If this design is acceptable,
Eric Whitney will run those tests.

The code supports 512-byte-device access, which is one of the reasons
for it being complex.  But I believe people expect that so we should
not take the easy way out by limiting it to btrfs block size access.

All completion/checksum/decompression processing occurs in 1 thread
rather than being spread out.  This is intentional because that way
directIO scales with multiple users and does not eat all resources.

The code requires use_mm() to permit 2 worker threads to make calls
to get_user_pages_fast().  One worker is the completion reaper.  The
other worker is for aio submit so we return control immediately to
the application before any I/O is initiated.  The INFO PATCH 02 is
what I sent to Andrew Morton so that btrfs can be built as a module.
I hope the only reason it was not put in 33 is he is waiting for
a caller (my code) that needs it.  

All of my previous patches except the one I retracted are required
to use this code if anyone wants to try it.

I'm ready for comments, questions, insults, whatever.

jim
