Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaDXC3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 22:29:21 -0400
Message-ID: <535876F5.9000802@redhat.com>
Date: Wed, 23 Apr 2014 21:29:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Which companies contribute to Btrfs?
References: <20140424011834.GN26949@merlins.org>
In-Reply-To: <20140424011834.GN26949@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/23/14, 8:18 PM, Marc MERLIN wrote:
> Howdy,
> 
> I writing slides about btrfs for an upcoming talk (at linuxcon) and I was
> trying to gather a list of companies that contribute code to btrfs.
> 
> What I came up with (sorted alphabetically)
> Couchbase (CouchDB)
> Facebook 
> Fujitsu
> Fusion-IO
> Oracle
> SGI
> Suse
> 
> Are there other companies I missed?
> 
> Thanks,
> Marc
> 

git knows!  (sorry for the bash horribleness, and I'm sure you can collapse i.e. jp.fujitsu.com and cn.fujitsu.com into "Fujitsu" somehow...

[root@host linux-2.6]# git log --format=%ae fs/btrfs/ | awk -F @ '{print $2}' | sort | uniq -c | sort -n
<snip>
     10 diku.dk
     11 linux.intel.com
     12 linux.vnet.ibm.com
     13 linux-m68k.org
     15 infradead.org
     20 suse.de
     24 intel.com
     30 fb.com
     35 googlemail.com
     35 newdream.net
     48 lst.de
     50 gmx.net
     55 21cn.com
     55 jp.fujitsu.com
     60 suse.com
     76 zeniv.linux.org.uk
     93 jan-o-sch.net
    102 giantdisaster.de
    109 suse.cz
    176 linux-foundation.org
    310 fusionio.com
    324 gmail.com
    388 redhat.com
    552 cn.fujitsu.com
   1198 oracle.com

[root@host btrfs-progs]# git log --format=%ae | awk -F @ '{print $2}' | sort | uniq -c | sort -n
<snip>
     10 inwind.it
     10 linux.vnet.ibm.com
     10 suse.de
     13 gentoo.org
     15 21cn.com
     15 jan-o-sch.net
     34 giantdisaster.de
     55 suse.cz
     77 fusionio.com
    104 gmail.com
    171 cn.fujitsu.com
    183 redhat.com
    405 oracle.com


