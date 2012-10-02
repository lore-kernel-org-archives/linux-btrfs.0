Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60464 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab2JBXql (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 19:46:41 -0400
Date: Tue, 2 Oct 2012 19:46:37 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS] btrfs filesystem disk-usage
Message-ID: <20121002234637.GF3214@shiny>
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 02, 2012 at 12:36:08PM -0600, Goffredo Baroncelli wrote:
> Hi all,
> 
> This serie of patches adds a new command called "btrfs filesystem
> disk-usage". I added this command because it is not so easy to get
> the information about the disk usage from the command "fi df" and "fi show".
> 
> From the man page (see 2nd patch):

I like it, thanks.  Could you please update btrfs fi df to show this
instead of adding a new command though?

-chris
