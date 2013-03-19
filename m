Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:48499
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab3CSElz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 00:41:55 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <51479C9B.80507@lolwut.org>
Date: Mon, 18 Mar 2013 22:41:52 -0600
Cc: Hugo Mills <hugo@carfax.org.uk>
Message-Id: <A980AB78-A70A-4380-AC1C-CE3229CB40B3@colorremedies.com>
References: <514759B5.5000507@lolwut.org> <20130318185702.GB19395@carfax.org.uk> <140D9ED4-B0CF-437E-AE58-9B6FB209DBD2@colorremedies.com> <51479C9B.80507@lolwut.org>
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>,
        Kyle <lists@lolwut.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 18, 2013, at 5:00 PM, Kyle <lists@lolwut.org> wrote:
> 
> I'm doubtful that encryption would be as effective as what Chris Mason was suggesting, which is to either find and use a disk with secure erase trim or rotate out the drives and securely erase them so that the data is destroyed entirely rather than encrypted.

Well, I'll argue it's more effective in that it's more likely to be used than it is to be cracked in the time frame of the data mattering if the proper setup is being used.

> 
> Simply having the data exist on a disk, even if it's encrypted, still leaves it open to various attacks. For instance, multiple side channel attacks exist which could reveal the decryption key, permitting all data on the disk to be read including deleted but not yet overwritten files.

Not if you're using LUKS with either a high entropy passphrase, or increasing PBKDF2 iterations, or both. LUKS and at least Opal SEDs don't store keys or passphrases in plaintext. If you're using plain dmcrypt (without LUKS) then you be concerned.


> Physical access to the machine may not even be required: A remote attacker able to exploit the machine and read the disk blocks would be able to recover the data as well.

If it's an HDD, or the SSD's garbage collection after trim is issue is slow, yes anyone who has either file system or block level access can obtain unencrypted data from a mapped encrypted block device. But if the fall back position to a remote take over is counting on deleted files being irrecoverable, well, you still have a remote attacker stealing visible files. Chances are if the deleted files are that sensitive, the non-deleted files are too. So I don't see the gain of going to extraordinary lengths to zero the data in released blocks for active use drives.

> 
> Granted these types of attacks are rare, however ultimately the only way to secure unneeded sensitive data against a determined attacker is to destroy it outright.

This is probably specious. It's sorta like saying the only way to secure a computer containing sensitive data is to disconnect it from the internet. Or from the wall outlet.

> Hugo made the point that a multitude of other data-leakage paths exist, and while this is true, at a minimum one should be able to destroy individual files beyond recovery so that should data leakage occur in the future, previously securely erased data is not recoverable. At least, in an ideal world.

Well at the moment we are SOL on that front with either SSDs or COW file systems. You'd need to use HDDs and a file system that'll support overwriting files with random data and then marking them as deleted.

I think the overwhelming concern is someone gaining physical access to the drive: theft of a laptop, or disposal of a dead drive (for which ATA security erase unit commands aren't going to work). And for that encryption is quite useful and important.

Chris Murphy