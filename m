From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] btrfs-progs: mkfs: allow not to trim a device
Date: Tue, 20 Mar 2012 09:30:43 -0400
Message-ID: <yq17gyf1jss.fsf@sermon.lab.mkp.net>
References: <1332010297-18581-1-git-send-email-dsterba@suse.cz>
	<201203191824.17665.Martin@lichtvoll.de>
	<20120320101641.GM32563@ds.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org, Roland Dreier <roland@purestorage.com>
To: dsterba@suse.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120320101641.GM32563@ds.suse.cz> (David Sterba's message of
	"Tue, 20 Mar 2012 11:16:41 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "David" == David Sterba <dsterba@suse.cz> writes:

>> Just curious: Whats the use case for this?

David> http://digitalvampire.org/blog/index.php/2012/03/16/you-can-never-be-too-rich-or-too-thin/

Well, a cap of 1MB per UNMAP command is absolute crazy talk. We
currently do 2GB per command on ATA and 2TB per command on most SCSI
targets.

I don't disagree that it may make sense to have a disable discard option
to mkfs. But Roland really needs to get his VPD reporting fixed. I
suspect what the array meant to communicate was a 1MB discard
granularity, not a 1MB per command limit...a common mistake.

-- 
Martin K. Petersen	Oracle Linux Engineering
