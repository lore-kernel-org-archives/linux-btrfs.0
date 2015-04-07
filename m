Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:39863 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbbDGOhw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 10:37:52 -0400
From: Russell Coker <russell@coker.com.au>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: btrfs subvolume & default subvolume
Date: Tue, 7 Apr 2015 14:37:46 +0000
Cc: linux-btrfs@vger.kernel.org
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com> <201504071358.29442.russell@coker.com.au> <CAK1hC9uUdBhS92RdVsxvbGY4L5bEXq7-5nNa6m-=XVkC-CLoUQ@mail.gmail.com>
In-Reply-To: <CAK1hC9uUdBhS92RdVsxvbGY4L5bEXq7-5nNa6m-=XVkC-CLoUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504071437.46807.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 7 Apr 2015 02:03:04 PM arnaud gaboury wrote:
> Would you mind give the return of # btrfs subvolume list and $ cat
> /etc/fstab ? It would help me. TY

ID 262 gen 1579103 top level 5 path mysql                                                                                                                                                                               
ID 263 gen 1179578 top level 5 path var/spool/squid                                                                                                                                                                     
ID 264 gen 1579262 top level 5 path xenstore                                                                                                                                                                            
ID 265 gen 1579262 top level 5 path mailstore                                                                                                                                                                           
ID 269 gen 1578978 top level 5 path xenswap                                                                                                                                                                             
ID 318 gen 1569545 top level 5 path webstore                                                                                                                                                                            
ID 328 gen 1574457 top level 262 path mysql/backup                                                                                                                                                                      
ID 329 gen 1569555 top level 264 path xenstore/backup                                                                                                                                                                   
ID 330 gen 1574457 top level 265 path mailstore/backup                                                                                                                                                                  
ID 331 gen 1569555 top level 318 path webstore/backup                                                                                                                                                                   
ID 618 gen 1569546 top level 5 path webdata                                                                                                                                                                             
ID 657 gen 1569555 top level 618 path webdata/backup                                                                                                                                                                    
ID 1456 gen 1569541 top level 5 path backup                                                                                                                                                                             
ID 1621 gen 1556937 top level 330 path mailstore/backup/2015-04-01                                                                                                                                                      
ID 1622 gen 1556938 top level 328 path mysql/backup/2015-04-01                                                                                                                                                          
ID 1623 gen 1559462 top level 330 path mailstore/backup/2015-04-02                                                                                                                                                      
ID 1624 gen 1559463 top level 328 path mysql/backup/2015-04-02                                                                                                                                                          
ID 1625 gen 1564402 top level 330 path mailstore/backup/2015-04-03                                                                                                                                                      
ID 1626 gen 1564403 top level 328 path mysql/backup/2015-04-03                                                                                                                                                          
ID 1627 gen 1566974 top level 330 path mailstore/backup/2015-04-04                                                                                                                                                      
ID 1628 gen 1566975 top level 328 path mysql/backup/2015-04-04                                                                                                                                                          
ID 1629 gen 1569540 top level 330 path mailstore/backup/2015-04-05                                                                                                                                                      
ID 1630 gen 1569543 top level 1456 path backup/2015-04-05                                                                                                                                                               
ID 1631 gen 1569542 top level 328 path mysql/backup/2015-04-05                                                                                                                                                          
ID 1632 gen 1569544 top level 329 path xenstore/backup/2015-04-05                                                                                                                                                       
ID 1633 gen 1569545 top level 331 path webstore/backup/2015-04-05                                                                                                                                                       
ID 1634 gen 1569546 top level 657 path webdata/backup/2015-04-05                                                                                                                                                        
ID 1635 gen 1571975 top level 330 path mailstore/backup/2015-04-06                                                                                                                                                      
ID 1636 gen 1571976 top level 328 path mysql/backup/2015-04-06                                                                                                                                                          
ID 1638 gen 1574447 top level 330 path mailstore/backup/2015-04-07                                                                                                                                                      
ID 1639 gen 1574448 top level 328 path mysql/backup/2015-04-07

Above is from one of my servers.  I've recently changed my backup naming 
scheme from $SUBVOL/backup to backup-$SUBVOL but haven't done it to that 
server yet.

ID 259 gen 394029 top level 5 path home                                                                                                                                                                            
ID 542 gen 389407 top level 5 path backup                                                                                                                                                                               
ID 2143 gen 393962 top level 5 path backup-home                                                                                                                                                                         
ID 4946 gen 394029 top level 5 path chroot                                                                                                                                                                              
ID 5609 gen 391938 top level 2143 path backup-home/2015-04-01                                                                                                                                                           
ID 5610 gen 391939 top level 2143 path backup-home/2015-04-01:00:00                                                                                                                                                     
ID 5611 gen 391984 top level 2143 path backup-home/2015-04-01:04:00                                                                                                                                                     
ID 5612 gen 392151 top level 2143 path backup-home/2015-04-03:02:00                                                                                                                                                     
ID 5613 gen 392252 top level 2143 path backup-home/2015-04-03:15:00                                                                                                                                                     
ID 5614 gen 392408 top level 2143 path backup-home/2015-04-04:04:00                                                                                                                                                     
ID 5615 gen 392543 top level 2143 path backup-home/2015-04-05                                                                                                                                                           
ID 5616 gen 392544 top level 2143 path backup-home/2015-04-05:00:00                                                                                                                                                     
ID 5617 gen 392620 top level 2143 path backup-home/2015-04-05:02:00                                                                                                                                                     
ID 5618 gen 392700 top level 2143 path backup-home/2015-04-05:14:00                                                                                                                                                     
ID 5619 gen 392779 top level 2143 path backup-home/2015-04-05:15:00                                                                                                                                                     
ID 5620 gen 392859 top level 2143 path backup-home/2015-04-05:20:00                                                                                                                                                     
ID 5621 gen 392966 top level 2143 path backup-home/2015-04-05:21:00                                                                                                                                                     
ID 5622 gen 393086 top level 2143 path backup-home/2015-04-06:15:00                                                                                                                                                     
ID 5623 gen 393191 top level 2143 path backup-home/2015-04-06:19:00                                                                                                                                                     
ID 5624 gen 393315 top level 2143 path backup-home/2015-04-07:13:00                                                                                                                                                     
ID 5625 gen 393419 top level 2143 path backup-home/2015-04-07:14:00                                                                                                                                                     
ID 5626 gen 393526 top level 2143 path backup-home/2015-04-07:15:00                                                                                                                                                     
ID 5627 gen 393645 top level 2143 path backup-home/2015-04-07:16:00                                                                                                                                                     
ID 5628 gen 393756 top level 2143 path backup-home/2015-04-07:17:00                                                                                                                                                     
ID 5629 gen 393847 top level 2143 path backup-home/2015-04-07:23:00                                                                                                                                                     
ID 5630 gen 393960 top level 2143 path backup-home/2015-04-08:00:00                                                                                                                                                     
ID 5631 gen 393961 top level 2143 path backup-home/2015-04-08

Above is from one of my workstations.

In both cases the BTRFS filesystem in question was mounted as root.

In both cases I grepped out the backups prior to this month, hundreds of extra 
lines would have made things less clear.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
