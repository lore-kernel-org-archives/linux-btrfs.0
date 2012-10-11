Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:37182 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2JKO4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 10:56:25 -0400
Date: Thu, 11 Oct 2012 15:56:01 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive to subdirectory
Message-ID: <20121011145601.GA29841@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
 <50733D66.5020600@gmx.net>
 <20121009111830.GC31743@campbell-lange.net>
 <CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
 <20121010221107.GA19266@campbell-lange.net>
 <CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
 <20121011113359.GD22640@campbell-lange.net>
 <CAOcd+r3E=vhtHwenmHbqV_i3FN5e4rK0x+CkOOHz3WHKVAQi1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r3E=vhtHwenmHbqV_i3FN5e4rK0x+CkOOHz3WHKVAQi1A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
> Hi Rory,
> all your tests work perfectly for me (really, I swear:)), with exact
> same mount points and subvol/snap/dir names.
> Just to make that the patch some how did not get messed up in the
> mail, I attach it.

... happy to try things further. Please confirm your btrfs/kernel
version. I'm on 

    5c4e935f44e1aace28988fdc06f233ef5c184103 refs/heads/send-recv

Cheers
Rory

-- 
Rory Campbell-Lange
rory@campbell-lange.net

Campbell-Lange Workshop
www.campbell-lange.net
0207 6311 555
3 Tottenham Street London W1T 2AF
Registered in England No. 04551928
