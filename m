Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34530 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaC0NWz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 09:22:55 -0400
Date: Thu, 27 Mar 2014 14:22:49 +0100
From: Xavier Bassery <xavier@bartica.org>
To: Adam Khan <adam.s.khan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Please advise on repair action
Message-ID: <20140327142249.63dffbb8@renoir.lan>
In-Reply-To: <5333287F.6000601@gmail.com>
References: <532931D9.60809@gmail.com>
	<20140321111701.2502a307@renoir.lan>
	<5333287F.6000601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 26 Mar 2014 15:20:31 -0400
Adam Khan <adam.s.khan@gmail.com> wrote:

> >>
> >> btrfsck returns this:
> >>
> >> Checking filesystem on /dev/mapper/xyz_crypt
> >> UUID: ...
> > 
> > Here you've omitted the interesting part (preceding the next line).
> > Weren't there lines looking like 
> > "root 256 inode XXXX errors 400, nbytes wrong" ?
> 
> There is not a detailed error returned by btrfsck. The only part I
> found interesting is 'used err is 1', but maybe that is because this
> was my first time running btrfsck. No inode errors are reported.

Could you please provide the full output of btrfs check?

Xavier
