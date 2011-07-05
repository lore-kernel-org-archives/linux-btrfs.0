From: Anand Jain <Anand.Jain@oracle.com>
Subject: bug: missing snapshot as in the btrfs subvolume list command
Date: Tue, 05 Jul 2011 18:10:42 +0800
Message-ID: <4E12E322.3050404@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



A confirmation if the following bug is being taken care will help.

Have 9 sub-vols `btrfs subvolume list /btrfs`
---------------------------------------------
# btrfs subvolume list /btrfs
ID 256 top level 5 path sv1
ID 257 top level 5 path snapy23988
ID 258 top level 5 path snapi24000
ID 259 top level 5 path snapC24009
ID 260 top level 5 path snapo24018
ID 261 top level 5 path snapm24027
ID 262 top level 5 path snapx24036
ID 263 top level 5 path snape24045
ID 264 top level 5 path snapt24054
# btrfs subvolume list /btrfs | wc -l
9
----------------------------------------

and create 10th subvol
-------
# S=`mktemp -u /btrfs/snapXXXXXX`; btrfs subvolume snapshot 
/btrfs/snapt24054 $S
Create a snapshot of '/btrfs/snapt24054' in '/btrfs/snapm24071'
------

now list fails to report ID 261 (note that last snapshot was
successfully created)
----------------
# btrfs subvolume list /btrfs
ID 256 top level 5 path sv1
ID 257 top level 5 path snapy23988
ID 258 top level 5 path snapi24000
ID 259 top level 5 path snapC24009
ID 260 top level 5 path snapo24018
ID 262 top level 5 path snapx24036
ID 263 top level 5 path snape24045
ID 264 top level 5 path snapt24054
ID 265 top level 5 path snapm24071
# btrfs subvolume list /btrfs | wc -l
9
#
------------------------------

only happens at 10th subvol if you create 11th subvol list if fine.
------------------------------
# S=`mktemp -u /btrfs/snapXXXXXX`; btrfs subvolume snapshot 
/btrfs/snapm24071 $S
Create a snapshot of '/btrfs/snapm24071' in '/btrfs/snapR24080'
# btrfs subvolume list /btrfs
ID 256 top level 5 path sv1
ID 257 top level 5 path snapy23988
ID 258 top level 5 path snapi24000
ID 259 top level 5 path snapC24009
ID 260 top level 5 path snapo24018
ID 261 top level 5 path snapm24027
ID 262 top level 5 path snapx24036
ID 263 top level 5 path snape24045
ID 264 top level 5 path snapt24054
ID 265 top level 5 path snapm24071
ID 266 top level 5 path snapR24080
# btrfs subvolume list /btrfs | wc -l
11
#
---------------------------

Thanks,
-Anand
