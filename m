Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41629 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161033AbbEOU6j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 16:58:39 -0400
Date: Fri, 15 May 2015 13:58:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Let's get a File & Storage miniconf going at LPC2015!
Message-ID: <20150515205825.GC24967@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

Early registration for this summer's Plumbers in Seattle, Washington ends
next Friday the 22nd.  With that in mind, I still don't have quite enough
people listed on the File & Storage miniconf wiki page for the organizers
to declare us an official miniconference, so if you're planning to go, or
even think you might go, please take a look at the planning page[1] and
add your name!

At a bare minimum, it seems like we can continue the ongoing discussions
around SMR exploration; the work going on with persistent memory and how to
expose it to filesystems and user apps; I see a proposal for the refereed
talks about the ongoing Open SSD work; and there have been prompts for more
conversation about rich ACL integration and supporting RDMA in NFS and Samba.
I think it would also be a good place to talk more about how to better
accomodate userspace filesystems like Ceph, giving things like the recent
O_NOMTIME thread, and other things like copy_file_range().

We of course are not limited to just those topics -- if there's something
you'd really like to discuss with everyone, please add that to the wiki.
I realize that mid-August is family vacation time for many people, but
those are the constraints the conference has to work with this year.
There are fun things to do around Seattle, and that's probably the best
time of year to visit.

--Darrick

[1] http://wiki.linuxplumbersconf.org/2015:file_and_storage_systems
