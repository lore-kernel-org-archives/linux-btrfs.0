Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:59259 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932348AbaJUPKf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 11:10:35 -0400
Message-ID: <54467768.4070302@pobox.com>
Date: Tue, 21 Oct 2014 08:10:32 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
References: <201410181454.19375.russell@coker.com.au> <pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net> <20141020130243.GB29401@hungrycats.org> <201410212113.30887.russell@coker.com.au>
In-Reply-To: <201410212113.30887.russell@coker.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/2014 03:13 AM, Russell Coker wrote:
> On Tue, 21 Oct 2014, Robert White <rwhite@pobox.com> wrote:
>> What happens if you stop the Xen domain for the mail server and then
>> mount the disks into a native 64bit environment and then ls the file name?
>
> The filesystem in question is NFS mounted from a server with 64bit kernel+user
> to a virtual server with 64bit kernel+32bit user.  On the file server (the Xen
> Dom0) ls doesn't even see that file in readdir.

So we need to do some variable isolation as I am now not sure what Xen 
would have to do with anything.

If the file doesn't exist under that name on the NFS server, then _that_ 
is where you need to do the find/ls checks for various name expansions. 
That is, all the various wildcard checks need to happen on the real 
server that has mounted the BTRFS in order to find the actual file that 
is leading to the phantom file. E.g. if the file "isn't there" on the 
BTRFS then the problem is really an NFS translation problem of some sort.

This problem involves two physical servers or just one?

The network connection between the two semantic servers is physical 
(real cables) or semantic (a Xen bridge etc)?

You are using NFS version? Over udp or tcp? using what options?

You are or you are not using any sort of secondary cache on top of your 
NFS? e.g. a cachefiles directory on a little local slice somewhere on 
either system. If so you have or have not cleared that cache manually?

You have or have not cleared the NFS server state (typically found in 
/var/lib/nfs or some such)?

The means you are using to synchronize time between the systems is?

Understand that at this point you've described an NFS problem (possibly 
an NFS server problem with BTRFS) but not a BTRFS problem per-se, so we 
have to figure out what the server sees on the file system before we can 
guess why the client is seeing what it is seeing.

>
>> I ask because the man page for lstat64 says its a "wrapper" for the
>> underlying system call (fstatat64). It is not impossible that you might
>> have a case where the wrapper is failing inside glibc due to some 32/64
>> bit conversion taking place.
>
> If there is a 32/64 conversion then we have another problem.  The mail server
> is configured to reject messages bigger than about 50M, I don't recall the
> exact number but it's a lot smaller than 2G.

This potential conversion issue has nothing to do with file size and 
everything to do with internal structure alignment and significant bits 
in things like file handles. (though now I'm not sure what matters now.)

NFS is sort of old and crufty in some cases, particularly it's own 
internal file handles operation, that was originally designed around 
absolute inodes-by-number. Technology moved on while NFS was just sort 
of cruft-patched to deal with what it could no longer understand. NFSv4 
is intended to fix lots of those problems (and if you aren't using it, 
it might be worth a stab, but it has its own departures and issues, 
particularly with trying to mount a v4 root without an initramfs stage).

(NOTE: I think there _is_ something NFS-server-from-BTRFS related as 
when I wireshark a particular problem I've been having with an NFS root 
environment, I've been getting some unexpected NOENT responses in the 
NFS data stream. If you are comfortable with wireshark/tcpdump etc you 
might want to look there as well. Coercing a mount point at the point of 
service and using fsid= in /etc/exports seems to have given me some 
progresss, but it sounds like that might be a bit much for your problem.)
