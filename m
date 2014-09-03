Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40776 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751146AbaICG0O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 02:26:14 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49300 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XP41F-001z7m-Gw
	for linux-btrfs@vger.kernel.org; Wed, 03 Sep 2014 00:26:13 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <88B7E732-0EB2-422C-B5C7-950E483C2E71@colorremedies.com>
Date: Wed, 3 Sep 2014 00:26:12 -0600
Message-Id: <9437B859-6FD7-4971-935A-E29EFBB7B261@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu> <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com> <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com> <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com> <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com> <08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com> <CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com> <5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com> <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com> <540617DE.5070605@gmail.com> <CADw2B2M+WSbCyphH3Y=5w8JyMHYe7sL_MdvScy9NLPS3PbRHiQ@mail.gmail.com> <88B7E732-0EB2-422C-B5C7-950E483C2E71@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 3, 2014, at 12:01 AM, Chris Murphy <lists@colorremedies.com> wrote:

> I created two pools, one xfs one btrfs, default formatting and mount options. I then created a qcow2 file on each using virt-manager, also using default options. And default caching (whatever that is, I think it's writethrough but don't hold me to it).

On the btrfs qcow2, xattr C was set.


Chris Murphy