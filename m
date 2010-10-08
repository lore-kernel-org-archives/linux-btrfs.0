From: <remi.urbillac@orange-ftgroup.com>
Subject: Parity RAIDs in btrfs / RAID5 or RAID6
Date: Fri, 8 Oct 2010 15:11:13 +0200
Message-ID: <32648_1286543473_4CAF1871_32648_227736_1_EABF98D1E9AEBB48A74724A0F1D9E8C71D279D68F1@PUEXCB2A.nanterre.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, 

I had a technical question about implementation of parity raid levels in btrfs, like RAID5 and or RAID6. 

Considering WAFL, the NetApp filesystem, each block is 4Kb. 
When we read 1 block, we have one 4Kb I/O on only one disk of the raid group.
So the raid group has a "random read I/O power" of all the disks it is made from.
Of course, WAFL was made form the beginning in order to use a NVRAM, which helps a lot. 

ZFS, with raidz1/2/3, uses a different idea. One block can have different size, and, in order to prevent the "write hole" issue, it was decided to spread the block in all disks of the raid group. 
Pros : we never have raid inconsistencies, even without NVRAM. 
Cons: in random read I/O, raidz1/2/3 are very pool performer. One raid group has the "I/O power" of one disk. 
Today, for a production storage solution, this can be a real issue. 

My question was about the direction btrfs had/will choose.
Of course, a solution like WAFL would be the best choice, in term of performance.  

If someone knows something about this ... 

Regards, 

Remi Urbillac
*********************************
This message and any attachments (the "message") are confidential and intended solely for the addressees. 
Any unauthorised use or dissemination is prohibited.
Messages are susceptible to alteration. 
France Telecom Group shall not be liable for the message if altered, changed or falsified.
If you are not the intended addressee of this message, please cancel it immediately and inform the sender.
********************************

