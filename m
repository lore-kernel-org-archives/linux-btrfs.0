Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:33296 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbcEFLsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 May 2016 07:48:36 -0400
Received: from localhost (unknown [192.168.1.189])
	by mail2.linuxsystems.it (Postfix) with ESMTPSA id 60737A3FA1
	for <linux-btrfs@vger.kernel.org>; Fri,  6 May 2016 13:48:34 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: How to rollback a snapshot of a subvolume with nested =?iso-8859-1?Q?subvolumes=3F?=
Date: Fri, 06 May 2016 13:48:31 +0200
MIME-Version: 1.0
Message-ID: <3812e008-1c89-4e02-8389-17ca2a8cfd9d@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following are my subvolumes:

$ sudo btrfs subvol list /
[sudo] password di niko: 
ID 257 gen 1040 top level 5 path @
ID 258 gen 1040 top level 5 path @home
ID 270 gen 889 top level 257 path var/cache/pacman/pkg
ID 271 gen 15 top level 257 path var/abs
ID 272 gen 972 top level 257 path var/tmp
ID 273 gen 37 top level 257 path tmp
ID 274 gen 20 top level 257 path srv
ID 276 gen 25 top level 258 path @home/niko/.cache/pacaur
ID 280 gen 993 top level 257 path .snapshots
ID 281 gen 993 top level 258 path @home/.snapshots
ID 282 gen 169 top level 280 path .snapshots/1/snapshot
ID 283 gen 171 top level 280 path .snapshots/2/snapshot
ID 284 gen 173 top level 280 path .snapshots/3/snapshot
ID 285 gen 124 top level 281 path @home/.snapshots/1/snapshot
ID 286 gen 175 top level 280 path .snapshots/4/snapshot
ID 288 gen 177 top level 280 path .snapshots/5/snapshot
ID 290 gen 237 top level 280 path .snapshots/6/snapshot
ID 291 gen 238 top level 281 path @home/.snapshots/2/snapshot
ID 292 gen 308 top level 280 path .snapshots/7/snapshot
ID 293 gen 309 top level 281 path @home/.snapshots/3/snapshot
ID 294 gen 376 top level 280 path .snapshots/8/snapshot
ID 295 gen 377 top level 281 path @home/.snapshots/4/snapshot               
                                                 
ID 296 gen 442 top level 280 path .snapshots/9/snapshot                     
                                                 
ID 297 gen 443 top level 281 path @home/.snapshots/5/snapshot               
                                                 
ID 298 gen 511 top level 280 path .snapshots/10/snapshot                    
                                                 
ID 299 gen 512 top level 281 path @home/.snapshots/6/snapshot               
                                                 
ID 300 gen 578 top level 280 path .snapshots/11/snapshot                    
                                                 
ID 301 gen 579 top level 281 path @home/.snapshots/7/snapshot               
                                                 
ID 302 gen 648 top level 280 path .snapshots/12/snapshot                    
                                                 
ID 303 gen 649 top level 281 path @home/.snapshots/8/snapshot               
                                                 
ID 304 gen 716 top level 280 path .snapshots/13/snapshot                    
                                                 
ID 305 gen 717 top level 281 path @home/.snapshots/9/snapshot               
                                                 
ID 306 gen 967 top level 280 path .snapshots/14/snapshot                    
                                                 
ID 307 gen 789 top level 281 path @home/.snapshots/10/snapshot              
                                                 
ID 309 gen 834 top level 280 path .snapshots/15/snapshot                    
                                                 
ID 310 gen 874 top level 280 path .snapshots/16/snapshot                    
                                                 
ID 311 gen 875 top level 281 path @home/.snapshots/11/snapshot              
                                                 
ID 312 gen 887 top level 280 path .snapshots/17/snapshot                    
                                                                            
                                                                            
                         
ID 313 gen 888 top level 280 path .snapshots/18/snapshot                    
                                                                            
                                                                            
                         
ID 314 gen 904 top level 280 path .snapshots/19/snapshot                    
                                                                            
                                                                            
                         
ID 316 gen 938 top level 280 path .snapshots/20/snapshot                    
                                                                            
                                                                            
                         
ID 317 gen 939 top level 281 path @home/.snapshots/12/snapshot              
                                                                            
                                                                            
                         
ID 318 gen 991 top level 280 path .snapshots/21/snapshot                    
                                                                            
                                                                            
                         
ID 319 gen 992 top level 281 path @home/.snapshots/13/snapshot

I would like to rollback to .snapshots/14/snapshot, restoring my @ 
subvolume to such a previous state.
So I booted into a livecd, mounted my disk into /mnt and typed:
btrfs subvol snapshot /mnt/@/.snapshots/14/snapshot /mnt/@

Unfortunately it simply creates a new /mnt/@/snapshot subvolume instead of 
replacing @.
If @ didn't have any nested subvolume I would simply delete it and run the 
previous command again, but
1) I dont't want to lose the @ nested subvolumes like var/cache/pacman/pkg
2) btrfs subvolume delete /mnt/@ doesn't want to delete it (cannot delete 
directory not empty), probably because of the nested subvolumes

So, how am I supposed to rollback to a previous snapshot?

Thanks,
Niccolò
