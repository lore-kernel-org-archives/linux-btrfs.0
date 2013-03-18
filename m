Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:45022 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab3CRXHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 19:07:51 -0400
Message-ID: <51479C9B.80507@lolwut.org>
Date: Mon, 18 Mar 2013 19:00:43 -0400
From: Kyle <lists@lolwut.org>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
References: <514759B5.5000507@lolwut.org> <20130318185702.GB19395@carfax.org.uk> <140D9ED4-B0CF-437E-AE58-9B6FB209DBD2@colorremedies.com>
In-Reply-To: <140D9ED4-B0CF-437E-AE58-9B6FB209DBD2@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/18/2013 3:09 PM, Chris Murphy wrote:
>
> On Mar 18, 2013, at 12:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>> On Mon, Mar 18, 2013 at 02:15:17PM -0400, Kyle wrote:
>>> After reading through the btrfs documentation I'm curious to know if
>>> it's possible to ever securely erase a file from a btrfs filesystem
>>> (or ZFS for that matter).
>>
>>    Not really.
>>
>>    It gets even worse for SSDs, because the SSD itself can be
>> effectively CoW, with old pages lurking away in the flash storage
>> where (with a bit of physical persuasion of the hardware) they can be
>> read. So you have the same problem on SSDs even with non-CoW
>> filesystems.
>
> Encryption is the solution, either dmcrypt, encryptfs, or Opal SED.
>
> With even consumer SSDs now, Opal 2.0 is increasingly common, so data on the SSD is already encrypted whether locked or not. By default the drive is unlocked, so the DEK is exposed but data on the chips is encrypted. Unfortunately I'm not aware of user space tools to manage Opal drives on linux, it's a side topic question but if anyone knows of such a tool I'd like to know about it. I don't think hdparm does, rather it manages the ATA  Security features like Secure Erase, Secure Enhanced Erase, and I think it can also cause DEK regeneration on SED drives which effectively is encryption erase (removes the existing DEK, creates a new one, thereby rendering the drive effectively erased in seconds). But I don't think it manages KEKs and the locking/unlocking of the drive.
>
> Booting from these Opal compliant SEDs is difficult because it requires firmware or bootloader support; and then also kernel and user space tools to support to lock/unlock when the computer is put to sleep/hibernation and then woken. For that use case it's necessary to use software encryption, dmcrypt/LUKS on Linux.
>
> Another possibility for the OP's use case is encryptfs which encrypts above btrfs. The file contents are encrypted, but the file names and file system itself (and metadata) are not. In this case, deletion is functionally equivalent to having filled the blocks with random data (short of the DEK escaping into the wild).
>
> Chris Murphy
>

I'm doubtful that encryption would be as effective as what Chris Mason 
was suggesting, which is to either find and use a disk with secure erase 
trim or rotate out the drives and securely erase them so that the data 
is destroyed entirely rather than encrypted.

Simply having the data exist on a disk, even if it's encrypted, still 
leaves it open to various attacks. For instance, multiple side channel 
attacks exist which could reveal the decryption key, permitting all data 
on the disk to be read including deleted but not yet overwritten files. 
Physical access to the machine may not even be required: A remote 
attacker able to exploit the machine and read the disk blocks would be 
able to recover the data as well.

Granted these types of attacks are rare, however ultimately the only way 
to secure unneeded sensitive data against a determined attacker is to 
destroy it outright. For encrypted data, it's true the decryption keys 
could be destroyed, thus essentially destroying the data (subject to the 
security of the cryptographic algorithm itself) however this would 
destroy the entire filesystem, not securely erase a single file.

Hugo made the point that a multitude of other data-leakage paths exist, 
and while this is true, at a minimum one should be able to destroy 
individual files beyond recovery so that should data leakage occur in 
the future, previously securely erased data is not recoverable. At 
least, in an ideal world.

For the time being I'll be thankful I'm not a person tasked with 
protecting/erasing such highly sensitive data. Aside from the 
confidence-inspiring crunching of decommissioned hard disks going 
through an industrial shredder, it must be a nightmare.

-Kyle
