Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:38278 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586Ab3AHU1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 15:27:30 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50EC7CF9.9010308@tiscalinet.it>
Date: Tue, 8 Jan 2013 13:27:30 -0700
Cc: Karel Zak <kzak@redhat.com>, Chris Mason <chris.mason@fusionio.com>,
        util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <7BEF5456-297D-4399-967E-2EFFB54E88CD@colorremedies.com>
References: <50E9C267.3050302@inwind.it> <20130108180126.GB9177@x2.net.home> <50EC7CF9.9010308@tiscalinet.it>
To: kreijack@inwind.it, Goffredo Baroncelli <kreijack@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 8, 2013, at 1:09 PM, Goffredo Baroncelli <kreijack@tiscalinet.it> wrote:

> Hi Karel,
> 
> On 01/08/2013 07:01 PM, Karel Zak wrote:
>> On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
>>> If the first superblock is valid except that the "magic field" is zeroed,
>>> btrfs skips the check of the other superblocks.
>>> If the first superblock is fully invalid, btrfs checks for the other
>>> superblock.
>> 
>> Hmm... why inconsistent (or missing) superblock is not reported as a
>> problem? If I good understand the filesystem is still mountable,
>> right?
> 
> It should, however my tests were unsuccessful :-(... Chris ?

I haven't tried mounting after wipefs, only after wipefs and subsequent mkfs.ext4; in that case the file system mounts without error as ext4. If I use mount -t btrfs I get an error. I haven't tried mounting with -t btrfs -o recovery.

Chris Murphy