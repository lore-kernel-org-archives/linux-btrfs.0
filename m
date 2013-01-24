Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45024 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab3AXWxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 17:53:04 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <20130124223652.GI10162@shiny.int.fusionio.com>
Date: Fri, 25 Jan 2013 09:52:00 +1100
Cc: "kreijack@inwind.it" <kreijack@inwind.it>,
        Eric Sandeen <sandeen@redhat.com>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, "gene@czarc.net" <gene@czarc.net>
Message-Id: <3D041EF5-3517-4F46-9ED2-37339521531E@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com> <5100FDA3.3040907@giantdisaster.de> <510175F7.5080806@gmail.com> <51018EBA.60201@redhat.com> <5101B131.6010804@tiscalinet.it> <20130124223652.GI10162@shiny.int.fusionio.com>
To: Chris Mason <chris.mason@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,

On 25/01/2013, at 9:36 AM, Chris Mason <chris.mason@fusionio.com> wrote:

> I'd say that if SuSE or oracle depend on them we keep them.  Otherwise,
> I'm fine with removing them or just making the 3 line bash script.


You can take this as an official response from Oracle: we don't need/want the old tools. :) All of our documentation uses the unified binary.

Thanks,
Avi

--
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

