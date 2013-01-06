Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50550 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3AFRUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 12:20:32 -0500
Received: by mail-bk0-f53.google.com with SMTP id j5so8025740bkw.12
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 09:20:31 -0800 (PST)
Message-ID: <50E9B26D.3030900@gmail.com>
Date: Sun, 06 Jan 2013 18:20:45 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
CC: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG btrfs fi show displays stale btrfs volume
References: <96FA5245-87A9-43C4-9B56-C0F4ADB9D975@colorremedies.com> <50E9A5D1.4050704@inwind.it>
In-Reply-To: <50E9A5D1.4050704@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 01/06/2013 05:26 PM, Goffredo Baroncelli wrote:
> Hi Chris
[...]
> 
> I will start to update the wiki; then I will give a look to wipefs to
> improve it.

Hello I updated the wiki page:


https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#What_if_I_don.27t_have_wipefs_at_hand.3F
-----
 What if I don't have wipefs at hand?

There are three superblocks: the first one is located at 64K, the second
one at 64M, the third one at 256GB. The following lines reset the magic
string on all the three superblocks

# dd if=/dev/zero bs=1 count=8 of=/dev/sda seek=$((64*1024+64))
# dd if=/dev/zero bs=1 count=8 of=/dev/sda seek=$((64*1024*1024+64))
# dd if=/dev/zero bs=1 count=8 of=/dev/sda seek=$((256*1024*1024*1024+64))

If you want to restore the superblocks magic string,

# echo "_BHRfS_M" | dd bs=1 count=8 of=/dev/sda seek=$((64*1024+64))
# echo "_BHRfS_M" | dd bs=1 count=8 of=/dev/sda seek=$((64*1024*1024+64))
# echo "_BHRfS_M" | dd bs=1 count=8 of=/dev/sda
seek=$((256*1024*1024*1024+64))
------

> 
> BR
> G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
