From: Peter Macko <pmacko@eecs.harvard.edu>
Subject: Question about back references
Date: Sat, 05 Sep 2009 16:19:50 -0400
Message-ID: <4AA2C7E6.40200@eecs.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to understand how exactly the file extent back references 
work in btrfs. Can please someone tell me if the following is correct? - 
The back references are accumulated in an in-memory balanced tree 
(delayed-ref.c and delayed-ref.h) and pushed to disk during the 
transaction commit (a part of a checkpoint). They are placed into the 
B-tree under the key (bytenr, BTRFS_EXTENT_REF_KEY, hash of the four 
fields of the record), so that they are stored next to the file extent 
forward references.

I am also wondering about the implications of copy on write: Imagine 
that you have an inode with four file extents and thus also four back 
references. COW of one of the extents then causes the COW of the inode. 
The new version of the inode has a different transaction ID, which is 
also one of the fields of back reference records. This causes the file 
system to add four new back reference records - one for the modified 
extent and three for the unmodified ones (since the transaction ID field 
has to be updated). Does this really happen, or is there some scheme to 
avoid adding these extra records?

Thank you,

Peter Macko

