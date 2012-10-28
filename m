Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:33445 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab2J1MYu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 08:24:50 -0400
Message-ID: <508D2430.9020006@inwind.it>
Date: Sun, 28 Oct 2012 13:25:20 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>
CC: Martin Steigerwald <Martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <20121027223812.GB5042@carfax.org.uk> <508CF08D.8060203@gmail.com> <201210281138.02590.Martin@lichtvoll.de> <508D1015.6050100@gmail.com> <20121028111858.GC2381@yeono.kjorling.se>
In-Reply-To: <20121028111858.GC2381@yeono.kjorling.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-28 12:18, Michael Kjörling wrote:
> On 28 Oct 2012 11:59 +0100, from kreijack@gmail.com (Goffredo Baroncelli):
>> On 2012-10-28 11:38, Martin Steigerwald wrote:
>>> But still if if can be arbitrarily long due to that per object replication 
>>> config, a vertical output might and leaving graphical representation to a 
>>> Qt Quick application or so might be better.
>>
>> Yes, this is my same feel: For console I prefer a text representation in
>> rows, leaving to a graphical GUI to show the information in columns..
> 
> So a sysadmin who logs on to a server (which uses btrfs) over plain
> SSH should need to install a good chunk of X11 plus a load of support
> libraries on the server, plus have a X11 server on the machine they
> are connecting from, simply to get a tabular view of the disk space?

As reported in another email, I like the tabular format. The point is
that it is not usable because the combination of Chunk-type (Data,
Metadata, System) and Profile (DUP, Single, RAID1, RAID10,
RAID0...RAID5/6) doesn't fit in 80 columns width.
Even tough the simple case (Only one profile, Data,Metadata,System chunk
type) could fit, this solution doesn't scale when will be possible to
select different profiles per subvolume basis.

[...]

> 
> I would personally really prefer a tabular view that perhaps does not
> show _all_ details when no explicit parameters are given, and a
> "--dump" or similar that will give a fuller data dump that might lend
> itself better to parsing by other tools for a more thorough
> presentation. The data is all right there; it's basically a matter of
> deciding how much of it to show by default.

In your opinion, which details we could omit ?
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
