From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: Status of BTRFS
Date: Fri, 16 Jul 2010 17:21:47 +0200
Message-ID: <201007161721.48792.johannes.hirte@fem.tu-ilmenau.de>
References: <000001cb24dd$cab87650$602962f0$@com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Edward Ned Harvey <kernel@nedharvey.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <000001cb24dd$cab87650$602962f0$@com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag 16 Juli 2010, 13:55:26 schrieb Edward Ned Harvey:
> Is this a good place to get a clue about the status of BTRFS?  Like ...  Is
> it usable yet, and stuff like that?
> 
> Thank you...

I wouldn't suggest to use it in productive environments. Especially as the 
error handling is very rudimentarily for now. If you run into errors, you 
won't be able to repair the filesystem. For productive environments there are 
also way to much situations where the whole kernel panics instead only the 
affected filesystem. Another construction area is still the ENOSPC handling.

regards,
  Johannes
