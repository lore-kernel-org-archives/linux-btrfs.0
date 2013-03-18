Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:53201 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168Ab3CRTQt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 15:16:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130318185702.GB19395@carfax.org.uk>
Date: Mon, 18 Mar 2013 13:09:39 -0600
Cc: Kyle <lists@lolwut.org>, linux-btrfs@vger.kernel.org
Message-Id: <140D9ED4-B0CF-437E-AE58-9B6FB209DBD2@colorremedies.com>
References: <514759B5.5000507@lolwut.org> <20130318185702.GB19395@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 18, 2013, at 12:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Mon, Mar 18, 2013 at 02:15:17PM -0400, Kyle wrote:
>> After reading through the btrfs documentation I'm curious to know if
>> it's possible to ever securely erase a file from a btrfs filesystem
>> (or ZFS for that matter).
> 
>   Not really.
> 
>   It gets even worse for SSDs, because the SSD itself can be
> effectively CoW, with old pages lurking away in the flash storage
> where (with a bit of physical persuasion of the hardware) they can be
> read. So you have the same problem on SSDs even with non-CoW
> filesystems.

Encryption is the solution, either dmcrypt, encryptfs, or Opal SED.

With even consumer SSDs now, Opal 2.0 is increasingly common, so data on the SSD is already encrypted whether locked or not. By default the drive is unlocked, so the DEK is exposed but data on the chips is encrypted. Unfortunately I'm not aware of user space tools to manage Opal drives on linux, it's a side topic question but if anyone knows of such a tool I'd like to know about it. I don't think hdparm does, rather it manages the ATA  Security features like Secure Erase, Secure Enhanced Erase, and I think it can also cause DEK regeneration on SED drives which effectively is encryption erase (removes the existing DEK, creates a new one, thereby rendering the drive effectively erased in seconds). But I don't think it manages KEKs and the locking/unlocking of the drive.

Booting from these Opal compliant SEDs is difficult because it requires firmware or bootloader support; and then also kernel and user space tools to support to lock/unlock when the computer is put to sleep/hibernation and then woken. For that use case it's necessary to use software encryption, dmcrypt/LUKS on Linux.

Another possibility for the OP's use case is encryptfs which encrypts above btrfs. The file contents are encrypted, but the file names and file system itself (and metadata) are not. In this case, deletion is functionally equivalent to having filled the blocks with random data (short of the DEK escaping into the wild).

Chris Murphy