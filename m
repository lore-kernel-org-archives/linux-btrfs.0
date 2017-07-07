Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33178 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdGGQif (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 12:38:35 -0400
Date: Fri, 7 Jul 2017 09:38:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: Re: ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
Message-ID: <20170707163834.GA6083@merlins.org>
References: <20170628144348.abvqowzmeveyzssn@merlins.org> <20170501170641.GG3516@merlins.org> <20170501180856.GH3516@merlins.org> <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com> <20170502032346.ayhh3n3uh5d5ekbb@merlins.org> <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com> <20170502051155.igmbqcqgzi4ukefg@merlins.org> <20170707053718.GA9735@merlins.org> <20170707053953.GB9735@merlins.org> <20170707093318.GD3224@fnst>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170707093318.GD3224@fnst>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 07, 2017 at 05:33:20PM +0800, Lu Fengqi wrote:
> I apologise for my late reply. As a colleague left, I have to take over his
> work recently.
 
no worries.

> >Mmmh, never mind, it seems that the software raid suffered yet another
> >double disk failure due to some undermined flakiness in the underlying block
> >device cabling :-/
> >That would likely explain the failures here.
> 
> I'm sorry for hear this. Which raid level are you using? So could you recover
> from this double disk failure?

The disks aren't failed, and the array wasn't being written to.
It's just a matter of putting the disks back in the md raid5 array in the
right order.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
