Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:38252 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750976AbbECHSJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 May 2015 03:18:09 -0400
Message-ID: <5545C9BF.9090500@inwind.it>
Date: Sun, 03 May 2015 09:09:51 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accessing Parent Subvolume
References: <CAK5rZE55PB79N6CeSP-O3ugYfWR-u9dSemht_M6zVEG-KZu3YQ@mail.gmail.com>
In-Reply-To: <CAK5rZE55PB79N6CeSP-O3ugYfWR-u9dSemht_M6zVEG-KZu3YQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-05-03 08:19, Imran Geriskovan wrote:
> ** QUESTIONS **
> 1- Is it safe to access /mnt/debian ?
> 2- Is it safe to access /mnt/debian/@arch ?
> (Yeah, I'm pushing my chances recursively)
> 
> 
> ** POSSIBLE ANSWERS **
> X- Sure.. Accessing parent subvolumes recursively is a
> non issue. Even /arch/debian/arch/debian... is no problem.
> (Then, add this to features/decumentation to show how
> generic btrfs subvolume mount machinery is)

It is safe. However I suggest to use the root subvolume only to host other subvolumes.

In your case the layout should be:

/@debian
/@arch

The biggest advantage is that all subvolume are equal, so it could be
manage in the same way when you do a snapshot/rollback...

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
