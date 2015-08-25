Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:46412 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbbHYPbj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:31:39 -0400
Message-ID: <55DC88C8.9000203@friendlyvirus.org>
Date: Tue, 25 Aug 2015 16:24:56 +0100
From: =?windows-1252?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
References: <loom.20150825T151154-787@post.gmane.org> <20150825145922.GE20179@merlins.org>
In-Reply-To: <20150825145922.GE20179@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

On 25-08-2015 15:59, Marc MERLIN wrote:
>> upgrading kernel requires upgrading ubuntu, which will upgrade a lot of
>> packages and might lead to problems which I don't have time to fix. One
> 
> You're doing it wrong :)
> Upgrade/compile your own kernel without upgrading the OS.
>

I did try that once but didn't manage to do it, the kernel upgrade broke
other stuff. I'm a bit more experienced then complete newbie (hence
using btrfs), but still very far from knowledable user, so I don't doubt
it can be done. Indeed, using btrfs might be seen as a wrong move in my
case, which I understand, although on the other hand btrfs saved me many
times from other begginer mistakes by allowing a simple restore by just
renaming snapshots.

>> block group 32...... flags 36'). This is a OCZ vertex 3, a quite fast SSD.
> 
> I've had 5 (yes 5, I replaced my drive 4 times) OCZ Vertex 4 drives, and
> they all gave me corruption with btrfs on unclean power down. The last
> one didn't work any better, I just gave up and went to Samsung EVO 840
> and those have been fine.

Ok, I've been warned then. I'm glad to know about the samsung EVO
though, I've been eyeing buying two of those for a raid1 system. Then I
would solve two issues in one go !

Best,
Miguel Negrão

