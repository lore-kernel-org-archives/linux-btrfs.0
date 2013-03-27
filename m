Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55201 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3C0V0v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 17:26:51 -0400
Date: Wed, 27 Mar 2013 14:26:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: zlib vs lzo uncompress speed, ssd vs nossd
Message-ID: <20130327212650.GG17613@merlins.org>
References: <20130327165309.GA23559@merlins.org> <CAKcLGm98D1H4oMnN8+Sc8tbC8dCh=gwUQL9vw7M1pmQOn78Epw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm98D1H4oMnN8+Sc8tbC8dCh=gwUQL9vw7M1pmQOn78Epw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 04:12:27PM -0500, Mitch Harder wrote:
> Lzo compression should be faster in every aspect than zlib, especially
> for reading.

Speaking of which, it would be awesome if there were a some chattr option to
choose which encryption you'd like for a file or a subdirectory tree
(compress this tree as much as you can, but use fast lzo for that tree).
But I agree that would be lower on the priority list, and the chattr
interface likely doesn't make that easy.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
