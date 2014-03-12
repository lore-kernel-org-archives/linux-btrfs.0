Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12b.wadns.net ([196.220.39.31]:43467 "EHLO fw12a.wadns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751020AbaCLXeq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 19:34:46 -0400
Message-ID: <5320EC45.70803@swiftspirit.co.za>
Date: Thu, 13 Mar 2014 01:22:45 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it
CC: Chris Mason <clm@fb.com>, systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de> <53209868.5090506@fb.com> <5320B18C.9050400@inwind.it> <F34652FB-331F-4BA7-A2D9-35C3DE7B770D@colorremedies.com>
In-Reply-To: <F34652FB-331F-4BA7-A2D9-35C3DE7B770D@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/12 09:31 PM, Chris Murphy wrote:
> On Mar 12, 2014, at 1:12 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>> On 03/12/2014 06:24 PM, Chris Mason wrote:
> Your suggestion also sounds like it places snapshots outside of their parent subvolume? If so it mitigates a possible security concern if the snapshot contains (old) binaries with vulnerabilities. I asked about how to go about assessing this on the Fedora security list:
> https://lists.fedoraproject.org/pipermail/security/2014-February/001748.html
>
> There aren't many replies but the consensus is that it's a legitimate concern, so either the snapshots shouldn't be persistently available (which is typical with e.g. snapper, and also yum-plugin-fs-snapshot), and/or when the subvolume containing snapshots is mounted, it's done with either mount option noexec or nosuid (no consensus on which one, although Gnome Shell uses nosuid by default when automounting removable media).
This is exactly the same result if following the previously-recommended 
subvolume layout given on the Arch wiki. It seems this wiki advice has 
"disappeared" so I can't give a link for it ...

My apologies if the rest of my mail is off-topic.

Though not specifically for rollback, my snapshots prior to btrfs {send 
| , receive} backup is done via temporary mountpoint. Until two days ago 
I was still using rsync to a secondary btrfs volume and the __snapshots 
folder had been sitting empty for about a year. The performance 
difference with send|receive is magnitudes apart: A daily backup to the 
secondary disk now takes between 30 and 40 seconds whereas it took 20 to 
30 minutes with rsync.

Here are my current subvolumes:
__active
__active/home
__active/usr
__active/var
__snapshots/__2014-03-12-23h00m01s+0200
__snapshots/_home_2014-03-12-23h00m01s+0200
__snapshots/_usr_2014-03-12-23h00m01s+0200
__snapshots/_var_2014-03-12-23h00m01s+0200

I hadn't thought of noexec or nosuid. On a single-user system you don't 
really expect that type of incursion. I will put up my work after I've 
properly automated cleanup.

The only minor gripe I have with the temporary mount is that I feel it 
should be possible to perform snapshots and use send|receive without the 
requirement of having the subvolumes be "visible" in userspace.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

