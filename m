Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55902 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2JGLCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 07:02:23 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 7 Oct 2012 13:02:22 +0200
Cc: =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
References: <50714AC8.4010100@petaramesh.org> (sfid-20121007_121057_935818_E179B3F4)
In-Reply-To: <50714AC8.4010100@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210071302.22229.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Swâmi Petaramesh:
> Hi,
> 
> I have 4 machines, all converted to BTRFS about 6 months ago, now all
> running Ubuntu Quantal with kernel 3.5.0-17
> 
> The matter is that all these machines are now getting slower and slower
> everyday, every disk access causing the disk to be 100% busy for long
> periods, to the point that I'm now seriously considering migrating
> everything back to ext4...
> 
> From the start BTRFS was "not very fast", still satisfactory, but now
> it becomes truly unusable.
> 
> On one machine, I know have a typical complete boot time to a usable
> GUI that is over 4 minutes, with the HD still very busy for a couple
> more minutes afterwards, where it used to be around 35-40 seconds in
> ext4 !
> 
> Is there anything I could do to speed things back (without losing all
> my snapshots or doubling the size of data on disk)...?

As told in my previous post its better to first understand the problem. 
What might help here, additionally to what I suggested already, is some 
output of

vmstat 1

and 

iostat -dx 1 /dev/sda

(or maybe even better 5 or 10 seconds interval)

where /dev/sda is device or better partition where the workload happens.

Also the amount of snapshots in use would be helpful I bet.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
