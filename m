From: James Cloos <cloos@jhcloos.com>
Subject: Re: BTRFS should increase the hard-link in the same directory limit
Date: Sun, 21 Aug 2011 18:05:50 -0400
Message-ID: <m3bovio1wp.fsf@jhcloos.com>
References: <874o1aztkm.fsf-genuine-vii@john.fremlin.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: John Fremlin <john@fremlin.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <874o1aztkm.fsf-genuine-vii@john.fremlin.org> (John Fremlin's
	message of "Sun, 21 Aug 2011 16:13:13 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "JF" == John Fremlin <john@fremlin.org> writes:

JF> instead of creating a separate inode for each marked message, uses a
JF> hardlink to a single markfile. This means that there maybe thousands
JF> of hardlinks to the same inode in a single directory.

And that behaviour is not limited to gnus.  Many workflows use that idiom.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
