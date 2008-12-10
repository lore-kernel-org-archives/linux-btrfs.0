From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 09:32:08 +0000
Message-ID: <gho2ao$d0q$1@ger.gmane.org>
References: <20081209145952.GA30494@tux64-03> <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Miguel Figueiredo Mascarenhas Sousa Filipe wrote:

> Things like compression or encription should be used at the "volume"
> level. So.. if a user wants a specific set of files or dirs ..they should
> create a mount-point/volume like:
> 
> private_vol
> bigarchives_vol

Does a normal user have permissions to do this?

I could easily see the case where a normal user has a set of very
compressible files in a directory. They shouldn't have to get a sysadmin go
to the trouble of setting this up.

Jeremy


