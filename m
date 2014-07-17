Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outmail110.swisscom.com ([193.222.81.110]:45462 "EHLO
	mail.swisscom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754731AbaGQNCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 09:02:18 -0400
From: <Philippe.Simonet@swisscom.com>
To: <hugo@carfax.org.uk>
CC: <linux-btrfs@vger.kernel.org>
Subject: RE: NFS FILE ID not unique when exporting many brtfs subvolumes
Date: Thu, 17 Jul 2014 13:02:06 +0000
Message-ID: <fa81b967fc564d7db91ef948c6605a3f@SG001738.corproot.net>
References: <562cbe8120c64c99b7dcee045a3bdc7e@SG001738.corproot.net>
 <20140717111303.GI4834@carfax.org.uk>
In-Reply-To: <20140717111303.GI4834@carfax.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo

> -----Original Message-----
> From: Hugo Mills [mailto:hugo@carfax.org.uk]
> Sent: Thursday, July 17, 2014 1:13 PM
> To: Simonet Philippe, INI-ON-FIT-NW-IPE
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: NFS FILE ID not unique when exporting many brtfs subvolumes
> 
> On Thu, Jul 17, 2014 at 10:40:14AM +0000, Philippe.Simonet@swisscom.com
> wrote:
> > I have a problem using btrfs/nfs to store my vmware images.
> [snip]
> > - vmware is basing its NFS files locks on the nfs fileid field returned from a NFS
> GETATTR request for the file being locked
> >
> 	http://kb.vmware.com/selfservice/microsites/search.do?language=en_
> US&cmd=displayKC&externalId=1007909
> >    vmware assumes that these nfs fileid are unique per storage.
> >
> > - it seemed that these nfs fileid are only unique 'per-subvolume', but because
> my nfs export contains many subvolumes,
> > the nfs export has then my files (in different subvolume) with the same nfs
> fileid.
> >
> > - no problem when I start all machine alone, but when 2 machines are running
> at the same time, vmware seems to mix its reference to lock file and
> > sometimes kills one vm.
> >
> > 	in esx server, following messages : 	/var/log/vmkwarning.log :
> >
> > 	2014-07-17T06:31:46.854Z cpu2:268913)WARNING: NFSLock: 1315:
> Inode (Dup: 260 Orig: 260) has been recycled by server, freeing lock info for
> .lck-0401000000000000
> > 	2014-07-17T06:34:47.925Z cpu2:114740)WARNING: NFSLock: 2348:
> Unable to remove lockfile .invalid, not found
> > 	2014-07-17T10:18:50.320Z cpu0:32824)WARNING: NFSLock: 2348:
> Unable to remove lockfile .invalid, not found
> >
> > 	and in machine log :
> > 		Message from sncubeesx02: The lock protecting vm-w7-
> sysp.vmdk has been lost,
> > 		possibly due to underlying storage issues. If this virtual machine
> is configured to be highly
> > 		available, ensure that the virtual machine is running on some
> other host before clicking OK.
> >
> > - vmware try to make its own file locking for flowing file type :
> >
> 	http://kb.vmware.com/selfservice/microsites/search.do?language=en_
> US&cmd=displayKC&externalId=10051
> >
> > 	VMNAME.vswp
> > 	DISKNAME-flat.vmdk
> > 	DISKNAME-ITERATION-delta.vmdk
> > 	VMNAME.vmx
> > 	VMNAME.vmxf
> > 	vmware.log
> >
> > Is there a way to deal with this problem ? is that a bug ?
> 
>    Add an arbitrary and unique "fsid=0x12345" value to the exports
> declaration. For example, my server exports a number of subvolumes
> from the same FS with:
> 
> /srv/nfs/nadja    -rw,async,fsid=0x1729,no_subtree_check,no_root_squash \
>                    10.0.0.20 fe80::20
> /srv/nfs/home     -rw,async,fsid=0x1730,no_subtree_check,no_root_squash \
>                    fe80::/64
> /srv/nfs/video    -ro,async,fsid=0x1731,no_subtree_check \
>                    10.0.0.0/24 fe80::/64
> 
>    Hugo.
> 

first of all, thank for your answer !
on my system, I have one export, that is the root btrfs subvolume and contains itself one subvolume per vm.
if I change the NFS export  fsid, it does not change anything in each the file IDs of the whole NFS export. 
(I crossed checked it just to be sure, tshark -V -nlp -t a port 2049 | egrep "Entry: name|File ID", and effectively, 
fsid has no impact on file id) 



> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- You can get more with a kind word and a two-by-four than you ---
>                        can with just a kind word.
