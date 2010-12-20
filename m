From: Martin Eisenhardt <martin.eisenhardt@mneisen.org>
Subject: Re: A start at RAID[56] support.
Date: Mon, 20 Dec 2010 12:55:20 +0100
Message-ID: <20101220115520.GA17852@samsumm>
References: <1247323186.17045.15.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247323186.17045.15.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

for an internal demonstration system due in Q1/2011, I am very much interested
in setting up a btrfs fs with RAID5; RAID1 just won't cut it.

As can be read in the btrfs wiki [1], the 'magic' number for RAID5 support in
btrfs is 2.6.37 which is just around the corner.

So my question is: Is this still the roadmap for the introduction of RAID5 and
RAID6, or has it been delayed somewhat? If so, what is the current target kernel
release for btrfs RAID5 support?

Thanks for the information!

Best regards
Martin


[1] https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_use_RAID.5B56.5D_on_my_Btrfs_filesystem.3F
